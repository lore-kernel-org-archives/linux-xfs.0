Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC4BC43334
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 12:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiGGMjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 08:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbiGGMjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 08:39:12 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 324DC2B190
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 05:39:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 407E310E7B07;
        Thu,  7 Jul 2022 22:39:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9Qmj-00FcxX-7f; Thu, 07 Jul 2022 22:39:09 +1000
Date:   Thu, 7 Jul 2022 22:39:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: merge xfs_buf_find() and xfs_buf_get_map()
Message-ID: <20220707123909.GN227878@dread.disaster.area>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-4-david@fromorbit.com>
 <YrwB2JS9oVRh6l0L@infradead.org>
 <YrzM57Xg2LU4pEha@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrzM57Xg2LU4pEha@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62c6d3ee
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=8T-lkysbdweBmo_DCqIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 03:06:31PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 29, 2022 at 12:40:08AM -0700, Christoph Hellwig wrote:
> > >  
> > > -static inline struct xfs_buf *
> > > -xfs_buf_find_fast(
> > > -	struct xfs_perag	*pag,
> > > -	struct xfs_buf_map	*map)
> > > -{
> > > -	struct xfs_buf          *bp;
> > > -
> > > -	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
> > > -	if (!bp)
> > > -		return NULL;
> > > -	atomic_inc(&bp->b_hold);
> > > -	return bp;
> > > -}
> > 
> > > -static int
> > > -xfs_buf_find_insert(
> > > -	struct xfs_buftarg	*btp,
> > > -	struct xfs_perag	*pag,
> > 
> > Adding the function just in the last patch and moving them around
> > here and slighty changing seems a little counter productive.
> > I think just merging the two might actually end up with a result
> > that is easier to review.
> 
> I read the second patch and it makes sense, but I'm also curious if
> hch's suggestion here would make this change easier to read?

I moved the initial placement of these functions around and it took
a big chunk out of the diff in this patch. That should make it
easier to read without combining the two patches together...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
