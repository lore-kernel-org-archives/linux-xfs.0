Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E59C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92FE32075B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YinFMawU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgH0IPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgH0IP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:15:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB2EC061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZEUn/0ov4W/ACnlCqTOHP4s7oQVUAub65OSz6mEd5rM=; b=YinFMawUMVS8IBOxU4V91n1WJq
        Lm2SQlFX5jaJrWiKeTCRu4akqjCQtcHFRMUMVV0OT9S3jJg1UHx4IFGexHYaVGUexrkCAafq4AAh9
        l8hqbdwIMhGdueOb0y1YOsSN6fBdovQ2yt64N0KqODxBV/Y+kb0gGuUxqNmdK7Y2fcVErbSqP4Q3l
        alfhphV8iA4Jl+GYR20yhyRB1fvgUEDgAOt18WcZnbzkkoqf8/zkqHUOGuaovJFAj0oThW0X6pfya
        lVYVaQpbCJglHzQpqW+BJZ66uL/mK4P43p0kZTTIpZ9Mcacfki5Op6/QZjHYFd+7KyX3X7y89Q/RD
        y7Bd8NdQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBD4A-0002So-LF; Thu, 27 Aug 2020 08:15:26 +0000
Date:   Thu, 27 Aug 2020 09:15:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: "signed < sizeof()" bug in xfs_attr_shortform_verify() ?
Message-ID: <20200827081526.GE7605@infradead.org>
References: <20200825211048.GA2162993@localhost.localdomain>
 <20200825221842.GR6107@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825221842.GR6107@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 03:18:42PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 26, 2020 at 12:10:48AM +0300, Alexey Dobriyan wrote:
> > xfs_attr_shortform_verify() contains the following code:
> > 
> > 
> > 	int64_t size = ifp->if_bytes;
> >         /*
> >          * Give up if the attribute is way too short.
> >          */
> >         if (size < sizeof(struct xfs_attr_sf_hdr))
> >                 return __this_address;
> > 
> > 
> > In general "if (signed < sizeof())" is wrong because of how type
> > promotions work. Such check won't catch small negative values.
> > 
> > I don't know XFS well enough to know if negative values were excluded
> > somewhere above the callchain, but maybe someone else does.
> 
> The initial allocations are always positive and the subsequent
> xfs_idata_realloc are checked to prevent if_bytes from going negative,
> but it does seem funny to me that if_bytes is declared int64_t...

Yes, the int64_t is weird.  IIRC the signednes was done to simplify
some arithmertics in the reallocation case, but that shouldn't really
leak out..
