Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED962B9C1
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710870681; cv=none; b=VDMlaeO1FfarLh5TNs0yEcck5ZMNBqqkFX2PH47aJecr2gqs9OT4wD7/YJIVewKil4dkaLKa+fo3qXLHzOiNZTp3U6mIR/qMR0h1Mzfa7y09xs2ILfXvbLp+njSgpadr+W5yTCeGT9pfeWAQV66r+9UBPzXneyyBpKGnpiSnnfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710870681; c=relaxed/simple;
	bh=YN1u+CbIQrDa5Mg2geq0ropRruvQWW/EHhlXEiz/lL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PqqjmkXlpuMi/A+Qzu0Y8fA7+ZPsK/ochGlJ50qGjGJJWUqAoF/72OyRHgamEitWb/GySe5QBXJWSj1TT2fJSDXXo8xfBewbK2ZHn4mSo1wOQ6cTI+aGNMTb/RdQVXahC1kpXni9Xo8CCK2S4uwFDkmOnDBmaGohnt/oqsWua+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CzRaUGpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CzRaUGpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154CBC433F1;
	Tue, 19 Mar 2024 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710870681;
	bh=YN1u+CbIQrDa5Mg2geq0ropRruvQWW/EHhlXEiz/lL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CzRaUGpepkX9/I/N7O3ZVya3XyrPKyoM7wMwCq7eoC6R1P1b1N13t8Hid6T1dFgYm
	 NOdne3ys4Mt4r2K88Rc/VaSXPyF9jK6Fjacs7P8phRSKXAmOGEKo3+ad/8AC14feor
	 qKiUxgAwy8RGNW0XpTfPsvubYHQ6L21nTNrU6m9FYBJSD/By9kqTnpAzDRBsbpWUBS
	 U4Ut7/hsy4YHuagTyEZeebPTFA9W6QYKoBkLG0DGYzg+7NdsFoJS7aXjEdn/6UByxX
	 MB1WrcITmzjRz7AaL8dii0NydP/MOuVZNfof0Gyo/vk9JnsrHiV+AAqX6Chwo+lWL7
	 KK/cHbYPJI9xA==
Date: Tue, 19 Mar 2024 10:51:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: stop advertising SB_I_VERSION
Message-ID: <20240319175120.GV1927156@frogsfrogsfrogs>
References: <20240318225406.3378998-1-david@fromorbit.com>
 <20240318225406.3378998-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318225406.3378998-2-david@fromorbit.com>

On Tue, Mar 19, 2024 at 09:51:00AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The redefinition of how NFS wants inode->i_version to be updated is
> incomaptible with the XFS i_version mechanism. The VFS now wants
> inode->i_version to only change when ctime changes (i.e. it has
> become a ctime change counter, not an inode change counter). XFS has
> fine grained timestamps, so it can just use ctime for the NFS change
> cookie like it still does for V4 XFS filesystems.
> 
> We still want XFS to update the inode change counter as it currently
> does, so convert all the code that checks SB_I_VERSION to check for
> v5 format support. Then we can remove the SB_I_VERSION flag from the
> VFS superblock to indicate that inode->i_version is not a valid
> change counter and should not be used as such.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Acked-by: Jeff Layton <jlayton@kernel.org>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_trans_inode.c | 15 +++++----------
>  fs/xfs/xfs_iops.c               | 16 +++-------------
>  fs/xfs/xfs_super.c              |  8 --------
>  3 files changed, 8 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 69fc5b981352..b82f9c7ff2d5 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -97,17 +97,12 @@ xfs_trans_log_inode(
>  
>  	/*
>  	 * First time we log the inode in a transaction, bump the inode change
> -	 * counter if it is configured for this to occur. While we have the
> -	 * inode locked exclusively for metadata modification, we can usually
> -	 * avoid setting XFS_ILOG_CORE if no one has queried the value since
> -	 * the last time it was incremented. If we have XFS_ILOG_CORE already
> -	 * set however, then go ahead and bump the i_version counter
> -	 * unconditionally.
> +	 * counter if it is configured for this to occur.
>  	 */
> -	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
> -		if (IS_I_VERSION(inode) &&
> -		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
> -			flags |= XFS_ILOG_IVERSION;
> +	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags) &&
> +	    xfs_has_crc(ip->i_mount)) {
> +		atomic64_inc(&inode->i_version);
> +		flags |= XFS_ILOG_IVERSION;
>  	}
>  
>  	iip->ili_dirty_flags |= flags;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 66f8c47642e8..3940ad1ee66e 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -584,11 +584,6 @@ xfs_vn_getattr(
>  		}
>  	}
>  
> -	if ((request_mask & STATX_CHANGE_COOKIE) && IS_I_VERSION(inode)) {
> -		stat->change_cookie = inode_query_iversion(inode);
> -		stat->result_mask |= STATX_CHANGE_COOKIE;
> -	}
> -
>  	/*
>  	 * Note: If you add another clause to set an attribute flag, please
>  	 * update attributes_mask below.
> @@ -1043,16 +1038,11 @@ xfs_vn_update_time(
>  	struct timespec64	now;
>  
>  	trace_xfs_update_time(ip);
> +	ASSERT(!(flags & S_VERSION));
>  
>  	if (inode->i_sb->s_flags & SB_LAZYTIME) {
> -		if (!((flags & S_VERSION) &&
> -		      inode_maybe_inc_iversion(inode, false))) {
> -			generic_update_time(inode, flags);
> -			return 0;
> -		}
> -
> -		/* Capture the iversion update that just occurred */
> -		log_flags |= XFS_ILOG_CORE;
> +		generic_update_time(inode, flags);
> +		return 0;
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c21f10ab0f5d..bfc5f3a27451 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1690,10 +1690,6 @@ xfs_fs_fill_super(
>  
>  	set_posix_acl_flag(sb);
>  
> -	/* version 5 superblocks support inode version counters. */
> -	if (xfs_has_crc(mp))
> -		sb->s_flags |= SB_I_VERSION;
> -
>  	if (xfs_has_dax_always(mp)) {
>  		error = xfs_setup_dax_always(mp);
>  		if (error)
> @@ -1915,10 +1911,6 @@ xfs_fs_reconfigure(
>  	int			flags = fc->sb_flags;
>  	int			error;
>  
> -	/* version 5 superblocks always support version counters. */
> -	if (xfs_has_crc(mp))
> -		fc->sb_flags |= SB_I_VERSION;
> -
>  	error = xfs_fs_validate_params(new_mp);
>  	if (error)
>  		return error;
> -- 
> 2.43.0
> 
> 
