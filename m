Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F090C07E96
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 06:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E2C61358
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 06:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhGOGDI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 02:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhGOGDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jul 2021 02:03:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A27CC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 23:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I0lr9LcilYlAWklp6NCgeJMGcAdgCk8zGjPXcR6M8k8=; b=Ypb40wCuk1pgWMvLizoXk8xXZ5
        tUWsGSb74LGl6odYxLBdldq7Y4KTQnD6AqxOzJi++fwPwgXOjEfxaV0tBHVHLWFEaTgzvtdgDyRX+
        lkY8cu7F8ZswCMo4njltMNG8XyMgF3NMRyF4CkwXOSYudIDqdcKdltNeEkjdPf77jdkdk4PTAs7vN
        /9baSpvu1oIyBYP2nWIrlJxBp1UXgqsCsquhf/85q4bQSXeAJIRlREYxe5MGDSGLX4+LZyqFqXIOz
        TPDex1/+dZ6j+oZu0GsGkTU1IgRTGZSLn5g3vhAAxuCxvdFQeO6KUwR5Xh2DuYYfWWAWdpkToEVxs
        QMkR0M3g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3uP1-0032Wu-7o; Thu, 15 Jul 2021 05:59:35 +0000
Date:   Thu, 15 Jul 2021 06:59:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs: consolidate mount option features in
 m_features
Message-ID: <YO/Otw6P7UhR5B6I@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-7-david@fromorbit.com>
 <YO6MxE1VvDYqCc4s@infradead.org>
 <20210714095507.GZ664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714095507.GZ664593@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 07:55:07PM +1000, Dave Chinner wrote:
> > What about using a separate field for these?  With this patch we've used
> > up all 64-bits in the features field, which isn't exactly the definition
> > of future proof..
> 
> I've used 16 mount option flags and 26 sb feature flags in this
> patch set, so there's still 22 feature flags remaining before we
> need to split them. This is all in-memory stuff so it's easy to
> modify in future. Given that the flag sets are largely set in only
> one place each and the check functions are all macro-ised, splitting
> them when we do run out of bits is trivial.
> 
> I'm more interested in trying to keep the cache footprint of
> frequently accessed read-only data down to a minimum right now,
> which is why I aggregated them in the first place...

Oh, I missed the hole in the middle.  Still not sure if mixing up mount
and on-disk flags entirely is something I'm fully comfortable with.  What
do you think of at least marking the mount options in the name?
