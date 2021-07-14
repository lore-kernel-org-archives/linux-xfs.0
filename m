Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BB3C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C09613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 06:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhGNGQc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 02:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbhGNGQb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 02:16:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E921EC0613DD
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R9PWeIXJ7h40eHBZl4a5fR+Q2ErbuzGYWkuKBJ6ksHM=; b=gMptOOMMgzLO1AqW3HImivLHJX
        +q1YRUG9uasDI0qWsdreE8d3VO538HaHHFMFKoXd+mqPEdQgKCz//+FGddhXAHntsej1L6yV0EZ3g
        hJcCydpRQmHaAJlsxSveHw6xAiIj7Xlbt3U85hj5i3nyh24dhx//8jEVS0eYVGtMjBXGRaVqoX5aF
        wxrmt+kk7kb3jAvXkMVqnayfZYFMIzVWCVmFkh+Ft0Kxd7ju9eL5nPh2Kd9rXBjzG/M578mD/D84/
        OmRhj6xrUTmtkjgFEvWnisPWMAwOa3L1F5pVmDgQnjSmv4FwSezVMwErXNlkudfiwRNP/iHk/ayZL
        8U6BzNmg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3Y8v-001ugu-Vj; Wed, 14 Jul 2021 06:13:26 +0000
Date:   Wed, 14 Jul 2021 07:13:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: XLOG_STATE_IOERROR must die
Message-ID: <YO6AedoDQRiwWfxG@infradead.org>
References: <20210714031958.2614411-1-david@fromorbit.com>
 <20210714031958.2614411-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031958.2614411-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -2781,23 +2770,20 @@ xlog_state_do_callback(
>  		 * Keep looping through iclogs until one full pass is made
>  		 * without running any callbacks.
>  		 */
> -		first_iclog = log->l_iclog;
> -		iclog = log->l_iclog;
>  		cycled_icloglock = false;
> -		ioerror = false;
> -		repeats++;
> +		first_iclog = log->l_iclog;
> +		iclog = first_iclog;
>  
>  		do {


> -		} while (first_iclog != iclog);
> +		} while (iclog != first_iclog);
>  
> -		if (repeats > 5000) {
> +		if (++repeats > 5000) {

Still various unrelated random reshuffling.

The rest looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
