Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47B4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbiATAXw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60204 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbiATAXw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C99FE61518
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5EEC004E1;
        Thu, 20 Jan 2022 00:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638231;
        bh=9a8TdlSNB7FLZOEqyE9/9fySGogyun37pta63CEanco=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jTgmeOBSLESKTE/KFYieIq5cSwx5xml8IaZvMpjlyiSnA5ojYpoXI85I9NMuoC422
         VbYK+L1UBsuljfhsJ3mxOtUGxBRyFXYMWCeck7+Owngw5p0wVPUTk+7BoUeYif6LyO
         YgE5+DYy4pfLxBCm902N4N4svX8S5Zy1J3BOc700sZsSKHgIVhjR9EJ06PNz8X0zhr
         uzQrWMaO1mk1KJjM3XmY5PiFXB0HYxBzpDwg2udDqC44ULXDWM8Ys5CPPx0up5K0Vm
         nkCFSzs0BNKZX34tWajzXU6A3FpLQiTaGoK/67h688v2AdNvztlN40CBXs8LvLatdd
         RY/EGKd7UOFRA==
Subject: [PATCH 07/48] xfs: remove the xfs_dsb_t typedef
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:23:50 -0800
Message-ID: <164263823084.865554.3241633670572014327.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ed67ebfd7c4061b4b505ac42eb00e08dd09f4d38

Remove the few leftover instances of the xfs_dinode_t typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c           |    2 +-
 copy/xfs_copy.h           |    2 +-
 libxfs/xfs_format.h       |    4 ++--
 libxfs/xfs_sb.c           |    4 ++--
 logprint/logprint.c       |    2 +-
 mdrestore/xfs_mdrestore.c |    6 +++---
 repair/sb.c               |    6 +++---
 7 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 2642114f..41f594bd 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -471,7 +471,7 @@ read_ag_header(int fd, xfs_agnumber_t agno, wbuf *buf, ag_header_t *ag,
 	read_wbuf(fd, buf, mp);
 	ASSERT(buf->length >= length);
 
-	ag->xfs_sb = (xfs_dsb_t *) (buf->data + diff);
+	ag->xfs_sb = (struct xfs_dsb *) (buf->data + diff);
 	ASSERT(be32_to_cpu(ag->xfs_sb->sb_magicnum) == XFS_SB_MAGIC);
 	ag->xfs_agf = (xfs_agf_t *) (buf->data + diff + sectorsize);
 	ASSERT(be32_to_cpu(ag->xfs_agf->agf_magicnum) == XFS_AGF_MAGIC);
diff --git a/copy/xfs_copy.h b/copy/xfs_copy.h
index 0b0ec0ea..1eb168d3 100644
--- a/copy/xfs_copy.h
+++ b/copy/xfs_copy.h
@@ -18,7 +18,7 @@
  * each of which is an AG and has an ag_header at the beginning.
  */
 typedef struct ag_header  {
-	xfs_dsb_t	*xfs_sb;	/* superblock for filesystem or AG */
+	struct xfs_dsb	*xfs_sb;	/* superblock for filesystem or AG */
 	xfs_agf_t	*xfs_agf;	/* free space info */
 	xfs_agi_t	*xfs_agi;	/* free inode info */
 	struct xfs_agfl	*xfs_agfl;	/* AG freelist */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 347c291c..10f38541 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -184,7 +184,7 @@ typedef struct xfs_sb {
  * Superblock - on disk version.  Must match the in core version above.
  * Must be padded to 64 bit alignment.
  */
-typedef struct xfs_dsb {
+struct xfs_dsb {
 	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
 	__be32		sb_blocksize;	/* logical block size, bytes */
 	__be64		sb_dblocks;	/* number of data blocks */
@@ -263,7 +263,7 @@ typedef struct xfs_dsb {
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
 	/* must be padded to 64 bit alignment */
-} xfs_dsb_t;
+};
 
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d7e3526c..986f9466 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -493,7 +493,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 static void
 __xfs_sb_from_disk(
 	struct xfs_sb	*to,
-	xfs_dsb_t	*from,
+	struct xfs_dsb	*from,
 	bool		convert_xquota)
 {
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
@@ -569,7 +569,7 @@ __xfs_sb_from_disk(
 void
 xfs_sb_from_disk(
 	struct xfs_sb	*to,
-	xfs_dsb_t	*from)
+	struct xfs_dsb	*from)
 {
 	__xfs_sb_from_disk(to, from, true);
 }
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 3514d013..9a8811f4 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -79,7 +79,7 @@ logstat(xfs_mount_t *mp)
 		 * Conjure up a mount structure
 		 */
 		sb = &mp->m_sb;
-		libxfs_sb_from_disk(sb, (xfs_dsb_t *)buf);
+		libxfs_sb_from_disk(sb, (struct xfs_dsb *)buf);
 		mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
 		mp->m_blkbb_log = sb->sb_blocklog - BBSHIFT;
 
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 1cd399db..7c1a66c4 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -89,7 +89,7 @@ perform_restore(
 	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
 		fatal("error reading from metadump file\n");
 
-	libxfs_sb_from_disk(&sb, (xfs_dsb_t *)block_buffer);
+	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
 
 	if (sb.sb_magicnum != XFS_SB_MAGIC)
 		fatal("bad magic number for primary superblock\n");
@@ -104,7 +104,7 @@ perform_restore(
 	    sb.sb_sectsize > max_indices * block_size)
 		fatal("bad sector size %u in metadump image\n", sb.sb_sectsize);
 
-	((xfs_dsb_t*)block_buffer)->sb_inprogress = 1;
+	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
 	if (is_target_file)  {
 		/* ensure regular files are correctly sized */
@@ -163,7 +163,7 @@ perform_restore(
 
 	memset(block_buffer, 0, sb.sb_sectsize);
 	sb.sb_inprogress = 0;
-	libxfs_sb_to_disk((xfs_dsb_t *)block_buffer, &sb);
+	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
 	if (xfs_sb_version_hascrc(&sb)) {
 		xfs_update_cksum(block_buffer, sb.sb_sectsize,
 				 offsetof(struct xfs_sb, sb_crc));
diff --git a/repair/sb.c b/repair/sb.c
index 90f32e74..7391cf04 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -141,7 +141,7 @@ __find_secondary_sb(
 		 */
 		for (i = 0; !done && i < bsize; i += BBSIZE)  {
 			c_bufsb = (char *)sb + i;
-			libxfs_sb_from_disk(&bufsb, (xfs_dsb_t *)c_bufsb);
+			libxfs_sb_from_disk(&bufsb, (struct xfs_dsb *)c_bufsb);
 
 			if (verify_sb(c_bufsb, &bufsb, 0) != XR_OK)
 				continue;
@@ -521,7 +521,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 void
 write_primary_sb(xfs_sb_t *sbp, int size)
 {
-	xfs_dsb_t	*buf;
+	struct xfs_dsb	*buf;
 
 	if (no_modify)
 		return;
@@ -558,7 +558,7 @@ int
 get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
 {
 	int error, rval;
-	xfs_dsb_t *buf;
+	struct xfs_dsb *buf;
 
 	buf = memalign(libxfs_device_alignment(), size);
 	if (buf == NULL) {

