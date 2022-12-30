Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34324C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbiLaDTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:19:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943C510540;
        Fri, 30 Dec 2022 19:19:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FDD5B81E65;
        Sat, 31 Dec 2022 03:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56F5C433EF;
        Sat, 31 Dec 2022 03:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456790;
        bh=jpWawCmPf3EJ2Z91gihOoNRXs3i1ffrVIRjyp71hvwg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ApDNV8lMUBA4zNQI1Zz4X6XbPvUObFsNNYgzn3ogzzMHwkAsWlrFlvkp639Tx6rZR
         z5BcATA9sIMcT8lWxXUqzqu3BvifVEYhbuK2a+8ADdXUpdulJ9xZ9JwDhVeuXKuKpE
         f7VkbfXFpoMOMLeiHFDnKJ0k1qJA0UjClxCyW01o7KDAjZ5R0RezC2ugdk0PAg3UaJ
         CZHm6OJRLnscNXgdDlAWaWtTDQIuJA21EGxe+ERy7nQrx/0UK9vTHWlQHbM3ZiYwQc
         4WWUd8HC7Y9zyWd9V8Cuz+3zel+L2Aii9t0+HOi0pBXr4MMW74Q8QPpm1Q17cRdfOI
         IrvxohAXaQ7xw==
Subject: [PATCH 1/1] xfs: regression testing of quota on the realtime device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:56 -0800
Message-ID: <167243885619.740668.9115709816530565020.stgit@magnolia>
In-Reply-To: <167243885607.740668.16615332202838475736.stgit@magnolia>
References: <167243885607.740668.16615332202838475736.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that quota accounting and enforcement work correctly for
realtime volumes on XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/quota      |   30 ++++++++++
 tests/xfs/767     |  167 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/767.out |   41 +++++++++++++
 3 files changed, 238 insertions(+)
 create mode 100755 tests/xfs/767
 create mode 100644 tests/xfs/767.out


diff --git a/common/quota b/common/quota
index 96b8d04424..f4c528c836 100644
--- a/common/quota
+++ b/common/quota
@@ -117,6 +117,36 @@ _require_xfs_quota_acct_enabled()
 	_notrun "$qtype: accounting not enabled on $fsname filesystem."
 }
 
+# Decide if the mounted filesystem supports realtime quotas.
+_require_rtquota()
+{
+	local dev="$1"
+	test -z "$dev" && dev="$TEST_DEV"
+	local rtdev="$2"
+	test -z "$rtdev" && rtdev="$TEST_RTDEV"
+
+	test "$FSTYP" = "xfs" || \
+		_notrun "Realtime quota only supported on xfs"
+
+	[ -n "$XFS_QUOTA_PROG" ] || \
+		_notrun "xfs_quota user tool not installed"
+
+	$here/src/feature -q $dev || \
+		_notrun "Installed kernel does not support XFS quotas"
+
+	test -b "$rtdev" || \
+		_notrun "No realtime device supplied?"
+
+	test "$USE_EXTERNAL" = "yes" || \
+		_notrun "Realtime requires USE_EXTERNAL='yes'"
+
+	$here/src/feature -U $dev || \
+	$here/src/feature -G $dev || \
+	$here/src/feature -P $dev || \
+		_notrun "Mounted rt filesystem does not have quotas enabled"
+
+}
+
 #
 # checks that xfs_quota can operate on foreign (non-xfs) filesystems
 # Skips check on xfs filesystems, old xfs_quota is fine there.
