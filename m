Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D48C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AF2E20702
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="plsYN+aC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgA2S2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 13:28:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgA2S2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 13:28:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LimRarKuPqONzyqbtxPCyHQ3FHsR1DVZRsqR9LBidPI=; b=plsYN+aC0qBjYCxa+1NobZ5tw
        yZi5efVZ0XHT0oa3puC5ELrJzjC/j5eHCeaqA/6URKW9dzwF755QtPuhUbQXlFpwQkrN4stCpHf2e
        GhRXQm+GjYlsV13Dw5vrPpsCKSrEI18pxkHRvLpCzOJQTtKvjyBf6O/dYMLFz4KPBul0GJ5w9q7Vn
        25fvtmXjS4Tebn/ALzPWICJGnkltHy2QBzJVsy0z7t8KxbY0e7kiLHIejITthXpseWK+OxvoyATSx
        ti6ndVm2h3pisEm1FVW7Xp0xxGgqfllXuSHtNyemA3rU76j4UmFXF5U34CC/jn0uoMGspVbUPnxra
        GDGK1KmYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iws4r-0003vV-EW; Wed, 29 Jan 2020 18:28:37 +0000
Date:   Wed, 29 Jan 2020 10:28:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: don't take addresses of packed xfs_agfl_t member
Message-ID: <20200129182837.GD14855@infradead.org>
References: <65e48930-96ae-7307-ba65-6b7528bb2fb5@redhat.com>
 <09382ee9-8539-2f1d-bd4d-7256daf38a40@redhat.com>
 <20200129180954.GC14855@infradead.org>
 <1e0fada6-1a6f-6980-ab2c-85aa8b4998e7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e0fada6-1a6f-6980-ab2c-85aa8b4998e7@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 12:18:16PM -0600, Eric Sandeen wrote:
> > 
> > But I absolutely do not see the point.  If agfl_bno was unalgined
> > so is adding the offsetoff.  The warnings makes no sense, and there is
> > a good reason the kernel build turned it off.
> 
> Why do the warnings make no sense?

Because taking the address of a member of a packed struct itself doesn't
mean it is misaligned.  Taking the address of misaligned member does
that.  And adding a non-aligned offset to a pointer will make it just
as misaligned.

> TBH, the above construction actually makes a lot more intuitive sense to
> me, alignment concerns or not.

Using offsetoff to take the address of a struct member is really
strange.

If we want to stop taking the address of agfl_bno we should just remove
the field entirely:

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fc93fd88ec89..d91177c4a1e4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -585,11 +585,12 @@ xfs_alloc_fixup_trees(
 
 static xfs_failaddr_t
 xfs_agfl_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
-	struct xfs_mount *mp = bp->b_mount;
-	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
-	int		i;
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_agfl		*agfl = XFS_BUF_TO_AGFL(bp);
+	__be32			*agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
+	int			i;
 
 	/*
 	 * There is no verification of non-crc AGFLs because mkfs does not
@@ -614,8 +615,8 @@ xfs_agfl_verify(
 		return __this_address;
 
 	for (i = 0; i < xfs_agfl_size(mp); i++) {
-		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
-		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
+		if (be32_to_cpu(agfl_bno[i]) != NULLAGBLOCK &&
+		    be32_to_cpu(agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 77e9fa385980..0d0a6616e129 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -783,21 +783,21 @@ typedef struct xfs_agi {
  */
 #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
-#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
+#define	XFS_BUF_TO_AGFL(bp)	((struct xfs_agfl *)((bp)->b_addr))
 
-#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
-		(__be32 *)(bp)->b_addr)
+#define XFS_BUF_TO_AGFL_BNO(mp, bp)			\
+	((__be32 *)					\
+	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ?	\
+	  (bp)->b_addr :				\
+	  ((bp)->b_addr + sizeof(struct xfs_agfl))))
 
-typedef struct xfs_agfl {
+struct xfs_agfl {
 	__be32		agfl_magicnum;
 	__be32		agfl_seqno;
 	uuid_t		agfl_uuid;
 	__be64		agfl_lsn;
 	__be32		agfl_crc;
-	__be32		agfl_bno[];	/* actually xfs_agfl_size(mp) */
-} __attribute__((packed)) xfs_agfl_t;
+} __attribute__((packed));
 
 #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
 

