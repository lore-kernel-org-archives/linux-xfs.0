Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1242DA75A;
	Tue, 10 Feb 2026 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740350; cv=none; b=i/9AOmgyvBMvtsFYfW1FW8tYxx/aI//kUhdW01sPkC0rEayXKB2g7ISzvcwF7Hps2Ga/oj4TQfbfktdiQiTNYrTDVkyIbTU0qzMn4azbT7n5tjyTrAjhSFU2/qZq59FIDxKsZGC1lE0BOaLRNvd5u6e/ZljxbqW2UW9fB1B14dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740350; c=relaxed/simple;
	bh=DJgpqDgCDLe3uWVySnf1XSHMXSBUe6qPOwn/xpZjWJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VrXdM55jLzCRU8VavIktzOTsjzRNiCq18Q4Nwe1HcIzCqpoHu/LqvpI11zA58a6/SR4VKlhNWOd+vd3DJYnoFg9XesMgMZaO1cLr0miTVffqEBRDyYXkBZGsSqGVYXLRdupclipXsWXxqLVOr9nLQ5Wi7bY/zbT6mRa7Uvl/pxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sgxfn2gV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sgxfn2gV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PGesva70mslEDm8VYYOxxhMMj39lZTeJUpaUgZeqCFs=; b=Sgxfn2gV3O8tsllkd4lZB+PbMS
	C/LKAKk9csEzyBZSndd0metDMHwo4WGhp//i2S9y1Ez0Fo2KnqEhAR2KbJwb62LWScAGz1SzmMQfy
	r1XFso1GnCyy03+4f68zj1zhFQzSUbP3IL4cQHnhOaROw9BHgfVKJeaZyxE7NHFXrhcLHFvWRRhI/
	EwAnenzyDSPpwNTXtce3wzDwrYDY0HhWRFv3XYkRu6LjozQCy+6FWbQUdlVicjRQatRdq0h5X2Z8o
	4bZuy+g6VT6+Ge64agQZOimRzwe8N6MvSs+Onn1wWes7opNCGkFye2G2/r5LuQ33yVXBUcY+z0mcx
	j2VKT3cA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpqSD-0000000HDJQ-1qtf;
	Tue, 10 Feb 2026 16:19:09 +0000
Date: Tue, 10 Feb 2026 08:19:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/5] xfs: only flush when COW fork blocks overlap data
 fork holes
Message-ID: <aYtafWEg11UBZwge@infradead.org>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-5-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129155028.141110-5-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 29, 2026 at 10:50:27AM -0500, Brian Foster wrote:
> The zero range hole mapping flush case has been lifted from iomap
> into XFS. Now that we have more mapping context available from the
> ->iomap_begin() handler, we can isolate the flush further to when we
> know a hole is fronted by COW blocks.
> 
> Rather than purely rely on pagecache dirty state, explicitly check
> for the case where a range is a hole in both forks. Otherwise trim
> to the range where there does happen to be overlap and use that for
> the pagecache writeback check. This might prevent some spurious
> zeroing, but more importantly makes it easier to remove the flush
> entirely.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_iomap.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 0edab7af4a10..0e82b4ec8264 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1760,10 +1760,12 @@ xfs_buffered_write_iomap_begin(
>  {
>  	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
>  						     iomap);
> +	struct address_space	*mapping = inode->i_mapping;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
> +	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
>  	struct xfs_bmbt_irec	imap, cmap;
>  	struct xfs_iext_cursor	icur, ccur;
>  	xfs_fsblock_t		prealloc_blocks = 0;
> @@ -1831,6 +1833,8 @@ xfs_buffered_write_iomap_begin(
>  		}
>  		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
>  				&ccur, &cmap);
> +		if (!cow_eof)
> +			cow_fsb = cmap.br_startoff;
>  	}
>  
>  	/* We never need to allocate blocks for unsharing a hole. */
> @@ -1845,17 +1849,37 @@ xfs_buffered_write_iomap_begin(
>  	 * writeback to remap pending blocks and restart the lookup.
>  	 */
>  	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
> -		if (filemap_range_needs_writeback(inode->i_mapping, offset,
> -						  offset + count - 1)) {
> +		loff_t start, end;
> +
> +		imap.br_blockcount = imap.br_startoff - offset_fsb;
> +		imap.br_startoff = offset_fsb;
> +		imap.br_startblock = HOLESTARTBLOCK;
> +		imap.br_state = XFS_EXT_NORM;
> +
> +		if (cow_fsb == NULLFILEOFF) {
> +			goto found_imap;
> +		} else if (cow_fsb > offset_fsb) {

No need for an else after a goto.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I wonder if at some point the zeroing logic should be split into a
separate helper..
