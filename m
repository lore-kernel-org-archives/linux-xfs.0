Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40760 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbeHBXZJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Aug 2018 19:25:09 -0400
Subject: Re: [PATCH] xfs: check for COW overflows in i_delayed_blks
References: <20180802180335.GS30972@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7c8ef73e-32a2-1d47-7caf-be81624c7eb2@sandeen.net>
Date: Thu, 2 Aug 2018 16:32:10 -0500
MIME-Version: 1.0
In-Reply-To: <20180802180335.GS30972@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <guaneryu@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On 8/2/18 1:03 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> With the new copy on write functionality it's possible to reserve so
> much COW space for a file that we end up overflowing i_delayed_blks.
> The only user-visible effect of this is to cause totally wrong i_blocks
> output in stat, so check for that.

The other thing that can go wrong is transfer of delayed blocks for
quota accounting during a chown; it's fairly easy to add that to this
test by mounting the loop fs w/ quota, doing quotacheck, and then doing
a quota report before & after chowning both files to the qa user.

kindasorta like this:

diff --git a/tests/xfs/907 b/tests/xfs/907
index 029ed69f..2d50caaa 100755
--- a/tests/xfs/907
+++ b/tests/xfs/907
@@ -28,6 +28,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/reflink
+. ./common/quota
 
 # real QA test starts here
 _supported_os Linux
@@ -35,10 +36,13 @@ _supported_fs xfs
 _require_scratch_reflink
 _require_loop
 _require_xfs_debug
+_require_quota
+_require_user
 
 echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
+
 _require_fs_space $SCRATCH_MNT 2400000	# 100T fs requires ~2.4GB of space
 
 loop_file=$SCRATCH_MNT/a.img
@@ -46,7 +50,10 @@ loop_mount=$SCRATCH_MNT/a
 truncate -s 100T $loop_file
 $MKFS_XFS_PROG $MKFS_OPTIONS -f $loop_file >> $seqres.full
 mkdir $loop_mount
-mount -o loop -t xfs $loop_file $loop_mount
+mount -o loop,usrquota,grpquota -t xfs $loop_file $loop_mount
+
+quotacheck -u -g $loop_mount 2> /dev/null
+quotaon $loop_mount 2> /dev/null
 
 echo "Create crazy huge file"
 touch "${loop_mount}/a"
@@ -117,6 +124,15 @@ if [ "${fsblocks}" -lt "$((2 ** 32))" ]; then
 	echo "stat blocks (${fsblocks}) should be more than 2^32!"
 fi
 
+echo "before"
+_report_quota_blocks ${loop_mount}
+echo "chown"
+chown $qa_user ${loop_mount}/a
+chown $qa_user ${loop_mount}/b
+ls -l ${loop_mount}
+echo "after"
+_report_quota_blocks ${loop_mount}
+
 echo "Test done"
 umount $loop_mount
 
...

which currently trips an assert:

kernel:XFS: Assertion failed: dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount), file: fs/xfs/xfs_trans_dquot.c, line: 714


