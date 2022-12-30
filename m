Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962A3C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiLaDMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiLaDMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:12:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6C31104;
        Fri, 30 Dec 2022 19:12:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CBA1B81E69;
        Sat, 31 Dec 2022 03:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67FAC433EF;
        Sat, 31 Dec 2022 03:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456323;
        bh=pPEO/P4oIew2l6FEt8LSrmEKtt3KARoUoizygJX/xpc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pJKauModK8Qx6phbZCsHLJpMXXv0UuvhG60TpS0E649vXCCKbcCbSLcYqCKuPYblL
         yXGyzN06ZteeYSYZgboRDxoiNOC59VELejeYZNi0ePihB6599z1KAE5TTiHV0py1MI
         SGrNbH2QnQM2WKt1RYSs+jTy739WvSZhRCdZvDEndqPZpheWVmFDLM2cOy1p3Sm7Zc
         bRKPezt+0BpDcBA1Tn1jRAHkEi/sFafp9nRgUt24QSI9CEFA8cYo5VhHL+rbJ9Z5TW
         kY6Oj8EtulpJc7xM44ifg6YnSWqDSqKWVxSTYs4t9QzJSA17puHyvbu65CW0xIrix/
         f/abmo+VuX+0Q==
Subject: [PATCH 10/12] xfs/27[46],xfs/556: fix tests to deal with rtgroups
 output in bmap/fsmap commands
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884076.739029.15949521498602375099.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix these tests to deal with the xfs_io bmap and fsmap commands printing
out realtime group numbers if the feature is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |    4 ++++
 tests/xfs/271 |    3 ++-
 tests/xfs/556 |   16 ++++++++++------
 3 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/common/xfs b/common/xfs
index ccdcf45d0d..6089a05d0e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -486,6 +486,10 @@ _xfs_has_feature()
 		feat="rtextents"
 		feat_regex="[1-9][0-9]*"
 		;;
+	"rtgroups")
+		feat="rgcount"
+		feat_regex="[1-9][0-9]*"
+		;;
 	esac
 
 	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -E -w -c "$feat=$feat_regex")"
diff --git a/tests/xfs/271 b/tests/xfs/271
index d67ac4d6c1..74e2c822c1 100755
--- a/tests/xfs/271
+++ b/tests/xfs/271
@@ -31,6 +31,7 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
 agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+rgcount=$(_xfs_mount_rgcount $SCRATCH_MNT)
 
 # mkfs lays out btree root blocks in the order bnobt, cntbt, inobt, finobt,
 # rmapbt, refcountbt, and then allocates AGFL blocks.  Since GETFSMAP has the
@@ -48,7 +49,7 @@ cat $TEST_DIR/fsmap >> $seqres.full
 
 echo "Check AG header" | tee -a $seqres.full
 grep 'static fs metadata[[:space:]]*[0-9]*[[:space:]]*(0\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
-_within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $agcount 0 -v
+_within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $((agcount + rgcount)) 0 -v
 
 echo "Check freesp/rmap btrees" | tee -a $seqres.full
 grep 'per-AG metadata[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
diff --git a/tests/xfs/556 b/tests/xfs/556
index 66908a5410..72343e8625 100755
--- a/tests/xfs/556
+++ b/tests/xfs/556
@@ -47,16 +47,20 @@ victim=$SCRATCH_MNT/a
 file_blksz=$(_get_file_block_size $SCRATCH_MNT)
 $XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
 unset errordev
-_xfs_is_realtime_file $victim && errordev="RT"
+
+awk_len_prog='{print $6}'
+if _xfs_is_realtime_file $victim; then
+	if ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+		awk_len_prog='{print $4}'
+	fi
+	errordev="RT"
+fi
 bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
 echo "$errordev:$bmap_str" >> $seqres.full
 
 phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
-if [ "$errordev" = "RT" ]; then
-	len="$(echo "$bmap_str" | $AWK_PROG '{print $4}')"
-else
-	len="$(echo "$bmap_str" | $AWK_PROG '{print $6}')"
-fi
+len="$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
+
 fs_blksz=$(_get_block_size $SCRATCH_MNT)
 echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
 kernel_sectors_per_fs_block=$((fs_blksz / 512))

