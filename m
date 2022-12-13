Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0713FC10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiLMTpT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236674AbiLMTpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:45:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC2A2494A;
        Tue, 13 Dec 2022 11:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C48F3B815B1;
        Tue, 13 Dec 2022 19:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B94C433EF;
        Tue, 13 Dec 2022 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960715;
        bh=NHGfY35oR8EUPomUFOSE8wOPn7JdR+FoqlMQtXdmSMU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uR9/DP7L2uDAqlVUE8aGfyK71vLzOJdmIR/l9imEqXd2k6JsUuvHZ1O5EgPf1KmSv
         8obVemZkBv1voc52Y86Emv/15cXmCGI6jout3NwbTOuFFaHmHuK/8KqAS3T+f/9bSF
         zR9pIk1AtvqfSiFefLTYDL/ONwDwQan/0SSahQgm8D4Wa4oB3PYKRad4cHuiHu8Xh1
         tFPPItJIAkyLpf6v3Fp2ZI2NANJIHd9n8gameNH1wN5/hWI/dBdF818FP5YOS0Payy
         XfXy//i00y+/hE4/1xUd42Fed0W4DBpKQadXJrPb5lWXnjKkE5cghrUiQbtk+j7xPf
         h2HxPk+WP4e2w==
Subject: [PATCH 1/4] common/populate: create helpers to handle restoring
 metadumps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Dec 2022 11:45:15 -0800
Message-ID: <167096071510.1750373.2221240504175764288.stgit@magnolia>
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

Refactor _scratch_populate_restore_cached so that the actual commands
for restoring metadumps are filesystem-specific helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/ext4     |   10 ++++++++++
 common/fuzzy    |    2 +-
 common/populate |    4 ++--
 common/xfs      |    9 +++++++++
 4 files changed, 22 insertions(+), 3 deletions(-)


diff --git a/common/ext4 b/common/ext4
index 4a2eaa157f..dc2e4e59cc 100644
--- a/common/ext4
+++ b/common/ext4
@@ -125,6 +125,16 @@ _ext4_metadump()
 		$DUMP_COMPRESSOR -f "$dumpfile" &>> "$seqres.full"
 }
 
+_ext4_mdrestore()
+{
+	local metadump="$1"
+	local device="$2"
+	shift; shift
+	local options="$@"
+
+	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
+}
+
 # this test requires the ext4 kernel support crc feature on scratch device
 #
 _require_scratch_ext4_crc()
diff --git a/common/fuzzy b/common/fuzzy
index 2d688fd27b..fad79124e5 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -159,7 +159,7 @@ __scratch_xfs_fuzz_mdrestore()
 	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
 
 	__scratch_xfs_fuzz_unmount
-	$XFS_MDRESTORE_PROG "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
+	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
 }
 
 __fuzz_notify() {
diff --git a/common/populate b/common/populate
index 6e00499734..f382c40aca 100644
--- a/common/populate
+++ b/common/populate
@@ -861,7 +861,7 @@ _scratch_populate_restore_cached() {
 
 	case "${FSTYP}" in
 	"xfs")
-		$XFS_MDRESTORE_PROG "${metadump}" "${SCRATCH_DEV}"
+		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
 		res=$?
 		test $res -ne 0 && return $res
 
@@ -876,7 +876,7 @@ _scratch_populate_restore_cached() {
 		return $res
 		;;
 	"ext2"|"ext3"|"ext4")
-		$E2IMAGE_PROG -r "${metadump}" "${SCRATCH_DEV}"
+		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
 		ret=$?
 		test $ret -ne 0 && return $ret
 
diff --git a/common/xfs b/common/xfs
index f466d2c42f..27d6ac84e3 100644
--- a/common/xfs
+++ b/common/xfs
@@ -638,6 +638,15 @@ _xfs_metadump() {
 	return $res
 }
 
+_xfs_mdrestore() {
+	local metadump="$1"
+	local device="$2"
+	shift; shift
+	local options="$@"
+
+	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
+}
+
 # Snapshot the metadata on the scratch device
 _scratch_xfs_metadump()
 {

