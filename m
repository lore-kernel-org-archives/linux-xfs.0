Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA4FC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 08:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiLQISh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 03:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLQISh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 03:18:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1412B60D;
        Sat, 17 Dec 2022 00:18:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 305DE60303;
        Sat, 17 Dec 2022 08:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794EAC433EF;
        Sat, 17 Dec 2022 08:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671265114;
        bh=+uAt+NcmaZgOo2XQFcNtENy3I4gj2GQzDRA6htScgM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VtGtgC8x5wm+Ld4zqGjpl8Pa6rfsCabseN5ClE6BSivEp1A6wBe83qLd84y9oxU4w
         GgsBjTPgUzEUGhO4ll7qKT16hj/10jZxI5sdfEiwqDhxaSBhDf+csEYImMAmhj7e/u
         f7Mg4WZRU9xdPU7ElG+b+iRoVi97mD6epSejCk8PUDCicCOSO/5qCsKiD7eQepCEGh
         kRAbE5AK7ye0ECjno+K01wIVrji8mM21R/Ob9AI82WjijxUpI73sK3e879UM3Wbl00
         +7cq5Ax6inBViCc68gtIkbTxITEnGKZhpt8rVikdCW4PSMKwOHzaD68ST/jdKGHFPB
         LFYO+D6OZ7YZw==
Date:   Sat, 17 Dec 2022 00:18:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 3/4] common/populate: move decompression code to
 _{xfs,ext4}_mdrestore
Message-ID: <Y517WiHeORSpumeK@magnolia>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
 <167096072838.1750373.11954125201906427521.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167096072838.1750373.11954125201906427521.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the metadump decompression code to the per-filesystem mdrestore
commands so that everyone can take advantage of them.  This enables the
XFS and ext4 _mdrestore helpers to handle metadata dumps compressed with
their respective _metadump helpers.

In turn, this means that the xfs fuzz tests can now handle the
compressed metadumps created by the _scratch_populate_cached helper.
This is key to unbreaking fuzz testing for xfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: remove unnecessary parameter
---
 common/ext4     |   10 ++++++++++
 common/populate |   11 -----------
 common/xfs      |   10 ++++++++++
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/common/ext4 b/common/ext4
index dc2e4e59cc..8fd6dbc682 100644
--- a/common/ext4
+++ b/common/ext4
@@ -132,6 +132,16 @@ _ext4_mdrestore()
 	shift; shift
 	local options="$@"
 
+	# If we're configured for compressed dumps and there isn't already an
+	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
+	# something.
+	if [ ! -e "$metadump" ] && [ -n "$DUMP_COMPRESSOR" ]; then
+		for compr in "$metadump".*; do
+			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
+		done
+	fi
+	test -r "$metadump" || return 1
+
 	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
 }
 
diff --git a/common/populate b/common/populate
index f382c40aca..0a8a6390d4 100644
--- a/common/populate
+++ b/common/populate
@@ -848,17 +848,6 @@ _scratch_populate_cache_tag() {
 _scratch_populate_restore_cached() {
 	local metadump="$1"
 
-	# If we're configured for compressed dumps and there isn't already an
-	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
-	# something.
-	if [ -n "$DUMP_COMPRESSOR" ]; then
-		for compr in "$metadump".*; do
-			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
-		done
-	fi
-
-	test -r "$metadump" || return 1
-
 	case "${FSTYP}" in
 	"xfs")
 		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
diff --git a/common/xfs b/common/xfs
index 216dab3bcd..60848a5b8a 100644
--- a/common/xfs
+++ b/common/xfs
@@ -644,6 +644,16 @@ _xfs_mdrestore() {
 	shift; shift
 	local options="$@"
 
+	# If we're configured for compressed dumps and there isn't already an
+	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
+	# something.
+	if [ ! -e "$metadump" ] && [ -n "$DUMP_COMPRESSOR" ]; then
+		for compr in "$metadump".*; do
+			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
+		done
+	fi
+	test -r "$metadump" || return 1
+
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 }
 
