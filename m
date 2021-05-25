Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62487C47086
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 20:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374B9613D2
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 20:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhEYUft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 16:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhEYUfs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 16:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A139861408;
        Tue, 25 May 2021 20:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621974858;
        bh=t1VIuLEgCfNC+XZ8yvuSk+Ve+jzgaP2nyJWP1PUedo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uYKkBmNIFamkrtyLZci3wmR1X28Wbm36YaUo7HtR7FWf6hu1eSRrKAR2iTOn4KWAP
         VF8Ppp0BswiYDad+N+HsDOCNuF32V8sTXuitH01+y3E/N1ts8b6AvOEWtPycRyDbRs
         ui7q8W23Y6nwyJCa05ui6UpMrvEgH+JcuMTKiOIJsuE6SA8b6vx0QV7U7ZE8RraXyo
         V7SNuzG/CshhOdEDO19ce2lcbpYSPcZdvv75CCr0K5V9KyqsnjsYJSn39HDg0VKq/y
         z/6cVDVQcYQE2xgdtu6IJXFryFSK5mSppeKxTng7ySwEUGpQ1oWxWUS2vXbcm+6E81
         NT2m3wYL06e+w==
Date:   Tue, 25 May 2021 13:34:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v19 11/14] xfs: Remove xfs_attr_rmtval_set
Message-ID: <20210525203418.GI202121@locust>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
 <20210525195504.7332-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525195504.7332-12-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 12:55:01PM -0700, Allison Henderson wrote:
> This function is no longer used, so it is safe to remove
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 66 -----------------------------------------
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 -
>  2 files changed, 67 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index ba3b1c8..b5bc50c 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -562,72 +562,6 @@ xfs_attr_rmtval_stale(
>  }
>  
>  /*
> - * Write the value associated with an attribute into the out-of-line buffer
> - * that we have defined for it.
> - */
> -int
> -xfs_attr_rmtval_set(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_inode	*dp = args->dp;
> -	struct xfs_bmbt_irec	map;
> -	xfs_dablk_t		lblkno;
> -	int			blkcnt;
> -	int			nmap;
> -	int			error;
> -
> -	trace_xfs_attr_rmtval_set(args);
> -
> -	error = xfs_attr_rmt_find_hole(args);
> -	if (error)
> -		return error;
> -
> -	blkcnt = args->rmtblkcnt;
> -	lblkno = (xfs_dablk_t)args->rmtblkno;
> -	/*
> -	 * Roll through the "value", allocating blocks on disk as required.
> -	 */
> -	while (blkcnt > 0) {
> -		/*
> -		 * Allocate a single extent, up to the size of the value.
> -		 *
> -		 * Note that we have to consider this a data allocation as we
> -		 * write the remote attribute without logging the contents.
> -		 * Hence we must ensure that we aren't using blocks that are on
> -		 * the busy list so that we don't overwrite blocks which have
> -		 * recently been freed but their transactions are not yet
> -		 * committed to disk. If we overwrite the contents of a busy
> -		 * extent and then crash then the block may not contain the
> -		 * correct metadata after log recovery occurs.
> -		 */
> -		nmap = 1;
> -		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
> -				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
> -				  &nmap);
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -
> -		ASSERT(nmap == 1);
> -		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> -		       (map.br_startblock != HOLESTARTBLOCK));
> -		lblkno += map.br_blockcount;
> -		blkcnt -= map.br_blockcount;
> -
> -		/*
> -		 * Start the next trans in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> -	}
> -
> -	return xfs_attr_rmtval_set_value(args);
> -}
> -
> -/*
>   * Find a hole for the attr and store it in the delayed attr context.  This
>   * initializes the context to roll through allocating an attr extent for a
>   * delayed attr operation
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 8ad68d5..61b85b9 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -9,7 +9,6 @@
>  int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
> -int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> -- 
> 2.7.4
> 
