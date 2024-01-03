Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD491F932
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 23:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJwWBLta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72710C433C7;
	Wed,  3 Jan 2024 23:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704325730;
	bh=kzeF/2gV5HVrILoCgSh0mi0TADbFSXOraWovke+RBZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cJwWBLtaTd1jteJo43e4mb5XQufIqU5Z6B/x+LZccmzFhfUlCuFBQ7z0OdQ5K6l9O
	 h6f8SrS0Tbj6nt878Bx+vXpW5seicMicCIW1Mu9dI5rHdq4/mO8fnURb64oS5mh7LI
	 4Y/rSPc/74ZysJBwNZjXvHvudjxTvK8Rnmmw2DJDF0yOfZK3rHomTRXZwBs91Obamh
	 m3Njf4SiJndYQKWWMIBQMICU+X0RlWGq2xdOq/80gjsRUa8e43AS4swXkX3D9BU3tT
	 KVpm9DKjFQNaOZRRat+GTQekYZ7h+kdNWYQi2Cf+fy9FedioEFjtdB1SkB0jBgO1gK
	 R4uqV60P5i9Ag==
Date: Wed, 3 Jan 2024 15:48:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/15] xfs: remove the xfile_pread/pwrite APIs
Message-ID: <20240103234849.GY361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-6-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:16AM +0000, Christoph Hellwig wrote:
> All current and pending xfile users use the xfile_obj_load
> and xfile_obj_store API, so make those the actual implementation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  .../xfs/xfs-online-fsck-design.rst            | 10 +---
>  fs/xfs/scrub/trace.h                          |  4 +-
>  fs/xfs/scrub/xfile.c                          | 54 +++++++++----------
>  fs/xfs/scrub/xfile.h                          | 32 +----------
>  4 files changed, 30 insertions(+), 70 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> index 352516feef6ffe..324d5ec921e8e5 100644
> --- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> +++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> @@ -1915,19 +1915,13 @@ four of those five higher level data structures.
>  The fifth use case is discussed in the :ref:`realtime summary <rtsummary>` case
>  study.
>  
> -The most general storage interface supported by the xfile enables the reading
> -and writing of arbitrary quantities of data at arbitrary offsets in the xfile.
> -This capability is provided by ``xfile_pread`` and ``xfile_pwrite`` functions,
> -which behave similarly to their userspace counterparts.
>  XFS is very record-based, which suggests that the ability to load and store
>  complete records is important.
>  To support these cases, a pair of ``xfile_obj_load`` and ``xfile_obj_store``
> -functions are provided to read and persist objects into an xfile.
> -They are internally the same as pread and pwrite, except that they treat any
> -error as an out of memory error.
> +functions are provided to read and persist objects into an xfile that unlike
> +the pread and pwrite system calls treat any error as an out of memory error.

I don't think we need to mention pread and pwrite anymore.

"To support these cases, a pair of ``xfile_obj_load`` and ``xfile_obj_store``
functions are provided to read and persist objects into an xfile.  An errors
encountered here are treated as an out of memory error."

