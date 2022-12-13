Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC18FC10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbiLMTp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiLMTpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:45:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3801EDFF6;
        Tue, 13 Dec 2022 11:45:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBE6C6171D;
        Tue, 13 Dec 2022 19:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA31C433EF;
        Tue, 13 Dec 2022 19:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960723;
        bh=JMP/OHGwFRI2ZlExeb50OJGCkOsRRZ+fywXAeZ+AJ40=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UbJpoJF9CqCyrTtBWy0SKYnFno9Qb7orHMapb5gDgZMcqkqPXLxIRe4YFuqaEmGrf
         PTtsre8krKrbBNY5gs3i1WMufcK1FEr9C91Og80p1RcAL9yKs3Tvds/g3FCx9cnoDy
         c5e2Voe0qM7V9poUhFC7Pm3M8ZnHmJl94MZKt72j/E2/a6C7Cy/FKG/BT04BZyNjK9
         4Caqn3ykgfv5yjUi1KqMl7olyY9g1SVJbu/YIT849mq1q33G7fDdokiOYQkH8W//Ab
         em0sWMVtCHYevsqqOAjMd7dBLgt5Lm0RE91uhvlGmDAzR60X62iVSQQW1PZY1rWiHc
         /Lmugm7NkNidg==
Subject: [PATCH 2/4] common/xfs: create a helper for restoring metadumps to
 the scratch devs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Dec 2022 11:45:20 -0800
Message-ID: <167096072069.1750373.18446461395763381324.stgit@magnolia>
In-Reply-To: <167096070957.1750373.5715692265711468248.stgit@magnolia>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor the open-coded $XFS_MDRESTORE_PROG calls into a proper
_scratch_xfs_mdrestore helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |    9 +++++++++
 tests/xfs/129 |    2 +-
 tests/xfs/234 |    2 +-
 tests/xfs/253 |    2 +-
 tests/xfs/284 |    2 +-
 tests/xfs/291 |    2 +-
 tests/xfs/336 |    2 +-
 tests/xfs/432 |    2 +-
 tests/xfs/503 |    8 ++++----
 9 files changed, 20 insertions(+), 11 deletions(-)


diff --git a/common/xfs b/common/xfs
index 27d6ac84e3..216dab3bcd 100644
--- a/common/xfs
+++ b/common/xfs
@@ -660,6 +660,15 @@ _scratch_xfs_metadump()
 	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" nocompress "$@"
 }
 
+# Restore snapshotted metadata on the scratch device
+_scratch_xfs_mdrestore()
+{
+	local metadump=$1
+	shift
+
+	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
+}
+
 # run xfs_check and friends on a FS.
 _check_xfs_filesystem()
 {
diff --git a/tests/xfs/129 b/tests/xfs/129
index 09d40630d0..6f2ef5640d 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -53,7 +53,7 @@ _scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
-$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
+SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
 SCRATCH_DEV=$TEST_DIR/image _scratch_mount
 SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
 
diff --git a/tests/xfs/234 b/tests/xfs/234
index cc1ee9a8ca..57d447c056 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -53,7 +53,7 @@ _scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
-$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
+SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
 SCRATCH_DEV=$TEST_DIR/image _scratch_mount
 SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
 
diff --git a/tests/xfs/253 b/tests/xfs/253
index 1cfc218088..ce90247777 100755
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -152,7 +152,7 @@ _scratch_unmount
 _scratch_xfs_metadump $METADUMP_FILE
 
 # Now restore the obfuscated one back and take a look around
-$XFS_MDRESTORE_PROG "${METADUMP_FILE}" "${SCRATCH_DEV}"
+_scratch_xfs_mdrestore "$METADUMP_FILE"
 
 _scratch_mount
 
diff --git a/tests/xfs/284 b/tests/xfs/284
index e2bd05d4c7..58f330035e 100755
--- a/tests/xfs/284
+++ b/tests/xfs/284
@@ -49,7 +49,7 @@ _scratch_unmount
 # xfs_mdrestore should refuse to restore to a mounted device
 _scratch_xfs_metadump $METADUMP_FILE
 _scratch_mount
-$XFS_MDRESTORE_PROG $METADUMP_FILE $SCRATCH_DEV 2>&1 | filter_mounted
+_scratch_xfs_mdrestore $METADUMP_FILE 2>&1 | filter_mounted
 _scratch_unmount
 
 # Test xfs_copy to a mounted device
diff --git a/tests/xfs/291 b/tests/xfs/291
index f5fea7f9a5..600dcb2eba 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -93,7 +93,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
 # Yes they can!  Now...
 # Can xfs_metadump cope with this monster?
 _scratch_xfs_metadump $tmp.metadump || _fail "xfs_metadump failed"
-$XFS_MDRESTORE_PROG $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
+SCRATCH_DEV=$tmp.img _scratch_xfs_mdrestore $tmp.metadump || _fail "xfs_mdrestore failed"
 SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
 	_fail "xfs_repair of metadump failed"
 
diff --git a/tests/xfs/336 b/tests/xfs/336
index ee8ec649cb..5bcac976e4 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -65,7 +65,7 @@ _scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
-$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
+SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
 SCRATCH_DEV=$TEST_DIR/image _scratch_mount
 SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
 
diff --git a/tests/xfs/432 b/tests/xfs/432
index 676be9bd8a..66315b0398 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -87,7 +87,7 @@ test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
 
 echo "Try to metadump"
 _scratch_xfs_metadump $metadump_file -w
-$XFS_MDRESTORE_PROG $metadump_file $metadump_img
+SCRATCH_DEV=$metadump_img _scratch_xfs_mdrestore $metadump_file
 
 echo "Check restored metadump image"
 SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
diff --git a/tests/xfs/503 b/tests/xfs/503
index 18bd8694c8..c786b04ccd 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -66,25 +66,25 @@ _check_scratch_fs
 _scratch_unmount
 
 echo mdrestore
-$XFS_MDRESTORE_PROG $metadump_file $SCRATCH_DEV
+_scratch_xfs_mdrestore $metadump_file
 _scratch_mount
 _check_scratch_fs
 _scratch_unmount
 
 echo mdrestore a
-$XFS_MDRESTORE_PROG $metadump_file_a $SCRATCH_DEV
+_scratch_xfs_mdrestore $metadump_file_a
 _scratch_mount
 _check_scratch_fs
 _scratch_unmount
 
 echo mdrestore g
-$XFS_MDRESTORE_PROG $metadump_file_g $SCRATCH_DEV
+_scratch_xfs_mdrestore $metadump_file_g
 _scratch_mount
 _check_scratch_fs
 _scratch_unmount
 
 echo mdrestore ag
-$XFS_MDRESTORE_PROG $metadump_file_ag $SCRATCH_DEV
+_scratch_xfs_mdrestore $metadump_file_ag
 _scratch_mount
 _check_scratch_fs
 _scratch_unmount

