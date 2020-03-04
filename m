Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B734C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 15:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5675E215A4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 15:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G3dE6ZtF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgCDPt4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 10:49:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCDPtz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:49:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pddle2KSFTtBqsDy7IuwlrjbpsLtzuCbl8rWNR+bdro=; b=G3dE6ZtFlp9VmtHhTP9pWClXzs
        trY2sg59m/54uBj6xOMN2V6Dvv0CexYWEk67nE+XNvGxasjpZ07/GVypgL3TzABi5LaqRsA4IKDnA
        Iv7kLY7iJvbbb/SLFuO4+FvYtgcBKkKF80V3C9kmAUswiMBJbtOa0r131A+rGXaLPG7xWZOurvDcB
        Kv0OYgQKiPXCA9l9Ls8tPnIp9vSsKFioP2joW8lQDAcIHLQ6UYYgqwEP32HyeuKcjGXPxbq+JQxSB
        vVL9Pw/cS1bL2U1aEheAtiLpXMHNbvM3SRJPPTCFZtQbjl77GzX/QcQri71wYtWwTJnwLUuGdj/bu
        X+8/yt5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WHT-0000Gr-79; Wed, 04 Mar 2020 15:49:55 +0000
Date:   Wed, 4 Mar 2020 07:49:55 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: refactor and split xfs_log_done()
Message-ID: <20200304154955.GB17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +int
> +xlog_write_done(
> +	struct xlog		*log,
>  	struct xlog_ticket	*ticket,
>  	struct xlog_in_core	**iclog,
> +	xfs_lsn_t		*lsn)
>  {
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		return -EIO;
>  
> +	return xlog_commit_record(log, ticket, iclog, lsn);
> +}

Can we just move the XLOG_FORCED_SHUTDOWN check into xlog_commit_record
and call xlog_commit_record directly?

>  
> +/*
> + * Release or regrant the ticket reservation now the transaction is done with
> + * it depending on caller context. Rolling transactions need the ticket
> + * regranted, otherwise we release it completely.
> + */
> +void
> +xlog_ticket_done(
> +	struct xlog		*log,
> +	struct xlog_ticket	*ticket,
> +	bool			regrant)
> +{
>  	if (!regrant) {
>  		trace_xfs_log_done_nonperm(log, ticket);
>  		xlog_ungrant_log_space(log, ticket);
>  	} else {
>  		trace_xfs_log_done_perm(log, ticket);
>  		xlog_regrant_reserve_log_space(log, ticket);
>  	}

>  	xfs_log_ticket_put(ticket);

I'd move the trace points and the call to xfs_log_ticket_put into
xlog_ungrant_log_space and xlog_regrant_reserve_log_space, and then call
the two functions directly from the callers.  There is only a single
place the ever regrants anyway.
