Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848C8C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 23:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355131AbiFUXEV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 19:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354327AbiFUXES (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jun 2022 19:04:18 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A44633341
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jun 2022 16:04:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1C21510E8BE0;
        Wed, 22 Jun 2022 09:04:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o3mus-009TwV-Eu; Wed, 22 Jun 2022 09:04:14 +1000
Date:   Wed, 22 Jun 2022 09:04:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] xfs_repair: Use xfs_extnum_t instead of basic data types
Message-ID: <20220621230414.GS227878@dread.disaster.area>
References: <20220621065010.666439-1-chandan.babu@oracle.com>
 <990cd4b5-28c4-770b-6869-7218faf4c685@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <990cd4b5-28c4-770b-6869-7218faf4c685@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b24e70
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=5tjSwGpEgLYejASABdkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 21, 2022 at 05:23:46PM -0500, Eric Sandeen wrote:
> On 6/21/22 1:50 AM, Chandan Babu R wrote:
> > xfs_extnum_t is the type to use to declare variables whose values have been
> > obtained from per-inode extent counters. This commit replaces using basic
> > types (e.g. uint64_t) with xfs_extnum_t when declaring such variables.
> > 
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> 
> Thanks Chandan - I had rolled something like this into the merge of kernel
> "xfs: Use xfs_extnum_t instead of basic data types"
> because it seemed like it should maybe all be done at once.
> 
> And the tree Dave has already had (some of) these type changes in db/ and
> repair/dinode.c as part of that patch.
> 
> On top of that, I added a lot more of these conversions, i.e. to
> bmap(), bmap_one_extent(), and make_bbmap() in db/bmap.c, 
> process_bmbt_reclist() in db/check.c, fa_cfileoffd() and
> fa_dfiloffd() in db/faddr.c ... perhaps I should send you my net diff
> on top of the tree dchinner assembled, and you can see what you think?

Just merge what we've already got, then do an audit to check for
anything that is missing and then commit them.

> But at the highest level, does it make more sense to convert everything
> in the utilities at the same time as "xfs: Use xfs_extnum_t instead of
> basic data types" is applied to xfsprogs libxfs/ or would separate patches
> be better?

So long as it is converted before the release point it doesn't
matter. We don't have extent counts of > 2*32 out in the wild yet,
so as long as the conversions are all sorted by the time 5.19 is
done then it just doesn't matter how many commits it takes because
users won't be using the dev tree to repair filesystems with extent
counts that could overflow a 32 bit counter....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
