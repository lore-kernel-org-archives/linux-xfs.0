Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E877C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A3C2208C3
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:01:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L3ig1AVH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgEAIBz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgEAIBz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:01:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A4AC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wsmiPebSLKvhEVIzn/cuiiElnHZJ7ECbscJmrKnx/Pg=; b=L3ig1AVHp9u8cFuFFERcEe1L2/
        /HItixBenNsdkfA9YDZ8kxBkmhdFtKJkff56+DrbezlOHZ4ThRZmf9JE3anFN1B2e4TcwemHZJdoY
        XDdRWS2xPHrZzngBqg8kPAnaCvYsc5tUH/G3fv3bdeW7ySXdfKAYCKRHxF6ftdLRhUEq8gJn9OimC
        UPfPKfEP084foZEPj28oJWW71cy2mYB7fpPvM5ugvhr93FulEUqaMxZLkVB16iut7njQ7yPFoeNY7
        76RabxhR+7QlOsETqPrlZ0+uRB7Y3rAQYyBFoxt5XolwX7tGgs7IPVO/wOhZ/4y5kwEkyTL81iNuX
        6V5+xR3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQcJ-0004CA-Gk; Fri, 01 May 2020 08:01:51 +0000
Date:   Fri, 1 May 2020 01:01:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 13/17] xfs: combine xfs_trans_ail_[remove|delete]()
Message-ID: <20200501080151.GI29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-14-bfoster@redhat.com>
 <20200430185841.GN6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430185841.GN6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 11:58:41AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 29, 2020 at 01:21:49PM -0400, Brian Foster wrote:
> > Now that the functions and callers of
> > xfs_trans_ail_[remove|delete]() have been fixed up appropriately,
> > the only difference between the two is the shutdown behavior. There
> > are only a few callers of the _remove() variant, so make the
> > shutdown conditional on the parameter and combine the two functions.
> > 
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Ok.  I guess the rest of you like this broken out though tbh I found it
> harder to figure out why and where we were going (and used git range
> diff as a crutch).  Not that I'm asking to have things put back.  I got
> through it already... :)

The fine grained split actually allowed me to understand what was going
on.  The large catch all patch looks vaguely nice to me, but I could
not really reason how it was correct, this series nicely leads there.
