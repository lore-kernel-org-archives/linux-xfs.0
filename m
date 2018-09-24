Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbeIXXH7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Sep 2018 19:07:59 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31842308FF32
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 17:04:53 +0000 (UTC)
Date: Mon, 24 Sep 2018 13:04:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: validate inode di_forkoff
Message-ID: <20180924170447.GA60179@bfoster>
References: <0c8c405b-8929-82a6-5c9a-f5965da2c464@redhat.com>
 <da670f4a-6ae7-fbe7-94db-b6a4e6bb0c9e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da670f4a-6ae7-fbe7-94db-b6a4e6bb0c9e@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Sep 10, 2018 at 05:22:08PM -0500, Eric Sandeen wrote:
> Verify the inode di_forkoff, lifted from xfs_repair's
> process_check_inode_forkoff().
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 30d1d60f1d46..8d76637a49a7 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -415,6 +415,31 @@ xfs_dinode_verify_fork(
>  	return NULL;
>  }
>  
> +static xfs_failaddr_t
> +xfs_dinode_verify_forkoff(
> +	struct xfs_dinode	*dip,
> +	struct xfs_mount	*mp)
> +{
> +	if (dip->di_forkoff == 0)
> +		return NULL;

I think it would be good to use XFS_DFORK_Q() here, just to be
consistent with the other, similar checks. Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	switch (dip->di_format)  {
> +	case XFS_DINODE_FMT_DEV:
> +		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
> +			return __this_address;
> +		break;
> +	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
> +	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
> +	case XFS_DINODE_FMT_BTREE:
> +		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
> +			return __this_address;
> +		break;
> +	default:
> +		return __this_address;
> +	}
> +	return NULL;
> +}
> +
>  xfs_failaddr_t
>  xfs_dinode_verify(
>  	struct xfs_mount	*mp,
> @@ -470,6 +498,11 @@ xfs_dinode_verify(
>  	if (mode && (flags & XFS_DIFLAG_REALTIME) && !mp->m_rtdev_targp)
>  		return __this_address;
>  
> +	/* check for illegal values of di_forkoff */
> +	fa = xfs_dinode_verify_forkoff(dip, mp);
> +	if (fa)
> +		return fa;
> +
>  	/* Do we have appropriate data fork formats for the mode? */
>  	switch (mode & S_IFMT) {
>  	case S_IFIFO:
> 
