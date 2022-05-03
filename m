Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA806C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 21:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiECVbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 17:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiECVbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 17:31:09 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71D792AE01
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 14:27:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 99EE110E6198;
        Wed,  4 May 2022 07:27:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm03S-007fTQ-6v; Wed, 04 May 2022 07:27:34 +1000
Date:   Wed, 4 May 2022 07:27:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: detect self referencing btree sibling pointers
Message-ID: <20220503212734.GB1098723@dread.disaster.area>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-2-david@fromorbit.com>
 <YnFB+Ff+gRh0vQbb@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnFB+Ff+gRh0vQbb@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62719e47
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=e4CzIaq9dZG77jKYzP8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 07:53:45AM -0700, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> One nit (with a few instances):
> 
> > +	if (level >= 0) {
> > +		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
> > +			return __this_address;
> > +	} else if (!xfs_verify_fsbno(mp, sibling)) {
> > +		return __this_address;
> > +	}
> 
> Maybe it's just me, but I would find the non-condensed version a little
> easier to read for these kinds of checks:
> 
> 	if (level >= 0) {
> 		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
> 			return __this_address;
> 	} else {
> 		if (!xfs_verify_fsbno(mp, sibling))
> 			return __this_address;
> 	}

Ok, I can do that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
