Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD1CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 21:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiF2VHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiF2VHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:07:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E509F3FBED
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98EB9B82739
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 21:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467B6C34114;
        Wed, 29 Jun 2022 21:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656536866;
        bh=dDAwo1rTKb/yUcA2KyRY4NY02HIDgZM7HIG6nweV8I0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pHZy9qpbZ3hVRCIF6AkFO0FSmvxLxkU0N06oODcc4oEydQfUxtWUrdAVr0Fdg48nY
         n6UNEAI5M6ehHeWeorzml/4WhqSz1zQ5PT/raMK15py73i/wo+pk8F/KjaxR81Q+1g
         P1XFlDhlrq555AL7W6nzFtv0RiBq7kREdUQcVQ+ew9xH3e2viaP0Xd1qqsDp1n5Ny8
         AgxhDRvfhRmbmw2WaGbi0HyETsKWVlg4UEHsBQ+m+6bwMnDmeVYNAZ1Wj3dOD+XAln
         vTOTda32IyjWramJM4Bqc+6FsXqE+JvZK0wG3KYsuLxj+BlsfUGCVnf2EsewHLKEW+
         G1cBGELav4xxA==
Date:   Wed, 29 Jun 2022 14:07:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: combine iunlink inode update functions
Message-ID: <Yry/IfVbJQcf8Has@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:34AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Combine the logging of the inode unlink list update into the
> calling function that looks up the buffer we end up logging. These
> do not need to be separate functions as they are both short, simple
> operations and there's only a single call path through them. This
> new function will end up being the core of the iunlink log item
> processing...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 52 ++++++++++++++--------------------------------
>  1 file changed, 16 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8d4edb8129b5..d6c88a27f29d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1923,38 +1923,9 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> -/* Set an on-disk inode's next_unlinked pointer. */
> -STATIC void
> -xfs_iunlink_update_dinode(
> -	struct xfs_trans	*tp,
> -	struct xfs_perag	*pag,
> -	xfs_agino_t		agino,
> -	struct xfs_buf		*ibp,
> -	struct xfs_dinode	*dip,
> -	struct xfs_imap		*imap,
> -	xfs_agino_t		next_agino)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	int			offset;
> -
> -	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino));
> -
> -	trace_xfs_iunlink_update_dinode(mp, pag->pag_agno, agino,
> -			be32_to_cpu(dip->di_next_unlinked), next_agino);
> -
> -	dip->di_next_unlinked = cpu_to_be32(next_agino);
> -	offset = imap->im_boffset +
> -			offsetof(struct xfs_dinode, di_next_unlinked);
> -
> -	/* need to recalc the inode CRC if appropriate */
> -	xfs_dinode_calc_crc(mp, dip);
> -	xfs_trans_inode_buf(tp, ibp);
> -	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> -}
> -
>  /* Set an in-core inode's unlinked pointer and return the old value. */
>  static int
> -xfs_iunlink_update_inode(
> +xfs_iunlink_log_inode(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	struct xfs_perag	*pag,
> @@ -1964,6 +1935,7 @@ xfs_iunlink_update_inode(
>  	struct xfs_dinode	*dip;
>  	struct xfs_buf		*ibp;
>  	xfs_agino_t		old_value;
> +	int			offset;
>  	int			error;
>  
>  	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino));
> @@ -1997,9 +1969,17 @@ xfs_iunlink_update_inode(
>  		goto out;
>  	}
>  
> -	/* Ok, update the new pointer. */
> -	xfs_iunlink_update_dinode(tp, pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			ibp, dip, &ip->i_imap, next_agino);
> +	trace_xfs_iunlink_update_dinode(mp, pag->pag_agno,
> +			XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			be32_to_cpu(dip->di_next_unlinked), next_agino);
> +
> +	dip->di_next_unlinked = cpu_to_be32(next_agino);
> +	offset = ip->i_imap.im_boffset +
> +			offsetof(struct xfs_dinode, di_next_unlinked);
> +
> +	xfs_dinode_calc_crc(mp, dip);
> +	xfs_trans_inode_buf(tp, ibp);
> +	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
>  	return 0;
>  out:
>  	xfs_trans_brelse(tp, ibp);
> @@ -2045,7 +2025,7 @@ xfs_iunlink_insert_inode(
>  		 * There is already another inode in the bucket, so point this
>  		 * inode to the current head of the list.
>  		 */
> -		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino);
> +		error = xfs_iunlink_log_inode(tp, ip, pag, next_agino);
>  		if (error)
>  			return error;
>  		ip->i_next_unlinked = next_agino;
> @@ -2119,7 +2099,7 @@ xfs_iunlink_remove_inode(
>  	 * the old pointer value so that we can update whatever was previous
>  	 * to us in the list to point to whatever was next in the list.
>  	 */
> -	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO);
> +	error = xfs_iunlink_log_inode(tp, ip, pag, NULLAGINO);
>  	if (error)
>  		return error;
>  
> @@ -2139,7 +2119,7 @@ xfs_iunlink_remove_inode(
>  		if (!prev_ip)
>  			return -EFSCORRUPTED;
>  
> -		error = xfs_iunlink_update_inode(tp, prev_ip, pag,
> +		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
>  				ip->i_next_unlinked);
>  		prev_ip->i_next_unlinked = ip->i_next_unlinked;
>  	} else {
> -- 
> 2.36.1
> 
