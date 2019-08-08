Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbfHHPhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 11:37:00 -0400
Date: Thu, 8 Aug 2019 08:36:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190808153658.GA26893@infradead.org>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
 <20190807150316.GL2708@suse.de>
 <20190807205615.GI2739@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807205615.GI2739@techsingularity.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>

> -			if (sc->may_shrinkslab) {
> -				shrink_slab(sc->gfp_mask, pgdat->node_id,
> -				    memcg, sc->priority);
> -			}
> +			shrink_slab(sc->gfp_mask, pgdat->node_id,
> +			    memcg, sc->priority);

Not the most useful comment, but the indentation for the continuing line
is weird (already in the original code).  This should be something like:

			shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
					sc->priority);
