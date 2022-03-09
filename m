Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B148AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 19:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbiCITYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbiCITYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 14:24:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDFBBC11
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 11:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE7FE6179E
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 19:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2744DC340EC;
        Wed,  9 Mar 2022 19:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853762;
        bh=4GWUFytwtcNfUFzEszbtPcgXbsVnKbxLWK4ZRe+rltw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fHOsC34n84sw5r/7mMpKURLH2nVlLWkL7Ba/RFOigAe/O8wxGHWYXHOgCPcm7FCzy
         ohwGspEpEW2gepRcqjUaGVE5OZ90DaQCj4w2GyOWJibCSbWxsBO/ET8m4tVVPP8soS
         KzS6gvXaRyXuQ2RvvJaOitvktuwFIMfALYHLNU3RxtIYXFjxf3E+xwWhGO6pBRqx4y
         +twERzpBrGvPTRurgbPN7MvSF+xheFfW3eFZ6+Yu1pNSOGC90R7jKIEdtrSSQgbZh5
         ZaWwQcEUeaiAA5pTvzTfHBP1UbtlMEdhWHany++EJVJxgi9CrRYUL+2McSFwai3MwB
         19Hl2w/7VU9+w==
Subject: [PATCH 1/2] xfs: constify the name argument to various directory
 functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Mar 2022 11:22:41 -0800
Message-ID: <164685376173.496011.12006782245730068988.stgit@magnolia>
In-Reply-To: <164685375609.496011.2754821878646256374.stgit@magnolia>
References: <164685375609.496011.2754821878646256374.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Various directory functions do not modify their @name parameter,
so mark it const to make that clear.  This will enable us to mark
the global xfs_name_dotdot variable as const to prevent mischief.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c      |   12 ++++++------
 fs/xfs/libxfs/xfs_dir2.h      |    4 ++--
 fs/xfs/libxfs/xfs_dir2_priv.h |    5 +++--
 3 files changed, 11 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 50546eadaae2..a77d931d65a3 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -54,10 +54,10 @@ xfs_mode_to_ftype(
  */
 xfs_dahash_t
 xfs_ascii_ci_hashname(
-	struct xfs_name	*name)
+	const struct xfs_name	*name)
 {
-	xfs_dahash_t	hash;
-	int		i;
+	xfs_dahash_t		hash;
+	int			i;
 
 	for (i = 0, hash = 0; i < name->len; i++)
 		hash = tolower(name->name[i]) ^ rol32(hash, 7);
@@ -243,7 +243,7 @@ int
 xfs_dir_createname(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
@@ -475,7 +475,7 @@ int
 xfs_dir_replace(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,		/* name of entry to replace */
+	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
@@ -728,7 +728,7 @@ xfs_dir2_namecheck(
 xfs_dahash_t
 xfs_dir2_hashname(
 	struct xfs_mount	*mp,
-	struct xfs_name		*name)
+	const struct xfs_name	*name)
 {
 	if (unlikely(xfs_has_asciici(mp)))
 		return xfs_ascii_ci_hashname(name);
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d03e6098ded9..f7e6cc869c13 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -39,7 +39,7 @@ extern int xfs_dir_isempty(struct xfs_inode *dp);
 extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t inum,
+				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
@@ -48,7 +48,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t inum,
+				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 711709a2aa53..7404a9ff1a92 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -40,7 +40,7 @@ struct xfs_dir3_icfree_hdr {
 };
 
 /* xfs_dir2.c */
-xfs_dahash_t xfs_ascii_ci_hashname(struct xfs_name *name);
+xfs_dahash_t xfs_ascii_ci_hashname(const struct xfs_name *name);
 enum xfs_dacmp xfs_ascii_ci_compname(struct xfs_da_args *args,
 		const unsigned char *name, int len);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
@@ -201,7 +201,8 @@ xfs_dir2_data_entsize(
 	return round_up(len, XFS_DIR2_DATA_ALIGN);
 }
 
-xfs_dahash_t xfs_dir2_hashname(struct xfs_mount *mp, struct xfs_name *name);
+xfs_dahash_t xfs_dir2_hashname(struct xfs_mount *mp,
+		const struct xfs_name *name);
 enum xfs_dacmp xfs_dir2_compname(struct xfs_da_args *args,
 		const unsigned char *name, int len);
 

