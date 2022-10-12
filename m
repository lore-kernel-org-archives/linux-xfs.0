Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9716C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJLBpz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJLBpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:45:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B87D97EEA;
        Tue, 11 Oct 2022 18:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17038B80BFC;
        Wed, 12 Oct 2022 01:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06E2C433C1;
        Wed, 12 Oct 2022 01:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665539150;
        bh=AzsGNLHQvLkc3Kvhnmf6Sff2DXrnLUsMTnKxmNstU58=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cgYaNSUtLC3mcoUb/e4VTj3ycv84vj1rK2Pnuo0KngKWZPur3pNO7WrRAd+aXC3dU
         w6J3n4Ix+CuClx971UlZ0S9HYcfwLlFhOT+KM2Lzuq7v+DPbwIsNQxXJtQD/kVLmiK
         qZtX40GJ+8AfKh5R2lGur7t9y8nzHyxYGymByHxTWIBiKID2UY6tznCVBDOBNhvvIR
         ewq3swA3cFQzm5dTIwlLComM0za3yx3cQNZubP9hFbqpS7DjVyFinsoqar75zlGubP
         eXhUY4bz2n/bzfI2a2DR6AMTwtiy9XsjsgTTReNkFs3LR/LtATuw7JWsSN068dSa65
         YnGsI008N1biQ==
Subject: [PATCH 5/5] fstests: refactor xfs_mdrestore calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Oct 2022 18:45:50 -0700
Message-ID: <166553915032.422450.8262466611928449491.stgit@magnolia>
In-Reply-To: <166553912229.422450.15473762183660906876.stgit@magnolia>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wrap calls to xfs_mdrestore in the usual $XFS_MDRESTORE_PROG variable.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/config   |    1 +
 common/fuzzy    |    2 +-
 common/populate |    3 ++-
 tests/xfs/129   |    3 ++-
 tests/xfs/234   |    3 ++-
 tests/xfs/253   |    3 ++-
 tests/xfs/284   |    3 ++-
 tests/xfs/291   |    3 ++-
 tests/xfs/336   |    3 ++-
 tests/xfs/432   |    3 ++-
 tests/xfs/503   |    9 +++++----
 11 files changed, 23 insertions(+), 13 deletions(-)


diff --git a/common/config b/common/config
index 5eaae4471d..0c3813dc23 100644
--- a/common/config
+++ b/common/config
@@ -156,6 +156,7 @@ export XFS_LOGPRINT_PROG="$(type -P xfs_logprint)"
 export XFS_REPAIR_PROG="$(type -P xfs_repair)"
 export XFS_DB_PROG="$(type -P xfs_db)"
 export XFS_METADUMP_PROG="$(type -P xfs_metadump)"
+export XFS_MDRESTORE_PROG="$(type -P xfs_mdrestore)"
 export XFS_ADMIN_PROG="$(type -P xfs_admin)"
 export XFS_GROWFS_PROG=$(type -P xfs_growfs)
 export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
diff --git a/common/fuzzy b/common/fuzzy
index b4fda6f533..2d688fd27b 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -159,7 +159,7 @@ __scratch_xfs_fuzz_mdrestore()
 	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
 
 	__scratch_xfs_fuzz_unmount
-	xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
+	$XFS_MDRESTORE_PROG "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
 }
 
 __fuzz_notify() {
diff --git a/common/populate b/common/populate
index 05bdfe33c5..0c0538554a 100644
--- a/common/populate
+++ b/common/populate
@@ -15,6 +15,7 @@ _require_populate_commands() {
 	"xfs")
 		_require_command "$XFS_DB_PROG" "xfs_db"
 		_require_command "$WIPEFS_PROG" "wipefs"
+		_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 		;;
 	ext*)
 		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
@@ -860,7 +861,7 @@ _scratch_populate_restore_cached() {
 
 	case "${FSTYP}" in
 	"xfs")
-		xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
+		$XFS_MDRESTORE_PROG "${metadump}" "${SCRATCH_DEV}"
 		res=$?
 		test $res -ne 0 && return $res
 
diff --git a/tests/xfs/129 b/tests/xfs/129
index 90887d5476..09d40630d0 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -25,6 +25,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_loop
 _require_scratch_reflink
 
@@ -52,7 +53,7 @@ _scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
-xfs_mdrestore $metadump_file $TEST_DIR/image
+$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
 SCRATCH_DEV=$TEST_DIR/image _scratch_mount
 SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
 
diff --git a/tests/xfs/234 b/tests/xfs/234
index 6ff2f228e8..cc1ee9a8ca 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -24,6 +24,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_loop
 _require_xfs_scratch_rmapbt
 _require_xfs_io_command "fpunch"
