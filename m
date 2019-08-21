Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EC1C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 23:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B27522DD3
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 23:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YXxEylS1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfHUX3q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 19:29:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56824 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbfHUX3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 19:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aHYhu/BO6JRiwvcQs+qhaKTsW8NlTKBRxI7/+gLWijc=; b=YXxEylS1qcsNDflm4wX/sr9Hd
        gQP+ZpZ50Gpzp9IZ+3P758X4NUwWvQ4ICxwEron/q3VBlMN3A33Wj73W/IKMyudUP3NXMAUqGga6K
        enM0IW9e8mB8UHQ6hiZ3yelJkR0SNuWfys+tCnv7bNAYgmZqWg3wNHXTjZyCP4TND3k+sVI3uxIgo
        z+U/oXZ4/Xkqtkh+sV6/xYABoVsvBqEbrD0my9eZotzD3OLKqjqhTKg90VU8KGepCJg/f9/R1HQHF
        L9W9K5ljZ1OhhE9XHv/59UpD415MrJ+LMhTq5ywJdkv4muQ1/DyJZszcuU17KImtYbD900RDc4xNB
        c7r6c33+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0a2z-0002G7-TK; Wed, 21 Aug 2019 23:29:45 +0000
Date:   Wed, 21 Aug 2019 16:29:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190821232945.GC24904@infradead.org>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821083820.11725-4-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add memory buffer alignment validation checks to bios built in XFS
> to catch bugs that will result in silent data corruption in block
> drivers that cannot handle unaligned memory buffers but don't
> validate the incoming buffer alignment is correct.
> 
> Known drivers with these issues are xenblk, brd and pmem.
> 
> Despite there being nothing XFS specific to xfs_bio_add_page(), this
> function was created to do the required validation because the block
> layer developers that keep telling us that is not possible to
> validate buffer alignment in bio_add_page(), and even if it was
> possible it would be too much overhead to do at runtime.

I really don't think we should life this to XFS, but instead fix it
in the block layer.  And that is not only because I have a pending
series lifting bits you are touching to the block layer..

> +int
> +xfs_bio_add_page(
> +	struct bio	*bio,
> +	struct page	*page,
> +	unsigned int	len,
> +	unsigned int	offset)
> +{
> +	struct request_queue	*q = bio->bi_disk->queue;
> +	bool		same_page = false;
> +
> +	if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
> +		return -EIO;
> +
> +	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
> +		if (bio_full(bio, len))
> +			return 0;
> +		__bio_add_page(bio, page, len, offset);
> +	}
> +	return len;

I know Jens disagree, but with the amount of bugs we've been hitting
thangs to slub (and I'm pretty sure we have a more hiding outside of
XFS) I think we need to add the blk_rq_aligned check to bio_add_page.

Note that all current callers of bio_add_page can only really check
for the return value != the added len anyway, so it is not going to
make anything worse.
