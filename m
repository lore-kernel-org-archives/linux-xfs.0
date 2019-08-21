Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757D9C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 23:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 478D12339F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 23:30:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MRdFvrjT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfHUXam (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 19:30:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfHUXam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 19:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0SEEcjeozELTYxVuI2O3kRhz2+D3iEF4LLMc1D+5c60=; b=MRdFvrjTNm3GbNaASWTfAZX/t
        RfIUKKYj2OwU5YVurgpOM+hGlRZbOvxzrttvcdIJQYAtv6u7s6AYaHE2S3SwRSnTFOeHTMXQVJLxa
        y8KTQSfk5T83/JpgsHgtJF5/8Gx+R5Jq0GBeJmU6/DkBbC1CP5pDKHxjxwRv3ho29CE5KPC3FUE6l
        2xuPiHUSUl1yQrR0NVPv4lLQzE9hqlgXSV8jKK3OIsj/n04cHBwdGTJ3/W6Lka7aiDYjraxq/9C1L
        1ciMnlg6y5+38L6cwprQZmigR3mvLPZfD7zmPJDwB1Y0jKgRGTE6dLyAESSQWf8t+/0mZaqXpi+zG
        JGe3jR9bA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0a3t-0003nN-WC; Wed, 21 Aug 2019 23:30:42 +0000
Date:   Wed, 21 Aug 2019 16:30:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190821233041.GD24904@infradead.org>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821133904.GC19646@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821133904.GC19646@bfoster>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 09:39:04AM -0400, Brian Foster wrote:
> > @@ -36,9 +57,12 @@ xfs_rw_bdev(
> >  		unsigned int	off = offset_in_page(data);
> >  		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
> >  
> > -		while (bio_add_page(bio, page, len, off) != len) {
> > +		while ((ret = xfs_bio_add_page(bio, page, len, off)) != len) {
> >  			struct bio	*prev = bio;
> >  
> > +			if (ret < 0)
> > +				goto submit;
> > +
> 
> Hmm.. is submitting the bio really the right thing to do if we get here
> and have failed to add any pages to the bio? If we're already seeing
> weird behavior for bios with unaligned data memory, this seems like a
> recipe for similar weirdness. We'd also end up doing a partial write in
> scenarios where we already know we're returning an error. Perhaps we
> should create an error path or use a check similar to what is already in
> xfs_buf_ioapply_map() (though I'm not a fan of submitting a partial I/O
> when we already know we're going to return an error) to call bio_endio()
> to undo any chaining.

It is not the right thing to do.  Calling bio_endio after setting
an error is the right thing to do (modulo any other cleanup needed).
