Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C328F40
	for <linux-xfs@vger.kernel.org>; Sat, 27 Jan 2024 01:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706318791; cv=none; b=dbnBlxNYFzx6URYX/BQzOkM3s4bEsEPP58NxtAIIdiddx6wSKkGhHD4NQYJxb6aJ9DZFKcKE1JJ37JmxPCFN05KGo/Qw2PpfCsseG4eEFpZN+WcI9B35ubPvY6E6iLspi5aQIFLn3xG3mT3TIDrblUkdeEu+nR1dWDdo2Y2DwyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706318791; c=relaxed/simple;
	bh=xHexHROsgUDIdo/rZVaFD3MOC/+fMMzEcCBPFHJ2EoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=os775jv7y52QciFWPOs4zh3uJcMLsoK/7CFp/1DtNVaCsa0qLwck1xVhxERtQhAOjn0PbrIJ0QrJPkPuMzWGqiU6duuyOwTG5OZfkiAJRKdNxN2V6tHRLIgHwCvz1TeBWp7HW31iaolU4zVobYP8MGIhpfs6NPngo0GZd/sgARs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BaDk5GW7; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BaDk5GW7"
Date: Fri, 26 Jan 2024 20:26:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706318786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Akf18JN8rrX0hJsrfsuEeXzfXlwZhkA1uJ+oIzKUYNs=;
	b=BaDk5GW7tEypSSCVI2N7K3xzkUNp0qvEC+FRaYDFuw0HBCy+WA/oVfUy+BLok9l68e19jt
	/jLNm5Shla+h1nBT26fb53J4UcaOHVuua35n2Xus59tFatBBCiPLMmt/RSltfWdagChs3b
	cyyzXBbYpxoVY+DzM9GIpPxqAw8HkbE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 17/21] xfs: add file_{get,put}_folio
Message-ID: <zfgublewgj5g6ipf2twkdl4kyvgttrvmigegxthgvc6ghdauwo@fej77ff4mtjs>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-18-hch@lst.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 26, 2024 at 02:28:59PM +0100, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Add helper similar to file_{get,set}_page, but which deal with folios
> and don't allocate new folio unless explicitly asked to, which map
> to shmem_get_folio instead of calling into the aops.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks boilerplatey to my eyes, but this is all new conceptual stuff and
the implementation will be evolving, so...

one nit: that's really not the right place for memalloc_nofs_save(), can
we try to start figuring out the proper locations for those?

Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>

> ---
>  fs/xfs/scrub/trace.h |  2 ++
>  fs/xfs/scrub/xfile.c | 74 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/xfile.h |  7 +++++
>  3 files changed, 83 insertions(+)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 0327cab606b070..c61fa7a95ef522 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -908,6 +908,8 @@ DEFINE_XFILE_EVENT(xfile_store);
>  DEFINE_XFILE_EVENT(xfile_seek_data);
>  DEFINE_XFILE_EVENT(xfile_get_page);
>  DEFINE_XFILE_EVENT(xfile_put_page);
> +DEFINE_XFILE_EVENT(xfile_get_folio);
> +DEFINE_XFILE_EVENT(xfile_put_folio);
>  
>  TRACE_EVENT(xfarray_create,
>  	TP_PROTO(struct xfarray *xfa, unsigned long long required_capacity),
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 2d802c20a8ddfe..1c1db4ae1ba6ee 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -365,3 +365,77 @@ xfile_put_page(
>  		return -EIO;
>  	return 0;
>  }
> +
> +/*
> + * Grab the (locked) folio for a memory object.  The object cannot span a folio
> + * boundary.  Returns the locked folio if successful, NULL if there was no
> + * folio or it didn't cover the range requested, or an ERR_PTR on failure.
> + */
> +struct folio *
> +xfile_get_folio(
> +	struct xfile		*xf,
> +	loff_t			pos,
> +	size_t			len,
> +	unsigned int		flags)
> +{
> +	struct inode		*inode = file_inode(xf->file);
> +	struct folio		*folio = NULL;
> +	unsigned int		pflags;
> +	int			error;
> +
> +	if (inode->i_sb->s_maxbytes - pos < len)
> +		return ERR_PTR(-ENOMEM);
> +
> +	trace_xfile_get_folio(xf, pos, len);
> +
> +	/*
> +	 * Increase the file size first so that shmem_get_folio(..., SGP_CACHE),
> +	 * actually allocates a folio instead of erroring out.
> +	 */
> +	if ((flags & XFILE_ALLOC) && pos + len > i_size_read(inode))
> +		i_size_write(inode, pos + len);
> +
> +	pflags = memalloc_nofs_save();
> +	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> +			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
> +	memalloc_nofs_restore(pflags);
> +	if (error)
> +		return ERR_PTR(error);
> +
> +	if (!folio)
> +		return NULL;
> +
> +	if (len > folio_size(folio) - offset_in_folio(folio, pos)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return NULL;
> +	}
> +
> +	if (xfile_has_lost_data(inode, folio)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return ERR_PTR(-EIO);
> +	}
> +
> +	/*
> +	 * Mark the folio dirty so that it won't be reclaimed once we drop the
> +	 * (potentially last) reference in xfile_put_folio.
> +	 */
> +	if (flags & XFILE_ALLOC)
> +		folio_set_dirty(folio);
> +	return folio;
> +}
> +
> +/*
> + * Release the (locked) folio for a memory object.
> + */
> +void
> +xfile_put_folio(
> +	struct xfile		*xf,
> +	struct folio		*folio)
> +{
> +	trace_xfile_put_folio(xf, folio_pos(folio), folio_size(folio));
> +
> +	folio_unlock(folio);
> +	folio_put(folio);
> +}
> diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
> index 465b10f492b66d..afb75e9fbaf265 100644
> --- a/fs/xfs/scrub/xfile.h
> +++ b/fs/xfs/scrub/xfile.h
> @@ -39,4 +39,11 @@ int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
>  		struct xfile_page *xbuf);
>  int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
>  
> +#define XFILE_MAX_FOLIO_SIZE	(PAGE_SIZE << MAX_PAGECACHE_ORDER)
> +
> +#define XFILE_ALLOC		(1 << 0) /* allocate folio if not present */
> +struct folio *xfile_get_folio(struct xfile *xf, loff_t offset, size_t len,
> +		unsigned int flags);
> +void xfile_put_folio(struct xfile *xf, struct folio *folio);
> +
>  #endif /* __XFS_SCRUB_XFILE_H__ */
> -- 
> 2.39.2
> 
