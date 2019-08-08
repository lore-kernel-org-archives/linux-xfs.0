Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outbound-smtp24.blacknight.com ([81.17.249.192]:51895 "EHLO
        outbound-smtp24.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404172AbfHHREk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 13:04:40 -0400
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp24.blacknight.com (Postfix) with ESMTPS id 635CFB8855
        for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2019 18:04:39 +0100 (IST)
Date: Thu, 8 Aug 2019 18:04:37 +0100
From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190808170437.GL2739@techsingularity.net>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
 <20190807150316.GL2708@suse.de>
 <20190807205615.GI2739@techsingularity.net>
 <20190808153658.GA26893@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20190808153658.GA26893@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>

On Thu, Aug 08, 2019 at 08:36:58AM -0700, Christoph Hellwig wrote:
> > -			if (sc->may_shrinkslab) {
> > -				shrink_slab(sc->gfp_mask, pgdat->node_id,
> > -				    memcg, sc->priority);
> > -			}
> > +			shrink_slab(sc->gfp_mask, pgdat->node_id,
> > +			    memcg, sc->priority);
> 
> Not the most useful comment, but the indentation for the continuing line
> is weird (already in the original code).  This should be something like:
> 
> 			shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
> 					sc->priority);

If that's the worst you found then I take it as good news. I have not
sent a version with an updated changelog so I can fix it up.

-- 
Mel Gorman
SUSE Labs
