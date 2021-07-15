Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C9BC636C9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 23:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF86613DA
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 23:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhGOXqH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 19:46:07 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:53525 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229783AbhGOXqH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jul 2021 19:46:07 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 155CC1B127A;
        Fri, 16 Jul 2021 09:43:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m4B0Y-0070Ih-52; Fri, 16 Jul 2021 09:43:10 +1000
Date:   Fri, 16 Jul 2021 09:43:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs: consolidate mount option features in
 m_features
Message-ID: <20210715234310.GH664593@dread.disaster.area>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-7-david@fromorbit.com>
 <YO6MxE1VvDYqCc4s@infradead.org>
 <20210714095507.GZ664593@dread.disaster.area>
 <YO/Otw6P7UhR5B6I@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO/Otw6P7UhR5B6I@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=6vEuCEZc5XIkkFIEHOkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 15, 2021 at 06:59:19AM +0100, Christoph Hellwig wrote:
> On Wed, Jul 14, 2021 at 07:55:07PM +1000, Dave Chinner wrote:
> > > What about using a separate field for these?  With this patch we've used
> > > up all 64-bits in the features field, which isn't exactly the definition
> > > of future proof..
> > 
> > I've used 16 mount option flags and 26 sb feature flags in this
> > patch set, so there's still 22 feature flags remaining before we
> > need to split them. This is all in-memory stuff so it's easy to
> > modify in future. Given that the flag sets are largely set in only
> > one place each and the check functions are all macro-ised, splitting
> > them when we do run out of bits is trivial.
> > 
> > I'm more interested in trying to keep the cache footprint of
> > frequently accessed read-only data down to a minimum right now,
> > which is why I aggregated them in the first place...
> 
> Oh, I missed the hole in the middle.  Still not sure if mixing up mount
> and on-disk flags entirely is something I'm fully comfortable with.  What
> do you think of at least marking the mount options in the name?

Then stuff like the XFS_FEAT_ATTR2 logic doesn't work - the
simplifications that this patchset introduces ends up relying on
both the mount option and the on-disk flag using the same feature
flag to enable creation of ATTR2 features. That becomes more complex
and error prone if we go and separate them back out again.

In reality, how often do you actually care whether a feature was set
by sb bit, mount option, etc, outside of the actual code that
manipulates the feature bit? For me, the answer is almost always
"never".

And that is the whole point of this patchset: the code doing the
feature checking does not care whether a feature is specified by
on-disk flag, mount option, sysctl or sysfs variable.

This change is intended to unify the feature checking under a single
consistent API that has minimal runtime overhead and is independent
of how the feature is managed. Encoded where the feature came from
into the name is a step sideways from the current code, not a step
forwards.

Indeed, what happens when I start adding feature flags for boolean
features that are currently specified by sysfs or proc variables?
e.g: mp->m_always_cow should be a feature flag, not a
boolean variable. This implementation is a third way we specify
mount features, and while these don't fit into either on-disk or mount
flags, they are feature flags that should be brought in under the
unified feature/opstate interfaces.

Hence I don't think encoding whether the feature came from into the
xfs_has_foo() interfaces or the flag names themselves really
provides any benefit. It's not necessary to use the interfaces, and
beyond the code that sets/clears the feature, nobody cares how it
was set/cleared...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
