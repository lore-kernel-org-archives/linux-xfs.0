Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187933C3C0E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 09:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781689539; cv=none; b=FZ8RJIp1C6NA3FGrIivF32yJb0oAAlBVKFbK8kv+5Pk1gDMF2vHi22czfIDaxkPSFpFMaozRnU9RH8HhW23JnkoZ4Gh+c+MAPeu3hV2vdJPt+3mU2gH+E3URUiMlfDCl9TV+zRZ4d2MQiMMpWeh+NQoP6+txT63uIxNG1POd+34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781689539; c=relaxed/simple;
	bh=twlOvb2CoVN4w6Fqz+WMhzH21a+mb1zXpVSvI9ZJFIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4R9TTue9zj8DaDVQ+2JW/XshBfXLeLx1zF5qWscVjqwdC92Xx4uamOAWegMowznOPrCaVS9XT6klcnerZh7bK98k7Jvjt/P57GVvGFZxC/o6Xdu+ApAZ3uKIWDD5biWmztRlVYyer48BgYtK+6ZNnaHkCY3TukJCK1JML4MBVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ojt4Em5S; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ojt4Em5S"
Date: Wed, 17 Jun 2026 11:44:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781689525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iL7gXwiArhbYanz54F/a7E15TsUWqUH8XIrYW1qiax8=;
	b=Ojt4Em5SHuyFXs9QY6b73RwCDIQDbvdtVcKgdMlW3LgG+n2ZVYHXHKBK7u+PCH+rrDEl0o
	yiObqmlx3BFsj7v3nqctpQsRycOh20V87BQ8ZGnugasoIfzkR0qbMUXwNyn3QKm6NleG3y
	FcVcCbB2ccO0b5SqQ82iSBp/yd0Hl/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org, 
	bfoster@redhat.com, lukas@herbolt.com, "Darrick J . Wong" <djwong@kernel.org>, 
	dgc@kernel.org, gost.dev@samsung.com, andres@anarazel.de, 
	kundan.kumar@samsung.com, cem@kernel.org, Zhang Yi <yi.zhang@huawei.com>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v6 3/3] xfs: add support for FALLOC_FL_WRITE_ZEROES
Message-ID: <kn5dyqdxmsydibpfcurgpom5vwqtwinrz27oenh4pekks6ybdj@wyi4zkh7mogy>
References: <20260611114029.176200-4-p.raghav@samsung.com>
 <ajFQPANpajmFuKpi@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajFQPANpajmFuKpi@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 16, 2026 at 06:31:40AM -0700, Christoph Hellwig wrote:
> [API questions for Zhang and -fsdevel/ -api below)
> 
> > +	unsigned int		blksize = i_blocksize(inode);
> > +	loff_t			offset_aligned = round_down(offset, blksize);
> 
> I think this actually needs to found up instead of rounding down.
> 
> > +	/*
> > +	 * Zero the tail of the old EOF block and any space up to the new
> > +	 * offset.
> > +	 * In the usual truncate path, xfs_falloc_setsize takes care of
> > +	 * zeroing those blocks.
> > +	 */
> > +	if (offset_aligned > old_size) {
> > +		trace_xfs_zero_eof(ip, old_size, offset_aligned - old_size);
> > +		error = xfs_zero_range(ip, old_size, offset_aligned - old_size,
> > +				NULL, &did_zero);
> > +		if (error)
> > +			return error;
> > +	}
> 
> ... then this will properly zero from the old i_size to the first block
> boundary after the old size.

Hmm, right now we do this:

|----------|----------|----------|
    ^      ^     ^    ^
    |      |     |    |
 old_size  |   offset |
           |          |
	off_rd       off_ru

At the moment, we zero out old_size to off_rd and pass offset to
xfs_alloc_file_space. xfs_alloc_file_space rounds down the offset to off_rd.

What you are proposing is to zero out old_size to off_ru, and pass
off_ru to xfs_alloc_file_space. I don't exactly understand the
difference.

> 
> > +	error = xfs_alloc_file_space(ip, offset, len,
> > +			XFS_ALLOC_FILE_SPACE_WRITE_ZEROES);
> 
> ... and here we need to pass offset_aligned instead of offset and
> a new calculated len based on the last block boundary, and then
> zero again after that.  That is assuming FALLOC_FL_WRITE_ZEROES
> allows unaligned ranges for file systems.  The block code doesn't,
> but I can't quite follow the ext4 code if it does or not, and there
> is no mention of FALLOC_FL_WRITE_ZEROES even in the latest man-pages
> tree.


I can't find any references to FALLOC_FL_WRITE_ZEROES in the man pages
master branch. Maybe we missed it. I can send a separate patch for that
once we have some clarity on the API.
> 
> Maybe we also want xfstests that try unaligned FALLOC_FL_WRITE_ZEROES
> and make sure no existing data before the range is lost and the
> entire range is zeroed?
> 

I added FALLOC_FL_WRITE_ZEROES support to ltp (both fsx and fsstress).
For example, generic/363 tests for unaligned writes and checks for any
stale data. By default, I think we do unaligned reads, writes and
truncate in fsx.

> 
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * xfs_falloc_setsize() would re-zero the written extents via
> > +	 * iomap_zero_range(). Use xfs_setfilesize() instead.
> > +	 * Update in-core i_size first as xfs_setfilesize() clamps the on-disk
> > +	 * size to it.
> > +	 */
> > +	if (new_size > i_size_read(inode))
> > +		i_size_write(inode, new_size);
> 
> I think Sashiko is right that we need a pagecache_isize_extended and
> filemap_write_and_wait_range calls here.
> 

Ok. Current fsx or fsstress did not expose this
problem. I will look into this. Thanks Christoph.

--
Pankaj
