Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D20BC3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6855922CE9
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PCXPCcCF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfH3Pbb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:31:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbfH3Pbb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 11:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bIzG1jGsQuMTGAuQ2DDC3ZA7tgwfkwza6fvkhDfPJcA=; b=PCXPCcCFTmpEeYY1gXy9O3Ot/
        0EW+7a3XSBKQ4MRRgf+QjRxpywjKFOzED5ijGU29m924rSK/oUnflnAHuRAGDno6VHFdmGNB9gNyP
        /GpwibHbcz2bIHNog42JzclBz1EvWpb7BOQi+h1An2p664Q3tYiBzfo2BGWFvhbPZ/b/FnRMs8sDV
        8J1srsgH95JewpW2+6EtC8gjIeJVFD8aSdTZwpu0ieOp4d1zxUJ7xIIruzf+hqRiGUaLnQNICGQlC
        SLryH2PRvLMi8blitQ8Qfzzwfn7gH3kCf9V5Ezdr/gyKJCQvTKzL2O1JrWkpASCsjr6DNo0KDfUvY
        NCpgBbhQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3is7-0007aj-6g; Fri, 30 Aug 2019 15:31:31 +0000
Date:   Fri, 30 Aug 2019 08:31:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reinitialize rm_flags when unpacking an offset
 into an rmap irec
Message-ID: <20190830153131.GB13924@infradead.org>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
 <156685618619.2853674.16603505107055424362.stgit@magnolia>
 <20190829072957.GF18102@infradead.org>
 <20190829160118.GG5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829160118.GG5354@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:01:18AM -0700, Darrick J. Wong wrote:
> > >  	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
> > > diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> > > index 0c2c3cb73429..abe633403fd1 100644
> > > --- a/fs/xfs/libxfs/xfs_rmap.h
> > > +++ b/fs/xfs/libxfs/xfs_rmap.h
> > > @@ -68,6 +68,7 @@ xfs_rmap_irec_offset_unpack(
> > >  	if (offset & ~(XFS_RMAP_OFF_MASK | XFS_RMAP_OFF_FLAGS))
> > >  		return -EFSCORRUPTED;
> > >  	irec->rm_offset = XFS_RMAP_OFF(offset);
> > > +	irec->rm_flags = 0;
> > 
> > The change looks sensible-ish.  But why do we even have a separate
> > xfs_rmap_irec_offset_unpack with a single caller nd out of the
> > way in a header?  Wouldn't it make sense to just merge the two
> > functions?
> 
> xfs_repair uses libxfs_rmap_irec_offset_unpack, which is why it's a
> separate function.

True.  Athough repair would also benefit a lot from a version of
xfs_rmap_btrec_to_irec that just takes a bmbt_key instead, but that is
for another time.
