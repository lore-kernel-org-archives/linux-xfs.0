Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF13C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 03:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E4F920738
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 03:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGIDAU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 23:00:20 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:45932 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgGIDAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 23:00:20 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id B3E6010C4C4;
        Thu,  9 Jul 2020 13:00:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtMn6-0002Rb-WA; Thu, 09 Jul 2020 13:00:05 +1000
Date:   Thu, 9 Jul 2020 13:00:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: Modify xlog_ticket_alloc() to use kernel's MM
 API
Message-ID: <20200709030004.GU2005@dread.disaster.area>
References: <20200708125608.155645-1-cmaiolino@redhat.com>
 <20200708125608.155645-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708125608.155645-4-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=xdQltp5hqO32v8DZUikA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 08, 2020 at 02:56:07PM +0200, Carlos Maiolino wrote:
> change xlog_ticket_alloc() to use default kmem_cache_zalloc(), and
> modify its callers to pass MM flags as arguments.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 7 ++++---
>  fs/xfs/xfs_log_cil.c  | 2 +-
>  fs/xfs/xfs_log_priv.h | 2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00fda2e8e7380..6d40d479e34a1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -433,7 +433,8 @@ xfs_log_reserve(
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
> +				(GFP_KERNEL | __GFP_NOFAIL));
>  	*ticp = tic;

xfs_log_reserve() is called either from transaction reservation
which is under memalloc_nofs context, or from the CIL with explicit
GFP_NOFS, or from the unmount path which is GFP_KERNEL but is
holding various filesystem locks.

I suspect that this patch should just remove the gfp flags from
xlog_ticket_alloc() and just unconditionally use GFP_NOFS |
__GFP_NOFAIL fo allocating the ticket. That would clean this up
quite a bit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
