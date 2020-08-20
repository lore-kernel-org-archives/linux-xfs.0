Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4770C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 22:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC86207DA
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 22:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgHTWrr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 18:47:47 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:52753 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728587AbgHTWr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 18:47:29 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 2287DD7C8A7;
        Fri, 21 Aug 2020 08:47:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8tL5-0007Sh-2s; Fri, 21 Aug 2020 08:47:19 +1000
Date:   Fri, 21 Aug 2020 08:47:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200820224719.GD7941@dread.disaster.area>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia>
 <20200818233535.GD21744@dread.disaster.area>
 <20200819214322.GE6096@magnolia>
 <20200820000102.GF6096@magnolia>
 <CAOQ4uxiinUPDB6K=cZ=4h1hwzOefoLgCR8pF3B+cn3u0HTWj0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiinUPDB6K=cZ=4h1hwzOefoLgCR8pF3B+cn3u0HTWj0A@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=wgvxBlqqQ1Wnds_m4O4A:9 a=WTQvOBvpGdEmkXy-:21 a=BoBosQtKaBKmlGP6:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 08:11:27AM +0300, Amir Goldstein wrote:
> On Thu, Aug 20, 2020 at 3:03 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Wed, Aug 19, 2020 at 02:43:22PM -0700, Darrick J. Wong wrote:
> > So... while we could get rid of the union and hand-decode the timestamp
> > from a __be64 on legacy filesystems, I see the static checker complaints
> > as a second piece of evidence that this would be unnecessarily risky.
> >
> 
> And unnecessarily make the code less readable and harder to review.
> To what end? Dave writes:
> "I just didn't really like the way the code in the encode/decode
> helpers turned out..."
> 
> Cannot respond to that argument on a technical review.

Sure you can.

I gave a possible alternative implementation in my review, Darrick
pointed out it has problems and asked why I suggested a different
implementation. My answer was simply "I didn't really like the code,
maybe it could be done differently".

That's perfectly normal. If you -don't like the way the code is
written- then that should be a part of the review feedback. If
there's no other alternative to the way the code was presented, then
the reviewer is just going to have to live with it. That's perfectly
acceptible.

> I can only say that as a reviewer, the posted version was clear and easy
> for me to verify

Which is your personal opinion. Opinions differ and, again, there's
nothing wrong with that.

But you're stating that you don't want reviewers to express an
opinion on how the code looks because you "cannot respond to that on
a technical review". That's kind of naive - when was the last time
you asked someone to reformat the code because you found it was hard
to read?

We've always considered how the code looks as a key metric in
determining if the code will be maintainable. Why else would we care
about macro nesting, typedefs, keeping functions short and concise,
etc? That's all about how the code looks and how easy it is to read,
and hence we can infer the cost of maintainability of the code bein
proposed from that. That's all technical analysis of the code being
proposed, and it's all subjective.

See what I'm getting at here? Comments about the *look* of the code
is valid technical feedback, and we can argue *technically* at
length about whether the code is structured the best way it could be
done. And we often do this at length just because someone simply
"doesn't like the way the proposed code currently looks"...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
