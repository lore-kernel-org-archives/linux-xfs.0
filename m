Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238482BD11;
	Tue, 10 Mar 2026 00:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773103796; cv=none; b=EdjySlshNDsIQ9i4IzkBD3y8Y/WYEkJs/RsOOKu1EGBD5XQeIor2cIFX7OdeU3JUojcqDEm2jgPTsY1oh9Kq745Y0xCDBCy/ssqJOZQllx+aWZ1D5AaEWaAJ97R5Jmy1JAYCTtArwlWht1YSdLS2D4UgA/ky+9n54oPy1flFgrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773103796; c=relaxed/simple;
	bh=m5e1BbgSDz/Jp6ApfzlcRflHEVyII/7PM1S61xMzj00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMaWHu8EbnvPHNx2wmiofTSwl7bmh6rusodVyPqrTax9HcJsh4/tMPlfYj5JJaulXLuAOyEQbdFxbqs/trrweZ1aAqT1dyPCtdO1ysPn/GU6IBqeZ1EKcI1AQZv5AVBkvhUZPEfZqaoRm2XI0Pc5Ka9zWc6/xmDzqN7iRSBeB48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cuw2OQeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cuw2OQeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD59C19423;
	Tue, 10 Mar 2026 00:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773103795;
	bh=m5e1BbgSDz/Jp6ApfzlcRflHEVyII/7PM1S61xMzj00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cuw2OQeOpgO+Knj/hmcnUNStlVQf+YgVnexAxVyuiJG9vIBXm57WxbfD1VlBf6+7L
	 7SPC+tpiC3D1MhOtUHc1gXqCGIhDk/T3Dr2C58uUIkmJ7AM7cl4nQ/uvaCu2j/8zI6
	 pFfzjaEd6K6ybU1M0xdA8HjZ9Ri0tw68cabtqn6hO5LZkvVYn24faqJHdLU9p68M/n
	 47AydTSM3hpoU663OFWRkbaJUWE1SW5yQH0pgivzazgjGdPPWHECO6KRQSy5I4TMM5
	 VEZNKGIlAg68JTLq8u7GU5zxRfA2mvx/GgRc+zSeekv8tU3pzEinoM3F0lKuvdqGQZ
	 MBsz0h92GQKBA==
Date: Mon, 9 Mar 2026 17:49:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 05/25] fsverity: pass digest size and hash of the
 empty block to ->write
Message-ID: <20260310004955.GY6033@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-6-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-6-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:20PM +0100, Andrey Albershteyn wrote:
> Let filesystem iterate over hashes in the block and check if these are
> hashes of zeroed data blocks. XFS will use this to decide if it want to
> store tree block full of these hashes.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Seems reasonable enough to me, though we'll see when I get to the actual
users...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/btrfs/verity.c        | 6 +++++-
>  fs/ext4/verity.c         | 4 +++-
>  fs/f2fs/verity.c         | 4 +++-
>  fs/verity/enable.c       | 4 +++-
>  include/linux/fsverity.h | 6 +++++-
>  5 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 0062b3a55781..6d8d3808d75d 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -773,11 +773,15 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>   * @buf:	Merkle tree block to write
>   * @pos:	the position of the block in the Merkle tree (in bytes)
>   * @size:	the Merkle tree block size (in bytes)
> + * @zero_digest:	the hash of a merkle block-sized buffer of zeroes
> + * @digest_size:	size of zero_digest, in bytes
>   *
>   * Returns 0 on success or negative error code on failure
>   */
>  static int btrfs_write_merkle_tree_block(struct file *file, const void *buf,
> -					 u64 pos, unsigned int size)
> +					 u64 pos, unsigned int size,
> +					 const u8 *zero_digest,
> +					 unsigned int digest_size)
>  {
>  	struct inode *inode = file_inode(file);
>  	loff_t merkle_pos = merkle_file_pos(inode);
> diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
> index ca61da53f313..347945ac23a4 100644
> --- a/fs/ext4/verity.c
> +++ b/fs/ext4/verity.c
> @@ -374,7 +374,9 @@ static void ext4_readahead_merkle_tree(struct inode *inode, pgoff_t index,
>  }
>  
>  static int ext4_write_merkle_tree_block(struct file *file, const void *buf,
> -					u64 pos, unsigned int size)
> +					u64 pos, unsigned int size,
> +					const u8 *zero_digest,
> +					unsigned int digest_size)
>  {
>  	pos += ext4_verity_metadata_pos(file_inode(file));
>  
> diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> index 92ebcc19cab0..b3b3e71604ac 100644
> --- a/fs/f2fs/verity.c
> +++ b/fs/f2fs/verity.c
> @@ -270,7 +270,9 @@ static void f2fs_readahead_merkle_tree(struct inode *inode, pgoff_t index,
>  }
>  
>  static int f2fs_write_merkle_tree_block(struct file *file, const void *buf,
> -					u64 pos, unsigned int size)
> +					u64 pos, unsigned int size,
> +					const u8 *zero_digest,
> +					unsigned int digest_size)
>  {
>  	pos += f2fs_verity_metadata_pos(file_inode(file));
>  
> diff --git a/fs/verity/enable.c b/fs/verity/enable.c
> index 42dfed1ce0ce..ad4ff71d7dd9 100644
> --- a/fs/verity/enable.c
> +++ b/fs/verity/enable.c
> @@ -50,7 +50,9 @@ static int write_merkle_tree_block(struct file *file, const u8 *buf,
>  	int err;
>  
>  	err = inode->i_sb->s_vop->write_merkle_tree_block(file, buf, pos,
> -							  params->block_size);
> +							  params->block_size,
> +							  params->zero_digest,
> +							  params->digest_size);
>  	if (err)
>  		fsverity_err(inode, "Error %d writing Merkle tree block %lu",
>  			     err, index);
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index b490b2c8a393..1ca8de129323 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -124,6 +124,8 @@ struct fsverity_operations {
>  	 * @buf: the Merkle tree block to write
>  	 * @pos: the position of the block in the Merkle tree (in bytes)
>  	 * @size: the Merkle tree block size (in bytes)
> +	 * @zero_digest: the hash of a merkle block-sized buffer of zeroes
> +	 * @digest_size: size of zero_digest, in bytes
>  	 *
>  	 * This is only called between ->begin_enable_verity() and
>  	 * ->end_enable_verity().
> @@ -131,7 +133,9 @@ struct fsverity_operations {
>  	 * Return: 0 on success, -errno on failure
>  	 */
>  	int (*write_merkle_tree_block)(struct file *file, const void *buf,
> -				       u64 pos, unsigned int size);
> +				       u64 pos, unsigned int size,
> +				       const u8 *zero_digest,
> +				       unsigned int digest_size);
>  };
>  
>  #ifdef CONFIG_FS_VERITY
> -- 
> 2.51.2
> 
> 
