Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:45415 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751962AbdC0WJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 18:09:52 -0400
Date: Tue, 28 Mar 2017 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: move the inline directory verifiers
Message-ID: <20170327220937.GI17542@dastard>
References: <20170327170828.GI5722@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170327170828.GI5722@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Mon, Mar 27, 2017 at 10:08:28AM -0700, Darrick J. Wong wrote:
> The inline directory verifiers should be called on the inode fork data,
> which means after iformat_local on the read side, and prior to
> ifork_flush on the write side.  This makes the fork verifier more
> consistent with the way buffer verifiers work -- i.e. they will operate
> on the memory buffer that the code will be reading and writing directly.
> 
> Also revise the verifier function to return -EFSCORRUPTED so that we
> don't flood the logs with corruption messages and assert notices.
> 
> I've been testing xfs/348 in a loop for 4 days now and it seems to fix
> all of the crashes and weird behavior introduced by the original patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -632,36 +632,45 @@ xfs_dir2_sf_check(
>  /* Verify the consistency of an inline directory. */
>  int
>  xfs_dir2_sf_verify(
> -	struct xfs_mount		*mp,
> -	struct xfs_dir2_sf_hdr		*sfp,
> -	int				size)
> +	struct xfs_inode		*ip)
>  {
> +	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_dir2_sf_hdr		*sfp;
>  	struct xfs_dir2_sf_entry	*sfep;
>  	struct xfs_dir2_sf_entry	*next_sfep;
>  	char				*endp;
>  	const struct xfs_dir_ops	*dops;
> +	struct xfs_ifork		*ifp;
>  	xfs_ino_t			ino;
>  	int				i;
>  	int				i8count;
>  	int				offset;
> +	int				size;
> +	int				error;
>  	__uint8_t			filetype;
>  
> -	dops = xfs_dir_get_ops(mp, NULL);
> +	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
> +	dops = mp->m_dir_inode_ops;

Please use xfs_dir_get_ops() for consistency - that way we don't
have to care what context this function gets called from in future
(especially in userspace!).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
