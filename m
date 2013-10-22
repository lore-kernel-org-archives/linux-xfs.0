Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 005BD7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 15:25:58 -0500 (CDT)
Message-ID: <5266DF4F.8010403@sgi.com>
Date: Tue, 22 Oct 2013 15:25:51 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] xfstests: generic/274 increase scratch fs size to 2g
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
	<1382120790-31060-5-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-5-git-send-email-jbacik@fusionio.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


Patch does not apply, already committed.

Thanks
--Rich

commit 859f127da2ee6d49faa41cafd4ed362aa526e4a0
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Fri Jun 21 20:31:10 2013 +0000

     xfstests: make fs for 274 larger

     Btrfs will default to mixed block groups for 1 gigabyte file 
systems and
     smaller, which means data and metadata share the same area.  This makes
     generic/274 fail for us because we cannot reserve enough metadata 
space to do
     our writes.  Bumping the scratch fs up to 2 gigabytes allows us to 
do our normal
     metadata/data separation and allows us to pass this test.  Thanks,

     Signed-off-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Ben Myers <bpm@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

diff --git a/tests/generic/274 b/tests/generic/274
index da45fab..7c4887f 100755
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -57,7 +57,7 @@ echo "------------------------------"
  rm -f $seqres.full

  umount $SCRATCH_DEV 2>/dev/null
-_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
  _scratch_mount

  # Create a 4k file and Allocate 4M past EOF on that file

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
