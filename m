Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA79DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 21:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238792AbiECV3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 17:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiECV3z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 17:29:55 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C9902AE01
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 14:26:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A7E8D10E61EB;
        Wed,  4 May 2022 07:26:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm02F-007fSe-1j; Wed, 04 May 2022 07:26:19 +1000
Date:   Wed, 4 May 2022 07:26:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: validate v5 feature fields
Message-ID: <20220503212619.GA1098723@dread.disaster.area>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-5-david@fromorbit.com>
 <YnFDoMfAM9Ofls6f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnFDoMfAM9Ofls6f@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62719dfc
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=aOwNTqsQtImvZpe7GKwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 08:00:48AM -0700, Christoph Hellwig wrote:
> > +	/* Now check all the required V4 feature flags are set. */
> 
> V5?

It's checking the required v4 feature flags for v5 filesystems are
set. I'll clarify it on commit, something like:

/*
 * Check that all the V4 feature flags that V5 filesystems
 * require are correctly set.
 */

> Otherwise this looks good modulo the buildbot warning about the missing
> static.  A more verbose and decriptive commit log would be nice, though.

*nod*. I was just pissed off at having to waste an entire day on
unplanned fuzzer whack-a-mole for yet more "cannot happen in the
real world without malicious tampering" issues.

This one was caused by a fuzzer setting the version number to 5 and
then clearing the dirv2 bit and recalculating the CRC causing the
xfs_da_mount() to fire an assert that the dirv2 bit wasn't set. The
other fuzzed filesystems also had other v4 features bits cleared.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
