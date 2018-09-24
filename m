Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbeIXXKR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Sep 2018 19:10:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0499130832CB
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 17:07:11 +0000 (UTC)
Date: Mon, 24 Sep 2018 13:06:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2 V2] xfs: verify size-vs-format for symlinks & dirs
Message-ID: <20180924170658.GB60179@bfoster>
References: <0c8c405b-8929-82a6-5c9a-f5965da2c464@redhat.com>
 <d2648726-e4f9-a5a7-c9b1-560ad03d3e67@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2648726-e4f9-a5a7-c9b1-560ad03d3e67@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Sep 10, 2018 at 05:24:17PM -0500, Eric Sandeen wrote:
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
> V2: restructure code & tests per Dave's suggestion on the V1 patch.
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 183ec0cb8921..d6a137f5e207 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -732,12 +732,32 @@ xfs_ifork_verify_data(
>  	struct xfs_inode	*ip,
>  	struct xfs_ifork_ops	*ops)
>  {
> -	/* Non-local data fork, we're done. */
> -	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			mode = VFS_I(ip)->i_mode;
> +
> +	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) {
> +		/*
> +		 * types that can be in local form need size checks
> +		 * to ensure they have the right amount of data in
> +		 * them to be in non-local form
> +		 */

Just another nit... I had to read the comment a few times to understand
how it relates to the code. Could we perhaps move it above the if check
and reword it to something like:

/*
 * If this is a non-local format directory or symlink, verify the inode
 * size is consistent with non-local format.
 */

> +		switch (mode & S_IFMT) {
> +		case S_IFDIR:
> +			if (ip->i_d.di_size < mp->m_dir_geo->blksize)
> +				return __this_address;

Hmm, where does the ->blksize check come from? The dir shortform
transition code looks like it keys off of XFS_IFORK_DSIZE()..

Ah Ok, I went back and read Dave's feedback on the v1 post. If we want
to use this to also cover a range of invalid dir sizes, could we
incorporate that into the above comment as well so it's more clear?
E.g., change the above to something like:

/*
 * Verify non-local format forks have a valid size. Symlinks must have
 * outgrown the data fork size. The same goes for non-local dirs, but
 * dirs grow at dirblock granularity. Perform a slightly stronger check
 * and require the dir is at least one dirblock in size.
 */

Otherwise with the comment fixups:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +			break;
> +		case S_IFLNK:
> +			if (ip->i_d.di_size <= XFS_IFORK_DSIZE(ip))
> +				return __this_address;
> +			break;
> +		default:
> +			break;
> +		}
>  		return NULL;
> +	}
>  
>  	/* Check the inline data fork if there is one. */
> -	switch (VFS_I(ip)->i_mode & S_IFMT) {
> +	switch (mode & S_IFMT) {
>  	case S_IFDIR:
>  		return ops->verify_dir(ip);
>  	case S_IFLNK:
> 
