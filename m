Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A11CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 02:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2805E20738
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 02:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGICz3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 22:55:29 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59271 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbgGICz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 22:55:28 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 59762822524;
        Thu,  9 Jul 2020 12:55:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtMiZ-0002Og-Jj; Thu, 09 Jul 2020 12:55:23 +1000
Date:   Thu, 9 Jul 2020 12:55:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: Remove kmem_zone_zalloc() usage
Message-ID: <20200709025523.GT2005@dread.disaster.area>
References: <20200708125608.155645-1-cmaiolino@redhat.com>
 <20200708125608.155645-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708125608.155645-3-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=wOPP6H8ZxkVRx9LMawUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 08, 2020 at 02:56:06PM +0200, Carlos Maiolino wrote:
> Use kmem_cache_zalloc() directly.
> 
> With the exception of xlog_ticket_alloc() which will be dealt on the
> next patch for readability.
> 
> Most users of kmem_zone_zalloc() were converted to either
> "GFP_KERNEL | __GFP_NOFAIL" or "GFP_NOFS | __GFP_NOFAIL", with the
> exception of _xfs_buf_alloc(), which is allowed to fail, so __GFP_NOFAIL
> is not used there.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    | 3 ++-
>  fs/xfs/libxfs/xfs_bmap.c           | 5 ++++-
>  fs/xfs/libxfs/xfs_bmap_btree.c     | 3 ++-
>  fs/xfs/libxfs/xfs_da_btree.c       | 4 +++-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c     | 6 +++---
>  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
>  fs/xfs/libxfs/xfs_rmap_btree.c     | 2 +-
>  fs/xfs/xfs_bmap_item.c             | 4 ++--
>  fs/xfs/xfs_buf.c                   | 2 +-
>  fs/xfs/xfs_buf_item.c              | 2 +-
>  fs/xfs/xfs_dquot.c                 | 2 +-
>  fs/xfs/xfs_extfree_item.c          | 6 ++++--
>  fs/xfs/xfs_icreate_item.c          | 2 +-
>  fs/xfs/xfs_inode_item.c            | 3 ++-
>  fs/xfs/xfs_refcount_item.c         | 5 +++--
>  fs/xfs/xfs_rmap_item.c             | 6 ++++--
>  fs/xfs/xfs_trans.c                 | 5 +++--
>  fs/xfs/xfs_trans_dquot.c           | 3 ++-
>  19 files changed, 41 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 60c453cb3ee37..9cc1a4af40180 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -484,7 +484,8 @@ xfs_allocbt_init_common(
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone,
> +				GFP_NOFS | __GFP_NOFAIL);

This still fits on one line....

Hmmm - many of the other conversions are similar, but not all of
them. Any particular reason why these are split over multiple lines
and not kept as a single line of code? My preference is that they
are a single line if it doesn't overrun 80 columns....

> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 897749c41f36e..325c0ae2033d8 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -77,11 +77,13 @@ kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
>  /*
>   * Allocate a dir-state structure.
>   * We don't put them on the stack since they're large.
> + *
> + * We can remove this wrapper
>   */
>  xfs_da_state_t *
>  xfs_da_state_alloc(void)
>  {
> -	return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
> +	return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
>  }

Rather than add a comment that everyone will promptly forget about,
add another patch to the end of the patchset that removes the
wrapper.

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 20b748f7e1862..0ccd0a3c840af 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -211,7 +211,7 @@ _xfs_buf_alloc(
>  	int			i;
>  
>  	*bpp = NULL;
> -	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
> +	bp = kmem_cache_zalloc(xfs_buf_zone, GFP_NOFS);
>  	if (unlikely(!bp))
>  		return -ENOMEM;

That's a change of behaviour. The existing call does not set
KM_MAYFAIL so this allocation will never fail, even though the code
is set up to handle a failure. This probably should retain
__GFP_NOFAIL semantics and the -ENOMEM handling removed in this
patch as the failure code path here has most likely never been
tested.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