>  For online repair, squashing error conditions in this manner is an acceptable
>  behavior because the only reaction is to abort the operation back to userspace.
> -All five xfile usecases can be serviced by these four functions.
>  
>  However, no discussion of file access idioms is complete without answering the
>  question, "But what about mmap?"
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index ed9e044f6d603c..e6156d000fc615 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -903,8 +903,8 @@ DECLARE_EVENT_CLASS(xfile_class,
>  DEFINE_EVENT(xfile_class, name, \
>  	TP_PROTO(struct xfile *xf, loff_t pos, unsigned long long bytecount), \
>  	TP_ARGS(xf, pos, bytecount))
> -DEFINE_XFILE_EVENT(xfile_pread);
> -DEFINE_XFILE_EVENT(xfile_pwrite);
> +DEFINE_XFILE_EVENT(xfile_obj_load);
> +DEFINE_XFILE_EVENT(xfile_obj_store);

Want to shorten the names to xfile_load and xfile_store?  That's really
what they're doing anyway.

With those changes,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  DEFINE_XFILE_EVENT(xfile_seek_data);
>  DEFINE_XFILE_EVENT(xfile_get_page);
>  DEFINE_XFILE_EVENT(xfile_put_page);
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 87654cdd5ac6f9..9e25ecf3dc2fec 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -118,13 +118,11 @@ xfile_destroy(
>  }
>  
>  /*
> - * Read a memory object directly from the xfile's page cache.  Unlike regular
> - * pread, we return -E2BIG and -EFBIG for reads that are too large or at too
> - * high an offset, instead of truncating the read.  Otherwise, we return
> - * bytes read or an error code, like regular pread.
> + * Load an object.  Since we're treating this file as "memory", any error or
> + * short IO is treated as a failure to allocate memory.
>   */
> -ssize_t
> -xfile_pread(
> +int
> +xfile_obj_load(
>  	struct xfile		*xf,
>  	void			*buf,
>  	size_t			count,
> @@ -133,16 +131,15 @@ xfile_pread(
>  	struct inode		*inode = file_inode(xf->file);
>  	struct address_space	*mapping = inode->i_mapping;
>  	struct page		*page = NULL;
> -	ssize_t			read = 0;
>  	unsigned int		pflags;
>  	int			error = 0;
>  
>  	if (count > MAX_RW_COUNT)
> -		return -E2BIG;
> +		return -ENOMEM;
>  	if (inode->i_sb->s_maxbytes - pos < count)
> -		return -EFBIG;
> +		return -ENOMEM;
>  
> -	trace_xfile_pread(xf, pos, count);
> +	trace_xfile_obj_load(xf, pos, count);
>  
>  	pflags = memalloc_nofs_save();
>  	while (count > 0) {
> @@ -160,8 +157,10 @@ xfile_pread(
>  				__GFP_NOWARN);
>  		if (IS_ERR(page)) {
>  			error = PTR_ERR(page);
> -			if (error != -ENOMEM)
> +			if (error != -ENOMEM) {
> +				error = -ENOMEM;
>  				break;
> +			}
>  
>  			memset(buf, 0, len);
>  			goto advance;
> @@ -185,23 +184,18 @@ xfile_pread(
>  		count -= len;
>  		pos += len;
>  		buf += len;
> -		read += len;
>  	}
>  	memalloc_nofs_restore(pflags);
>  
> -	if (read > 0)
> -		return read;
>  	return error;
>  }
>  
>  /*
> - * Write a memory object directly to the xfile's page cache.  Unlike regular
> - * pwrite, we return -E2BIG and -EFBIG for writes that are too large or at too
> - * high an offset, instead of truncating the write.  Otherwise, we return
> - * bytes written or an error code, like regular pwrite.
> + * Store an object.  Since we're treating this file as "memory", any error or
> + * short IO is treated as a failure to allocate memory.
>   */
> -ssize_t
> -xfile_pwrite(
> +int
> +xfile_obj_store(
>  	struct xfile		*xf,
>  	const void		*buf,
>  	size_t			count,
> @@ -211,16 +205,15 @@ xfile_pwrite(
>  	struct address_space	*mapping = inode->i_mapping;
>  	const struct address_space_operations *aops = mapping->a_ops;
>  	struct page		*page = NULL;
> -	ssize_t			written = 0;
>  	unsigned int		pflags;
>  	int			error = 0;
>  
>  	if (count > MAX_RW_COUNT)
> -		return -E2BIG;
> +		return -ENOMEM;
>  	if (inode->i_sb->s_maxbytes - pos < count)
> -		return -EFBIG;
> +		return -ENOMEM;
>  
> -	trace_xfile_pwrite(xf, pos, count);
> +	trace_xfile_obj_store(xf, pos, count);
>  
>  	pflags = memalloc_nofs_save();
>  	while (count > 0) {
> @@ -239,8 +232,10 @@ xfile_pwrite(
>  		 */
>  		error = aops->write_begin(NULL, mapping, pos, len, &page,
>  				&fsdata);
> -		if (error)
> +		if (error) {
> +			error = -ENOMEM;
>  			break;
> +		}
>  
>  		/*
>  		 * xfile pages must never be mapped into userspace, so we skip
> @@ -259,13 +254,14 @@ xfile_pwrite(
>  		ret = aops->write_end(NULL, mapping, pos, len, len, page,
>  				fsdata);
>  		if (ret < 0) {
> -			error = ret;
> +			error = -ENOMEM;
>  			break;
>  		}
>  
> -		written += ret;
> -		if (ret != len)
> +		if (ret != len) {
> +			error = -ENOMEM;
>  			break;
> +		}
>  
>  		count -= ret;
>  		pos += ret;
> @@ -273,8 +269,6 @@ xfile_pwrite(
>  	}
>  	memalloc_nofs_restore(pflags);
>  
> -	if (written > 0)
> -		return written;
>  	return error;
>  }
>  
> diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
> index c602d11560d8ee..f0e11febf216a7 100644
> --- a/fs/xfs/scrub/xfile.h
> +++ b/fs/xfs/scrub/xfile.h
> @@ -29,38 +29,10 @@ struct xfile {
>  int xfile_create(const char *description, loff_t isize, struct xfile **xfilep);
>  void xfile_destroy(struct xfile *xf);
>  
> -ssize_t xfile_pread(struct xfile *xf, void *buf, size_t count, loff_t pos);
> -ssize_t xfile_pwrite(struct xfile *xf, const void *buf, size_t count,
> +int xfile_obj_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
> +int xfile_obj_store(struct xfile *xf, const void *buf, size_t count,
>  		loff_t pos);
>  
> -/*
> - * Load an object.  Since we're treating this file as "memory", any error or
> - * short IO is treated as a failure to allocate memory.
> - */
> -static inline int
> -xfile_obj_load(struct xfile *xf, void *buf, size_t count, loff_t pos)
> -{
> -	ssize_t	ret = xfile_pread(xf, buf, count, pos);
> -
> -	if (ret < 0 || ret != count)
> -		return -ENOMEM;
> -	return 0;
> -}
> -
> -/*
> - * Store an object.  Since we're treating this file as "memory", any error or
> - * short IO is treated as a failure to allocate memory.
> - */
> -static inline int
> -xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t pos)
> -{
> -	ssize_t	ret = xfile_pwrite(xf, buf, count, pos);
> -
> -	if (ret < 0 || ret != count)
> -		return -ENOMEM;
> -	return 0;
> -}
> -
>  loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
>  
>  int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
> -- 
> 2.39.2
> 
> 
