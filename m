Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1129F48986A;
	Thu, 30 Jul 2026 07:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397523; cv=none; b=QpB8bfj7A+S2ebG771kOdNLra4WZUc5oaviOP8s5bYNGZsyZRPOSOc+G1y0od5QkM0iM20MCrah80bsTWkHyLvm62Jbr7KAo6YI6oao9Jpcfaj4D2EXqOJ6FJd2EKJPYK/5XqAmJiG5XMXm9Cg3P2k4QKgoKCD7GMeXFb80rQjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397523; c=relaxed/simple;
	bh=GmoWq6ygORDJSWwNT1d7flWz3XJXqdT/v36xiXmHo2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rrWqiCMUejj1omKFBVl8eoh+U2earaVs0uBRb3/vDODDo9s6X60A+sDYTM759bcofAGcQvfV2gMaQhtgFnVXZ2Jkekr4dyNl0j9oNqEv2QoVOyfSt9NJLNZvrxvIbqlabnxOgOuRi6H+MCPZ5og0y4ki3vcahukNU3xj7lmmB5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QyPg+PLG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QyPg+PLG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cgLmjrZdzGqgeCNG77DjIF5Q6BGAm3Y+Yu8lukm+PrE=; b=QyPg+PLGl6TDU/rgEY/+9CmGDe
	rNBadit96JAnbA+qf3xFOey3uJ1SbQXmzTt2+Bxpa02MuoNucHwbMZTRKo8O96+BS7Ek7nCY+SYLR
	YVVTAeF/uByCjNWlrtg+oJzYg66nZAqH4Os+3+apzzJIUjSOKNsaErwyDaxiwG7AGmU+XgR+aaCPF
	OvrZ1TjVDzNl3LEVii4x1p1uVe1ar7PrSqB8n974K89zZYkrUypGbOnvkmTJPzG2QnjavTOqwJw1s
	SVwXJ5hbTznmvubaeHXWz633W7/7g8wLgYaduARTjJPPvw1r7m8A4l1veXSP6iKLlOxe5DQ8fEU64
	QFJ+oiKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLSD-00000009lzN-1nsx;
	Thu, 30 Jul 2026 07:45:21 +0000
Date: Thu, 30 Jul 2026 00:45:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
Message-ID: <amsBEVNnsYJjKGpK@infradead.org>
References: <e69cc8a4a9c3f641b97872b50f04c397880077cd.1785374485.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e69cc8a4a9c3f641b97872b50f04c397880077cd.1785374485.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 10:52:10AM +0930, Qu Wenruo wrote:
> [BUG]
> On the latest development branch, btrfs with 8K block size on 4K page
> sized systems will fail the following fsstress workload:
> 
>  # $fsstress -n 4 -d $mnt -s 1785675805 -v

Please add this to xfstests.

> +/*
> + * File systems that write out of place and always allocate new blocks
> + * need each bio to be block aligned as that's the unit of allocation.
> + */
> +static unsigned int iomap_dio_alignment(const struct iomap_iter *iter,
> +					const struct iomap_dio *dio)
> +{
> +	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED)
> +		return i_blocksize(iter->inode);
> +	return bdev_logical_block_size(iter->iomap.bdev);
> +}

This already exists in the VFS iomap tree (with a slightly different
prototype).

>  static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  {
> -	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
> +	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
> +	const unsigned int alignment = iomap_dio_alignment(iter, dio);
> +	const loff_t aligned_copied = round_down(copied, alignment);
>  
> -	dio->size += length;
> -	if (!length)
> +	iov_iter_revert(dio->submit.iter, copied - aligned_copied);
> +	dio->size += aligned_copied;
> +	if (!aligned_copied)
>  		return -EFAULT;
> -	return iomap_iter_advance(iter, length);
> +	return iomap_iter_advance(iter, aligned_copied);
>  }

iomap generall expects extents to be block aligned, how do you end up
with non-aligned reporting here?
