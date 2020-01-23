Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBFAC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 726B021D7E
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:40:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TKjBv6ey"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgAWWky (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:40:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbgAWWkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fUs+lhS1C/qDOuRE70YbwcP5aPjMmG2xnHfVryJ/NiQ=; b=TKjBv6eyBr7lLQQFGFndS63V7
        Mh6ho6ulUh83TZqI9D4lAXEL46ackkwdnCykUDbz8jGL74GLGKB96jwI68PP/8Lhlk7WaCzup9kFh
        10J39AY9SJMByAWM3TE6LP48XTW23nulR3WQdMp6Tyzq4KXprLS5gWIeAWQD5z7Th2UdWQxvPEXBF
        SzSrbjewiELHCgTlk441uUaCF0dS6nynN8TCUusvfcCwwaUldBKv21Kb3t6VfBmWwThscjm1Hc5yV
        3NOql8Dmmiv2yfR1iDp02GJUf203UAMPasY5Y9uP3iRsdeHnvcjv7ss7QwgKDVERRo9vRsS+6DBu6
        Eav58fGiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iul9e-0004q3-Jv; Thu, 23 Jan 2020 22:40:50 +0000
Date:   Thu, 23 Jan 2020 14:40:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 14/29] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
Message-ID: <20200123224050.GF2669@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-15-hch@lst.de>
 <20200121181752.GN8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121181752.GN8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 10:17:52AM -0800, Darrick J. Wong wrote:
> > + * If args->value is NULL but args->valuelen is non-zero, allocate the buffer
> > + * for the value after existence of the attribute has been determined. The
> > + * caller always has to free args->value if it is set, no matter if this
> > + * function was successful or not.
> 
> /me wonders if the "null value means alloc buffer internally" (and the
> "zero valuelen means return only the value size") behaviors ought to be
> documented in the struct xfs_da_args definition?

Well, that behavior only exists for attr_get, so documenting it there
make sense, not on the data structure that is used differently for
the set and remove side.
