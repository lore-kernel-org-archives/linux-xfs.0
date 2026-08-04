Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B75481A9A;
	Tue,  4 Aug 2026 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866573; cv=none; b=kU9IJfAjrFwBxzcbxbitN55D3Nf5q6vHC33yMhdYL2p0z3G8+rU232cX5cOBeVu61WzOZMcA1Xp6D1DdOcF/Vn1O7HNkF9kojN24AOD39/+0rbCyt4EnYW6aY/opHDK9j67DpY9gdPst0eWQLhH5AjlHmRubEOCWMXbo93Lphug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866573; c=relaxed/simple;
	bh=Qd5/FaTN25QWxfGCFytU4SD3Mj4kY3aI6sLohRJsMMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jglsCFIdvcZI3Dl9ebkehhu95mcRe3ew9osKttqbTFTiAhvytQJ890wy5Bq6SvCqCE7H4Fn4i3IxU3RbD8bTZ3Asruj8arpY+yURJ5t1vSOWbD75WgvMeNoVcvQk/PVpyzgNELfI3lhPMSfUpUVvamJBN5gWidPOn469UcOtTvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kf1LK7j/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kf1LK7j/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CBDF1F000E9;
	Tue,  4 Aug 2026 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785866571;
	bh=RUV8diOUH6tIOqPemd79Edzg1FCzsPp8Zo9fdBv9ho8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kf1LK7j/mxecdE+LM7nAUymhk7YJkc/hE1AAggkPApnXOsjIFo1Qnvjy6disQTebc
	 3rlUZDBq5qr1+/RKkCLbDJnEjwIYQ05paIs8P2EMP3/p3Kaew6C5kjcGNr3vAwXk2A
	 NOGgmxxX4FVTmwNkvubOyJLXhd9LnzkKQXSAd5Pdg1YtfSwHm1kkOXuYWb82eUk1/W
	 AurLvQrkjvQplXuX8J7zqt7LDIczrvgZX5FdQhDMuaTSEwbB36ZIj1FZV+1ZX5Wipx
	 Buh5SJMbVrojcdmV3xBKGGIlO4RUvIsKbhTTqljxdGw+ZDal9WUXjSIvPOj+mCr+8B
	 X4t9DCHuVui4A==
Date: Tue, 4 Aug 2026 11:02:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v14 07/21] fsverity: hoist statx reporting of fs-verity
 flag
Message-ID: <20260804180251.GL3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-8-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-8-aalbersh@kernel.org>

On Mon, Aug 03, 2026 at 10:07:57PM +0200, Andrey Albershteyn wrote:
> All filesystems, supporting fsverity, report this status by checking
> inode flag. Also, BTRFS was missing stat->attributes_mask, which is
> fixed now.
> 
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/btrfs/inode.c | 3 ---
>  fs/ext4/inode.c  | 5 +----
>  fs/f2fs/file.c   | 5 +----
>  fs/stat.c        | 6 +++++-
>  4 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 272598f6ae77..de729c44d6d2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8040,7 +8040,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
>  	struct inode *inode = d_inode(path->dentry);
>  	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
>  	u32 bi_flags = BTRFS_I(inode)->flags;
> -	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
>  
>  	stat->result_mask |= STATX_BTIME;
>  	stat->btime.tv_sec = BTRFS_I(inode)->i_otime_sec;
> @@ -8053,8 +8052,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
>  		stat->attributes |= STATX_ATTR_IMMUTABLE;
>  	if (bi_flags & BTRFS_INODE_NODUMP)
>  		stat->attributes |= STATX_ATTR_NODUMP;
> -	if (bi_ro_flags & BTRFS_INODE_RO_VERITY)
> -		stat->attributes |= STATX_ATTR_VERITY;
>  
>  	stat->attributes_mask |= (STATX_ATTR_APPEND |
>  				  STATX_ATTR_COMPRESSED |
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..99fa7a28951f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6250,15 +6250,12 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
>  		stat->attributes |= STATX_ATTR_IMMUTABLE;
>  	if (flags & EXT4_NODUMP_FL)
>  		stat->attributes |= STATX_ATTR_NODUMP;
> -	if (flags & EXT4_VERITY_FL)
> -		stat->attributes |= STATX_ATTR_VERITY;
>  
>  	stat->attributes_mask |= (STATX_ATTR_APPEND |
>  				  STATX_ATTR_COMPRESSED |
>  				  STATX_ATTR_ENCRYPTED |
>  				  STATX_ATTR_IMMUTABLE |
> -				  STATX_ATTR_NODUMP |
> -				  STATX_ATTR_VERITY);
> +				  STATX_ATTR_NODUMP);
>  
>  	generic_fillattr(idmap, request_mask, inode, stat);
>  	return 0;
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 4b52c56d71f0..9b531a016ed4 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -1024,15 +1024,12 @@ int f2fs_getattr(struct mnt_idmap *idmap, const struct path *path,
>  		stat->attributes |= STATX_ATTR_IMMUTABLE;
>  	if (flags & F2FS_NODUMP_FL)
>  		stat->attributes |= STATX_ATTR_NODUMP;
> -	if (IS_VERITY(inode))
> -		stat->attributes |= STATX_ATTR_VERITY;
>  
>  	stat->attributes_mask |= (STATX_ATTR_COMPRESSED |
>  				  STATX_ATTR_APPEND |
>  				  STATX_ATTR_ENCRYPTED |
>  				  STATX_ATTR_IMMUTABLE |
> -				  STATX_ATTR_NODUMP |
> -				  STATX_ATTR_VERITY);
> +				  STATX_ATTR_NODUMP);
>  
>  	generic_fillattr(idmap, request_mask, inode, stat);
>  
> diff --git a/fs/stat.c b/fs/stat.c
> index 89909746bed1..ae1299bd7436 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -203,8 +203,12 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
>  	if (IS_DAX(inode))
>  		stat->attributes |= STATX_ATTR_DAX;
>  
> +	if (IS_VERITY(inode))
> +		stat->attributes |= STATX_ATTR_VERITY;

Makes sense to hoist this;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
>  	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
> -				  STATX_ATTR_DAX);
> +				  STATX_ATTR_DAX |
> +				  STATX_ATTR_VERITY);
>  
>  	idmap = mnt_idmap(path->mnt);
>  	if (inode->i_op->getattr) {
> -- 
> 2.54.0
> 
> 
