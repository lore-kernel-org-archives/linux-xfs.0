Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88EB7C6EB
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 09:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717147811; cv=none; b=crphtda7rTARLSOypj6YSjnAxjSbt13dhTtMN1JJs85enXfoic5G1lBN9oTAkOR6nbc+L/auK9eAB9AusA3ZFJa8G3qo4d4WiX467HrtQZNDYOTFZYuxVh86e2kAs5ieaN/jm2mvcngr3ihPajDsA/Doh9ySa2KtSR2LKk5Wfj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717147811; c=relaxed/simple;
	bh=RsJ9HsiI18Ocv3yZVkzhpn4NdbeXtPNdBYvgL+WjPks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P8QmLaa44EzmlhwOdFB36momRrjOoZhlDygFjAD21ZKi0yUbMEHbYH06Cgu/EVAmCykiSVef0IbDUTh7nIgp7RWMVTMDAwmpNbn39kPxkf/FO8l3AnBRSUbFgqRMPgsSjjKuR7X+J+2+HbxdS0SfuxkS+QmVJR2rP8ss49vIW24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIR4FicI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIR4FicI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C415C32786;
	Fri, 31 May 2024 09:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717147811;
	bh=RsJ9HsiI18Ocv3yZVkzhpn4NdbeXtPNdBYvgL+WjPks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KIR4FicIBXl4W71RnHhcIaQTU4WLbeSON0KjXcZ+vqcqKt5LQmcITimOXEi8fFvY8
	 8yKku0gkoL0uKbCnNnzClx78tMeYe2iAlRvuzB64CnBagTi0QW0h3RKLv0bAxTtt46
	 5Cea0uqDO+qddqNzyNZBZAHtUJB67GP+eCHUy8m+VdvCz/orFRFLAgxaC7pXOcBcV2
	 nN6prKxef2qqN/JuHP76qqY4a0W86yDws5rN6qA86XL1WpF3XBS+lYnOpU6ja26+HV
	 kCixlfM8cPxhrc1/CS9EgwnlNN/1227w03F0qzKCtDnwf6DHpziSTcdH+Bxzx1hRZF
	 5KO68g2I4MnsA==
Date: Fri, 31 May 2024 11:30:07 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 090/111] libxfs: partition memfd files to avoid using too
 many fds
Message-ID: <a33tbx6cnkaiifb5gqeimzilyq7rjwyofeaqtgyr4s3thklpxr@nu4oyfkt7tnj>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
 <HYSzgoK3nUyhNhA8gSk9r2MoBVWChVShzAFvYhwHuMHFjtCVQXsyz03IBl8RXAfYtaRIf42kNpBdk5Xo1b24UA==@protonmail.internalid>
 <171634533050.2478931.6745973902518195395.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171634533050.2478931.6745973902518195395.stgit@frogsfrogsfrogs>

On Tue, May 21, 2024 at 08:12:14PM GMT, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In a few patchsets from now, we'll transition xfs_repair to use
> memfd-backed rmap and rcbag btrees for storing repair data instead of
> heap allocations.  This allows repair to use libxfs code shared from the
> online repair code, which reduces the size of the codebase.  It also
> reduces heap fragmentation, which might be critical on 32-bit systems.
> 
> However, there's one hitch -- userspace xfiles naively allocate one
> memfd per data structure, but there's only so many file descriptors that
> a process can open.  If a filesystem has a lot of allocation groups, we
> can run out of fds and fail.  xfs_repair already tries to increase
> RLIMIT_NOFILE to the maximum (~1M) but this can fail due to system or
> memory constraints.
> 
> Fortunately, it is possible to compute the upper bound of a memfd btree,
> which implies that we can store multiple btrees per memfd.  Make it so
> that we can partition a memfd file to avoid running out of file
> descriptors.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

