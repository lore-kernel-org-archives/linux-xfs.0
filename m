Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CACC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EACF921D81
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgLGRrm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:47:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbgLGRrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607363175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kaHzjfcsTQANMgxi0xEgMXhHnvjpWEttEY6IQ3GkpoM=;
        b=Jwe7zsEY39WW+7/REXLO0jkfdDgOsn45I9SrIhsGPkUS8DtR/beScDrXLBuFase6qN8Wsy
        ZfuwMgPGvlDsEYvVJgs4vcdRiI753U+I9ypFKvX/FcJY+Pr5IXln9iH+1qOMWd+9cvWE2b
        zb6R/VuuHFg1ri7+cL8at4x/k2D9yfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-Ek7IbgtlMWqwH1Usn_z--g-1; Mon, 07 Dec 2020 12:46:10 -0500
X-MC-Unique: Ek7IbgtlMWqwH1Usn_z--g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 829C11842141;
        Mon,  7 Dec 2020 17:46:09 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EB7B5D6AB;
        Mon,  7 Dec 2020 17:46:08 +0000 (UTC)
Date:   Mon, 7 Dec 2020 12:46:07 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: refactor data device extent validation
Message-ID: <20201207174607.GB1598552@bfoster>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729625702.1608297.4480089333393399990.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729625702.1608297.4480089333393399990.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:10:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the open-coded validation of non-static data device extents
> into a single helper.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c   |    8 ++------
>  fs/xfs/libxfs/xfs_types.c  |   23 +++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_types.h  |    2 ++
>  fs/xfs/scrub/bmap.c        |    5 +----
>  fs/xfs/xfs_bmap_item.c     |   11 +----------
>  fs/xfs/xfs_extfree_item.c  |   11 +----------
>  fs/xfs/xfs_refcount_item.c |   11 +----------
>  fs/xfs/xfs_rmap_item.c     |   11 +----------
>  8 files changed, 32 insertions(+), 50 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index de9c27ef68d8..7f1b6ad570a9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6242,12 +6242,8 @@ xfs_bmap_validate_extent(
>  		if (!xfs_verify_rtbno(mp, endfsb))
>  			return __this_address;
>  	} else {
> -		if (!xfs_verify_fsbno(mp, irec->br_startblock))
> -			return __this_address;
> -		if (!xfs_verify_fsbno(mp, endfsb))
> -			return __this_address;
> -		if (XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
> -		    XFS_FSB_TO_AGNO(mp, endfsb))
> +		if (!xfs_verify_fsbext(mp, irec->br_startblock,
> +					   irec->br_blockcount))
>  			return __this_address;
>  	}
>  	if (irec->br_state != XFS_EXT_NORM && whichfork != XFS_DATA_FORK)
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index 4f595546a639..b74866dbea94 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -61,6 +61,29 @@ xfs_verify_fsbno(
>  	return xfs_verify_agbno(mp, agno, XFS_FSB_TO_AGBNO(mp, fsbno));
>  }
>  
> +/*
> + * Verify that a data device extent is fully contained inside the filesystem,
> + * does not cross an AG boundary, and does not point at static metadata.
> + */
> +bool
> +xfs_verify_fsbext(
> +	struct xfs_mount	*mp,
> +	xfs_fsblock_t		fsbno,
> +	xfs_fsblock_t		len)
> +{
> +	if (fsbno + len <= fsbno)
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, fsbno))
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, fsbno + len - 1))
> +		return false;
> +
> +	return  XFS_FSB_TO_AGNO(mp, fsbno) ==
> +		XFS_FSB_TO_AGNO(mp, fsbno + len - 1);
> +}
> +
>  /* Calculate the first and last possible inode number in an AG. */
>  void
>  xfs_agino_range(
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 397d94775440..7feaaac25b3d 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -184,6 +184,8 @@ xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
>  bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		xfs_agblock_t agbno);
>  bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
> +bool xfs_verify_fsbext(struct xfs_mount *mp, xfs_fsblock_t fsbno,
> +		xfs_fsblock_t len);
>  
>  void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		xfs_agino_t *first, xfs_agino_t *last);
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index fed56d213a3f..3e2ba7875059 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -359,10 +359,7 @@ xchk_bmap_iextent(
>  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  	if (!info->is_rt &&
> -	    (!xfs_verify_fsbno(mp, irec->br_startblock) ||
> -	     !xfs_verify_fsbno(mp, end) ||
> -	     XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
> -				XFS_FSB_TO_AGNO(mp, end)))
> +	    !xfs_verify_fsbext(mp, irec->br_startblock, irec->br_blockcount))
>  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 8d3ed07800f6..5c9706760e68 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -452,16 +452,7 @@ xfs_bui_validate(
>  	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
>  		return false;
>  
> -	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
> -		return false;
> -
> -	if (!xfs_verify_fsbno(mp, bmap->me_startblock))
> -		return false;
> -
> -	if (!xfs_verify_fsbno(mp, bmap->me_startblock + bmap->me_len - 1))
> -		return false;
> -
> -	return true;
> +	return xfs_verify_fsbext(mp, bmap->me_startblock, bmap->me_len);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index bfdfbd192a38..93223ebb3372 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -584,16 +584,7 @@ xfs_efi_validate_ext(
>  	struct xfs_mount		*mp,
>  	struct xfs_extent		*extp)
>  {
> -	if (extp->ext_start + extp->ext_len <= extp->ext_start)
> -		return false;
> -
> -	if (!xfs_verify_fsbno(mp, extp->ext_start))
> -		return false;
> -
> -	if (!xfs_verify_fsbno(mp, extp->ext_start + extp->ext_len - 1))
> -		return false;
> -
> -	return true;
> +	return xfs_verify_fsbext(mp, extp->ext_start, extp->ext_len);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 937d482c9be4..07ebccbbf4df 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -439,16 +439,7 @@ xfs_cui_validate_phys(
>  		return false;
>  	}
>  
> -	if (refc->pe_startblock + refc->pe_len <= refc->pe_startblock)
> -		return false;
> -
> -	if (!xfs_verify_fsbno(mp, refc->pe_startblock))
> -		return false;
> -
> -	if (!xfs_verify_fsbno(mp, refc->pe_startblock + refc->pe_len - 1))
> -		return false;
> -
> -	return true;
> +	return xfs_verify_fsbext(mp, refc->pe_startblock, refc->pe_len);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 9b84017184d9..4fa875237422 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -493,16 +493,7 @@ xfs_rui_validate_map(
>  	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
>  		return false;
>  
> -	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
> -		return false;
> -
> -	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
> -		return false;
> -
> -	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
> -		return false;
> -
> -	return true;
> +	return xfs_verify_fsbext(mp, rmap->me_startblock, rmap->me_len);
>  }
>  
>  /*
> 

