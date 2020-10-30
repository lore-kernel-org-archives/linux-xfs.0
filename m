Return-Path: <SRS0=YpFG=EF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C38C55178
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 08:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D906822253
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 08:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ABXvdDqp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgJ3IYC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3IYC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 04:24:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEFBC0613CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 01:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pehdzqsTKEeVldR2x8JCF0mBqGxB8RmQEOxPMXF3W7c=; b=ABXvdDqppBLdMtFu0SwtEB9/jy
        DXlmB0ndrbC7SEzWzrnoZL+9CGG+nV/YlYH79ForS0v9YyH3m5/yZlPDckTw2Qg46YZiIz62ckshT
        Qao0cjejYJ89b29Hle4aeFtS76HNtVKooOw0lM/Ix3eg8maVpsoo+Iw1XLWcoZLvuEF8s+iJVSn6u
        0Hewke0Qew/GXk/rIlM8sT3P03BwIdtDi3qagFIWGSWXSDCfKPO4zI6yA7pJ0NvONcepJqwsUPeNj
        QSAJ2Mu9WGI3JybVK//sbccSiemOO1uKkxumlQ5kZM+DAwOZB5l4NpGl5xKZ0roCMcle1RheJ7LMe
        920xzJNQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYPhW-0000Rw-SQ; Fri, 30 Oct 2020 08:23:58 +0000
Date:   Fri, 30 Oct 2020 08:23:58 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/26] xfs_db: report bigtime format timestamps
Message-ID: <20201030082358.GC303@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375537615.881414.8162037930017365466.stgit@magnolia>
 <20201029095010.GO2091@infradead.org>
 <20201029174544.GR1061252@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029174544.GR1061252@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 10:45:44AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 29, 2020 at 09:50:10AM +0000, Christoph Hellwig wrote:
> > > +static void
> > > +fp_time64(
> > > +	time64_t		sec)
> > >  {
> > > +	time_t			tt = sec;
> > >  	char			*c;
> > > +
> > > +	BUILD_BUG_ON(sizeof(long) != sizeof(time_t));
> > 
> > Why?
> 
> Trying to make the best of a braindead situation.  IIRC C99/11/18 don't
> provide a specific definition of what time_t is supposed to be.  POSIX
> 2017 seems to hint that it should be an integer seconds counter, but
> doesn't provide any further clarity.  (And then says it defers to ISO C,
> having made that allusion to integerness.)

I'm pretty sure the x32 ABI has a time_t that is bigger than long,
which broken POSIX semantics.

> Hence adding a trap so that if xfsprogs ever does encounter C library
> where time_t isn't a long int, we'd get to hear about it.  Granted that
> further assumes that time_t isn't a float, but ... ugh.
> 
> I guess this could have assigned sec to a time_t value and then compared
> it back to the original value to see if we ripped off any upper bits.

I think the standard way would be an intmax_t local variable that the
value is assigned to.
