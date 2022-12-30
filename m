Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64B6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbiLaCYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiLaCYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:24:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F27A19C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:24:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A00A161CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A51EC433D2;
        Sat, 31 Dec 2022 02:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453445;
        bh=zcPsXmyhnw2ndlyW4IdPQMN0o0bk10UApbKdnmJ3y2w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uJ67EMe0iFFbIxqFRMowclzrTlxq44+P+gZ8qdyvRObKsxIGk/l77lie7s3TAb1TR
         y/bOXPn2E65BgOTh+nZV8fkCERKobcqjGW6w9q9oI6/YFTxQTbIy7677fUMthTkQVz
         56SRZFhokqRps6MRcgpkdG2vWdhiK+MJMqEY9zucgqPC25N1toFyqv9kD3KEPJBzby
         hzJocPOeTYn+Y0/Md+SpHgTdvooqJQFAwPE6mwTES8zKayBZ0Y3aA2QbHnqEOoxO8Z
         DxJnUnZZKN0ttJirdXYAAGl2AsU1Bfhi94xyWWk3ikHxfSOkZBubw/WSv3ywwm4sU8
         4e+zyoG2Ojm2A==
Subject: [PATCH 09/10] xfs_repair: convert utility to use new rt extent
 helpers and types
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:29 -0800
Message-ID: <167243876934.727509.595013064865664971.stgit@magnolia>
In-Reply-To: <167243876812.727509.17144221830951566022.stgit@magnolia>
References: <167243876812.727509.17144221830951566022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the repair program to use the new realtime extent types and
helper functions instead of open-coding them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.h |    2 +-
 repair/dinode.c   |   21 ++++++++++++---------
 repair/incore.c   |   16 ++++++++--------
 repair/incore.h   |    4 ++--
 repair/phase4.c   |   16 ++++++++--------
 repair/rt.c       |    4 ++--
 6 files changed, 33 insertions(+), 30 deletions(-)


