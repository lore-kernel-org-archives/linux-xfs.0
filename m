Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F7A20B814
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738603172; cv=none; b=h4iXtKvtJ8ExvGGX/NSIvNYFxdqFqlldID7afe0I0mJ/DS2te4OS+UmH1I28JvdRrG5RVxnr5oVi1wZJFCWBdiUUWAareYZGTAtyfM7obxZVogR/biFv9TyPNdPmoTvVl+lSQxLZzgI7Bi8fk6Bc3ZNr7l9L5nQqHBNxZn6OaXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738603172; c=relaxed/simple;
	bh=y649eFD2uKHXaQ1jxkumqPfhYEMhlXhiOulG4XWssvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g3v/hu26n5WdnCMVv0WqgCq2k1b76vqJ/U/85k9LJPBujaA0ou8eOVG9L+7ysD4TnTuYkUo+mX9BXSj9ReWU3p5aW1K2DFPbvpu//hZFPGRHbRl84nG1goVzwloWUAkNt4A7A/1SsaQWvzJuMOvtsQ47IEwZMevetgFu7VF9Tto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQuTGrMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQuTGrMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECF8C4CED2;
	Mon,  3 Feb 2025 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738603171;
	bh=y649eFD2uKHXaQ1jxkumqPfhYEMhlXhiOulG4XWssvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tQuTGrMi49sYfoJ63Kiv1ntJ//e7wLRCOBXij1hKm4l9GYaveOEvX/bS4g5XSr4+E
	 zR27ramzrxktc5jlLoQ9so/3r2IFX44poOoUPIbwk3nQRmyb2dchEN3muKYeM1zpny
	 TXlRl+e8vDimF230/MkeitL9Ozs6PmJHL71RcJqGIIfN8b7+dXmJwDvDuih7sjbSLB
	 6gIhRvWTE+1nEcTEkbiSDZa1f7avzGi8LdT7C64oqMR6L6Pn7SUFiJrDBLEtIxFc0F
	 bGnPqeq1FEfpHn/j7ZT7rHETmU9zzYQ0MGPCoEKRUC9q4VPoXxngE0tuMxLTBm40BT
	 pgQUir54J4gPg==
Date: Mon, 3 Feb 2025 09:19:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Message-ID: <20250203171930.GA134532@frogsfrogsfrogs>
References: <20250203163425.125272-1-axboe@kernel.dk>
 <20250203163425.125272-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203163425.125272-2-axboe@kernel.dk>

On Mon, Feb 03, 2025 at 09:32:38AM -0700, Jens Axboe wrote:
> Add iomap buffered write support for RWF_DONTCACHE. If RWF_DONTCACHE is
> set for a write, mark the folios being written as uncached. Then
> writeback completion will drop the pages. The write_iter handler simply
> kicks off writeback for the pages, and writeback completion will take
> care of the rest.
> 
> This still needs the user of the iomap buffered write helpers to call
> folio_end_dropbehind_write() upon successful issue of the writes.

I thought iomap calls folio_end_writeback, which cares of that?  So xfs
doesn't itself have to call folio_end_dropbehind_write?

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/iomap/buffered-io.c | 4 ++++
>  include/linux/iomap.h  | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d303e6c8900c..ea863c3cf510 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -603,6 +603,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
>  
>  	if (iter->flags & IOMAP_NOWAIT)
>  		fgp |= FGP_NOWAIT;
> +	if (iter->flags & IOMAP_DONTCACHE)
> +		fgp |= FGP_DONTCACHE;
>  	fgp |= fgf_set_order(len);
>  
>  	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
> @@ -1034,6 +1036,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		iter.flags |= IOMAP_NOWAIT;
> +	if (iocb->ki_flags & IOCB_DONTCACHE)
> +		iter.flags |= IOMAP_DONTCACHE;
>  
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.processed = iomap_write_iter(&iter, i);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 75bf54e76f3b..26b0dbe23e62 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -183,6 +183,7 @@ struct iomap_folio_ops {
>  #define IOMAP_DAX		0
>  #endif /* CONFIG_FS_DAX */
>  #define IOMAP_ATOMIC		(1 << 9)
> +#define IOMAP_DONTCACHE		(1 << 10)

This needs a mention in the iomap documentation.  If the patch below
accurately summarizes what it does nowadays, then you can add it to the
series with a:

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

--D

diff --git a/Documentation/filesystems/iomap/design.rst b/Documentation/filesystems/iomap/design.rst
index b0d0188a095e55..7b91546750f59e 100644
--- a/Documentation/filesystems/iomap/design.rst
+++ b/Documentation/filesystems/iomap/design.rst
@@ -352,6 +352,11 @@ operations:
    ``IOMAP_NOWAIT`` is often set on behalf of ``IOCB_NOWAIT`` or
    ``RWF_NOWAIT``.
 
+ * ``IOMAP_DONTCACHE`` is set when the caller wishes to perform a
+   buffered file I/O and would like the kernel to drop the pagecache
+   after the I/O completes, if it isn't already being used by another
+   thread.
+
 If it is necessary to read existing file contents from a `different
 <https://lore.kernel.org/all/20191008071527.29304-9-hch@lst.de/>`_
 device or address range on a device, the filesystem should return that
diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
index 2c7f5df9d8b037..584ff549f9a659 100644
--- a/Documentation/filesystems/iomap/operations.rst
+++ b/Documentation/filesystems/iomap/operations.rst
@@ -131,6 +131,8 @@ These ``struct kiocb`` flags are significant for buffered I/O with iomap:
 
  * ``IOCB_NOWAIT``: Turns on ``IOMAP_NOWAIT``.
 
+ * ``IOCB_DONTCACHE``: Turns on ``IOMAP_DONTCACHE``.
+
 Internal per-Folio State
 ------------------------
 
