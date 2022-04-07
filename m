Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D921C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbiDGBdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242171AbiDGBcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F2458396
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7AD1612A4
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DF5C385A3;
        Thu,  7 Apr 2022 01:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294994;
        bh=gDkj8M6pnHCNOud3lvXyKg46pW7yyImFzSmZgItEm30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rb6xfP1YA73FytdZ5177tA0iALlktr0cEcnE9rTC976BXm4Wqd2pLwsafBiuvxt9k
         1klZ1IE33sGKPIux8y2f2bzyuToZSdDodnsreCRmRgNBCt3EbTJ0iyglUIMwaCHdoH
         OTRlSk+IxL+Oe1BQXpBd1DuqF/9qjm6VMZz6Cx7wD/AdtgAE9IzV/q+TS9V7NVgjFG
         QAZntBWO/V+t3v3XeH5A2NctsKcoA8eKqJRSEP/euVMqgVZeQjiQMbc2DIkV1/POT1
         TO+LajMZaZJ8TX+GiT6iMuYp0eI42qznmpLkZTxC4OrzEU1KWD1phBgl8aWKDiAn+b
         gDjhzo2OtcF4w==
Date:   Wed, 6 Apr 2022 18:29:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V9 17/19] xfs: Decouple XFS_IBULK flags from XFS_IWALK
 flags
Message-ID: <20220407012953.GU27690@magnolia>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-18-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-18-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 11:49:01AM +0530, Chandan Babu R wrote:
> A future commit will add a new XFS_IBULK flag which will not have a
> corresponding XFS_IWALK flag. In preparation for the change, this commit
> separates XFS_IBULK_* flags from XFS_IWALK_* flags.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good to me now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_itable.c | 6 +++++-
>  fs/xfs/xfs_itable.h | 2 +-
>  fs/xfs/xfs_iwalk.h  | 2 +-
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index c08c79d9e311..71ed4905f206 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -256,6 +256,7 @@ xfs_bulkstat(
>  		.breq		= breq,
>  	};
>  	struct xfs_trans	*tp;
> +	unsigned int		iwalk_flags = 0;
>  	int			error;
>  
>  	if (breq->mnt_userns != &init_user_ns) {
> @@ -279,7 +280,10 @@ xfs_bulkstat(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
> +	if (breq->flags & XFS_IBULK_SAME_AG)
> +		iwalk_flags |= XFS_IWALK_SAME_AG;
> +
> +	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>  	xfs_trans_cancel(tp);
>  out:
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 7078d10c9b12..2cf3872fcd2f 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -17,7 +17,7 @@ struct xfs_ibulk {
>  };
>  
>  /* Only iterate within the same AG as startino */
> -#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
> +#define XFS_IBULK_SAME_AG	(1 << 0)
>  
>  /*
>   * Advance the user buffer pointer by one record of the given size.  If the
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> index 37a795f03267..3a68766fd909 100644
> --- a/fs/xfs/xfs_iwalk.h
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -26,7 +26,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>  		unsigned int inode_records, bool poll, void *data);
>  
>  /* Only iterate inodes within the same AG as @startino. */
> -#define XFS_IWALK_SAME_AG	(0x1)
> +#define XFS_IWALK_SAME_AG	(1 << 0)
>  
>  #define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
>  
> -- 
> 2.30.2
> 
