Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541B9C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2886140E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhGBIDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhGBIDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:03:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B05C061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TXTAdWMAtN301PVXiI2WOJk5s0zbA0HrdJnrc9P5NGY=; b=qdajw1QP0CyHpApFrn71oGn++a
        crpZneeEWMeJdcYpQPsGfnIesbtnkc8Ona4j2s+s6AQ7Ptmaw6aACdTwLmPdkDCnSjp7TFEvBFV+d
        P3b1W7gUw9muLQLjNmx4gkrLn60JUkgysBlUUCo9Xof+qyME8gEMVnM9VKO+tkoFY0rbIHHFS7+4h
        CA5sL9J6dLkCrRGkKX82MNTLsSPVjtrNLHk+9ji5RdQuRf/TLjeY2AXvY2gZlB4OhRD8s2OwCSK1c
        /OPJR2pS1J5Z/UORXFSP0n3FKTBAnd5KMehKDStyum0kHWIJ44jMPFoyS1yPHEe97GnFO/IzjDMWn
        /l1CRQhw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzE5q-007Tdf-Nf; Fri, 02 Jul 2021 08:00:15 +0000
Date:   Fri, 2 Jul 2021 09:00:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: XLOG_STATE_IOERROR must die
Message-ID: <YN7HivsUsXYmfBHM@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	else
>  		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		       iclog->ic_state == XLOG_STATE_IOERROR);
> +			xlog_is_shutdown(log));

Nit:  think doing this as:

	else if (!xlog_is_shutdown(log))
		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);

would be a tad cleaner.

>  		else
>  			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -			       iclog->ic_state == XLOG_STATE_IOERROR);
> +				xlog_is_shutdown(log));

Same here.

> @@ -2765,12 +2755,13 @@ xlog_state_do_callback(
>  	struct xlog_in_core	*iclog;
>  	struct xlog_in_core	*first_iclog;
>  	bool			cycled_icloglock;
> -	bool			ioerror;
>  	int			flushcnt = 0;
>  	int			repeats = 0;
>  
>  	spin_lock(&log->l_icloglock);
>  	do {
> +		repeats++;
> +
>  		/*
>  		 * Scan all iclogs starting with the one pointed to by the
>  		 * log.  Reset this starting point each time the log is
> @@ -2779,23 +2770,21 @@ xlog_state_do_callback(
>  		 * Keep looping through iclogs until one full pass is made
>  		 * without running any callbacks.
>  		 */
> -		first_iclog = log->l_iclog;
> -		iclog = log->l_iclog;
>  		cycled_icloglock = false;
> -		ioerror = false;
> -		repeats++;
> -
> -		do {
> +		first_iclog = NULL;
> +		for (iclog = log->l_iclog;
> +		     iclog != first_iclog;
> +		     iclog = iclog->ic_next) {
>  			LIST_HEAD(cb_list);
>  
> -			if (xlog_state_iodone_process_iclog(log, iclog,
> -							&ioerror))
> -				break;
> +			if (!first_iclog)
> +				first_iclog = iclog;
>  
> -			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
> -			    iclog->ic_state != XLOG_STATE_IOERROR) {
> -				iclog = iclog->ic_next;
> -				continue;
> +			if (!xlog_is_shutdown(log)) {
> +				if (xlog_state_iodone_process_iclog(log, iclog))
> +					break;
> +				if (iclog->ic_state != XLOG_STATE_CALLBACK)
> +					continue;
>  			}
>  			list_splice_init(&iclog->ic_callbacks, &cb_list);
>  			spin_unlock(&log->l_icloglock);
> @@ -2810,8 +2799,7 @@ xlog_state_do_callback(
>  				wake_up_all(&iclog->ic_force_wait);
>  			else
>  				xlog_state_clean_iclog(log, iclog);
> -			iclog = iclog->ic_next;
> -		} while (first_iclog != iclog);
> +		};

I don't think swiching to a random other iteration style here helps
to review.  Please keep the old in in this otherwise pretty mechnical
change and clean it up later if you strongly prefer the new style.
(which I'm really not sold on, btw - yes it makes the continiue easier
but otherwise isn't all that great either).

Otherwise looks fine and long overdue.
