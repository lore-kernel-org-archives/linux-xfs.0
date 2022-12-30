Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C10C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbiLaDJB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbiLaDJA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:09:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24C010540;
        Fri, 30 Dec 2022 19:08:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75E33B81E69;
        Sat, 31 Dec 2022 03:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317DAC433D2;
        Sat, 31 Dec 2022 03:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456137;
        bh=Fap7+eQntY4azp33+7EmMEt/z/LH/Y9zKHAx3JZPLl0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hZddP1VRGYfNZhvtvt9CKvOp11K6ClizRoHJQPAianxHSe8hll4UcRl+P7mJEezjE
         9XVZhe7YFIBEfUf+uGwA25FHTGVMsFnr3D3S3s/e2wQr8qw/UxkEsn1kUddKdcIl1r
         BMSs1g4I0lFamq6fGOtnQ1mVS545KiI0vowaLx5V9L9go04igNEgQitssFyoBfW5bp
         vFPd+mHlVXi4PY65Sq+PCqb+8ekZepcJn8zwD6ZbwZxiFQY+qa95yw50z+3+8wgt79
         fr9wdDMXh9B3FrsxojHPm0f2Q5EczNYtW07VSEFqSKWlmxEqGjkzwPLP8Hr+QlTkPh
         URhseMgII46TQ==
Subject: [PATCH 2/4] common/xfs: wipe external logs during mdrestore
 operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:36 -0800
Message-ID: <167243883638.738384.14861856901709322328.stgit@magnolia>
In-Reply-To: <167243883613.738384.6883268151338937809.stgit@magnolia>
References: <167243883613.738384.6883268151338937809.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The XFS metadump file format doesn't support the capture of external log
devices, which means that mdrestore ought to wipe the external log and
run xfs_repair to rewrite the log device as needed to get the restored
filesystem to work again.  The common/populate code could already do
this, so push it to the common xfs helper.

While we're at it, fix the uncareful usage of SCRATCH_LOGDEV in the
populate code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy    |    7 ++++++-
 common/populate |   19 ++++++-------------
 common/xfs      |   21 +++++++++++++++++++--
 3 files changed, 31 insertions(+), 16 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index ef54f2fe2c..7034ff8c42 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -297,7 +297,12 @@ __scratch_xfs_fuzz_unmount()
 __scratch_xfs_fuzz_mdrestore()
 {
 	__scratch_xfs_fuzz_unmount
-	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" || \
+
+	local logdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		logdev=$SCRATCH_LOGDEV
+
+	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" "${logdev}" || \
 		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
 }
 
diff --git a/common/populate b/common/populate
index 8db7acefb6..08c4bdc151 100644
--- a/common/populate
+++ b/common/populate
@@ -902,21 +902,14 @@ _scratch_populate_cache_tag() {
 _scratch_populate_restore_cached() {
 	local metadump="$1"
 
+	local logdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		logdev=$SCRATCH_LOGDEV
+
 	case "${FSTYP}" in
 	"xfs")
-		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		res=$?
-		test $res -ne 0 && return $res
-
-		# Cached images should have been unmounted cleanly, so if
-		# there's an external log we need to wipe it and run repair to
-		# format it to match this filesystem.
-		if [ -n "${SCRATCH_LOGDEV}" ]; then
-			$WIPEFS_PROG -a "${SCRATCH_LOGDEV}"
-			_scratch_xfs_repair
-			res=$?
-		fi
-		return $res
+		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
+		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
 		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
diff --git a/common/xfs b/common/xfs
index 77af8a6d60..29130fabbc 100644
--- a/common/xfs
+++ b/common/xfs
@@ -682,7 +682,8 @@ _xfs_metadump() {
 _xfs_mdrestore() {
 	local metadump="$1"
 	local device="$2"
-	shift; shift
+	local logdev="$3"
+	shift; shift; shift
 	local options="$@"
 
 	# If we're configured for compressed dumps and there isn't already an
@@ -696,6 +697,18 @@ _xfs_mdrestore() {
 	test -r "$metadump" || return 1
 
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
+	res=$?
+	test $res -ne 0 && return $res
+
+	# Cached images should have been unmounted cleanly, so if there's an
+	# external log we need to wipe it and run repair to format it to match
+	# this filesystem.
+	if [ "${logdev}" != "none" ]; then
+		$WIPEFS_PROG -a "${logdev}"
+		_scratch_xfs_repair
+		res=$?
+	fi
+	return $res
 }
 
 # Snapshot the metadata on the scratch device
@@ -717,7 +730,11 @@ _scratch_xfs_mdrestore()
 	local metadump=$1
 	shift
 
-	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
+	local logdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		logdev=$SCRATCH_LOGDEV
+
+	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$@"
 }
 
 # run xfs_check and friends on a FS.

