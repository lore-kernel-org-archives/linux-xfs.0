Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AF8C35242
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 02:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B2952071A
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 02:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NLd9tUYu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgAZCno (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 21:43:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53550 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgAZCno (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 21:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HzA6qPuHVZSRpJbgDK1bsoFMNcaYWWkVypEX7PpBi8E=; b=NLd9tUYuUhutKsvbPHhvTCrgT
        3O6POkEoIBSj3vA3W7wGhO31nV/AcYmzkKV/+44nMUOzlFmp32f8V59R3gPFTJjAtQu1FGQrc7cyV
        uK1a6xogGSbaXfrNyfS2ZCTJTiEaA1weBuSn3L5UJDRVd4BDBhg7Hf8TF2S3C2m/417PdmU+Pemav
        99kXJfN/0Q7Lnu8s6AQl97mJsFyezpg3mIaifMJsrKWNG2RWCQkde7A3qpBNWJn7+4Ir7r7D9p3hB
        fU1yyxd9a1T8lWYappNNBVxsga20j0hvYOAC/EbBYxIQb9ICKH3J1v4Vs5B0QeNmoSPeuuBqOeCcw
        Vt4dna5zQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivXtn-0005Fn-B4; Sun, 26 Jan 2020 02:43:43 +0000
Date:   Sat, 25 Jan 2020 18:43:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 10/12] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
Message-ID: <20200126024343.GA20075@infradead.org>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
 <157984320125.3139258.966527323692871610.stgit@magnolia>
 <20200124231207.GD20014@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124231207.GD20014@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 24, 2020 at 03:12:07PM -0800, Christoph Hellwig wrote:
> > +	/* We don't support trylock when freeing. */
> > +	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
> > +			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
> 
> Does this assert really work?  Shouldn't it be
> 
> 	ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING) ||
> 	       !(flags & XFS_ALLOC_FLAG_TRYLOCK));

Actually, I'll take that back - your version is doing the right thing.
It just isn't quite as obvious to read.
