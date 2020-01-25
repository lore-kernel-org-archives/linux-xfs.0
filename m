Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217ABC35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D801420704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o3nSiHCw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgAYXIm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:08:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgAYXIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bFYIR4DAF8e8uSQWLLk84i2LP1YruYaniMVqgtG6IUY=; b=o3nSiHCw1FLLjnl/9lBPHF6OZ
        wOZBC9hKDmWkQU2HB+Ess5zypB3x9SCp/QL9GQFOsU88fh1NnYPIshIRjexDub90d1jeh2w8jTOuc
        g0aPVbs5vzlkKJic24Jz1pTsNN7udM4OMpIwvH6i1cIf4f+Q9t18RVcM/q5hig9t0lt5Cp1TqgfZe
        oNwhflzXa0t5xzxS7iorNr9ElKskwZiKdkVmH8jS1l3nPfe6s+eNkQNFIKT/4pLD7Ev1Jf2kcu/qf
        6zzsbouSRyBaarEVhHcwLOygGoYYgIO5vq/klziuhRZy1IOSxtBMj08EPN6Hd0eahGs+H5pDYI+Jo
        LUSsWxmdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUXh-000439-2p; Sat, 25 Jan 2020 23:08:41 +0000
Date:   Sat, 25 Jan 2020 15:08:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 04/14] xfs: Add xfs_has_attr and subroutines
Message-ID: <20200125230841.GA15222@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-5-allison.henderson@oracle.com>
 <20191224121830.GD18379@infradead.org>
 <2b29c0a0-03bb-8a21-8a8a-fd4754bff3ff@oracle.com>
 <20200121223059.GG8247@magnolia>
 <6f955cc1-8739-7c00-0dcb-0b9e4a912380@oracle.com>
 <32b91246-a6c0-a8c1-a50d-8a11cc30674a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32b91246-a6c0-a8c1-a50d-8a11cc30674a@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 25, 2020 at 09:27:39AM -0700, Allison Collins wrote:
> I was thinking of adapting this patch to be part of a 3 patch series
> including one of Chistophs.  Something like this:
> 
> [PATCH v6 11/16] xfs: Check for -ENOATTR or -EEXIST
> [PATCH v6 03/16] xfs: Add xfs_has_attr and subroutines
> [PATCH 02/29] xfs: merge xfs_attr_remove into xfs_attr_set
> 
> What would people think of that?  I figured this would be better than the
> two of us bombarding the mailing list with giant conflicting sets? Also, was
> I able to answer everyones questions on this patch?

I'm still not sold at all on this series.  It adds a lot of code and
makes it much harder to understand.  So I'd much rather go back and
figuring out how we can do delayed attrs in a more streamlined way.
The has_attr and co changes are some of exactly that kind of logic
that is just making things worse in the standalone patch set, so even
if we must end up with it they absolutely belong into a series actually
adding functionality, as they have no use on their own.

Independent of that we'll need to clean up the flags mess, so I'd rather
just go ahead with that for now.
