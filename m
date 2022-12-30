Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6452C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbiLaCx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:53:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF25918387
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0712B81E4A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616DDC433D2;
        Sat, 31 Dec 2022 02:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455234;
        bh=OJVV0QzHaXTQ3yXBH/uwnlnqFTcK9sWIMUy42mUey4s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jvjgBw51Hbl/eOAOXp+5lMjabVmhxBbH8Uylq+bavWlq72Jxw4sPA20iOsKHd6vMy
         ulyhwIhYKrMkaGvOrxiiFV57fDVmj9eCYfyRcZ4CPOuRK5aOsbv+rUrxNzG78rpA/U
         gVbN7V7foNVvRDQeEKjJh+OKgjkq76u3qqvi2YY9xe/2+alVv+QjCchj0LcM8kdMss
         5V8kP9mGYsn6P3mFDavvJAnhysOVuUP6B2TU6VgV9BmIBZ/IvdFEoaIbU4osjA8jPv
         lXW7zJuAhzS3FBWFk0cbtqYXH1TSZCV+OSYOieUq219AVXH+3KZqheD2eDq514GmhT
         GRqI5sB2ymG/g==
Subject: [PATCH 3/4] xfs_repair: use libxfs_alloc_file_space to reallocate rt
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:04 -0800
Message-ID: <167243880438.733953.4659523039685755586.stgit@magnolia>
In-Reply-To: <167243880399.733953.2483387870694006201.stgit@magnolia>
References: <167243880399.733953.2483387870694006201.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that libxfs_alloc_file_space can allocate and zero blocks, use it to
repair the realtime metadata instead of open-coding all this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   74 +++++++------------------------------------------------
 1 file changed, 10 insertions(+), 64 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 8828f7f72b9..890bb20bce1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -695,13 +695,8 @@ mk_rbmino(
 	struct xfs_imeta_update	upd;
 	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
-	struct xfs_bmbt_irec	*ep;
 	int			i;
-	int			nmap;
 	int			error;
-	xfs_fileoff_t		bno;
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	uint			blocks;
 
 	error = ensure_imeta_dirpath(mp, &XFS_IMETA_RTBITMAP);
 	if (error)
@@ -744,36 +739,15 @@ _("Couldn't find realtime bitmap parent, error %d\n"),
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	blocks = mp->m_sb.sb_rbmblocks +
-			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (error)
-		res_failed(error);
-
-	libxfs_trans_ijoin(tp, ip, 0);
-	bno = 0;
-	while (bno < mp->m_sb.sb_rbmblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, ip, bno,
-			  (xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
-			  0, mp->m_sb.sb_rbmblocks, map, &nmap);
+	if (mp->m_sb.sb_rbmblocks) {
+		error = -libxfs_alloc_file_space(ip, 0,
+				mp->m_sb.sb_rbmblocks << mp->m_sb.sb_blocklog,
+				XFS_BMAPI_ZERO);
 		if (error) {
 			do_error(
-			_("couldn't allocate realtime bitmap, error = %d\n"),
+	_("allocation of the realtime bitmap failed, error = %d\n"),
 				error);
 		}
-		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_ddev_targp,
-				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
-				XFS_FSB_TO_BB(mp, ep->br_blockcount));
-			bno += ep->br_blockcount;
-		}
-	}
-	error = -libxfs_trans_commit(tp);
-	if (error) {
-		do_error(
-		_("allocation of the realtime bitmap failed, error = %d\n"),
-			error);
 	}
 	libxfs_irele(ip);
 }
@@ -951,14 +925,8 @@ mk_rsumino(
 	struct xfs_imeta_update	upd;
 	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
-	struct xfs_bmbt_irec	*ep;
 	int			i;
-	int			nmap;
 	int			error;
-	int			nsumblocks;
-	xfs_fileoff_t		bno;
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	uint			blocks;
 
 	error = ensure_imeta_dirpath(mp, &XFS_IMETA_RTSUMMARY);
 	if (error)
@@ -1001,36 +969,14 @@ _("Couldn't find realtime summary parent, error %d\n"),
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (error)
-		res_failed(error);
-
-	libxfs_trans_ijoin(tp, ip, 0);
-	bno = 0;
-	while (bno < nsumblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, ip, bno,
-			  (xfs_extlen_t)(nsumblocks - bno),
-			  0, nsumblocks, map, &nmap);
+	if (mp->m_rsumsize) {
+		error = -libxfs_alloc_file_space(ip, 0, mp->m_rsumsize,
+				XFS_BMAPI_ZERO);
 		if (error) {
 			do_error(
-		_("couldn't allocate realtime summary inode, error = %d\n"),
-				error);
-		}
-		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_ddev_targp,
-				      XFS_FSB_TO_DADDR(mp, ep->br_startblock),
-				      XFS_FSB_TO_BB(mp, ep->br_blockcount));
-			bno += ep->br_blockcount;
-		}
-	}
-	error = -libxfs_trans_commit(tp);
-	if (error) {
-		do_error(
 	_("allocation of the realtime summary ino failed, error = %d\n"),
-			error);
+				error);
+		}
 	}
 	libxfs_irele(ip);
 }