diff --git a/tests/xfs/767 b/tests/xfs/767
new file mode 100755
index 0000000000..f30321d7fc
--- /dev/null
+++ b/tests/xfs/767
@@ -0,0 +1,167 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 767
+#
+# Functional testing for realtime quotas.
+
+. ./common/preamble
+_begin_fstest auto quick quota realtime
+
+# Import common functions.
+. ./common/quota
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_test_program "punch-alternating"
+_require_scratch
+_require_user
+
+echo "Format filesystem" | tee -a $seqres.full
+_scratch_mkfs > $seqres.full
+_qmount_option 'usrquota'
+_qmount
+_require_rtquota $SCRATCH_DEV $SCRATCH_RTDEV
+
+# Make sure all our files are on the rt device
+_xfs_force_bdev realtime $SCRATCH_MNT
+chmod a+rwx $SCRATCH_MNT
+
+# Record rt geometry
+bmbt_blksz=$(_get_block_size $SCRATCH_MNT)
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+rextsize=$((file_blksz / bmbt_blksz))
+echo "bmbt_blksz $bmbt_blksz" >> $seqres.full
+echo "file_blksz $file_blksz" >> $seqres.full
+echo "rextsize $rextsize" >> $seqres.full
+
+note() {
+	echo -e "\n$@" | tee -a $seqres.full
+}
+
+# Report on the user's block and rt block usage, soft limit, hard limit, and
+# warning count for rt volumes
+report_rtusage() {
+	local user="$1"
+	local timeout_arg="$2"
+	local print_timeout=0
+
+	test -z "$user" && user=$qa_user
+	test -n "$timeout_arg" && print_timeout=1
+
+	$XFS_QUOTA_PROG -c "quota -u -r -n -N $user" $SCRATCH_MNT | \
+		sed -e 's/ days/_days/g' >> $seqres.full
+
+	$XFS_QUOTA_PROG -c "quota -u -r -n -N $user" $SCRATCH_MNT | \
+		sed -e 's/ days/_days/g' | \
+		awk -v user=$user -v print_timeout=$print_timeout -v file_blksz=$file_blksz \
+			'{printf("%s[real] %d %d %d %d %s\n", user, $2 * 1024 / file_blksz, $3 * 1024 / file_blksz, $4 * 1024 / file_blksz, $5, print_timeout ? $6 : "---");}'
+}
+
+note "Write 128rx to root"
+$XFS_IO_PROG -f -c "pwrite 0 $((128 * file_blksz))" $SCRATCH_MNT/file1 > /dev/null
+chmod a+r $SCRATCH_MNT/file1
+sync
+report_rtusage 0
+
+note "Write 64rx to root, 4444, and 5555."
+$XFS_IO_PROG -f -c "pwrite 0 $((64 * file_blksz))" $SCRATCH_MNT/file3.5555 > /dev/null
+chown 5555 $SCRATCH_MNT/file3.5555
+$XFS_IO_PROG -f -c "pwrite 0 $((64 * file_blksz))" $SCRATCH_MNT/file3.4444 > /dev/null
+chown 4444 $SCRATCH_MNT/file3.4444
+$XFS_IO_PROG -f -c "pwrite 0 $((64 * file_blksz))" $SCRATCH_MNT/file3 > /dev/null
+sync
+report_rtusage 0
+report_rtusage 4444
+report_rtusage 5555
+
+note "Move 64rx from root to 5555"
+chown 5555 $SCRATCH_MNT/file3
+report_rtusage 0
+report_rtusage 4444
+report_rtusage 5555
+
+note "Move 64rx from 5555 to 4444"
+chown 4444 $SCRATCH_MNT/file3
+report_rtusage 0
+report_rtusage 4444
+report_rtusage 5555
+
+note "Set hard limit of 1024rx and check enforcement"
+$XFS_QUOTA_PROG -x -c "limit -u rtbhard=$((1024 * file_blksz)) $qa_user" $SCRATCH_MNT
+su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite 0 $((2048 * file_blksz))' $SCRATCH_MNT/file2"
+report_rtusage
+
+note "Set soft limit of 512rx and check timelimit enforcement"
+rm -f $SCRATCH_MNT/file2 $SCRATCH_MNT/file2.1
+$XFS_QUOTA_PROG -x -c "limit -u rtbsoft=$((512 * file_blksz)) rtbhard=0 $qa_user" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c "timer -u -r -d 2" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT >> $seqres.full
+
+su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite 0 $((512 * file_blksz))' $SCRATCH_MNT/file2" > /dev/null
+report_rtusage
+
+overflow=$(date +%s)
+su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -b $file_blksz 0 $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage
+sleep 1
+echo "Try again after 1s"
+su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -b $file_blksz $file_blksz $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage
+sleep 2
+echo "Try again after 3s"
+su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -b $file_blksz $((2 * file_blksz)) $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage
+
+note "Extend time limits and warnings"
+rm -f $SCRATCH_MNT/file2 $SCRATCH_MNT/file2.1
+$XFS_QUOTA_PROG -x -c "limit -u rtbsoft=$((512 * file_blksz)) rtbhard=0 $qa_user" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c "timer -u -r -d 49h" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT >> $seqres.full
+
+su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite 0 $((512 * file_blksz))' $SCRATCH_MNT/file2" > /dev/null
+report_rtusage $qa_user want_timeout
+
+su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -b $file_blksz 0 $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage $qa_user want_timeout
+
+$XFS_QUOTA_PROG -x -c "timer -u -r 73h $qa_user" $SCRATCH_MNT
+
+su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -b $file_blksz $file_blksz $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage $qa_user want_timeout
+
+note "Test quota applied to bmbt"
+
+# Testing quota enforcement for bmbt shape changes is tricky.  The block
+# reservation will be for enough blocks to handle the maximal btree split.
+# This is (approximately) 9 blocks no matter the size of the existing extent
+# map structure, so we set the hard limit to one more than this quantity.
+#
+# However, that means that we need to make a file of at least twice that size
+# to ensure that we create enough extent records even in the rextsize==1 case
+# where punching doesn't just create unwritten records.
+#
+# Unfortunately, it's very difficult to predict when exactly the EDQUOT will
+# come down, so we just look for the error message.
+extent_records=$(( (25 * bmbt_blksz) / 16))
+echo "extent_records $extent_records" >> $seqres.full
+
+rm -f $SCRATCH_MNT/file2
+$XFS_QUOTA_PROG -x -c "limit -u rtbsoft=0 rtbhard=0 $qa_user" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c "limit -u bhard=$((bmbt_blksz * 10)) bsoft=0 $qa_user" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x58 -b 64m 0 $((extent_records * file_blksz))" $SCRATCH_MNT/file2 > /dev/null
+sync
+chown $qa_user $SCRATCH_MNT/file2
+$here/src/punch-alternating $SCRATCH_MNT/file2 2>&1 | _filter_scratch
+
+$XFS_QUOTA_PROG -c "quota -u -r -n -N $qa_user" -c "quota -u -b -n -N $qa_user" $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -c "bmap -e -l -p -v" $SCRATCH_MNT/file2 >> $seqres.full
+
+# success, all done
+$XFS_QUOTA_PROG -x -c 'report -a -u' -c 'report -a -u -r' $SCRATCH_MNT >> $seqres.full
+ls -latr $SCRATCH_MNT >> $seqres.full
+status=0
+exit
diff --git a/tests/xfs/767.out b/tests/xfs/767.out
new file mode 100644
index 0000000000..bff7c0f44c
--- /dev/null
+++ b/tests/xfs/767.out
@@ -0,0 +1,41 @@
+QA output created by 767
+Format filesystem
+
+Write 128rx to root
+0[real] 128 0 0 0 ---
+
+Write 64rx to root, 4444, and 5555.
+0[real] 192 0 0 0 ---
+4444[real] 64 0 0 0 ---
+5555[real] 64 0 0 0 ---
+
+Move 64rx from root to 5555
+0[real] 128 0 0 0 ---
+4444[real] 64 0 0 0 ---
+5555[real] 128 0 0 0 ---
+
+Move 64rx from 5555 to 4444
+0[real] 128 0 0 0 ---
+4444[real] 128 0 0 0 ---
+5555[real] 64 0 0 0 ---
+
+Set hard limit of 1024rx and check enforcement
+pwrite: Disk quota exceeded
+fsgqa[real] 1024 0 1024 0 ---
+
+Set soft limit of 512rx and check timelimit enforcement
+fsgqa[real] 512 512 0 0 ---
+fsgqa[real] 513 512 0 0 ---
+Try again after 1s
+fsgqa[real] 514 512 0 0 ---
+Try again after 3s
+pwrite: Disk quota exceeded
+fsgqa[real] 514 512 0 0 ---
+
+Extend time limits and warnings
+fsgqa[real] 512 512 0 0 [--------]
+fsgqa[real] 513 512 0 0 [2_days]
+fsgqa[real] 514 512 0 0 [3_days]
+
+Test quota applied to bmbt
+SCRATCH_MNT/file2: Disk quota exceeded

