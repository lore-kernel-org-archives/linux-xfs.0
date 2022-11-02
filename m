Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CCDC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 08:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiKBIZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 04:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiKBIZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 04:25:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A9322BCC
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 01:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HbVizKpsmkZe2gE1aM1AnyQQY71AouJcnL2xcW3ozq0=; b=4OMT4+hIQM5nCTcQ4VG9jmX9TI
        EI7akVb9W0ZKAlB91Svv8W3XYhyawIeGAhkZnpPgfeS7JBeUu9oOzQsog2lheb65zPAiSuFyNwpXN
        czK88iSUGYtW4p2CBRwmAnCEIluIR83zdNsqqvSAjnmlCcjarXZww1UqZrHS/je9GQoCGtbFtZ0Xr
        ZdtZXBmlqKn50QE83UkIHKoysi4lBmx0x2inv2s6rNafYqIhS4eoQ4EihJ25BQQyLLPzO9mV7aG8U
        yeRrIdj7uTYhuQMIaQvba1ys3MljvF1gmV+cXwBo4e03pwdyZHGtmDqDP+RiXphJf5hBza5dcBAgA
        QyO/9SDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oq94K-008tqz-IF; Wed, 02 Nov 2022 08:25:52 +0000
Date:   Wed, 2 Nov 2022 01:25:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: redirty eof folio on truncate to avoid filemap flush
Message-ID: <Y2IpkFqbM5/+C+CA@infradead.org>
References: <20221028130411.977076-1-bfoster@redhat.com>
 <20221028131109.977581-1-bfoster@redhat.com>
 <Y1we59XylviZs+Ry@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1we59XylviZs+Ry@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 02:26:47PM -0400, Brian Foster wrote:
> index 91ee0b308e13..14a9734b2838 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -899,7 +899,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
>  	loff_t written = 0;
>  
>  	/* already zeroed?  we're done. */
> -	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
> +	if ((srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) &&
> +	    !(srcmap->flags & IOMAP_F_TRUNC_PAGE))

As mentioned elsewere in the thread I think we can just move the
filemap_range_needs_writeback here, which removes the need for
IOMAP_F_TRUNC_PAGE.

> +static int
> +__iomap_zero_range(struct iomap_iter *iter, bool *did_zero,
> +		   const struct iomap_ops *ops)
> +{
> +	int ret;
> +
> +	while ((ret = iomap_iter(iter, ops)) > 0)
> +		iter->processed = iomap_zero_iter(iter, did_zero);
> +	return ret;
> +}

I'd be tempted to just duplicate this two line loop instead of adding
such a tivial helper, but that's just a matter of taste.
