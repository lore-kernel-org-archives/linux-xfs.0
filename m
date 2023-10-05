Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DA3E92701
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjJEOFv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjJEODy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:03:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F6025734
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 04:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9GUHZAgoZOLmR7mak1Cm+eHgDNiFRPmfgrjgl0EtO2Y=; b=ISOnoJLjPS14SBbsxBk2ttic9D
        VPg5nqOMdsYkEFFuDblI2Pw7vujHZ127N4sWpSnqfBlSBtfuvj3OUBf/dUVbIq95WxRXuZgDySWZy
        Kajqy2Z2fNn8WLmNCt71vREEfVdP+d7EKXRILkXMou8r28lGP7ow++oBHRvnlFg4JBLOl6V4eXzPz
        B5kXOgM806PolEdrzJjfYUTowG4qlAcd9SPkcz7kVLov/RIkGhsUAtypMl8uWqjE+0QYuG5OBoLAe
        pBFNH2uQaVmsvblFR4ZN8xr3K9CFBJsvlL7WpGjE2jQhWeAT2UVzK5V+HV1RpA5stg4EvGhKPGYdP
        a9JFu3PA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoMyT-002Vc6-0f;
        Thu, 05 Oct 2023 11:57:01 +0000
Date:   Thu, 5 Oct 2023 04:57:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 4/9] xfs: push the perag outwards in initial allocation
Message-ID: <ZR6kjTYPBtJNSLHy@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The logic looks good, and really helps to distinguis the lowspace
case:

Reviewed-by: Christoph Hellwig <hch@lst.de>

However I stll find the loop in xfs_bmap_btalloc_select_lengths a little
suboptimal.  I'd go for something like this incremental patch:


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3c250c89f42e92..c1da9e9cfe05f2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3268,35 +3268,31 @@ xfs_bmap_btalloc_select_lengths(
 			xfs_perag_rele(pag);
 			return error;
 		}
-		if (*blen >= args->maxlen + stripe_align) {
-			/*
-			 * We are going to target a different AG than the
-			 * incoming target, so we need to reset the target and
-			 * skip exact EOF allocation attempts.
-			 */
-			if (agno != startag) {
-				ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
-				ap->aeof = false;
-			}
-			args->pag = pag;
-			break;
-		}
+
 		if (*blen > max_blen) {
 			max_blen = *blen;
 			max_blen_agno = agno;
+			if (*blen >= args->maxlen + stripe_align)
+				goto out;
 		}
 	}
 
-	if (max_blen >= *blen) {
-		ASSERT(args->pag == NULL);
-		if (max_blen_agno != startag) {
-			ap->blkno = XFS_AGB_TO_FSB(mp, max_blen_agno, 0);
-			ap->aeof = false;
-		}
-		*blen = max_blen;
-		args->pag = xfs_perag_grab(mp, max_blen_agno);
+	/*
+	 * We did not find a perfect fit, so pick the AG with the longest
+	 * available free space.
+	 */
+	*blen = max_blen;
+	pag = xfs_perag_grab(mp, max_blen_agno);
+out:
+	/*
+	 * If we are going to target a different AG than the incoming target,
+	 * reset the target and skip exact EOF allocation attempts.
+	 */
+	if (max_blen_agno != startag) {
+		ap->blkno = XFS_AGB_TO_FSB(mp, max_blen_agno, 0);
+		ap->aeof = false;
 	}
-
+	args->pag = pag;
 	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
 	return 0;
 }
