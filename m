Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802CEC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2749064EDC
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhBYJm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbhBYJmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:42:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1772DC06178B
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=soI6DOvmFZQOQDZygJtSIK4/8+CD5L0lt3y5L9yBaVM=; b=vsA577s0wnBK8s08Qg3AGrKJ0e
        T2pzEC0/mccN+vS2LHRUZPGZ43sY2JAz83JRwOz+nbutMBI+jBAfbtWuLo+r27sD2GSUcd1NL/qtS
        xWpV/m1/ctB3n4ed/u+cz79o6tL78/xr8bCc1JElmRkqddOLPQqsRJWjt43C+C+u494DCBvfn8FEk
        fQwRAU/CKx+KqRQpBYjqQ6lZQkv3z5pwle3OCsbqkLBy/KWRqOu5LybPIikWjiScNfuRJdPjLriIO
        7rKZiejjNpTxQURBIiKO6olBiRl8lNWPUpfIMdde8zNf3wwDC9H08laGlMwknle6qx0l4com0H64C
        b3G+rVRQ==;
Received: from [2001:4bb8:188:6508:774c:3d81:3abc:7b82] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFD6R-00AWxs-Oa; Thu, 25 Feb 2021 09:38:43 +0000
Date:   Thu, 25 Feb 2021 10:38:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: embed the xlog_op_header in the unmount record
Message-ID: <YDdwGqzX+izceTtG@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 05:34:50PM +1100, Dave Chinner wrote:
>  	/* Don't account for regions with embedded ophdrs */
>  	if (optype && headers > 0) {
> +		headers--;
>  		if (optype & XLOG_START_TRANS) {
> +			ASSERT(headers >= 1);
> +			headers--;

A more detailed comment on the magic for XLOG_START_TRANS might be useful
here.

> @@ -2518,14 +2516,13 @@ xlog_write(
>  			/*
>  			 * The XLOG_START_TRANS has embedded ophdrs for the
>  			 * start record and transaction header. They will always
> -			 * be the first two regions in the lv chain.
> +			 * be the first two regions in the lv chain. Commit and
> +			 * unmount records also have embedded ophdrs.
>  			 */

Maybe update this comment to cover the other special cases as well?
