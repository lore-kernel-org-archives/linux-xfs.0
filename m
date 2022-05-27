Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7671C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 01:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiE0BLG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 21:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiE0BLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 21:11:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7EF8EAD2E
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 18:11:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 69C4552C1A6;
        Fri, 27 May 2022 11:11:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuOVI-00Gpmr-Uu; Fri, 27 May 2022 11:11:00 +1000
Date:   Fri, 27 May 2022 11:11:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfsprogs: autoconf modernisation
Message-ID: <20220527011100.GK1098723@dread.disaster.area>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-5-david@fromorbit.com>
 <393627ac-be5e-276b-65fb-6701679b958c@sandeen.net>
 <418a926d-fcc9-c5f0-1693-6392aaaa4618@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <418a926d-fcc9-c5f0-1693-6392aaaa4618@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62902527
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=CGbfGGxFuVefUj4tXRcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 02:44:54PM -0500, Eric Sandeen wrote:
> On 5/26/22 1:49 PM, Eric Sandeen wrote:
> >> Also, running autoupdate forces the minimum pre-req to be autoconf
> >> 2.71 because it replaces other stuff...
> > Bleah, to that part.  2.71 isn't even available on Fedora Core 35 which
> > was released 6 months ago.
> > I'm afraid this will break lots of builds in not-very-old environments.
> > 
> > I'm inclined to look into whether I can just replace the obsolete
> > macros to shut up the warnings for now, does that seem reasonable?
> > 
> > And then bumping the 2.50 minimum to the 8-year-old 2.69 is probably wise ;)
> > 
> > Thanks,
> > -Eric
> 
> Actually, I think that 2.71 from autoupdate is gratuitous, all your changes
> seem fine under the (ancient) 2.69.
> 
> So I'm inclined to merge this patch as is, but with a 2.69 minimum, as the
> current 2.50 version requirement is for something released around the turn
> of the century...
> 
> Any concerns or complaints?

Not from me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
