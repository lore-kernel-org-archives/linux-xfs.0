Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341ADC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 23:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiGKX71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKX70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 19:59:26 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8B61CE21
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 16:59:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2463110E7FE3;
        Tue, 12 Jul 2022 09:59:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oB3JD-00HOTp-5U; Tue, 12 Jul 2022 09:59:23 +1000
Date:   Tue, 12 Jul 2022 09:59:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: grant heads track byte counts, not LSNs
Message-ID: <20220711235923.GI3861211@dread.disaster.area>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-9-david@fromorbit.com>
 <YsvKTBufcBi32z88@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsvKTBufcBi32z88@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62ccb95d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=s2kmWyI5fxoF6XldjTQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 11:59:24PM -0700, Christoph Hellwig wrote:
> On Fri, Jul 08, 2022 at 11:55:58AM +1000, Dave Chinner wrote:
> > +void
> >  xlog_grant_sub_space(
> >  	struct xlog		*log,
> >  	struct xlog_grant_head	*head,
> >  	int			bytes)
> >  {
> > +	atomic64_sub(bytes, &head->grant);
> >  }
> >  
> >  static void
> > @@ -165,93 +144,34 @@ xlog_grant_add_space(
> >  	struct xlog_grant_head	*head,
> >  	int			bytes)
> >  {
> > +	atomic64_add(bytes, &head->grant);
> >  }
> 
> These probably make more senses as inlines and can you can drop their log
> agument as well.  Or maybe just drop these helpers entirely?

I didn't want to make the change even more complex by dropping the
wrappers entirely. They do add some value as code documentation,
and can probably become inlines in the end, but I've been holding
off doing API cleanups because there's much bigger code
restructuring and cleanups needed around this code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