I usually see bigger problems on those filesystems like mount timing out, before users reach
system's max fd limit, but I'm ok with it if you've seen it in the wild. Giving that - in theory -
cloud instances resources are pretty limited, we could get to pretty small max fd limits, so it
seems fair to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxfs/xfile.c |  197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  libxfs/xfile.h |   17 ++++-
>  2 files changed, 205 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/libxfs/xfile.c b/libxfs/xfile.c
> index cba173cc1..fdb76f406 100644
> --- a/libxfs/xfile.c
> +++ b/libxfs/xfile.c
> @@ -97,6 +97,149 @@ xfile_create_fd(
>  	return fd;
>  }
> 
> +static LIST_HEAD(fcb_list);
> +static pthread_mutex_t fcb_mutex = PTHREAD_MUTEX_INITIALIZER;
> +
> +/* Create a new memfd. */
> +static inline int
> +xfile_fcb_create(
> +	const char		*description,
> +	struct xfile_fcb	**fcbp)
> +{
> +	struct xfile_fcb	*fcb;
> +	int			fd;
> +
> +	fd = xfile_create_fd(description);
> +	if (fd < 0)
> +		return -errno;
> +
> +	fcb = malloc(sizeof(struct xfile_fcb));
> +	if (!fcb) {
> +		close(fd);
> +		return -ENOMEM;
> +	}
> +
> +	list_head_init(&fcb->fcb_list);
> +	fcb->fd = fd;
> +	fcb->refcount = 1;
> +
> +	*fcbp = fcb;
> +	return 0;
> +}
> +
> +/* Release an xfile control block */
> +static void
> +xfile_fcb_irele(
> +	struct xfile_fcb	*fcb,
> +	loff_t			pos,
> +	uint64_t		len)
> +{
> +	/*
> +	 * If this memfd is linked only to itself, it's private, so we can
> +	 * close it without taking any locks.
> +	 */
> +	if (list_empty(&fcb->fcb_list)) {
> +		close(fcb->fd);
> +		free(fcb);
> +		return;
> +	}
> +
> +	pthread_mutex_lock(&fcb_mutex);
> +	if (--fcb->refcount == 0) {
> +		/* If we're the last user of this memfd file, kill it fast. */
> +		list_del(&fcb->fcb_list);
> +		close(fcb->fd);
> +		free(fcb);
> +	} else if (len > 0) {
> +		struct stat	statbuf;
> +		int		ret;
> +
> +		/*
> +		 * If we were using the end of a partitioned file, free the
> +		 * address space.  IOWs, bonus points if you delete these in
> +		 * reverse-order of creation.
> +		 */
> +		ret = fstat(fcb->fd, &statbuf);
> +		if (!ret && statbuf.st_size == pos + len) {
> +			ret = ftruncate(fcb->fd, pos);
> +		}
> +	}
> +	pthread_mutex_unlock(&fcb_mutex);
> +}
> +
> +/*
> + * Find an memfd that can accomodate the given amount of address space.
> + */
> +static int
> +xfile_fcb_find(
> +	const char		*description,
> +	uint64_t		maxbytes,
> +	loff_t			*posp,
> +	struct xfile_fcb	**fcbp)
> +{
> +	struct xfile_fcb	*fcb;
> +	int			ret;
> +	int			error;
> +
> +	/* No maximum range means that the caller gets a private memfd. */
> +	if (maxbytes == 0) {
> +		*posp = 0;
> +		return xfile_fcb_create(description, fcbp);
> +	}
> +
> +	/* round up to page granularity so we can do mmap */
> +	maxbytes = roundup_64(maxbytes, PAGE_SIZE);
> +
> +	pthread_mutex_lock(&fcb_mutex);
> +
> +	/*
> +	 * If we only need a certain number of byte range, look for one with
> +	 * available file range.
> +	 */
> +	list_for_each_entry(fcb, &fcb_list, fcb_list) {
> +		struct stat	statbuf;
> +		loff_t		pos;
> +
> +		ret = fstat(fcb->fd, &statbuf);
> +		if (ret)
> +			continue;
> +		pos = roundup_64(statbuf.st_size, PAGE_SIZE);
> +
> +		/*
> +		 * Truncate up to ensure that the memfd can actually handle
> +		 * writes to the end of the range.
> +		 */
> +		ret = ftruncate(fcb->fd, pos + maxbytes);
> +		if (ret)
> +			continue;
> +
> +		fcb->refcount++;
> +		*posp = pos;
> +		*fcbp = fcb;
> +		goto out_unlock;
> +	}
> +
> +	/* Otherwise, open a new memfd and add it to our list. */
> +	error = xfile_fcb_create(description, &fcb);
> +	if (error)
> +		return error;
> +
> +	ret = ftruncate(fcb->fd, maxbytes);
> +	if (ret) {
> +		error = -errno;
> +		xfile_fcb_irele(fcb, 0, maxbytes);
> +		return error;
> +	}
> +
> +	list_add_tail(&fcb->fcb_list, &fcb_list);
> +	*posp = 0;
> +	*fcbp = fcb;
> +
> +out_unlock:
> +	pthread_mutex_unlock(&fcb_mutex);
> +	return error;
> +}
> +
>  /*
>   * Create an xfile of the given size.  The description will be used in the
>   * trace output.
> @@ -104,6 +247,7 @@ xfile_create_fd(
>  int
>  xfile_create(
>  	const char		*description,
> +	unsigned long long	maxbytes,
>  	struct xfile		**xfilep)
>  {
>  	struct xfile		*xf;
> @@ -113,13 +257,14 @@ xfile_create(
>  	if (!xf)
>  		return -ENOMEM;
> 
> -	xf->fd = xfile_create_fd(description);
> -	if (xf->fd < 0) {
> -		error = -errno;
> +	error = xfile_fcb_find(description, maxbytes, &xf->partition_pos,
> +			&xf->fcb);
> +	if (error) {
>  		kfree(xf);
>  		return error;
>  	}
> 
> +	xf->maxbytes = maxbytes;
>  	*xfilep = xf;
>  	return 0;
>  }
> @@ -129,7 +274,7 @@ void
>  xfile_destroy(
>  	struct xfile		*xf)
>  {
> -	close(xf->fd);
> +	xfile_fcb_irele(xf->fcb, xf->partition_pos, xf->maxbytes);
>  	kfree(xf);
>  }
> 
> @@ -137,6 +282,9 @@ static inline loff_t
>  xfile_maxbytes(
>  	struct xfile		*xf)
>  {
> +	if (xf->maxbytes > 0)
> +		return xf->maxbytes;
> +
>  	if (sizeof(loff_t) == 8)
>  		return LLONG_MAX;
>  	return LONG_MAX;
> @@ -160,7 +308,7 @@ xfile_load(
>  	if (xfile_maxbytes(xf) - pos < count)
>  		return -ENOMEM;
> 
> -	ret = pread(xf->fd, buf, count, pos);
> +	ret = pread(xf->fcb->fd, buf, count, pos + xf->partition_pos);
>  	if (ret < 0)
>  		return -errno;
>  	if (ret != count)
> @@ -186,7 +334,7 @@ xfile_store(
>  	if (xfile_maxbytes(xf) - pos < count)
>  		return -EFBIG;
> 
> -	ret = pwrite(xf->fd, buf, count, pos);
> +	ret = pwrite(xf->fcb->fd, buf, count, pos + xf->partition_pos);
>  	if (ret < 0)
>  		return -errno;
>  	if (ret != count)
> @@ -194,6 +342,38 @@ xfile_store(
>  	return 0;
>  }
> 
> +/* Compute the number of bytes used by a partitioned xfile. */
> +static unsigned long long
> +xfile_partition_bytes(
> +	struct xfile		*xf)
> +{
> +	loff_t			data_pos = xf->partition_pos;
> +	loff_t			stop_pos = data_pos + xf->maxbytes;
> +	loff_t			hole_pos;
> +	unsigned long long	bytes = 0;
> +
> +	data_pos = lseek(xf->fcb->fd, data_pos, SEEK_DATA);
> +	while (data_pos >= 0 && data_pos < stop_pos) {
> +		hole_pos = lseek(xf->fcb->fd, data_pos, SEEK_HOLE);
> +		if (hole_pos < 0) {
> +			/* save error, break */
> +			data_pos = hole_pos;
> +			break;
> +		}
> +		if (hole_pos >= stop_pos) {
> +			bytes += stop_pos - data_pos;
> +			return bytes;
> +		}
> +		bytes += hole_pos - data_pos;
> +
> +		data_pos = lseek(xf->fcb->fd, hole_pos, SEEK_DATA);
> +	}
> +	if (data_pos < 0 && errno != ENXIO)
> +		return xf->maxbytes;
> +
> +	return bytes;
> +}
> +
>  /* Compute the number of bytes used by a xfile. */
>  unsigned long long
>  xfile_bytes(
> @@ -202,7 +382,10 @@ xfile_bytes(
>  	struct stat		statbuf;
>  	int			error;
> 
> -	error = fstat(xf->fd, &statbuf);
> +	if (xf->maxbytes > 0)
> +		return xfile_partition_bytes(xf);
> +
> +	error = fstat(xf->fcb->fd, &statbuf);
>  	if (error)
>  		return -errno;
> 
> diff --git a/libxfs/xfile.h b/libxfs/xfile.h
> index d60084011..180a42bbb 100644
> --- a/libxfs/xfile.h
> +++ b/libxfs/xfile.h
> @@ -6,11 +6,24 @@
>  #ifndef __LIBXFS_XFILE_H__
>  #define __LIBXFS_XFILE_H__
> 
> -struct xfile {
> +struct xfile_fcb {
> +	struct list_head	fcb_list;
>  	int			fd;
> +	unsigned int		refcount;
>  };
> 
> -int xfile_create(const char *description, struct xfile **xfilep);
> +struct xfile {
> +	struct xfile_fcb	*fcb;
> +
> +	/* File position within fcb->fd where this partition starts */
> +	loff_t			partition_pos;
> +
> +	/* Maximum number of bytes that can be written to the partition. */
> +	uint64_t		maxbytes;
> +};
> +
> +int xfile_create(const char *description, unsigned long long maxbytes,
> +		struct xfile **xfilep);
>  void xfile_destroy(struct xfile *xf);
> 
>  ssize_t xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
> 
