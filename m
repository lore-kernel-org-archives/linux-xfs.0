Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1502FC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D397C2339D
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r/6LGXYB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbfIDGKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:10:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfIDGKi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2/Z5ADIULxHpfHGa1hpwPQBTnRX86WuxWxt3UdcYmjQ=; b=r/6LGXYBFRWCuEFKbbST7/jgP
        rknHjEwABhYK8HgLF5c/Nv/LrALwo+u7ozrMuNOiDbXbkAEI8jczkOMcBdtt3k9fyeg5b9WH+Vmki
        rX1mY7RdT5cF/sEz3U9iiDV+EOmG4etOLLrcs+aoF6e297CBuTN0xKP5UsIH6JEHzwoNBdAZ5P/yN
        e8HVU+8FLIOcqxmua9FIH/pUqK/ld5s/SvEXLQhrHItxnFI41zJJGyRFlxA8D2tXihGp6kldOvBll
        7BhqJvIic7HVbtkxMlz0fi+LDn+CRa6ZK5EqhPoc8Jn+TNfsL74IED1cmNPhx7ryjTP+pPY2O+1t7
        r86iYD+Ww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5OV4-0006bx-18; Wed, 04 Sep 2019 06:10:38 +0000
Date:   Tue, 3 Sep 2019 23:10:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: factor debug code out of
 xlog_state_do_callback()
Message-ID: <20190904061038.GC12591@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-4-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> + * Note that SYNCING|IOABORT is a valid state so we cannot just check for
> + * ic_state == SYNCING.

I've removed the IOABORT flag recently, but it seems I forgot to remove
this comment.  That beeing said the IOERR flag is still a complete mess
as we sometimes use it as a flag and sometimes as a separate state.
I've been wanting to sort that out, but always got preempted.

> + */
> +static void
> +xlog_state_callback_check_state(
> +	struct xlog		*log,
> +	int			did_callbacks)
> +{
> +	struct xlog_in_core	*iclog;
> +	struct xlog_in_core	*first_iclog;
> +
> +	if (!did_callbacks)
> +		return;
> +
> +	first_iclog = iclog = log->l_iclog;

I'd keep the did_callbacks check in the caller.  For the non-debug case
it will be optimized away, but it saves an argument, and allows
initializing the iclog variables on the declaration line.

> +	do {
> +		ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
> +		/*
> +		 * Terminate the loop if iclogs are found in states
> +		 * which will cause other threads to clean up iclogs.
> +		 *
> +		 * SYNCING - i/o completion will go through logs
> +		 * DONE_SYNC - interrupt thread should be waiting for
> +		 *              l_icloglock
> +		 * IOERROR - give up hope all ye who enter here
> +		 */
> +		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +		    iclog->ic_state & XLOG_STATE_SYNCING ||
> +		    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
> +		    iclog->ic_state == XLOG_STATE_IOERROR )
> +			break;
> +		iclog = iclog->ic_next;

No new, but if we list the states we should not miss one..
