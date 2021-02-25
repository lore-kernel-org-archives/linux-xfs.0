Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CE1C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 20:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE9A60201
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 20:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhBYUsj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 15:48:39 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:41483 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229993AbhBYUsi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 15:48:38 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 52BA2104CD9;
        Fri, 26 Feb 2021 07:47:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFNYB-004Ewj-LN; Fri, 26 Feb 2021 07:47:55 +1100
Date:   Fri, 26 Feb 2021 07:47:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210225204755.GK4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
 <YDdhJ0Oe6R+UXqDU@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDdhJ0Oe6R+UXqDU@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ABxO-cM9r7JnYSn4Z-wA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 09:34:47AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 25, 2021 at 08:44:17AM +1100, Dave Chinner wrote:
> > > Also, do you have any idea what was Christoph talking about wrt devices
> > > with no-op flushes the last time this patch was posted?  This change
> > > seems straightforward to me (assuming the answers to my two question are
> > > 'yes') but I didn't grok what subtlety he was alluding to...?
> > 
> > He was wondering what devices benefited from this. It has no impact
> > on highspeed devices that do not require flushes/FUA (e.g. high end
> > intel optane SSDs) but those are not the devices this change is
> > aimed at. There are no regressions on these high end devices,
> > either, so they are largely irrelevant to the patch and what it
> > targets...
> 
> I don't think it is that simple.  Pretty much every device aimed at
> enterprise use does not enable a volatile write cache by default.  That
> also includes hard drives, arrays and NAND based SSDs.
> 
> Especially for hard drives (or slower arrays) the actual I/O wait might
> matter. 

Sorry, I/O wait might matter for what?

I'm really not sure what you're objecting to - you've hand-waved
about hardware that doesn't need cache flushes twice now and
inferred that they'd be adversely affected by removing cache
flushes. That just doesn't make any sense at all, and I have numbers
to back it up.

You also asked what storage it improved performance on and I told
you and then also pointed out all the software layers that it
massively helps, too, regardless of the physical storage
characteristics.

https://lore.kernel.org/linux-xfs/20210203212013.GV4662@dread.disaster.area/

I have numbers to back it up. You did not reply to me, so I'm not
going to waste time repeating myself here.

> What is the argument against making this conditional?

There is no argument for making this conditional. You've created an
undefined strawman and are demanding that I prove it wrong. If
you've got anything concrete, then tell us about it directly and
provide numbers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
