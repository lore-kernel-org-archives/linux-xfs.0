Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB47DA93
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 09:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747042568; cv=none; b=OsGbDhWbNxdyLoUqrov1AEjSwxMXSJSKvWVltW4uNX8VgJ+1s7Gy7FSYEPBf/J9zg/0si+olxcG4cM/U9bz+R0E5SIgAyLjLsLapo+wIJ2uHc+W+F0tVZl1EtSz+WnfBeHl9DASoWjCV+fn6vqSzIlFVdxawU1SViW9XcbQHzf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747042568; c=relaxed/simple;
	bh=wuWMlSWai25nc9/11x7yHvbTUwz2OLQYkhEZmEXIYsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTHXQcmXMsM9xZCIOtM+W6rrKWxHXlXN5TBjUh1OIrZFPaLylo46cBHg6uK+gqwzjoYPd5aSO1Gq1o7p+fM3RPnQhSL7Bhi5+FS5nc9bVm18rohyJqBZfj3VrAwJyrRxS/ilsHbgz48uw1dMir1pztPbR0hBbhCz60+MkDoYMyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tV7q6osb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tV7q6osb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF38C4CEE7;
	Mon, 12 May 2025 09:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747042568;
	bh=wuWMlSWai25nc9/11x7yHvbTUwz2OLQYkhEZmEXIYsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tV7q6osboFewSHeEWlIiDJiQNgPkrqI2eyCU5wyKmcrVFjWHHHdohJ3b9PnjmPL2d
	 tgpuFY0ogNqPkCCPxVe573/R6+3COVmk+KH5RofzqSvehbk/WRQpnd6oXwV2SbdQ1k
	 BRV91vIZVLTkb94vd+ZyiVKTEuADyb277rXDOLHdx5aJ67kyDcSHI/CW1hLyFrEomS
	 cBSFWTAGWH1bwX3nF6Zy+1DWee1FmNNQFRkgd/UZvKkQuH9mA6Iwl9zQ3w+iFa3e/J
	 MZJfOWPtdBDEt8Zzb292rEBaf2nq6MDC8GXZB/3NTmjoIWmP+AvWnGhCbUKaYdwxru
	 ZONE3lom7Ng4A==
Date: Mon, 12 May 2025 11:36:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v4 1/1] xfs: Fail remount with noattr2 on a v5 with v4
 enabled
Message-ID: <zgl5yk2hmsdjox3sfzqkbumb7lv2hihl4bvnxlkj2znk26xpvg@dq6vdhy4nv7p>
References: <cover.1746600966.git.nirjhar.roy.lists@gmail.com>
 <eaL7yzt3CizUmfISa3-LHlCNyHTKpX8yNsEZgf0kBACfqG5XKp_WsNrb-2495PC1CbxtR0IG3esvYOe_vJEwxA==@protonmail.internalid>
 <9110d568dc6c9930e70967d702197a691aca74e7.1746600966.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9110d568dc6c9930e70967d702197a691aca74e7.1746600966.git.nirjhar.roy.lists@gmail.com>

Hi Nirjhar.

The patch looks fine, with a caveat below.

On Wed, May 07, 2025 at 12:59:13PM +0530, Nirjhar Roy (IBM) wrote:
> Bug: When we compile the kernel with CONFIG_XFS_SUPPORT_V4=y,
> remount with "-o remount,noattr2" on a v5 XFS does not
> fail explicitly.
> 
> Reproduction:
> mkfs.xfs -f /dev/loop0
> mount /dev/loop0 /mnt/scratch
> mount -o remount,noattr2 /dev/loop0 /mnt/scratch
> 
> However, with CONFIG_XFS_SUPPORT_V4=n, the remount
> correctly fails explicitly. This is because the way the
> following 2 functions are defined:
> 
> static inline bool xfs_has_attr2 (struct xfs_mount *mp)
> {
> 	return !IS_ENABLED(CONFIG_XFS_SUPPORT_V4) ||
> 		(mp->m_features & XFS_FEAT_ATTR2);
> }
> static inline bool xfs_has_noattr2 (const struct xfs_mount *mp)
> {
> 	return mp->m_features & XFS_FEAT_NOATTR2;
> }
> 
> xfs_has_attr2() returns true when CONFIG_XFS_SUPPORT_V4=n
> and hence, the following if condition in
> xfs_fs_validate_params() succeeds and returns -EINVAL:
> 
> /*
>  * We have not read the superblock at this point, so only the attr2
>  * mount option can set the attr2 feature by this stage.
>  */
> 
> if (xfs_has_attr2(mp) && xfs_has_noattr2(mp)) {
> 	xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
> 	return -EINVAL;
> }
> 
> With CONFIG_XFS_SUPPORT_V4=y, xfs_has_attr2() always return
> false and hence no error is returned.
> 
> Fix: Check if the existing mount has crc enabled(i.e, of
> type v5 and has attr2 enabled) and the
> remount has noattr2, if yes, return -EINVAL.
> 
> I have tested xfs/{189,539} in fstests with v4
> and v5 XFS with both CONFIG_XFS_SUPPORT_V4=y/n and
> they both behave as expected.
> 
> This patch also fixes remount from noattr2 -> attr2 (on a v4 xfs).
> 
> Related discussion in [1]
> 
> [1] https://lore.kernel.org/all/Z65o6nWxT00MaUrW@dread.disaster.area/
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b2dd0c0bf509..58a0431ab52d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2114,6 +2114,21 @@ xfs_fs_reconfigure(
>  	if (error)
>  		return error;
> 
> +	/* attr2 -> noattr2 */
> +	if (xfs_has_noattr2(new_mp)) {
> +		if (xfs_has_crc(mp)) {
> +			xfs_warn(mp,
> +			"attr2 and noattr2 cannot both be specified.");

This message doesn't seem to make sense to me. Your code checks the attr2 option
is not being changed on a V5 FS, but your error message states both mount
options are bing specified at the command line, confusing the user.

V5 format always use attr2, and can't use noattr2. So, this message is
misleading.

IMO this should be something like:

"attr2 is always enabled for for a V5 filesystem and can't be changed."

Carlos

> +			return -EINVAL;
> +		}
> +		mp->m_features &= ~XFS_FEAT_ATTR2;
> +		mp->m_features |= XFS_FEAT_NOATTR2;
> +	} else if (xfs_has_attr2(new_mp)) {
> +		/* noattr2 -> attr2 */
> +		mp->m_features &= ~XFS_FEAT_NOATTR2;
> +		mp->m_features |= XFS_FEAT_ATTR2;
> +	}
> +
>  	/* inode32 -> inode64 */
>  	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
>  		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
> @@ -2126,6 +2141,17 @@ xfs_fs_reconfigure(
>  		mp->m_maxagi = xfs_set_inode_alloc(mp, mp->m_sb.sb_agcount);
>  	}
> 
> +	/*
> +	 * Now that mp has been modified according to the remount options,
> +	 * we do a final option validation with xfs_finish_flags()
> +	 * just like it is done during mount. We cannot use
> +	 * xfs_finish_flags()on new_mp as it contains only the user
> +	 * given options.
> +	 */
> +	error = xfs_finish_flags(mp);
> +	if (error)
> +		return error;
> +
>  	/* ro -> rw */
>  	if (xfs_is_readonly(mp) && !(flags & SB_RDONLY)) {
>  		error = xfs_remount_rw(mp);
> --
> 2.43.5
> 
> 
