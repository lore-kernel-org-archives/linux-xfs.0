Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E31ECE58E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 12:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FAE620854
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 12:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfJQMzk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 08:55:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48460 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbfJQMzj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Oct 2019 08:55:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 78097308212D;
        Thu, 17 Oct 2019 12:55:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 22BFB5D6C8;
        Thu, 17 Oct 2019 12:55:39 +0000 (UTC)
Date:   Thu, 17 Oct 2019 08:55:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: use deferred frees to reap old btree blocks
Message-ID: <20191017125537.GE20114@bfoster>
References: <157063971218.2913192.8762913814390092382.stgit@magnolia>
 <157063973378.2913192.158267929318422892.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157063973378.2913192.158267929318422892.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 17 Oct 2019 12:55:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:48:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use deferred frees (EFIs) to reap the blocks of a btree that we just
> replaced.  This helps us to shrink the window in which those old blocks
> could be lost due to a system crash, though we try to flush the EFIs
> every few hundred blocks so that we don't also overflow the transaction
> reservations during and after we commit the new btree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/repair.c |   29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index e21faef6db5a..8349694f985d 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
...
> @@ -565,14 +568,24 @@ xrep_reap_block(
>  		xrep_reap_invalidate_block(sc, fsbno);
>  		error = xrep_put_freelist(sc, agbno);
>  	} else {
> +		/*
> +		 * Use deferred frees to get rid of the old btree blocks to try
> +		 * to minimize the window in which we could crash and lose the
> +		 * old blocks.  However, we still need to roll the transaction
> +		 * every 100 or so EFIs so that we don't exceed the log
> +		 * reservation.
> +		 */
>  		xrep_reap_invalidate_block(sc, fsbno);
> -		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
> +		__xfs_bmap_add_free(sc->tp, fsbno, 1, oinfo, true);

xfs_free_extent() sets skip_discard to false and this changes it to
true. Intentional?

Otherwise the rest looks straightforward.

Brian

> +		(*deferred)++;
> +		need_roll = *deferred > 100;
>  	}
>  	if (agf_bp != sc->sa.agf_bp)
>  		xfs_trans_brelse(sc->tp, agf_bp);
> -	if (error)
> +	if (error || !need_roll)
>  		return error;
>  
> +	*deferred = 0;
>  	if (sc->ip)
>  		return xfs_trans_roll_inode(&sc->tp, sc->ip);
>  	return xrep_roll_ag_trans(sc);
> @@ -594,6 +607,7 @@ xrep_reap_extents(
>  	struct xfs_bitmap_range		*bmr;
>  	struct xfs_bitmap_range		*n;
>  	xfs_fsblock_t			fsbno;
> +	unsigned int			deferred = 0;
>  	int				error = 0;
>  
>  	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
> @@ -605,12 +619,17 @@ xrep_reap_extents(
>  				XFS_FSB_TO_AGNO(sc->mp, fsbno),
>  				XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
>  
> -		error = xrep_reap_block(sc, fsbno, oinfo, type);
> +		error = xrep_reap_block(sc, fsbno, oinfo, type, &deferred);
>  		if (error)
>  			break;
>  	}
>  
> -	return error;
> +	if (error || deferred == 0)
> +		return error;
> +
> +	if (sc->ip)
> +		return xfs_trans_roll_inode(&sc->tp, sc->ip);
> +	return xrep_roll_ag_trans(sc);
>  }
>  
>  /*
> 