@@ -52,7 +53,7 @@ _scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
-xfs_mdrestore $metadump_file $TEST_DIR/image
+$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
 SCRATCH_DEV=$TEST_DIR/image _scratch_mount
 SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
 
diff --git a/tests/xfs/253 b/tests/xfs/253
index 1899ce5226..1cfc218088 100755
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -32,6 +32,7 @@ _cleanup()
 # Import common functions.
 . ./common/filter
 
+_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_test
 _require_scratch
 
@@ -151,7 +152,7 @@ _scratch_unmount
 _scratch_xfs_metadump $METADUMP_FILE
 
 # Now restore the obfuscated one back and take a look around
-xfs_mdrestore "${METADUMP_FILE}" "${SCRATCH_DEV}"
+$XFS_MDRESTORE_PROG "${METADUMP_FILE}" "${SCRATCH_DEV}"
 
 _scratch_mount
 
diff --git a/tests/xfs/284 b/tests/xfs/284
index fa7bfdd0f0..e2bd05d4c7 100755
--- a/tests/xfs/284
+++ b/tests/xfs/284
@@ -24,6 +24,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_xfs_copy
 _require_test
 _require_scratch
@@ -48,7 +49,7 @@ _scratch_unmount
 # xfs_mdrestore should refuse to restore to a mounted device
 _scratch_xfs_metadump $METADUMP_FILE
 _scratch_mount
-xfs_mdrestore $METADUMP_FILE $SCRATCH_DEV 2>&1 | filter_mounted
+$XFS_MDRESTORE_PROG $METADUMP_FILE $SCRATCH_DEV 2>&1 | filter_mounted
 _scratch_unmount
 
 # Test xfs_copy to a mounted device
diff --git a/tests/xfs/291 b/tests/xfs/291
index a2425e472d..f5fea7f9a5 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -13,6 +13,7 @@ _begin_fstest auto repair metadump
 . ./common/filter
 
 _supported_fs xfs
+_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 
 # real QA test starts here
 _require_scratch
@@ -92,7 +93,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
 # Yes they can!  Now...
 # Can xfs_metadump cope with this monster?
 _scratch_xfs_metadump $tmp.metadump || _fail "xfs_metadump failed"
-xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
+$XFS_MDRESTORE_PROG $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
 SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
 	_fail "xfs_repair of metadump failed"
 
diff --git a/tests/xfs/336 b/tests/xfs/336
index 6592419d03..b1de8e5fc1 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -21,6 +21,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_realtime
 _require_xfs_scratch_rmapbt
 _require_test_program "punch-alternating"
@@ -64,7 +65,7 @@ _scratch_xfs_metadump $metadump_file
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
-xfs_mdrestore $metadump_file $TEST_DIR/image
+$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
 SCRATCH_DEV=$TEST_DIR/image _scratch_mount
 SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
 
diff --git a/tests/xfs/432 b/tests/xfs/432
index e1e610d054..676be9bd8a 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -28,6 +28,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_scratch
 
 rm -f "$seqres.full"
@@ -86,7 +87,7 @@ test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
 
 echo "Try to metadump"
 _scratch_xfs_metadump $metadump_file -w
-xfs_mdrestore $metadump_file $metadump_img
+$XFS_MDRESTORE_PROG $metadump_file $metadump_img
 
 echo "Check restored metadump image"
 SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
diff --git a/tests/xfs/503 b/tests/xfs/503
index 6c4bfd1c45..18bd8694c8 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -28,6 +28,7 @@ testdir=$TEST_DIR/test-$seq
 # real QA test starts here
 _supported_fs xfs
 
+_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_xfs_copy
 _require_scratch_nocheck
 _require_populate_commands
@@ -65,25 +66,25 @@ _check_scratch_fs
 _scratch_unmount
 
 echo mdrestore
-xfs_mdrestore $metadump_file $SCRATCH_DEV
+$XFS_MDRESTORE_PROG $metadump_file $SCRATCH_DEV
 _scratch_mount
 _check_scratch_fs
 _scratch_unmount
 
 echo mdrestore a
-xfs_mdrestore $metadump_file_a $SCRATCH_DEV
+$XFS_MDRESTORE_PROG $metadump_file_a $SCRATCH_DEV
 _scratch_mount
 _check_scratch_fs
 _scratch_unmount
 
 echo mdrestore g
-xfs_mdrestore $metadump_file_g $SCRATCH_DEV
+$XFS_MDRESTORE_PROG $metadump_file_g $SCRATCH_DEV
 _scratch_mount
 _check_scratch_fs
 _scratch_unmount
 
 echo mdrestore ag
-xfs_mdrestore $metadump_file_ag $SCRATCH_DEV
+$XFS_MDRESTORE_PROG $metadump_file_ag $SCRATCH_DEV
 _scratch_mount
 _check_scratch_fs
 _scratch_unmount

