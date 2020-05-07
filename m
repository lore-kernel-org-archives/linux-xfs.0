Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E535DC4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0D8C208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YVn+RiuQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgEGMUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726218AbgEGMUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF896C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=d0xVcFkY5qqpPf1fNPOFZiAxsluRAKK46C25Gj+Rrxs=; b=YVn+RiuQoxlFiNhxIJxtKRiBHX
        DtcCaMvm3L412gB0YpPNv3MLY3WbbRvnYOI12soPfny4sgybEyTOkK20Ts/rPKuKlloFVBwAczXHG
        gMbdfkv8WD0x5NPhd61BzzjvLRE7IMvCumfUuJ9iQYpT5R4KPLypflP+bJ1dOtZUh47OeoUy394Lr
        brwm2aB/3R08UOXv+yqWQFa6GcPIqf498O27cUN9KlhBVeummBQ7BEL8LOGxDpOwX6e7VDOaCT/1n
        2dog0aID3HyiIvQuIOVPorR3ZW+12eBnMr7UrzCxdCOuxmf/j/mbH1sVnhKYPCMyEiqEgR/tvEVJ2
        cK19s2uw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfW0-0007hu-Fd; Thu, 07 May 2020 12:20:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 42/58] xfs: rename btree cursor private btree member flags
Date:   Thu,  7 May 2020 14:18:35 +0200
Message-Id: <20200507121851.304002-43-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 8ef547976a18e3d672194d8c944c19b345ef6bfc

BPRV is not longer appropriate because bc_private is going away.
Script:

$ sed -i 's/BTCUR_BPRV/BTCUR_BMBT/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

With manual cleanup to the definitions in fs/xfs/libxfs/xfs_btree.h

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: change "BC_BT" to "BTCUR_BMBT", fix subject line typo]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c       | 8 ++++----
 libxfs/xfs_bmap_btree.c | 4 ++--
 libxfs/xfs_btree.c      | 2 +-
 libxfs/xfs_btree.h      | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index efa85597..c00133ac 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -683,7 +683,7 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
 	 */
@@ -1521,7 +1521,7 @@ xfs_bmap_add_extent_delay_real(
 
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
-	       (bma->cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
+	       (bma->cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -2745,7 +2745,7 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	old;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -4181,7 +4181,7 @@ xfs_bmapi_allocate(
 
 	if (bma->cur)
 		bma->cur->bc_ino.flags =
-			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+			bma->wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
 
 	bma->got.br_startoff = bma->offset;
 	bma->got.br_startblock = bma->blkno;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index ed7b7286..62f77aa1 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -228,7 +228,7 @@ xfs_bmbt_alloc_block(
 	}
 
 	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL;
+	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
 	if (!args.wasdel && args.tp->t_blk_res == 0) {
 		error = -ENOSPC;
 		goto error0;
@@ -642,7 +642,7 @@ xfs_bmbt_change_owner(
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)
 		return -ENOMEM;
-	cur->bc_ino.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
+	cur->bc_ino.flags |= XFS_BTCUR_BMBT_INVALID_OWNER;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 9985b85d..6771c981 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1740,7 +1740,7 @@ xfs_btree_lookup_get_block(
 
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
-	    !(cur->bc_ino.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
+	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
 	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
 			cur->bc_ino.ip->i_ino)
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 88750586..33980a12 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -220,8 +220,8 @@ typedef struct xfs_btree_cur
 			short		forksize;	/* fork's inode space */
 			char		whichfork;	/* data or attr fork */
 			char		flags;		/* flags */
-#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
-#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
+#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
+#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
 		} b;
 	}		bc_private;	/* per-btree type data */
 #define bc_ag	bc_private.a
-- 
2.26.2

