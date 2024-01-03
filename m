Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A191F60B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+aKQmV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C25C433C8;
	Wed,  3 Jan 2024 23:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704325534;
	bh=+Web8xkZaS1KX/ZP5BaYyZG69RzbOJE8V1JknxDSl28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+aKQmV2gjiZ6ppZVojvSMgE+QeU45tcHEcpwI64nnkzyVWYQjm5zgPeO7KSOGOVq
	 Pot/EkcTYyC07jRj4kKkJ6o7wZqWpsrywIRyl7ih8CzA9EpqMTHmHL5Z7AnZJ7iwkS
	 7cLcuzzI7yO+Ur0IfRiIgxr7LfLHIGyK3grG+pBoyWeGMckBPZPN+tHGJIFVZj4FeY
	 8Z5Dq9QfJ/vtT6ZIzPPzDV8HUnd2pKrvmWgeDqAYcnQNHlEKkp/sZxO07JRRgAayNn
	 czHiIFxBnCg2VF+kK+IejeDyjBW5FNU2i22Gl4KHpRaKtpEmTY+aFu5iXbvs+pqYj0
	 73d5gz32KRL+w==
Date: Wed, 3 Jan 2024 15:45:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/15] xfs: remove xfile_stat
Message-ID: <20240103234533.GX361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-5-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:15AM +0000, Christoph Hellwig wrote:
> vfs_getattr is needed to query inode attributes for unknown underlying
> file systems.  But shmemfs is well known for users of shmem_file_setup
> and shmem_read_mapping_page_gfp that rely on it not needing specific
> inode revalidation and having a normal mapping.  Remove the detour
> through the getattr method and an extra wrapper, and just read the
> inode size and i_bytes directly in the scrub tracing code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/trace.h | 34 ++++++++++------------------------
>  fs/xfs/scrub/xfile.c | 19 -------------------
>  fs/xfs/scrub/xfile.h |  7 -------
>  3 files changed, 10 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 6bbb4e8639dca6..ed9e044f6d603c 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -861,18 +861,11 @@ TRACE_EVENT(xfile_destroy,
>  		__field(loff_t, size)
>  	),
>  	TP_fast_assign(
> -		struct xfile_stat	statbuf;
> -		int			ret;
> -
> -		ret = xfile_stat(xf, &statbuf);
> -		if (!ret) {
> -			__entry->bytes = statbuf.bytes;
> -			__entry->size = statbuf.size;
> -		} else {
> -			__entry->bytes = -1;
> -			__entry->size = -1;
> -		}
> -		__entry->ino = file_inode(xf->file)->i_ino;
> +		struct inode		*inode = file_inode(xf->file);
> +
> +		__entry->ino = inode->i_ino;
> +		__entry->bytes = inode->i_bytes;

Shouldn't this be (i_blocks << 9) + i_bytes?

> +		__entry->size = i_size_read(inode);
>  	),
>  	TP_printk("xfino 0x%lx mem_bytes 0x%llx isize 0x%llx",
>  		  __entry->ino,
> @@ -891,19 +884,12 @@ DECLARE_EVENT_CLASS(xfile_class,
>  		__field(unsigned long long, bytecount)
>  	),
>  	TP_fast_assign(
> -		struct xfile_stat	statbuf;
> -		int			ret;
> -
> -		ret = xfile_stat(xf, &statbuf);
> -		if (!ret) {
> -			__entry->bytes_used = statbuf.bytes;
> -			__entry->size = statbuf.size;
> -		} else {
> -			__entry->bytes_used = -1;
> -			__entry->size = -1;
> -		}
> -		__entry->ino = file_inode(xf->file)->i_ino;
> +		struct inode		*inode = file_inode(xf->file);
> +
> +		__entry->ino = inode->i_ino;
> +		__entry->bytes_used = inode->i_bytes;

Here too.

>  		__entry->pos = pos;
> +		__entry->size = i_size_read(inode);
>  		__entry->bytecount = bytecount;
>  	),
>  	TP_printk("xfino 0x%lx mem_bytes 0x%llx pos 0x%llx bytecount 0x%llx isize 0x%llx",
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 090c3ead43fdf1..87654cdd5ac6f9 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -291,25 +291,6 @@ xfile_seek_data(
>  	return ret;
>  }
>  
> -/* Query stat information for an xfile. */
> -int
> -xfile_stat(
> -	struct xfile		*xf,
> -	struct xfile_stat	*statbuf)
> -{
> -	struct kstat		ks;
> -	int			error;
> -
> -	error = vfs_getattr_nosec(&xf->file->f_path, &ks,
> -			STATX_SIZE | STATX_BLOCKS, AT_STATX_DONT_SYNC);
> -	if (error)
> -		return error;
> -
> -	statbuf->size = ks.size;
> -	statbuf->bytes = ks.blocks << SECTOR_SHIFT;
> -	return 0;
> -}
> -
>  /*
>   * Grab the (locked) page for a memory object.  The object cannot span a page
>   * boundary.  Returns 0 (and a locked page) if successful, -ENOTBLK if we
> diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
> index d56643b0f429e1..c602d11560d8ee 100644
> --- a/fs/xfs/scrub/xfile.h
> +++ b/fs/xfs/scrub/xfile.h
> @@ -63,13 +63,6 @@ xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t pos)
>  
>  loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
>  
> -struct xfile_stat {
> -	loff_t			size;
> -	unsigned long long	bytes;
> -};
> -
> -int xfile_stat(struct xfile *xf, struct xfile_stat *statbuf);

Removing this function will put some distance between the kernel and
xfsprogs xfile implementations, since userspace can't do failure-free
fstat.  OTOH I guess if xfile_stat fails in userspace, our xfile is
screwed and we probably have to abort the whole program anyway.

For the kernel I like getting rid of this clutter, modulo the question
above.

--D

> -
>  int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
>  		struct xfile_page *xbuf);
>  int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
> -- 
> 2.39.2
> 
> 
