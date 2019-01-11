Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391837AbfAKPLD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 10:11:03 -0500
Date: Fri, 11 Jan 2019 10:11:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs: check directory name validity
Message-ID: <20190111151100.GC30640@bfoster>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
 <154697978966.2839.8800976099907580396.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154697978966.2839.8800976099907580396.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Jan 08, 2019 at 12:36:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check directory entry names for invalid characters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_dir2.c |   17 +++++++++++++++++
>  fs/xfs/libxfs/xfs_dir2.h |    1 +
>  fs/xfs/scrub/dir.c       |    6 ++++++
>  3 files changed, 24 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 229152cd1a24..156ce95c9c45 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -703,3 +703,20 @@ xfs_dir2_shrink_inode(
>  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  	return 0;
>  }
> +
> +/* Returns true if the directory entry name is valid. */
> +bool
> +xfs_dir2_namecheck(
> +	const void	*name,
> +	size_t		length)
> +{
> +	/*
> +	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
> +	 * out, so use >= for the length check.
> +	 */
> +	if (length >= MAXNAMELEN)
> +		return false;
> +
> +	/* There shouldn't be any slashes or nulls here */
> +	return !memchr(name, '/', length) && !memchr(name, 0, length);
> +}
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index c3e3f6b813d8..f54244779492 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -326,5 +326,6 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
>  unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
>  void *xfs_dir3_data_endp(struct xfs_da_geometry *geo,
>  		struct xfs_dir2_data_hdr *hdr);
> +bool xfs_dir2_namecheck(const void *name, size_t length);
>  
>  #endif	/* __XFS_DIR2_H__ */
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index cd3e4d768a18..a38a22785a1a 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -129,6 +129,12 @@ xchk_dir_actor(
>  		goto out;
>  	}
>  
> +	/* Does this name make sense? */
> +	if (!xfs_dir2_namecheck(name, namelen)) {
> +		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +		goto out;
> +	}
> +
>  	if (!strncmp(".", name, namelen)) {
>  		/* If this is "." then check that the inum matches the dir. */
>  		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
> 
