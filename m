Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932BDC4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED4F2083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z2f0atbt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgEGMUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgEGMUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8431C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0iI9wWWhyARVh8bCpoEMkrkQK8q3XxbB/NEJUXqi1k8=; b=Z2f0atbtKml7Eja0kEXLJJvhR5
        FZFiaETyNf4CezVKv5CzQCdpFk1/0ulwddagdMv3YZc7JRfehhztK/BaIZqkwmeGN05Q7mcOeF/fS
        nEiX8nQHXX+o2KRMzagqVYq639lDMJMl6oCf//NFXGGUZQHtZjcWHn98p6BY/iOarA3hOGG34o21q
        T4Za4WkVmod2RwkHxjBp0eotXeDz+B5MyRaY1tkUOxpY2cyly1hk5AUHc0du2rlj43mKVjayfjlDx
        4HSesdELc+qIc84xLXSHzjOMo32IkYU+phP6ddQoHsmUsPf+19l2qmJhztW1Qc9bCdikSa+MuVmum
        gx9zw/Ng==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVS-0005Er-8E; Thu, 07 May 2020 12:20:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/58] xfs: remove the xfs_agfl_t typedef
Date:   Thu,  7 May 2020 14:18:21 +0200
Message-Id: <20200507121851.304002-29-hch@lst.de>
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

Source kernel commit: 4b97510859b22e0db5edf104096af1132daeea9a

There is just a single user left, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c     | 2 +-
 copy/xfs_copy.h     | 2 +-
 db/agfl.c           | 2 +-
 libxfs/xfs_format.h | 6 +++---
 repair/phase5.c     | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index c4f9f349..72ce3fe7 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -454,7 +454,7 @@ read_ag_header(int fd, xfs_agnumber_t agno, wbuf *buf, ag_header_t *ag,
 	ASSERT(be32_to_cpu(ag->xfs_agf->agf_magicnum) == XFS_AGF_MAGIC);
 	ag->xfs_agi = (xfs_agi_t *) (buf->data + diff + 2 * sectorsize);
 	ASSERT(be32_to_cpu(ag->xfs_agi->agi_magicnum) == XFS_AGI_MAGIC);
-	ag->xfs_agfl = (xfs_agfl_t *) (buf->data + diff + 3 * sectorsize);
+	ag->xfs_agfl = (struct xfs_agfl *) (buf->data + diff + 3 * sectorsize);
 }
 
 
diff --git a/copy/xfs_copy.h b/copy/xfs_copy.h
index 534b63e5..0b0ec0ea 100644
--- a/copy/xfs_copy.h
+++ b/copy/xfs_copy.h
@@ -21,7 +21,7 @@ typedef struct ag_header  {
 	xfs_dsb_t	*xfs_sb;	/* superblock for filesystem or AG */
 	xfs_agf_t	*xfs_agf;	/* free space info */
 	xfs_agi_t	*xfs_agi;	/* free inode info */
-	xfs_agfl_t	*xfs_agfl;	/* AG freelist */
+	struct xfs_agfl	*xfs_agfl;	/* AG freelist */
 	char		*residue;
 	int		residue_length;
 } ag_header_t;
diff --git a/db/agfl.c b/db/agfl.c
index 33075351..ce7a2548 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -34,7 +34,7 @@ const field_t	agfl_crc_hfld[] = { {
 	{ NULL }
 };
 
-#define	OFF(f)	bitize(offsetof(xfs_agfl_t, agfl_ ## f))
+#define	OFF(f)	bitize(offsetof(struct xfs_agfl, agfl_ ## f))
 const field_t	agfl_flds[] = {
 	{ "bno", FLDT_AGBLOCKNZ, OI(OFF(magicnum)), agfl_bno_size,
 	  FLD_ARRAY|FLD_COUNT, TYP_DATA },
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index c1c69a4c..32b1651d 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -783,15 +783,15 @@ typedef struct xfs_agi {
  */
 #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
-#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
+#define	XFS_BUF_TO_AGFL(bp)	((struct xfs_agfl *)((bp)->b_addr))
 
-typedef struct xfs_agfl {
+struct xfs_agfl {
 	__be32		agfl_magicnum;
 	__be32		agfl_seqno;
 	uuid_t		agfl_uuid;
 	__be64		agfl_lsn;
 	__be32		agfl_crc;
-} __attribute__((packed)) xfs_agfl_t;
+} __attribute__((packed));
 
 #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 8a2ef64f..980ad045 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -441,7 +441,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * as they will be *after* accounting for the free space
 	 * we've used up will need fewer blocks to to represent
 	 * than we've allocated.  We can use the AGFL to hold
-	 * xfs_agfl_size (sector/xfs_agfl_t) blocks but that's it.
+	 * xfs_agfl_size (sector/struct xfs_agfl) blocks but that's it.
 	 * Thus we limit things to xfs_agfl_size/2 for each of the 2 btrees.
 	 * if the number of extra blocks is more than that,
 	 * we'll have to be called again.
-- 
2.26.2

