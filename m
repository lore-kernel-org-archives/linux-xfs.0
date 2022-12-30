Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0893FC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiLaDIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiLaDIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:08:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D6515816;
        Fri, 30 Dec 2022 19:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6C53B81E6C;
        Sat, 31 Dec 2022 03:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904C4C433EF;
        Sat, 31 Dec 2022 03:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456090;
        bh=+36B7195VR9jl2Gu3IH7SWLqhI39xRLJcR776BqQRbg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=br40B4dtO6PGOHx/5NQ5JMtMVtPPXZtuXjO2inqTKqNU35r5zNzvOSfSMsqeJmHEk
         DhvmcHIgVdD4qIAtF0VH3mBJ0Jz2UKq0VKYBZ5Tc/3OB3pB528c1IpTW0VtolQZ2fQ
         Q5qDI5wtsBj5b0MnXbJ7PRGwHlL3emDfvhNjCSsmHiJDGXdi9DrC5mm7PS7/Rr1r2E
         i689VzY9JNVj0QdB8hNljtOOkX52Ya7NFbR1/e/QT0Ltz5efpCsPK/YYyR3F2MrPyT
         lDb3IM+m3gmrXGhuuE0+B0FpI6uY3vOk93A6Mwt23IwdKZGSq3C+0Q1JmkbtlXjA5R
         miLVpTYwObCcg==
Subject: [PATCH 8/9] xfs/509: adjust inumbers accounting for metadata
 directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:33 -0800
Message-ID: <167243883340.736753.11887860537534885651.stgit@magnolia>
In-Reply-To: <167243883244.736753.17143383151073497149.stgit@magnolia>
References: <167243883244.736753.17143383151073497149.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The INUMBERS ioctl exports data from the inode btree directly -- the
number of inodes it reports is taken from ir_freemask and includes all
the files in the metadata directory tree.  BULKSTAT, on the other hand,
only reports non-metadata files.  When metadir is enabled, this will
(eventually) cause a discrepancy in the inode counts that is large
enough to exceed the tolerances, thereby causing a test failure.

Correct this by counting the files in the metadata directory and
subtracting that from the INUMBERS totals.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/509 |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/509 b/tests/xfs/509
index d04dfbbfba..b87abef964 100755
--- a/tests/xfs/509
+++ b/tests/xfs/509
@@ -91,13 +91,13 @@ inumbers_count()
 	bstat_versions | while read v_tag v_flag; do
 		echo -n "inumbers all($v_tag): "
 		nr=$(inumbers_fs $SCRATCH_MNT $v_flag)
-		_within_tolerance "inumbers" $nr $expect $tolerance -v
+		_within_tolerance "inumbers" $((nr - METADATA_FILES)) $expect $tolerance -v
 
 		local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
 		for batchsize in 71 2 1; do
 			echo -n "inumbers $batchsize($v_tag): "
 			nr=$(inumbers_ag $agcount $batchsize $SCRATCH_MNT $v_flag)
-			_within_tolerance "inumbers" $nr $expect $tolerance -v
+			_within_tolerance "inumbers" $((nr - METADATA_FILES)) $expect $tolerance -v
 		done
 	done
 }
@@ -143,9 +143,26 @@ _supported_fs xfs
 DIRCOUNT=8
 INOCOUNT=$((2048 / DIRCOUNT))
 
+# Count everything in the metadata directory tree.
+count_metadir_files() {
+	local metadirs=('/realtime' '/quota')
+	local db_args=('-f')
+
+	for m in "${metadirs[@]}"; do
+		db_args+=('-c' "ls -m $m")
+	done
+
+	local ret=$(_scratch_xfs_db "${db_args[@]}" 2>/dev/null | grep regular | wc -l)
+	test -z "$ret" && ret=0
+	echo $ret
+}
+
 _scratch_mkfs "-d agcount=$DIRCOUNT" >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
+METADATA_FILES=$(count_metadir_files)
+echo "found $METADATA_FILES metadata files" >> $seqres.full
+
 # Figure out if we have v5 bulkstat/inumbers ioctls.
 has_v5=
 bs_root_out="$($XFS_IO_PROG -c 'bulkstat_single root' $SCRATCH_MNT 2>>$seqres.full)"

