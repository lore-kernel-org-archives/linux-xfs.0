Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27724CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D579621897
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tC0S8Rt0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfKAWJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAWJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NHlB1EfmHhzuB/Cir1vSbsrlHL11t7JWv/NSmXNetmo=; b=tC0S8Rt06zYr4sRARtr5BuZMf
        a0QqCojpjC0uCnFcXs1vgr4TFtRbY0R7jRKwKwsrxQfiJH0I8wFgN26uo/l8reFu3Yszw/fY+3op+
        Kav0P8WmA2mIej4A27JY6b8WOgAP2G/IqQnGTXvrcVDPu+/ufWk0JUJHGj7yCbY6zqsq6fRIk+nuN
        JqM0XhF3FSUo+VoY9XMa9aFS2vxMVwW7B1U2vHNb8Je5JPE71hYGblc1RldRrvbrKwZdjU6BIX9fu
        Ajbza4JtyMcsVgvKEtgVWdrpxZs7iAixaZUqxqfuXKCxnfyGNw4skzTuLX5uP/OmGwg82YxYIV8by
        4o0dU/edw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf6Y-00061M-ON
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/34] xfs: devirtualize ->sf_entsize and ->sf_nextentry
Date:   Fri,  1 Nov 2019 15:07:05 -0700
Message-Id: <20191101220719.29100-21-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just check for file-type enabled directories directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c  | 48 -----------------
 fs/xfs/libxfs/xfs_dir2.h       |  4 --
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 +
 fs/xfs/libxfs/xfs_dir2_sf.c    | 99 ++++++++++++++++++++--------------
 fs/xfs/xfs_dir2_readdir.c      |  7 +--
 6 files changed, 66 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 7858469c09e4..f80495a38a76 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -15,48 +15,6 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 
-/*
- * Shortform directory ops
- */
-static int
-xfs_dir2_sf_entsize(
-	struct xfs_dir2_sf_hdr	*hdr,
-	int			len)
-{
-	int count = sizeof(struct xfs_dir2_sf_entry);	/* namelen + offset */
-
-	count += len;					/* name */
-	count += hdr->i8count ? XFS_INO64_SIZE : XFS_INO32_SIZE; /* ino # */
-	return count;
-}
-
-static int
-xfs_dir3_sf_entsize(
-	struct xfs_dir2_sf_hdr	*hdr,
-	int			len)
-{
-	return xfs_dir2_sf_entsize(hdr, len) + sizeof(uint8_t);
-}
-
-static struct xfs_dir2_sf_entry *
-xfs_dir2_sf_nextentry(
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	return (struct xfs_dir2_sf_entry *)
-		((char *)sfep + xfs_dir2_sf_entsize(hdr, sfep->namelen));
-}
-
-static struct xfs_dir2_sf_entry *
-xfs_dir3_sf_nextentry(
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	return (struct xfs_dir2_sf_entry *)
-		((char *)sfep + xfs_dir3_sf_entsize(hdr, sfep->namelen));
-}
-
-
 /*
  * For filetype enabled shortform directories, the file type field is stored at
  * the end of the name.  Because it's only a single byte, endian conversion is
@@ -401,8 +359,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 }
 
 static const struct xfs_dir_ops xfs_dir2_ops = {
-	.sf_entsize = xfs_dir2_sf_entsize,
-	.sf_nextentry = xfs_dir2_sf_nextentry,
 	.sf_get_ftype = xfs_dir2_sfe_get_ftype,
 	.sf_put_ftype = xfs_dir2_sfe_put_ftype,
 	.sf_get_ino = xfs_dir2_sfe_get_ino,
@@ -430,8 +386,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
-	.sf_entsize = xfs_dir3_sf_entsize,
-	.sf_nextentry = xfs_dir3_sf_nextentry,
 	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
 	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
 	.sf_get_ino = xfs_dir3_sfe_get_ino,
@@ -459,8 +413,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
-	.sf_entsize = xfs_dir3_sf_entsize,
-	.sf_nextentry = xfs_dir3_sf_nextentry,
 	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
 	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
 	.sf_get_ino = xfs_dir3_sfe_get_ino,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d3a0b8daab5f..c99f0ad6607a 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -32,10 +32,6 @@ extern unsigned char xfs_mode_to_ftype(int mode);
  * directory operations vector for encode/decode routines
  */
 struct xfs_dir_ops {
-	int	(*sf_entsize)(struct xfs_dir2_sf_hdr *hdr, int len);
-	struct xfs_dir2_sf_entry *
-		(*sf_nextentry)(struct xfs_dir2_sf_hdr *hdr,
-				struct xfs_dir2_sf_entry *sfep);
 	uint8_t (*sf_get_ftype)(struct xfs_dir2_sf_entry *sfep);
 	void	(*sf_put_ftype)(struct xfs_dir2_sf_entry *sfep,
 				uint8_t ftype);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 2ee9fdd182e1..88b3d1884c74 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1231,7 +1231,7 @@ xfs_dir2_sf_to_block(
 		if (++i == sfp->count)
 			sfep = NULL;
 		else
-			sfep = dp->d_ops->sf_nextentry(sfp, sfep);
+			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 	}
 	/* Done with the temporary buffer */
 	kmem_free(sfp);
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index d5104fdb8543..a96b9ba7909b 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -137,6 +137,8 @@ extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
 /* xfs_dir2_sf.c */
 xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *hdr);
 void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *hdr, xfs_ino_t ino);
