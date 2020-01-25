Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8450C35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB5072071E
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="av1Awkl/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgAYXKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:10:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgAYXKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zl4xO6ZhbR/sX9iJBeWHku3VzhcvfWQ2SB5Fmoeicos=; b=av1Awkl/CfGVgZJiy9O5ULMUn
        Kpo9M+AHd2tH2onM22P9oXgQa7z5Jcbw4/7orQHKfb9P3HmArK3Fi7cCmBCl1bh2K+uj3JMCh9lBO
        m86aQWXfHQzlYh2Ze4pK0dajOZCWE4qh4oU2f+/DF5L99kD8nReEF5xcmgDnTzXxfOeoaa5aEIppL
        VhObC33DxsXcgj63FVEuKTfebvzyvhsBLxuO86rK/KWDZGa9hA4X53FaA4QC6bOygQPdIXu9L2ucp
        YpPL1doq2gzV1DudQ3FwOSMst/RyLzSFqTOq7isJoN2DUNFGFFWqXOeBUpSsDA+Ce1oe7p76eVIZ8
        V65lub1FA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUZj-0005Jd-6v; Sat, 25 Jan 2020 23:10:47 +0000
Date:   Sat, 25 Jan 2020 15:10:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 27/29] xfs: clean up the attr flag confusion
Message-ID: <20200125231047.GB15222@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-28-hch@lst.de>
 <20200121194440.GC8247@magnolia>
 <20200124232413.GB22102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124232413.GB22102@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 24, 2020 at 03:24:13PM -0800, Christoph Hellwig wrote:
> > > +	u32			ioc_flags)
> > > +{
> > > +	unsigned int		namespace = 0;
> > > +
> > > +	if (ioc_flags & XFS_IOC_ATTR_ROOT)
> > > +		namespace |= XFS_ATTR_ROOT;
> > > +	if (ioc_flags & XFS_IOC_ATTR_SECURE)
> > > +		namespace |= XFS_ATTR_SECURE;
> > 
> > Seeing as these are mutually exclusive options, I'm a little surprised
> > there isn't more checking that both of these flags aren't set at the
> > same time.
> > 
> > (Or I've been reading this series too long and missed that it does...)
> 
> XFS never rejected the combination.  It just won't find anything in that
> case.  Let me see if I could throw in another patch to add more checks
> there.

So for the get/set ioctl this was all fixed by

"xfs: reject invalid flags combinations in XFS_IOC_ATTRMULTI_BY_HANDLE"

for listattr it is rather harmless, but I can throw in a patch to
explicitly reject it.
