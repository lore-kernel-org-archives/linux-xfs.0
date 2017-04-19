Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27162 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935493AbdDSW07 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 18:26:59 -0400
Date: Wed, 19 Apr 2017 15:26:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: more do_div cleanups
Message-ID: <20170419222654.GA23371@birch.djwong.org>
References: <a366521f-769b-7453-2f47-8dbaa69eab7b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a366521f-769b-7453-2f47-8dbaa69eab7b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 19, 2017 at 03:55:49PM -0500, Eric Sandeen wrote:
> On some architectures do_div does the pointer compare
> trick to make sure that we've sent it an unsigned 64-bit
> number.  (Why unsigned?  I don't know.)
> 
> Fix up the few places that squawk about this; in 
> xfs_bmap_wants_extents() we just used a bare int64_t so change
> that to unsigned.
> 
> In xfs_adjust_extent_unmap_boundaries() all we wanted was the
> mod, and we have an xfs-specific function to handle that w/o
> side effects, which includes proper casting for do_div.
> 
> In xfs_daddr_to_ag[b]no, we were using the wrong type anyway;
> XFS_BB_TO_FSBT returns a block in the filesystem, so use
> xfs_rfsblock_t not xfs_daddr_t, and gain the unsignedness
> from that type as a bonus.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Lightly tested via cross-compile to parisc as well as
> (incomplete) xfstests testing.
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index bfc00de..fce43fb 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4856,7 +4856,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  	ASSERT(got_endoff >= del_endoff);
>  
>  	if (isrt) {
> -		int64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
> +		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
>  
>  		do_div(rtexts, mp->m_sb.sb_rextsize);
>  		xfs_mod_frextents(mp, rtexts);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index c141791..5c9e3d6 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1222,11 +1222,8 @@
>  		return error;
>  
>  	if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
> -		xfs_daddr_t	block;
> -
>  		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> -		block = imap.br_startblock;
> -		mod = do_div(block, mp->m_sb.sb_rextsize);
> +		mod = do_mod(imap.br_startblock, mp->m_sb.sb_rextsize);
>  		if (mod)
>  			*startoffset_fsb += mp->m_sb.sb_rextsize - mod;
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7f351f7..dea4e2b 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -311,7 +311,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  static inline xfs_agnumber_t
>  xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
>  {
> -	xfs_daddr_t ld = XFS_BB_TO_FSBT(mp, d);
> +	xfs_rfsblock_t ld = XFS_BB_TO_FSBT(mp, d);
>  	do_div(ld, mp->m_sb.sb_agblocks);
>  	return (xfs_agnumber_t) ld;
>  }
> @@ -319,7 +319,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  static inline xfs_agblock_t
>  xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
>  {
> -	xfs_daddr_t ld = XFS_BB_TO_FSBT(mp, d);
> +	xfs_rfsblock_t ld = XFS_BB_TO_FSBT(mp, d);
>  	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
