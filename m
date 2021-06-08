Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321DCC47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 16:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1510B610A2
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 16:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhFHQHB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 12:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFHQG7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 12:06:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5507D61042;
        Tue,  8 Jun 2021 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623168306;
        bh=DnwErfdBhVPvXKrV8jAy5knlNohj+eZJzdMROFqOIjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YYjidluHFF7vUfd60ukVPqVdn8LACv3IpRWn8Txmx/EgihHVAqRR6ZVzFkcAKpFAi
         fK5TsRA3h/bVsozT3445ZMIu/TAa1jRVVb5SCAI4WB6pNAzVVilza8KAUoHBfZgTfn
         lerNtYkrx4TW0pY+SxmbjjlfO8SeD85ftHci0MHKSszGlmKZMlXsF8BmSylBKmbrhC
         aYxSjOX6WCmRqaLj7TwZv95xHyK8CECDgpZu56ozbg23a2epKHHnWvlazqkzicWfj6
         Z4nhJetT1n2fABQO1VAlUYC7lBEpRjBTvvO7Ki26hN9b0vAedPigCC59T7vkPvWe24
         YTkbCeSBTnGDQ==
Date:   Tue, 8 Jun 2021 09:05:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: drop the AGI being passed to xfs_check_agi_freecount
Message-ID: <20210608160505.GT2945738@locust>
References: <20210607041529.392451-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607041529.392451-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 02:15:29PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Stephen Rothwell reported this compiler warning from linux-next:
> 
> fs/xfs/libxfs/xfs_ialloc.c: In function 'xfs_difree_finobt':
> fs/xfs/libxfs/xfs_ialloc.c:2032:20: warning: unused variable 'agi' [-Wunused-variable]
>  2032 |  struct xfs_agi   *agi = agbp->b_addr;
> 
> Which is fallout from agno -> perag conversions that were done in
> this function. xfs_check_agi_freecount() is the only user of "agi"
> in xfs_difree_finobt() now, and it only uses the agi to get the
> current free inode count. We hold that in the perag structure, so
> there's not need to directly reference the raw AGI to get this
> information.
> 
> The btree cursor being passed to xfs_check_agi_freecount() has a
> reference to the perag being operated on, so use that directly in
> xfs_check_agi_freecount() rather than passing an AGI.
> 
> Fixes: 7b13c5155182 ("xfs: use perag for ialloc btree cursors")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 2ed6de6faf8a..654a8d9681e1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -214,10 +214,9 @@ xfs_inobt_insert(
>   * Verify that the number of free inodes in the AGI is correct.
>   */
>  #ifdef DEBUG
> -STATIC int
> +static int
>  xfs_check_agi_freecount(
> -	struct xfs_btree_cur	*cur,
> -	struct xfs_agi		*agi)
> +	struct xfs_btree_cur	*cur)
>  {
>  	if (cur->bc_nlevels == 1) {
>  		xfs_inobt_rec_incore_t rec;
> @@ -243,12 +242,12 @@ xfs_check_agi_freecount(
>  		} while (i == 1);
>  
>  		if (!XFS_FORCED_SHUTDOWN(cur->bc_mp))
> -			ASSERT(freecount == be32_to_cpu(agi->agi_freecount));
> +			ASSERT(freecount == cur->bc_ag.pag->pagi_freecount);
>  	}
>  	return 0;
>  }
>  #else
> -#define xfs_check_agi_freecount(cur, agi)	0
> +#define xfs_check_agi_freecount(cur)	0
>  #endif
>  
>  /*
> @@ -1014,7 +1013,7 @@ xfs_dialloc_ag_inobt(
>  	if (!pagino)
>  		pagino = be32_to_cpu(agi->agi_newino);
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error0;
>  
> @@ -1234,7 +1233,7 @@ xfs_dialloc_ag_inobt(
>  	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
>  	pag->pagi_freecount--;
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error0;
>  
> @@ -1461,7 +1460,7 @@ xfs_dialloc_ag(
>  
>  	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_FINO);
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error_cur;
>  
> @@ -1504,7 +1503,7 @@ xfs_dialloc_ag(
>  	 */
>  	icur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
>  
> -	error = xfs_check_agi_freecount(icur, agi);
> +	error = xfs_check_agi_freecount(icur);
>  	if (error)
>  		goto error_icur;
>  
> @@ -1522,10 +1521,10 @@ xfs_dialloc_ag(
>  
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
>  
> -	error = xfs_check_agi_freecount(icur, agi);
> +	error = xfs_check_agi_freecount(icur);
>  	if (error)
>  		goto error_icur;
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error_icur;
>  
> @@ -1911,7 +1910,7 @@ xfs_difree_inobt(
>  	 */
>  	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error0;
>  
> @@ -2004,7 +2003,7 @@ xfs_difree_inobt(
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
>  	}
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error0;
>  
> @@ -2029,7 +2028,6 @@ xfs_difree_finobt(
>  	xfs_agino_t			agino,
>  	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
>  {
> -	struct xfs_agi			*agi = agbp->b_addr;
>  	struct xfs_btree_cur		*cur;
>  	struct xfs_inobt_rec_incore	rec;
>  	int				offset = agino - ibtrec->ir_startino;
> @@ -2114,7 +2112,7 @@ xfs_difree_finobt(
>  	}
>  
>  out:
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error;
>  
> -- 
> 2.31.1
> 