diff --git a/repair/agheader.h b/repair/agheader.h
index a63827c8725..e3e4a21e02b 100644
--- a/repair/agheader.h
+++ b/repair/agheader.h
@@ -11,7 +11,7 @@ typedef struct fs_geometry  {
 	uint32_t	sb_blocksize;	/* blocksize (bytes) */
 	xfs_rfsblock_t	sb_dblocks;	/* # data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* # realtime blocks */
-	xfs_rtblock_t	sb_rextents;	/* # realtime extents */
+	xfs_rtbxlen_t	sb_rextents;	/* # realtime extents */
 	xfs_fsblock_t	sb_logstart;	/* starting log block # */
 	xfs_agblock_t	sb_rextsize;	/* realtime extent size (blocks )*/
 	xfs_agblock_t	sb_agblocks;	/* # of blocks per ag */
diff --git a/repair/dinode.c b/repair/dinode.c
index cc2c3474634..e66f93abb1d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -194,13 +194,13 @@ process_rt_rec_dups(
 	xfs_ino_t		ino,
 	struct xfs_bmbt_irec	*irec)
 {
-	xfs_fsblock_t		b;
-	xfs_rtblock_t		ext;
+	xfs_rtblock_t		b;
+	xfs_rtxnum_t		ext;
 
-	for (b = rounddown(irec->br_startblock, mp->m_sb.sb_rextsize);
+	for (b = xfs_rtb_rounddown_rtx(mp, irec->br_startblock);
 	     b < irec->br_startblock + irec->br_blockcount;
 	     b += mp->m_sb.sb_rextsize) {
-		ext = (xfs_rtblock_t) b / mp->m_sb.sb_rextsize;
+		ext = xfs_rtb_to_rtxt(mp, b);
 		if (search_rt_dup_extent(mp, ext))  {
 			do_warn(
 _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
@@ -224,14 +224,17 @@ process_rt_rec_state(
 	struct xfs_bmbt_irec	*irec)
 {
 	xfs_fsblock_t		b = irec->br_startblock;
-	xfs_rtblock_t		ext;
+	xfs_rtxnum_t		ext;
 	int			state;
 
 	do {
-		ext = (xfs_rtblock_t)b / mp->m_sb.sb_rextsize;
+		xfs_extlen_t	mod;
+
+		ext = xfs_rtb_to_rtxt(mp, b);
 		state = get_rtbmap(ext);
 
-		if ((b % mp->m_sb.sb_rextsize) != 0) {
+		xfs_rtb_to_rtx(mp, b, &mod);
+		if (mod) {
 			/*
 			 * We are midway through a partially written extent.
 			 * If we don't find the state that gets set in the
@@ -242,7 +245,7 @@ process_rt_rec_state(
 				do_error(
 _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d at rt block %"PRIu64"\n"),
 					ino, ext, state, b);
-			b = roundup(b, mp->m_sb.sb_rextsize);
+			b = xfs_rtb_roundup_rtx(mp, b);
 			continue;
 		}
 
@@ -2321,7 +2324,7 @@ validate_extsize(
 	 */
 	if ((flags & XFS_DIFLAG_EXTSZINHERIT) &&
 	    (flags & XFS_DIFLAG_RTINHERIT) &&
-	    value % mp->m_sb.sb_rextsize > 0)
+	    xfs_extlen_to_rtxmod(mp, value) > 0)
 		misaligned = true;
 
 	/*
diff --git a/repair/incore.c b/repair/incore.c
index f7a89e70d91..06edaf0d605 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -178,21 +178,21 @@ static size_t		rt_bmap_size;
  */
 int
 get_rtbmap(
-	xfs_rtblock_t	bno)
+	xfs_rtxnum_t	rtx)
 {
-	return (*(rt_bmap + bno /  XR_BB_NUM) >>
-		((bno % XR_BB_NUM) * XR_BB)) & XR_BB_MASK;
+	return (*(rt_bmap + rtx /  XR_BB_NUM) >>
+		((rtx % XR_BB_NUM) * XR_BB)) & XR_BB_MASK;
 }
 
 void
 set_rtbmap(
-	xfs_rtblock_t	bno,
+	xfs_rtxnum_t	rtx,
 	int		state)
 {
-	*(rt_bmap + bno / XR_BB_NUM) =
-	 ((*(rt_bmap + bno / XR_BB_NUM) &
-	  (~((uint64_t) XR_BB_MASK << ((bno % XR_BB_NUM) * XR_BB)))) |
-	 (((uint64_t) state) << ((bno % XR_BB_NUM) * XR_BB)));
+	*(rt_bmap + rtx / XR_BB_NUM) =
+	 ((*(rt_bmap + rtx / XR_BB_NUM) &
+	  (~((uint64_t) XR_BB_MASK << ((rtx % XR_BB_NUM) * XR_BB)))) |
+	 (((uint64_t) state) << ((rtx % XR_BB_NUM) * XR_BB)));
 }
 
 static void
diff --git a/repair/incore.h b/repair/incore.h
index 53609f683af..c31b778a0fb 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -28,8 +28,8 @@ void		set_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
 int		get_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
 			     xfs_agblock_t maxbno, xfs_extlen_t *blen);
 
-void		set_rtbmap(xfs_rtblock_t bno, int state);
-int		get_rtbmap(xfs_rtblock_t bno);
+void		set_rtbmap(xfs_rtxnum_t rtx, int state);
+int		get_rtbmap(xfs_rtxnum_t rtx);
 
 static inline void
 set_bmap(xfs_agnumber_t agno, xfs_agblock_t agbno, int state)
diff --git a/repair/phase4.c b/repair/phase4.c
index 28ecf56f45b..cfdea1460e5 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -229,9 +229,9 @@ void
 phase4(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	xfs_rtblock_t		bno;
-	xfs_rtblock_t		rt_start;
-	xfs_extlen_t		rt_len;
+	xfs_rtxnum_t		rtx;
+	xfs_rtxnum_t		rt_start;
+	xfs_rtxlen_t		rt_len;
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
 	xfs_agblock_t		ag_end;
@@ -330,14 +330,14 @@ phase4(xfs_mount_t *mp)
 	rt_start = 0;
 	rt_len = 0;
 
-	for (bno = 0; bno < mp->m_sb.sb_rextents; bno++)  {
-		bstate = get_rtbmap(bno);
+	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx++)  {
+		bstate = get_rtbmap(rtx);
 		switch (bstate)  {
 		case XR_E_BAD_STATE:
 		default:
 			do_warn(
 	_("unknown rt extent state, extent %" PRIu64 "\n"),
-				bno);
+				rtx);
 			fallthrough;
 		case XR_E_METADATA:
 		case XR_E_UNKNOWN:
@@ -360,14 +360,14 @@ phase4(xfs_mount_t *mp)
 			break;
 		case XR_E_MULT:
 			if (rt_start == 0)  {
-				rt_start = bno;
+				rt_start = rtx;
 				rt_len = 1;
 			} else if (rt_len == XFS_MAX_BMBT_EXTLEN)  {
 				/*
 				 * large extent case
 				 */
 				add_rt_dup_extent(rt_start, rt_len);
-				rt_start = bno;
+				rt_start = rtx;
 				rt_len = 1;
 			} else
 				rt_len++;
diff --git a/repair/rt.c b/repair/rt.c
index a4cca7aa223..947382e9ede 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -48,8 +48,8 @@ generate_rtinfo(xfs_mount_t	*mp,
 		xfs_rtword_t	*words,
 		xfs_suminfo_t	*sumcompute)
 {
-	xfs_rtblock_t	extno;
-	xfs_rtblock_t	start_ext;
+	xfs_rtxnum_t	extno;
+	xfs_rtxnum_t	start_ext;
 	int		bitsperblock;
 	int		bmbno;
 	xfs_rtword_t	freebit;

