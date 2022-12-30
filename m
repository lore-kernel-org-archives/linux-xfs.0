Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10360C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiLaDIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbiLaDIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:08:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DDD12A9C;
        Fri, 30 Dec 2022 19:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C0DF61D43;
        Sat, 31 Dec 2022 03:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6807C433EF;
        Sat, 31 Dec 2022 03:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456121;
        bh=ZNjCnCZ07gW3ub0N+12jMOAoaMlKgghqJ3lcLjm0/q4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G7h3lexHr+I2YhnKCiE375+N+Nf7Zw3Anix7bW44TjSI+oNjgKcY0Scle15oRHdan
         3Z4N1+k1qmBTsIqjnacrW0Zn5bdPXDnz4vyOwvSUZcV5J/uORB76yTkqU3MUz8HLW4
         JFcbdTKltvh2VjzogeTQ9e6cLkiiWLkzB52Hjy6ypVbuBSszDscelYzyUfjjuk89hz
         xjy6B5xOiEbqZSDET92l733SdF4ThoHaKIOSZ/4aTd84ZgMLGFouVuoy1IlpSYGdh1
         9kUVLRU1kC4fclpMXQUljbF/ViUM+8QgwkeIo/PeKF62wEWPSM3oWZlY2bdkdLOnQ+
         V6ayeOVRzqtmQ==
Subject: [PATCH 1/4] common/populate: refactor caching of metadumps to a
 helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:36 -0800
Message-ID: <167243883626.738384.359731015865489369.stgit@magnolia>
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

Hoist out of _scratch_populate_cached all the code that we use to save a
metadump of the populated filesystem.  We're going to make this more
involved for XFS in the next few patches so that we can take advantage
of the new support for external devices in metadump/mdrestore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)


diff --git a/common/populate b/common/populate
index 29ea637ecb..8db7acefb6 100644
--- a/common/populate
+++ b/common/populate
@@ -938,6 +938,31 @@ _scratch_populate_restore_cached() {
 	return 1
 }
 
+# Take a metadump of the scratch filesystem and cache it for later.
+_scratch_populate_save_metadump()
+{
+	local metadump_file="$1"
+
+	case "${FSTYP}" in
+	"xfs")
+		local logdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			logdev=$SCRATCH_LOGDEV
+
+		_xfs_metadump "$metadump_file" "$SCRATCH_DEV" "$logdev" \
+				compress
+		res=$?
+		;;
+	"ext2"|"ext3"|"ext4")
+		_ext4_metadump "${SCRATCH_DEV}" "${metadump_file}" compress
+		res=$?
+		;;
+	*)
+		_fail "Don't know how to save a ${FSTYP} filesystem."
+	esac
+	return $res
+}
+
 # Populate a scratch FS from scratch or from a cached image.
 _scratch_populate_cached() {
 	local meta_descr="$(_scratch_populate_cache_tag "$@")"
@@ -961,26 +986,20 @@ _scratch_populate_cached() {
 
 	# Oh well, just create one from scratch
 	_scratch_mkfs
-	echo "${meta_descr}" > "${populate_metadump_descr}"
 	case "${FSTYP}" in
 	"xfs")
 		_scratch_xfs_populate $@
 		_scratch_xfs_populate_check
-
-		local logdev=none
-		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
-			logdev=$SCRATCH_LOGDEV
-
-		_xfs_metadump "$POPULATE_METADUMP" "$SCRATCH_DEV" "$logdev" \
-			compress
 		;;
 	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate $@
 		_scratch_ext4_populate_check
-		_ext4_metadump "${SCRATCH_DEV}" "${POPULATE_METADUMP}" compress
 		;;
 	*)
 		_fail "Don't know how to populate a ${FSTYP} filesystem."
 		;;
 	esac
+
+	_scratch_populate_save_metadump "${POPULATE_METADUMP}" && \
+			echo "${meta_descr}" > "${populate_metadump_descr}"
 }

