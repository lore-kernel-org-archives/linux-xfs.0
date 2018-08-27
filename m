Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:53974 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbeH0F1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Aug 2018 01:27:43 -0400
Date: Mon, 27 Aug 2018 11:43:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: verify size-vs-format for symlinks & dirs
Message-ID: <20180827014314.GF2234@dastard>
References: <b0919ac0-deb3-4a0c-f755-309dd65c3206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0919ac0-deb3-4a0c-f755-309dd65c3206@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, "Xu, Wen" <wen.xu@gatech.edu>

On Sun, Aug 26, 2018 at 03:31:35PM -0500, Eric Sandeen wrote:
> Today, xfs_ifork_verify_data() will simply skip verification if the inode
> claims to be in non-local format.  However, nothing catches the case where
> the size for the format is too small to be non-local.  xfs_repair tests
> for this mismatch in process_check_inode_sizes(), so do the same in this
> verifier.
> 
> Reported-by: Xu, Wen <wen.xu@gatech.edu>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200925
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index f9acf1d436f6..e032986d3f67 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -704,12 +704,21 @@ xfs_ifork_verify_data(
>  	struct xfs_inode	*ip,
>  	struct xfs_ifork_ops	*ops)
>  {
> -	/* Non-local data fork, we're done. */
> -	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> -		return NULL;
> +	int			mode = VFS_I(ip)->i_mode;
> +
> +	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) {
> +		/* Small size for dir & symlink must be local */
> +		if ((S_ISDIR(mode) || S_ISLNK(mode)) &&
> +		    (ip->i_d.di_size <= XFS_IFORK_DSIZE(ip))) {
> +			return __this_address;

So this trusts the ip->i_d.di_forkoff field to be correct to
validate the fork is in the correct format?

> +		} else {
> +			/* Non-local data fork, we're done. */
> +			return NULL;
> +		}
> +	}

Hmmm. A bit hard to follow. I'm having to think hard if the logic
here is correct. I don't think the else branch should be there - if
it's in non-local format we do not run the local format verifiers at
all, so that branch needs to return unconditionally.

Now, size checks - if a directory inode data fork is in extent or
btree format, then it must be at least in block form and so it's
size must be equal to or larger than the directory block size.
Hence the above check misses a whole range on invalid directory
sizes for extent/btree forms. I think we should check directories
against against the directory block size, so avoid needing to trust
any other inode fields at all.

Symlinks, though, aren't so nice. Even a short symlink can be pushed
into extent form if enough attributes are created, and the size
remains the same even though it now consumes entire blocks, so I
think we can only check against XFS_IFORK_DSIZE - there's nothing
else we can verify against.

so maybe something like this? 

	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) {
		/*
		 * types that can be in local form need size checks
		 * to ensure they have the right amount of data in
		 * them to be in non-local form
		 */
		switch (mode & S_IFMT) {
		case S_IFDIR:
			if (ip->i_d.di_size < mp->m_dir_geo->blksize)
				return __this_address;
			break;
		case S_IFLNK:
			if (ip->i_d.di_size <= XFS_IFORK_DSIZE(ip))
				return __this_address;
			break;
		default:
			break;
		}
		return NULL;
	}


>  	/* Check the inline data fork if there is one. */
> -	switch (VFS_I(ip)->i_mode & S_IFMT) {
> +	switch (mode & S_IFMT) {
>  	case S_IFDIR:
>  		return ops->verify_dir(ip);
>  	case S_IFLNK:
> 
> 

-- 
Dave Chinner
david@fromorbit.com
