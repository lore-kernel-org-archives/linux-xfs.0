Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3498C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 02:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8EFE205CB
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 02:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgGICpN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 22:45:13 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38224 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbgGICpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 22:45:12 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7BEF63A44F5;
        Thu,  9 Jul 2020 12:45:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtMYc-0002Hm-C3; Thu, 09 Jul 2020 12:45:06 +1000
Date:   Thu, 9 Jul 2020 12:45:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200709024506.GS2005@dread.disaster.area>
References: <20200708125608.155645-1-cmaiolino@redhat.com>
 <20200708125608.155645-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708125608.155645-2-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=JWytsmIsARJNDY1lS84A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 08, 2020 at 02:56:05PM +0200, Carlos Maiolino wrote:
> Use kmem_cache_alloc() directly.
> 
> All kmem_zone_alloc() users pass 0 as flags, which are translated into:
> GFP_KERNEL | __GFP_NOWARN, and kmem_zone_alloc() loops forever until the
> allocation succeeds.
> 
> So, call kmem_cache_alloc() with __GFP_NOFAIL directly. which will have
> the same result.
> 
> Once allocation will never fail, don't bother to add __GFP_NOWARN.

Last two paragraphs are a little odd. Maybe:

We can use __GFP_NOFAIL to tell the allocator to loop forever rather
than doing it ourself, and because the allocation will never fail we
do not need to use __GFP_NOWARN anymore. Hence all callers can be
converted to use GFP_KERNEL | __GFP_NOFAIL.


> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
>  fs/xfs/xfs_icache.c       | 11 +++--------
>  3 files changed, 7 insertions(+), 10 deletions(-)
> 
> @@ -36,14 +36,9 @@ xfs_inode_alloc(
>  {
>  	struct xfs_inode	*ip;
>  
> -	/*
> -	 * if this didn't occur in transactions, we could use
> -	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
> -	 * code up to do this anyway.
> -	 */
> -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> -	if (!ip)
> -		return NULL;
> +	ip = kmem_cache_alloc(xfs_inode_zone,
> +			      GFP_KERNEL | __GFP_NOFAIL);
> +

Hmmmm. We really should check PF_FSTRANS here for the flags we
should be setting. Something like:

	gfp_t		gfp_mask = GFP_KERNEL;

	if (current->flags & PF_FSTRANS)
		gfp_mask |= __GFP_NOFAIL;

	ip = kmem_cache_alloc(xfs_inode_zone, gfp_mask);
	if (!ip)
		return NULL;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
