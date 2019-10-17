Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE37FA372A
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 12:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D21E20854
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 12:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfJQMzP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 08:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbfJQMzO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Oct 2019 08:55:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 29966307D985;
        Thu, 17 Oct 2019 12:55:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4A175C1B5;
        Thu, 17 Oct 2019 12:55:13 +0000 (UTC)
Date:   Thu, 17 Oct 2019 08:55:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: only invalidate blocks if we're going to free
 them
Message-ID: <20191017125512.GD20114@bfoster>
References: <157063971218.2913192.8762913814390092382.stgit@magnolia>
 <157063972723.2913192.12835516373692425243.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157063972723.2913192.12835516373692425243.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 17 Oct 2019 12:55:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:48:47AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're discarding old btree blocks after a repair, only invalidate
> the buffers for the ones that we're freeing -- if the metadata was
> crosslinked with another data structure, we don't want to touch it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/repair.c |   76 +++++++++++++++++++++++--------------------------
>  fs/xfs/scrub/repair.h |    1 -
>  2 files changed, 35 insertions(+), 42 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 3a58788e0bd8..e21faef6db5a 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
...
> @@ -515,6 +477,35 @@ xrep_put_freelist(
>  	return 0;
>  }
>  
> +/* Try to invalidate the incore buffer for a block that we're about to free. */
> +STATIC void
> +xrep_reap_invalidate_block(
> +	struct xfs_scrub	*sc,
> +	xfs_fsblock_t		fsbno)
> +{
> +	struct xfs_buf		*bp;
> +
> +	/*
> +	 * For each block in each extent, see if there's an incore buffer for
> +	 * exactly that block; if so, invalidate it.  The buffer cache only
> +	 * lets us look for one buffer at a time, so we have to look one block
> +	 * at a time.  Avoid invalidating AG headers and post-EOFS blocks
> +	 * because we never own those; and if we can't TRYLOCK the buffer we
> +	 * assume it's owned by someone else.
> +	 */
> +	/* Skip AG headers and post-EOFS blocks */

The comment doesn't seem to quite go with the implementation any longer.
Also, there's probably no need to have two separate comments here.
Otherwise looks Ok.

Brian

> +	if (!xfs_verify_fsbno(sc->mp, fsbno))
> +		return;
> +	bp = xfs_buf_incore(sc->mp->m_ddev_targp,
> +			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> +			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
> +	if (!bp)
> +		return;
> +
> +	xfs_trans_bjoin(sc->tp, bp);
> +	xfs_trans_binval(sc->tp, bp);
> +}
> +
>  /* Dispose of a single block. */
>  STATIC int
>  xrep_reap_block(
> @@ -568,12 +559,15 @@ xrep_reap_block(
>  	 * blow on writeout, the filesystem will shut down, and the admin gets
>  	 * to run xfs_repair.
>  	 */
> -	if (has_other_rmap)
> +	if (has_other_rmap) {
>  		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
> -	else if (resv == XFS_AG_RESV_AGFL)
> +	} else if (resv == XFS_AG_RESV_AGFL) {
> +		xrep_reap_invalidate_block(sc, fsbno);
>  		error = xrep_put_freelist(sc, agbno);
> -	else
> +	} else {
> +		xrep_reap_invalidate_block(sc, fsbno);
>  		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
> +	}
>  	if (agf_bp != sc->sa.agf_bp)
>  		xfs_trans_brelse(sc->tp, agf_bp);
>  	if (error)
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 60c61d7052a8..eab41928990f 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -31,7 +31,6 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
>  struct xfs_bitmap;
>  
>  int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
> -int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xfs_bitmap *btlist);
>  int xrep_reap_extents(struct xfs_scrub *sc, struct xfs_bitmap *exlist,
>  		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
>  
> 
