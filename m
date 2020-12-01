Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883B6C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ECA822244
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OVDHyfq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392037AbgLAQSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:18:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390841AbgLAQSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:18:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606839438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=irG1Bhj1PtJ0Ilu0zpNIYH1r9APfz0jnp9hdfwBn6Tw=;
        b=OVDHyfq+YWD+PPluW8S8pfMPHwQBjhXfxIQzytTZLmMiYuYbkPkDChLp2e89dtfuhJjwN/
        mcF5i//ZZ6uV7fIO1NYRSr5/ToIwczF7UcuiTOK4mTMv1vDFKcxWCjzjI8YbBtH04fyNNW
        /LnbhCOgUBriekq6yc/Vo9asNKqYse4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-FccXdTyrM6WEkok6Zj1vRQ-1; Tue, 01 Dec 2020 11:17:14 -0500
X-MC-Unique: FccXdTyrM6WEkok6Zj1vRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A5D11005E44;
        Tue,  1 Dec 2020 16:17:13 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D2F01000320;
        Tue,  1 Dec 2020 16:17:12 +0000 (UTC)
Date:   Tue, 1 Dec 2020 11:17:10 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
Message-ID: <20201201161710.GC1205666@bfoster>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679384513.447856.3675245763779550446.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679384513.447856.3675245763779550446.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:37:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A couple of the superblock validation checks apply only to the kernel,
> so move them to xfs_mount.c before we start changing sb_inprogress.
> This also reduces the diff between kernel and userspace libxfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c |   23 ++++-------------------
>  fs/xfs/libxfs/xfs_sb.h |    3 +++
>  fs/xfs/xfs_mount.c     |   31 +++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 5aeafa59ed27..a2c43fe38f64 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -223,6 +223,7 @@ xfs_validate_sb_common(
>  	struct xfs_dsb		*dsb = bp->b_addr;
>  	uint32_t		agcount = 0;
>  	uint32_t		rem;
> +	int			error;
>  
>  	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
>  		xfs_warn(mp, "bad magic number");
> @@ -382,16 +383,9 @@ xfs_validate_sb_common(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	/*
> -	 * Until this is fixed only page-sized or smaller data blocks work.
> -	 */
> -	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
> -		xfs_warn(mp,
> -		"File system with blocksize %d bytes. "
> -		"Only pagesize (%ld) or less will currently work.",
> -				sbp->sb_blocksize, PAGE_SIZE);
> -		return -ENOSYS;
> -	}
> +	error = xfs_sb_validate_mount(mp, bp, sbp);
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * Currently only very few inode sizes are supported.
> @@ -415,15 +409,6 @@ xfs_validate_sb_common(
>  		return -EFBIG;
>  	}
>  
> -	/*
> -	 * Don't touch the filesystem if a user tool thinks it owns the primary
> -	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
> -	 * we don't check them at all.
> -	 */
> -	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && sbp->sb_inprogress) {
> -		xfs_warn(mp, "Offline file system operation in progress!");
> -		return -EFSCORRUPTED;
> -	}
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 92465a9a5162..ee0a5858dd47 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
>  				struct xfs_trans *tp, xfs_agnumber_t agno,
>  				struct xfs_buf **bpp);
>  
> +int xfs_sb_validate_mount(struct xfs_mount *mp, struct xfs_buf *bp,
> +		struct xfs_sb *sbp);
> +
>  #endif	/* __XFS_SB_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7110507a2b6b..7bc7901d648d 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -259,6 +259,37 @@ xfs_initialize_perag(
>  	return error;
>  }
>  
> +/* Validate the superblock is compatible with this mount. */
> +int
> +xfs_sb_validate_mount(
> +	struct xfs_mount	*mp,
> +	struct xfs_buf		*bp,
> +	struct xfs_sb		*sbp)
> +{
> +	/*
> +	 * Don't touch the filesystem if a user tool thinks it owns the primary
> +	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
> +	 * we don't check them at all.
> +	 */
> +	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && sbp->sb_inprogress) {
> +		xfs_warn(mp, "Offline file system operation in progress!");
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/*
> +	 * Until this is fixed only page-sized or smaller data blocks work.
> +	 */
> +	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
> +		xfs_warn(mp,
> +		"File system with blocksize %d bytes. "
> +		"Only pagesize (%ld) or less will currently work.",
> +				sbp->sb_blocksize, PAGE_SIZE);
> +		return -ENOSYS;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * xfs_readsb
>   *
> 