+struct xfs_dir2_sf_entry *xfs_dir2_sf_nextentry(struct xfs_mount *mp,
+		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
 extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 1d7c26d0157c..f3a4f0ddfc1a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -37,6 +37,32 @@ static void xfs_dir2_sf_check(xfs_da_args_t *args);
 static void xfs_dir2_sf_toino4(xfs_da_args_t *args);
 static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
 
+static int
+xfs_dir2_sf_entsize(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_sf_hdr	*hdr,
+	int			len)
+{
+	int			count = len;
+
+	count += sizeof(struct xfs_dir2_sf_entry);	/* namelen + offset */
+	count += hdr->i8count ? XFS_INO64_SIZE : XFS_INO32_SIZE; /* ino # */
+
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		count += sizeof(uint8_t);
+	return count;
+}
+
+struct xfs_dir2_sf_entry *
+xfs_dir2_sf_nextentry(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return (struct xfs_dir2_sf_entry *)
+		((char *)sfep + xfs_dir2_sf_entsize(mp, hdr, sfep->namelen));
+}
+
 /*
  * Given a block directory (dp/block), calculate its size as a shortform (sf)
  * directory and a header for the sf directory, if it will fit it the
@@ -219,7 +245,7 @@ xfs_dir2_block_to_sf(
 			dp->d_ops->sf_put_ftype(sfep,
 					dp->d_ops->data_get_ftype(dep));
 
-			sfep = dp->d_ops->sf_nextentry(sfp, sfep);
+			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 		}
 		ptr += dp->d_ops->data_entsize(dep->namelen);
 	}
@@ -291,7 +317,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Compute entry (and change in) size.
 	 */
-	incr_isize = dp->d_ops->sf_entsize(sfp, args->namelen);
+	incr_isize = xfs_dir2_sf_entsize(dp->i_mount, sfp, args->namelen);
 	objchange = 0;
 
 	/*
@@ -364,18 +390,17 @@ xfs_dir2_sf_addname_easy(
 	xfs_dir2_data_aoff_t	offset,		/* offset to use for new ent */
 	int			new_isize)	/* new directory size */
 {
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	int			byteoff;	/* byte offset in sf dir */
-	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
-	dp = args->dp;
-
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	byteoff = (int)((char *)sfep - (char *)sfp);
 	/*
 	 * Grow the in-inode space.
 	 */
-	xfs_idata_realloc(dp, dp->d_ops->sf_entsize(sfp, args->namelen),
+	xfs_idata_realloc(dp, xfs_dir2_sf_entsize(mp, sfp, args->namelen),
 			  XFS_DATA_FORK);
 	/*
 	 * Need to set up again due to realloc of the inode data.
@@ -416,9 +441,10 @@ xfs_dir2_sf_addname_hard(
 	int			objchange,	/* changing inode number size */
 	int			new_isize)	/* new directory size */
 {
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	int			add_datasize;	/* data size need for new ent */
 	char			*buf;		/* buffer for old */
-	xfs_inode_t		*dp;		/* incore directory inode */
 	int			eof;		/* reached end of old dir */
 	int			nbytes;		/* temp for byte copies */
 	xfs_dir2_data_aoff_t	new_offset;	/* next offset value */
@@ -432,8 +458,6 @@ xfs_dir2_sf_addname_hard(
 	/*
 	 * Copy the old directory to the stack buffer.
 	 */
-	dp = args->dp;
-
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	old_isize = (int)dp->i_d.di_size;
 	buf = kmem_alloc(old_isize, 0);
@@ -450,7 +474,7 @@ xfs_dir2_sf_addname_hard(
 	      eof = (char *)oldsfep == &buf[old_isize];
 	     !eof;
 	     offset = new_offset + dp->d_ops->data_entsize(oldsfep->namelen),
-	      oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep),
+	      oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep),
 	      eof = (char *)oldsfep == &buf[old_isize]) {
 		new_offset = xfs_dir2_sf_get_offset(oldsfep);
 		if (offset + add_datasize <= new_offset)
@@ -488,7 +512,7 @@ xfs_dir2_sf_addname_hard(
 	 * If there's more left to copy, do that.
 	 */
 	if (!eof) {
-		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
+		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
 	kmem_free(buf);
@@ -510,7 +534,8 @@ xfs_dir2_sf_addname_pick(
 	xfs_dir2_sf_entry_t	**sfepp,	/* out(1): new entry ptr */
 	xfs_dir2_data_aoff_t	*offsetp)	/* out(1): new offset */
 {
-	xfs_inode_t		*dp;		/* incore directory inode */
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	int			holefit;	/* found hole it will fit in */
 	int			i;		/* entry number */
 	xfs_dir2_data_aoff_t	offset;		/* data block offset */
@@ -519,8 +544,6 @@ xfs_dir2_sf_addname_pick(
 	int			size;		/* entry's data size */
 	int			used;		/* data bytes used */
 
-	dp = args->dp;
-
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = dp->d_ops->data_entsize(args->namelen);
 	offset = dp->d_ops->data_first_offset;
@@ -536,7 +559,7 @@ xfs_dir2_sf_addname_pick(
 			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
 		offset = xfs_dir2_sf_get_offset(sfep) +
 			 dp->d_ops->data_entsize(sfep->namelen);
-		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
+		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 	}
 	/*
 	 * Calculate data bytes used excluding the new entry, if this
@@ -595,7 +618,7 @@ xfs_dir2_sf_check(
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->count;
-	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(dp->i_mount, sfp, sfep)) {
 		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
 		ino = dp->d_ops->sf_get_ino(sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
@@ -680,7 +703,7 @@ xfs_dir2_sf_verify(
 		 * within the data buffer.  The next entry starts after the
 		 * name component, so nextentry is an acceptable test.
 		 */
-		next_sfep = dops->sf_nextentry(sfp, sfep);
+		next_sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 		if (endp < (char *)next_sfep)
 			return __this_address;
 
@@ -779,7 +802,8 @@ int						/* error */
 xfs_dir2_sf_lookup(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
-	xfs_inode_t		*dp;		/* incore directory inode */
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	int			i;		/* entry index */
 	int			error;
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
@@ -790,7 +814,6 @@ xfs_dir2_sf_lookup(
 	trace_xfs_dir2_sf_lookup(args);
 
 	xfs_dir2_sf_check(args);
-	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	/*
@@ -828,7 +851,7 @@ xfs_dir2_sf_lookup(
 	 */
 	ci_sfep = NULL;
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
 		/*
 		 * Compare name and if it's an exact match, return the inode
 		 * number. If it's the first case-insensitive match, store the
@@ -864,8 +887,9 @@ int						/* error */
 xfs_dir2_sf_removename(
 	xfs_da_args_t		*args)
 {
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	int			byteoff;	/* offset of removed entry */
-	xfs_inode_t		*dp;		/* incore directory inode */
 	int			entsize;	/* this entry's size */
 	int			i;		/* shortform entry index */
 	int			newsize;	/* new inode size */
@@ -875,8 +899,6 @@ xfs_dir2_sf_removename(
 
 	trace_xfs_dir2_sf_removename(args);
 
-	dp = args->dp;
-
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	oldsize = (int)dp->i_d.di_size;
 	/*
@@ -895,7 +917,7 @@ xfs_dir2_sf_removename(
 	 * Find the one we're deleting.
 	 */
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
 		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
 			ASSERT(dp->d_ops->sf_get_ino(sfp, sfep) ==
@@ -912,7 +934,7 @@ xfs_dir2_sf_removename(
 	 * Calculate sizes.
 	 */
 	byteoff = (int)((char *)sfep - (char *)sfp);
-	entsize = dp->d_ops->sf_entsize(sfp, args->namelen);
+	entsize = xfs_dir2_sf_entsize(mp, sfp, args->namelen);
 	newsize = oldsize - entsize;
 	/*
 	 * Copy the part if any after the removed entry, sliding it down.
@@ -951,7 +973,8 @@ int						/* error */
 xfs_dir2_sf_replace(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
-	xfs_inode_t		*dp;		/* incore directory inode */
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	int			i;		/* entry index */
 	xfs_ino_t		ino=0;		/* entry old inode number */
 	int			i8elevated;	/* sf_toino8 set i8count=1 */
@@ -960,14 +983,12 @@ xfs_dir2_sf_replace(
 
 	trace_xfs_dir2_sf_replace(args);
 
-	dp = args->dp;
-
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	/*
 	 * Bail out if the shortform directory is way too small.
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
-		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		return -EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
@@ -1017,7 +1038,7 @@ xfs_dir2_sf_replace(
 	 */
 	else {
 		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-		     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
+		     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
 			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
 				ino = dp->d_ops->sf_get_ino(sfp, sfep);
@@ -1076,8 +1097,9 @@ static void
 xfs_dir2_sf_toino4(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	char			*buf;		/* old dir's buffer */
-	xfs_inode_t		*dp;		/* incore directory inode */
 	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
@@ -1088,8 +1110,6 @@ xfs_dir2_sf_toino4(
 
 	trace_xfs_dir2_sf_toino4(args);
 
-	dp = args->dp;
-
 	/*
 	 * Copy the old directory to the buffer.
 	 * Then nuke it from the inode, and add the new buffer to the inode.
@@ -1123,8 +1143,8 @@ xfs_dir2_sf_toino4(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->count;
-	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep),
-		  oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
+		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
@@ -1149,8 +1169,9 @@ static void
 xfs_dir2_sf_toino8(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	char			*buf;		/* old dir's buffer */
-	xfs_inode_t		*dp;		/* incore directory inode */
 	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
@@ -1161,8 +1182,6 @@ xfs_dir2_sf_toino8(
 
 	trace_xfs_dir2_sf_toino8(args);
 
-	dp = args->dp;
-
 	/*
 	 * Copy the old directory to the buffer.
 	 * Then nuke it from the inode, and add the new buffer to the inode.
@@ -1196,8 +1215,8 @@ xfs_dir2_sf_toino8(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->count;
-	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep),
-		  oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
+		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 6f94d2a45174..7d150e914d00 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -48,6 +48,7 @@ xfs_dir2_sf_getdents(
 {
 	int			i;		/* shortform entry number */
 	struct xfs_inode	*dp = args->dp;	/* incore directory inode */
+	struct xfs_mount	*mp = dp->i_mount;
 	xfs_dir2_dataptr_t	off;		/* current entry's offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
@@ -109,7 +110,7 @@ xfs_dir2_sf_getdents(
 				xfs_dir2_sf_get_offset(sfep));
 
 		if (ctx->pos > off) {
-			sfep = dp->d_ops->sf_nextentry(sfp, sfep);
+			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 			continue;
 		}
 
@@ -122,9 +123,9 @@ xfs_dir2_sf_getdents(
 			return -EFSCORRUPTED;
 		}
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
-			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
+			    xfs_dir3_get_dtype(mp, filetype)))
 			return 0;
-		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
+		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 	}
 
 	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
-- 
2.20.1

