Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF573C10F25
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 889D220726
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tuSfa90o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCFOwU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:52:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52822 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgCFOwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:52:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=pIVInmgxCNbup/XPPKmAhgWUkOYnLAdV4XiFZ/HGu60=; b=tuSfa90oubix8D7yzRgKsCkZBW
        kKRG2MCkHsHobiOBocOqSOfwwxKbHyvEioGvzNsIJXnvkzZR4t/jnEgbhjtKQAIUVBPqLNewvNAGc
        o4FSqSfzLc2H4dBDnaTpZVeVzW3kLaNbMD2gJrpE6wuRzrRLhodTQ2AywTbbViJeqcAO5fyyPe3K6
        86qKpZEotImOGOFsEsIGh49ftxb/kmrh0FisKUKoBZejlfJeQfXLY5c75SaXSzs8D0urmIrHxkz/h
        EGT65jQ6InKXo3kLM9nCZQje+UGKkGrSKyqzJ+ec8V/z/3G7OrMIgsfqPysSN8DL1C0YDb+jQwuhO
        6lcbsm2g==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAEKp-0008B5-J2; Fri, 06 Mar 2020 14:52:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Date:   Fri,  6 Mar 2020 07:52:15 -0700
Message-Id: <20200306145220.242562-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306145220.242562-1-hch@lst.de>
References: <20200306145220.242562-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

struct xfs_agfl is a header in front of the AGFL entries that exists
for CRC enabled file systems.  For not CRC enabled file systems the AGFL
is simply a list of agbno.  Make the CRC case similar to that by just
using the list behind the new header.  This indirectly solves a problem
with modern gcc versions that warn about taking addresses of packed
structures (and we have to pack the AGFL given that gcc rounds up
structure sizes).  Also replace the helper macro to get from a buffer
with an inline function in xfs_alloc.h to make the code easier to
read.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c         |  2 +-
 fs/xfs/libxfs/xfs_alloc.c      | 11 ++++++-----
 fs/xfs/libxfs/xfs_alloc.h      |  9 +++++++++
 fs/xfs/libxfs/xfs_format.h     |  6 ------
 fs/xfs/scrub/agheader_repair.c |  2 +-
 5 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 08d6beb54f8c..831bdd035900 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -301,7 +301,7 @@ xfs_agflblock_init(
 		uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
 	}
 
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
+	agfl_bno = xfs_buf_to_agfl_bno(bp);
 	for (bucket = 0; bucket < xfs_agfl_size(mp); bucket++)
 		agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 183dc2587092..f668e62acc56 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -589,6 +589,7 @@ xfs_agfl_verify(
 {
 	struct xfs_mount *mp = bp->b_mount;
 	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
+	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
 	int		i;
 
 	/*
@@ -614,8 +615,8 @@ xfs_agfl_verify(
 		return __this_address;
 
 	for (i = 0; i < xfs_agfl_size(mp); i++) {
-		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
-		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
+		if (be32_to_cpu(agfl_bno[i]) != NULLAGBLOCK &&
+		    be32_to_cpu(agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return __this_address;
 	}
 
@@ -2684,7 +2685,7 @@ xfs_alloc_get_freelist(
 	/*
 	 * Get the block number and update the data structures.
 	 */
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
 	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
@@ -2820,7 +2821,7 @@ xfs_alloc_put_freelist(
 
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
 
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	blockp = &agfl_bno[be32_to_cpu(agf->agf_fllast)];
 	*blockp = cpu_to_be32(bno);
 	startoff = (char *)blockp - (char *)agflbp->b_addr;
@@ -3424,7 +3425,7 @@ xfs_agfl_walk(
 	unsigned int		i;
 	int			error;
 
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	i = be32_to_cpu(agf->agf_flfirst);
 
 	/* Nothing to walk in an empty AGFL. */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 7380fbe4a3ff..a851bf77f17b 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -236,4 +236,13 @@ typedef int (*xfs_agfl_walk_fn)(struct xfs_mount *mp, xfs_agblock_t bno,
 int xfs_agfl_walk(struct xfs_mount *mp, struct xfs_agf *agf,
 		struct xfs_buf *agflbp, xfs_agfl_walk_fn walk_fn, void *priv);
 
+static inline __be32 *
+xfs_buf_to_agfl_bno(
+	struct xfs_buf		*bp)
+{
+	if (xfs_sb_version_hascrc(&bp->b_mount->m_sb))
+		return bp->b_addr + sizeof(struct xfs_agfl);
+	return bp->b_addr;
+}
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 77e9fa385980..8c7aea7795da 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -785,18 +785,12 @@ typedef struct xfs_agi {
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
 #define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
 
-#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
-		(__be32 *)(bp)->b_addr)
-
 typedef struct xfs_agfl {
 	__be32		agfl_magicnum;
 	__be32		agfl_seqno;
 	uuid_t		agfl_uuid;
 	__be64		agfl_lsn;
 	__be32		agfl_crc;
-	__be32		agfl_bno[];	/* actually xfs_agfl_size(mp) */
 } __attribute__((packed)) xfs_agfl_t;
 
 #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index d5e6db9af434..68ee1ce1ae36 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -602,7 +602,7 @@ xrep_agfl_init_header(
 	 * step.
 	 */
 	fl_off = 0;
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
+	agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
 	for_each_xfs_bitmap_extent(br, n, agfl_extents) {
 		agbno = XFS_FSB_TO_AGBNO(mp, br->start);
 
-- 
2.24.1

