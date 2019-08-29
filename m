Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67574C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F3F22339E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:47:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LRAILXXv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfH2IrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:47:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36766 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfH2IrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CuD4SWz0721E0EQB/pRyPaVVUqT7ihD7x00KoJEHSwo=; b=LRAILXXvy58w4brvmkeD/v5XY
        NSKP+mQdibc0vIOGGcoUKAWQUaVTJZpWPAdFYsL0ZDJ6oUMWgyZLk5Vtq7fw+mYasap+6Qwh9YSbE
        eyiguyj5yyfAWqRjV5fbpUFZLNYFUQBT04/gXkW3MUW72eoLKdCBtqW/wU/MqAdOf4KxF9V11QGZW
        7yCWItPksZ3Ica4E/vtwtd6EtcXR6BgrGkFupKvHtCNsjHcnmslPy8hNDcguepoxbn79XBRPiaF2M
        CHfWuybmVaUdnZ9TjGRwlqcb9DSAF9LlWDoCAVr+1E7YVMEgzBQWuvE66rg1LIrXYDn2gEhjHavHD
        YvxErKJoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3G5F-0004vV-V4; Thu, 29 Aug 2019 08:47:09 +0000
Date:   Thu, 29 Aug 2019 01:47:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20190829084709.GA18853@infradead.org>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-5-david@fromorbit.com>
 <20190829081822.GD18195@infradead.org>
 <20190829084530.GP1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829084530.GP1119@dread.disaster.area>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 06:45:30PM +1000, Dave Chinner wrote:
> > 
> > The label rename while more descriptive also seems entirely unrelated.
> 
> That was one of your previous suggestions :)
> 
> I'll push it back up one patch into the cleanup patch and leave this
> as an optimisation only patch.

Oh well.  Just keep it then :)

> > > +		/* Scan the free entry array for a large enough free space. */
> > > +		do {
> > > +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> > > +			    be16_to_cpu(bests[findex]) >= length) {
> > > +				dbno = freehdr.firstdb + findex;
> > > +				goto found_block;
> > >  			}
> > > +		} while (++findex < freehdr.nvalid);
> > 
> > Nit: wou;dn't this be better written as a for loop also taking the
> > initialization of findex into the loop?
> 
> Agreed - the next patch does that with the reversal of the search
> order. The end result is what you're asking for, so I'll leave this
> alone for now....

If you touch this patch anyway please just switch to the for loop
here, that keeps the churn down in the next one.
