Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A08C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbiLaDMW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiLaDMV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722681104;
        Fri, 30 Dec 2022 19:12:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1257761D06;
        Sat, 31 Dec 2022 03:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1FDC433EF;
        Sat, 31 Dec 2022 03:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456339;
        bh=fYN1p6cOeDZHZJqgRz5r1WC22Pm3alzRVtB6KDDK+eo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uzBw7WT1axhgkpDAWQBsZt98AdvuYN6nlNHK9g+oFyZA3Ywl7spHSAiH/kuX51GEC
         XTnrAOyaM8rkSY/SOvaSW1Vaia/F41d+ViJ/83DLK8hjzwhkewuQkB7Hwky93Zqq3G
         3FUXbW2MYAg7cgBBBO4dP+SI1fplNwiLM7JIGfJIxadtyEARwYmUbQVIIJfV+DO7Ig
         wp+Zg7nm1P+PESwPGo+5fXnwcf1zz8HaTKteYej9gJdtLdtP9ex4MVUw8tyE6J7KmC
         pL/1mZ74yd1/lNXwrH29R6mz9z7bMqIbXkYeXcHFp2Bx/ou/xhQJw9HQztqsokNmU+
         U1YMimA420fMA==
Subject: [PATCH 11/12] common/xfs: capture realtime devices during
 metadump/mdrestore
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884089.739029.13006888061367748128.stgit@magnolia>
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

If xfs_metadump supports the -x and -R switches to capture the contents
of realtime devices and there is a realtime device, add the option to
the command line to enable preservation.

Similarly, if xfs_mdrestore supports the -R switch and there's an
external scratch rtdev, pass the option so that we can restore rtdev
contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy    |    6 +++++-
 common/populate |   12 ++++++++++--
 common/xfs      |   48 +++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 54 insertions(+), 12 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 7034ff8c42..7f96384402 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -302,7 +302,11 @@ __scratch_xfs_fuzz_mdrestore()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		logdev=$SCRATCH_LOGDEV
 
-	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" "${logdev}" || \
+	local rtdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" "${logdev}" "${rtdev}" || \
 		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
 }
 
diff --git a/common/populate b/common/populate
index 095e771d67..c0bbbc3f3b 100644
--- a/common/populate
+++ b/common/populate
@@ -908,7 +908,11 @@ _scratch_populate_restore_cached() {
 
 	case "${FSTYP}" in
 	"xfs")
-		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
+		local rtdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+			rtdev=$SCRATCH_RTDEV
+
+		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}" "${rtdev}"
 		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
@@ -930,8 +934,12 @@ _scratch_populate_save_metadump()
 		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 			logdev=$SCRATCH_LOGDEV
 
+		local rtdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+			rtdev=$SCRATCH_RTDEV
+
 		_xfs_metadump "$metadump_file" "$SCRATCH_DEV" "$logdev" \
-				compress
+				"$rtdev" compress
 		res=$?
 		;;
 	"ext2"|"ext3"|"ext4")
diff --git a/common/xfs b/common/xfs
index 6089a05d0e..a37284068f 100644
--- a/common/xfs
+++ b/common/xfs
@@ -679,15 +679,20 @@ _xfs_metadump() {
 	local metadump="$1"
 	local device="$2"
 	local logdev="$3"
-	local compressopt="$4"
-	shift; shift; shift; shift
+	local rtdev="$4"
+	local compressopt="$5"
+	shift; shift; shift; shift; shift
 	local options="$@"
 	test -z "$options" && options="-a -o"
 	local metadump_has_dash_x
+	local metadump_has_dash_R
 
 	# Does metadump support capturing from external devices?
 	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-[a-zA-Z]*[wW]x' && \
 			metadump_has_dash_x=1
+	# Does metadump support capturing realtime devices?
+	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-R rtdev' && \
+			metadump_has_dash_R=1
 
 	if [ "$logdev" != "none" ]; then
 		options="$options -l $logdev"
@@ -699,6 +704,17 @@ _xfs_metadump() {
 		fi
 	fi
 
+	# Capture the realtime device, if possible
+	if [ "$rtdev" != "none" ] && [ -n "$metadump_has_dash_R" ]; then
+		options="$options -R $rtdev"
+
+		# Tell metadump to capture the rt device
+		if [ -n "$metadump_has_dash_x" ]; then
+			options="$options -x"
+			unset metadump_has_dash_x
+		fi
+	fi
+
 	$XFS_METADUMP_PROG $options "$device" "$metadump"
 	res=$?
 	[ "$compressopt" = "compress" ] && [ -n "$DUMP_COMPRESSOR" ] &&
@@ -710,7 +726,8 @@ _xfs_mdrestore() {
 	local metadump="$1"
 	local device="$2"
 	local logdev="$3"
-	shift; shift; shift
+	local rtdev="$4"
+	shift; shift; shift; shift
 	local options="$@"
 
 	# If we're configured for compressed dumps and there isn't already an
@@ -730,6 +747,11 @@ _xfs_mdrestore() {
 		logdev="none"
 	fi
 
+	# Does mdrestore support restoring to realtime devices?
+	if [ "$rtdev" != "none" ] && $XFS_MDRESTORE_PROG --help 2>&1 | grep -q -- '-R rtdev'; then
+		options="$options -R $rtdev"
+	fi
+
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 	res=$?
 	test $res -ne 0 && return $res
@@ -750,12 +772,16 @@ _scratch_xfs_metadump()
 {
 	local metadump=$1
 	shift
+
 	local logdev=none
-
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		logdev=$SCRATCH_LOGDEV
 
-	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" nocompress "$@"
+	local rtdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" nocompress "$@"
 }
 
 # Restore snapshotted metadata on the scratch device
@@ -768,7 +794,11 @@ _scratch_xfs_mdrestore()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		logdev=$SCRATCH_LOGDEV
 
-	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$@"
+	local rtdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" "$@"
 }
 
 # run xfs_check and friends on a FS.
@@ -895,7 +925,7 @@ _check_xfs_filesystem()
 	if [ "$ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 		local flatdev="$(basename "$device")"
 		_xfs_metadump "$seqres.$flatdev.check.md" "$device" "$logdev" \
-			compress >> $seqres.full
+			"$rtdev" compress >> $seqres.full
 	fi
 
 	# Optionally test the index rebuilding behavior.
@@ -928,7 +958,7 @@ _check_xfs_filesystem()
 		if [ "$rebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.rebuild.md" "$device" \
-				"$logdev" compress >> $seqres.full
+				"$logdev" "$rtdev" compress >> $seqres.full
 		fi
 	fi
 
@@ -1009,7 +1039,7 @@ _check_xfs_filesystem()
 		if [ "$orebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.orebuild.md" "$device" \
-				"$logdev" compress >> $seqres.full
+				"$logdev" "$rtdev" compress >> $seqres.full
 		fi
 	fi
 

