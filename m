Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0A73093CE;
	Wed, 18 Feb 2026 06:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771397073; cv=none; b=hBXORsV51PPFCp6wostZ0HPJClm1+eDY7cozDqKDMIMf5M+P7qgBuezhS1fZUbA0E4wO4qLSmjkUYY6SDoMB0buyGA/4Zkd0jJcIbRThnMTfK2EdG+BF9L9H/Vqv4aXKr3/UwPa8kXbQrgfJGopLigPN97xfc4jzzDtyaFXVy9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771397073; c=relaxed/simple;
	bh=XhiKQrYnLcOJNwG57vhuQiThNany22rOWnx3WK4PDfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hztek8JbkqkqeEfnx3GP2pIpnxyiLbd9OyjJxMmUYK1aTCAi4ybvx+Xjs0WO8ikGv0zhqlsBiyqwlA1OK8aT0DsBammYHZlWa2lY+3D4HUTkedoFs0U/5vrVJrHJMUvhpTVpQ24bNVM9O6NbRdeonvfbVvRfkG5IX1R22reSY2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2E5368B05; Wed, 18 Feb 2026 07:44:29 +0100 (CET)
Date: Wed, 18 Feb 2026 07:44:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH v3 28/35] xfs: add fs-verity support
Message-ID: <20260218064429.GC8768@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-29-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-29-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +static int
> +xfs_fsverity_read(
> +	struct inode	*inode,
> +	void		*buf,
> +	size_t		count,
> +	loff_t		pos)
> +{
> +	struct folio	*folio;
> +	size_t		n;
> +
> +	while (count) {

It might be nice to lift this from ext4/f2fs into common code rather
than adding yet another duplicate.

> +static int
> +xfs_fsverity_write(
> +	struct file		*file,
> +	loff_t			pos,
> +	size_t			length,
> +	const void		*buf)
> +{
> +	int			ret;
> +	struct iov_iter		iiter;
> +	struct kvec		kvec = {
> +		.iov_base	= (void *)buf,
> +		.iov_len	= length,
> +	};
> +	struct kiocb		iocb = {
> +		.ki_filp	= file,
> +		.ki_ioprio	= get_current_ioprio(),
> +		.ki_pos		= pos,
> +	};
> +
> +	iov_iter_kvec(&iiter, WRITE, &kvec, 1, length);
> +
> +	ret = iomap_file_buffered_write(&iocb, &iiter,
> +				   &xfs_buffered_write_iomap_ops,
> +				   &xfs_iomap_write_ops, NULL);
> +	if (ret < 0)
> +		return ret;
> +	return 0;

I'd move this to fs/iomap/ as and pass in the ops.

> +static int
> +xfs_fsverity_drop_descriptor_page(
> +	struct inode	*inode,
> +	u64		offset)
> +{
> +	pgoff_t index = offset >> PAGE_SHIFT;
> +
> +	return invalidate_inode_pages2_range(inode->i_mapping, index, index);
> +}

What is the rationale for this?  Why do ext4 and f2fs get away without
it?

> +	pgoff_t			index)
> +{
> +	pgoff_t			metadata_idx =
> +		(fsverity_metadata_offset(inode) >> PAGE_SHIFT);
> +	pgoff_t			idx = index + metadata_idx;
> +
> +	return generic_read_merkle_tree_page(inode, idx);

I'd write this the same way ext4/f2fs do:

	idx += (fsverity_metadata_offset(inode) >> PAGE_SHIFT);
	return generic_read_merkle_tree_page(inode, idx);



> +{
> +	pgoff_t			metadata_idx =
> +		(fsverity_metadata_offset(inode) >> PAGE_SHIFT);
> +	pgoff_t			idx = index + metadata_idx;
> +
> +	generic_readahead_merkle_tree(inode, idx, nr_pages);

Same here.

> +	if ((i == size) && (size == ip->i_mount->m_sb.sb_blocksize))

No need for the inner braces.

