Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BA3C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D241361358
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbhGNJ6A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 05:58:00 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51003 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238271AbhGNJ6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 05:58:00 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E65681044D3B;
        Wed, 14 Jul 2021 19:55:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3bbf-006OuA-67; Wed, 14 Jul 2021 19:55:07 +1000
Date:   Wed, 14 Jul 2021 19:55:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs: consolidate mount option features in
 m_features
Message-ID: <20210714095507.GZ664593@dread.disaster.area>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-7-david@fromorbit.com>
 <YO6MxE1VvDYqCc4s@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO6MxE1VvDYqCc4s@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=wClFCkC5VGC9JO27ebMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 08:05:40AM +0100, Christoph Hellwig wrote:
> On Wed, Jul 14, 2021 at 02:19:02PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This provides separation of mount time feature flags from runtime
> > mount flags and mount option state. It also makes the feature
> > checks use the same interface as the superblock features. i.e. we
> > don't care if the feature is enabled by superblock flags or mount
> > options, we just care if it's enabled or not.
> 
> What about using a separate field for these?  With this patch we've used
> up all 64-bits in the features field, which isn't exactly the definition
> of future proof..

I've used 16 mount option flags and 26 sb feature flags in this
patch set, so there's still 22 feature flags remaining before we
need to split them. This is all in-memory stuff so it's easy to
modify in future. Given that the flag sets are largely set in only
one place each and the check functions are all macro-ised, splitting
them when we do run out of bits is trivial.

I'm more interested in trying to keep the cache footprint of
frequently accessed read-only data down to a minimum right now,
which is why I aggregated them in the first place...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
