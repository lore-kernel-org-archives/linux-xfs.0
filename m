Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C92C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E18220663
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:09:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X8vERt8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgCLOJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:09:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbgCLOJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xG8k+cj0HyOKJ3dVwJjBxlPrglTQrOM4WetThaisAQo=; b=X8vERt8CcAXVTP1rsV3quKC33E
        /VLI/TBEZrl3nj7/dsnBs5BSeET4XL5KboqVRuHSrE5ux3g9aCgZm9wFSPPAcQqsIUhP71LYj/rRm
        8heILUhFe2xwASEW0jAzLO2zSOW7RUL8JyUMPblV5tPcm5oj7Ke3tnav+MYZx23rE8lvk8c3+hGCu
        3X+6MlFKqmXLU9t7msERr74HUutb35M3oi4+j3xfBijP27Ng8Eszf2ulql5Eoec05lgppbTSmlkPj
        T/jLzTHbHXN91R9lM8/Wz3lvt39Xr3kIUwnWFaZqpLAKGWFfhDCDHCe/lMOpG6/8Cn1J1KcOJAr2X
        DKjb1leQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOWM-0006S0-AN; Thu, 12 Mar 2020 14:09:10 +0000
Date:   Thu, 12 Mar 2020 07:09:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
Message-ID: <20200312140910.GA11758@infradead.org>
References: <20191216215245.13666-1-david@fromorbit.com>
 <20200126110212.GA23829@infradead.org>
 <029fa407-6bf5-c8c0-450a-25bded280fec@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029fa407-6bf5-c8c0-450a-25bded280fec@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 27, 2020 at 11:43:02AM -0600, Eric Sandeen wrote:
> On 1/26/20 5:02 AM, Christoph Hellwig wrote:
> > Eric, can you pick this one up?  The warnings are fairly annoying..
> > 
> 
> Sorry, I had missed this one and/or the feedback on the original patch
> wasn't resolved.  I tend to agree that turning off the warning globally
> because we know /this/ one is OK seems somewhat suboptimal.
> 
> Let me take a look again.

Can we get this queued up in xfsprogs?  These warnings are pretty
annoying..
