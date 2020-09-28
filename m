Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7595CC2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 04:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3627A23998
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 04:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgI1Emf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 00:42:35 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40176 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725290AbgI1Emf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 00:42:35 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4D9E23A858D;
        Mon, 28 Sep 2020 14:42:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kMkzX-0004c8-VL; Mon, 28 Sep 2020 14:42:23 +1000
Date:   Mon, 28 Sep 2020 14:42:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Subject: Re: [PATCH 1/4] xfs: remove xfs_defer_reset
Message-ID: <20200928044223.GC14422@dread.disaster.area>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
 <160125007449.174438.15988765709988942671.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160125007449.174438.15988765709988942671.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=gld600zghi3yMcdeFe4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 27, 2020 at 04:41:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove this one-line helper.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c |   24 +++++-------------------
>  1 file changed, 5 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 29e9762f3b77..36c103c14bc9 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -312,22 +312,6 @@ xfs_defer_trans_roll(
>  	return error;
>  }
>  
> -/*
> - * Reset an already used dfops after finish.
> - */
> -static void
> -xfs_defer_reset(
> -	struct xfs_trans	*tp)
> -{
> -	ASSERT(list_empty(&tp->t_dfops));
> -
> -	/*
> -	 * Low mode state transfers across transaction rolls to mirror dfops
> -	 * lifetime. Clear it now that dfops is reset.
> -	 */
> -	tp->t_flags &= ~XFS_TRANS_LOWMODE;
> -}
> -
>  /*
>   * Free up any items left in the list.
>   */
> @@ -477,7 +461,10 @@ xfs_defer_finish(
>  			return error;
>  		}
>  	}
> -	xfs_defer_reset(*tp);
> +
> +	/* Reset LOWMODE now that we've finished all the dfops. */
> +	ASSERT(list_empty(&(*tp)->t_dfops));
> +	(*tp)->t_flags &= ~XFS_TRANS_LOWMODE;
>  	return 0;
>  }
>  
> @@ -551,8 +538,7 @@ xfs_defer_move(
>  	 * that behavior.
>  	 */
>  	dtp->t_flags |= (stp->t_flags & XFS_TRANS_LOWMODE);
> -
> -	xfs_defer_reset(stp);
> +	stp->t_flags &= ~XFS_TRANS_LOWMODE;
>  }
>  
>  /*

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
