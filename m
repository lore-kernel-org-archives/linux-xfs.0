Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6452ECEA3;
	Wed, 18 Feb 2026 21:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771450838; cv=none; b=cXpuC2PqNIYiGnIz6bCww9wKWFXJDuwpMbRlm9mVcbdTHfI1LlRwH43Gi2igBKPggAEgs2jg8cxEFzeb+KzQIpOokBTJdTYJsROUjjjn2t/oHjR37UskAWHtizd+OT/0DalsGf0sBafiPWxt0tuI5R+hSX76Ri5z6+eJbCY3WxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771450838; c=relaxed/simple;
	bh=DTQ+wjpGAm0naij3zSO0oGQV1qi4m4Px+di5qfjPB1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRW1s4lVZGEufcaq2roUgT4mNge3MioXd5S3e+Qu5r7BVvSn6TQgPjcAM5FV3cLvnKAlY7cdZskd59PAmyUSdRmfRHSEhpvXPMOKizUCU3agZ9nhKfwa531bPyMgrRsjW0w8Vzv41Q4IQzC2IJ0JRm8U+sxVluhn3ZxtGj8Nt8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edtfrJ6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edtfrJ6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E044DC116D0;
	Wed, 18 Feb 2026 21:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771450837;
	bh=DTQ+wjpGAm0naij3zSO0oGQV1qi4m4Px+di5qfjPB1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edtfrJ6znppj7TTZHdKkQmi2lQDALyZHhKByyDfPvRsphXwq5uqe01dCKUKFgaqLI
	 6DEvjQ3yYDOn35eEYvuLRo7auvtABzVCWys5Djs8ACLJ3uEuTiPIdZb5pWJBg1cwAG
	 Z0I5bh9/hOSbNhWFRBoDHt00qtqVhjQYGXkgQaSe5wd6D+VwqTQfNow5ywO3kpDBhX
	 bdtPItLuk8IexmDZrh8ek6HqooQXKtQ599BYnaDlEok0f9pJaqDywAq88Lv7ovTLkx
	 eXutym2M2Vw4i10rWuJyINpTwh9mc/0S5ExVEF48Fa5J5JzStjBmxU9hXZDG84PAUA
	 7ABi0CsRvmFcw==
Date: Wed, 18 Feb 2026 13:40:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 01/35] fsverity: report validation errors back to the
 filesystem
Message-ID: <20260218214037.GA6467@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-2-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:01AM +0100, Andrey Albershteyn wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Provide a new function call so that validation errors can be reported
> back to the filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/verity/verify.c              |  4 ++++
>  include/linux/fsverity.h        | 14 ++++++++++++++
>  include/trace/events/fsverity.h | 19 +++++++++++++++++++
>  3 files changed, 37 insertions(+)
> 
> diff --git a/fs/verity/verify.c b/fs/verity/verify.c
> index 404ab68aaf9b..8f930b2ed9c0 100644
> --- a/fs/verity/verify.c
> +++ b/fs/verity/verify.c
> @@ -312,6 +312,10 @@ static bool verify_data_block(struct fsverity_info *vi,
>  		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
>  		params->hash_alg->name, hsize,
>  		level == 0 ? dblock->real_hash : real_hash);
> +	trace_fsverity_file_corrupt(inode, data_pos, params->block_size);
> +	if (inode->i_sb->s_vop->file_corrupt)
> +		inode->i_sb->s_vop->file_corrupt(inode, data_pos,
> +						 params->block_size);

Once 7.0-rc1 lands you could turn this into:

	fserror_report_data_lost(inode, data_pos, params->block_size,
			GFP_WHATEVER);

--D

>  error:
>  	for (; level > 0; level--) {
>  		kunmap_local(hblocks[level - 1].addr);
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index fed91023bea9..d8b581e3ce48 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -132,6 +132,20 @@ struct fsverity_operations {
>  	 */
>  	int (*write_merkle_tree_block)(struct file *file, const void *buf,
>  				       u64 pos, unsigned int size);
> +
> +	/**
> +	 * Notify the filesystem that file data is corrupt.
> +	 *
> +	 * @inode: the inode being validated
> +	 * @pos: the file position of the invalid data
> +	 * @len: the length of the invalid data
> +	 *
> +	 * This function is called when fs-verity detects that a portion of a
> +	 * file's data is inconsistent with the Merkle tree, or a Merkle tree
> +	 * block needed to validate the data is inconsistent with the level
> +	 * above it.
> +	 */
> +	void (*file_corrupt)(struct inode *inode, loff_t pos, size_t len);
>  };
>  
>  #ifdef CONFIG_FS_VERITY
> diff --git a/include/trace/events/fsverity.h b/include/trace/events/fsverity.h
> index a8c52f21cbd5..0c842aaa4158 100644
> --- a/include/trace/events/fsverity.h
> +++ b/include/trace/events/fsverity.h
> @@ -140,6 +140,25 @@ TRACE_EVENT(fsverity_verify_merkle_block,
>  		__entry->hidx)
>  );
>  
> +TRACE_EVENT(fsverity_file_corrupt,
> +	TP_PROTO(const struct inode *inode, loff_t pos, size_t len),
> +	TP_ARGS(inode, pos, len),
> +	TP_STRUCT__entry(
> +		__field(ino_t, ino)
> +		__field(loff_t, pos)
> +		__field(size_t, len)
> +	),
> +	TP_fast_assign(
> +		__entry->ino = inode->i_ino;
> +		__entry->pos = pos;
> +		__entry->len = len;
> +	),
> +	TP_printk("ino %lu pos %llu len %zu",
> +		(unsigned long) __entry->ino,
> +		__entry->pos,
> +		__entry->len)
> +);
> +
>  #endif /* _TRACE_FSVERITY_H */
>  
>  /* This part must be outside protection */
> -- 
> 2.51.2
> 
> 
