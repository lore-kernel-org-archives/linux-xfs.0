Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C5219992E
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724244153; cv=none; b=IjxA5juQFCNrATdui+OyZo8YYc3gfqtF754yNLLLqBXi1Yn0Ry46B+sKFER1nC04KL/iEfvEL/VyiY1iuNJzAttV+k8Fc3JZXwUKsREDLGYKm5TOkGowvf7bq+uISmYTwWCzLUErmBafuWLToWZn60sK8iIUq1ND8XPu53QNM2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724244153; c=relaxed/simple;
	bh=pr8x7xBt3dnAXdKyyFYrTYZ+tmy4IjB6fVtdw8MXI+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8g6di2M1zbn0giqlBeuv9A6YjvChsArgtrv+EN2zGIHS7IPmiZmGPIoO8Q/ri7tv4+7tcKk8EugMPYIC1holroK/OmYoB0g8fsgGAh+NJgpH88sH8fILLJyvaYhGek22jPlOW0p23MhnzrcuFMLuUWy+Dk1meQMgJvb4DEE7cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aiut9/B+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aiut9/B+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724244149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=biTZDxY9LzT9VXX6oFguiB/o8AtQcaw6tBVuWVqguuU=;
	b=aiut9/B+UPxN2gErpmeT7bod3PIbqDcNwCq5MCpPPmtxpLLGQN+OVUp6leP+qjAXme5JDp
	Li33CIHynnO3SFyIJur8+7VM1A+1wjH97vke5E84CUi4TPj4oE10elKeDq//K2RHhMVeB4
	YvXTy2jUBYVfuYlZBZ55QDZM+8yTZZQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-HWoGUg1aOKeBQaKn5vqlFw-1; Wed,
 21 Aug 2024 08:42:23 -0400
X-MC-Unique: HWoGUg1aOKeBQaKn5vqlFw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 676401955D4B;
	Wed, 21 Aug 2024 12:42:21 +0000 (UTC)
Received: from bfoster (unknown [10.22.33.147])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26D0B3002240;
	Wed, 21 Aug 2024 12:42:18 +0000 (UTC)
Date: Wed, 21 Aug 2024 08:43:14 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/6] fs: sort out the fallocate mode vs flag mess
Message-ID: <ZsXg4mUWsTya0dNu@bfoster>
References: <20240821063108.650126-1-hch@lst.de>
 <20240821063108.650126-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821063108.650126-4-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Aug 21, 2024 at 08:30:29AM +0200, Christoph Hellwig wrote:
> The fallocate system call takes a mode argument, but that argument
> contains a wild mix of exclusive modes and an optional flags.
> 
> Replace FALLOC_FL_SUPPORTED_MASK with FALLOC_FL_MODE_MASK, which excludes
> the optional flag bit, so that we can use switch statement on the value
> to easily enumerate the cases while getting the check for duplicate modes
> for free.
> 
> To make this (and in the future the file system implementations) more
> readable also add a symbolic name for the 0 mode used to allocate blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/open.c                   | 53 ++++++++++++++++++-------------------
>  include/linux/falloc.h      | 18 ++++++++-----
>  include/uapi/linux/falloc.h |  1 +
>  3 files changed, 39 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 22adbef7ecc2a6..c598d2071c45cc 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -252,42 +252,41 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (offset < 0 || len <= 0)
>  		return -EINVAL;
>  
> -	/* Return error if mode is not supported */
> -	if (mode & ~FALLOC_FL_SUPPORTED_MASK)
> +	if (mode & ~(FALLOC_FL_MODE_MASK | FALLOC_FL_KEEP_SIZE))
>  		return -EOPNOTSUPP;
>  
> -	/* Punch hole and zero range are mutually exclusive */
> -	if ((mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) ==
> -	    (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE))
> -		return -EOPNOTSUPP;
> -
> -	/* Punch hole must have keep size set */
> -	if ((mode & FALLOC_FL_PUNCH_HOLE) &&
> -	    !(mode & FALLOC_FL_KEEP_SIZE))
> +	/*
> +	 * Modes are exclusive, even if that is not obvious from the encoding
> +	 * as bit masks and the mix with the flag in the same namespace.
> +	 *
> +	 * To make things even more complicated, FALLOC_FL_ALLOCATE_RANGE is
> +	 * encoded as no bit set.
> +	 */
> +	switch (mode & FALLOC_FL_MODE_MASK) {
> +	case FALLOC_FL_ALLOCATE_RANGE:
> +	case FALLOC_FL_UNSHARE_RANGE:
> +	case FALLOC_FL_ZERO_RANGE:
> +		break;
> +	case FALLOC_FL_PUNCH_HOLE:
> +		if (!(mode & FALLOC_FL_KEEP_SIZE))
> +			return -EOPNOTSUPP;
> +		break;
> +	case FALLOC_FL_COLLAPSE_RANGE:
> +	case FALLOC_FL_INSERT_RANGE:
> +		if (mode & FALLOC_FL_KEEP_SIZE)
> +			return -EOPNOTSUPP;
> +		break;
> +	default:
>  		return -EOPNOTSUPP;
> -
> -	/* Collapse range should only be used exclusively. */
> -	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> -	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
> -		return -EINVAL;
> -
> -	/* Insert range should only be used exclusively. */
> -	if ((mode & FALLOC_FL_INSERT_RANGE) &&
> -	    (mode & ~FALLOC_FL_INSERT_RANGE))
> -		return -EINVAL;
> -
> -	/* Unshare range should only be used with allocate mode. */
> -	if ((mode & FALLOC_FL_UNSHARE_RANGE) &&
> -	    (mode & ~(FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_KEEP_SIZE)))
> -		return -EINVAL;
> +	}
>  
>  	if (!(file->f_mode & FMODE_WRITE))
>  		return -EBADF;
>  
>  	/*
> -	 * We can only allow pure fallocate on append only files
> +	 * We can only allow pure space allocation on append only files.
>  	 */
> -	if ((mode & ~FALLOC_FL_KEEP_SIZE) && IS_APPEND(inode))
> +	if (mode != FALLOC_FL_ALLOCATE_RANGE && IS_APPEND(inode))
>  		return -EPERM;

Unless I'm misreading, this changes semantics by enforcing that we
cannot use KEEP_SIZE on append only files. That means one can no longer
do a post-eof prealloc without actually changing the file size, which on
a quick test seems to work today.

That aside, this all looks like a nice cleanup to me.

Brian

>  
>  	if (IS_IMMUTABLE(inode))
> diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> index f3f0b97b167579..3f49f3df6af5fb 100644
> --- a/include/linux/falloc.h
> +++ b/include/linux/falloc.h
> @@ -25,12 +25,18 @@ struct space_resv {
>  #define FS_IOC_UNRESVSP64	_IOW('X', 43, struct space_resv)
>  #define FS_IOC_ZERO_RANGE	_IOW('X', 57, struct space_resv)
>  
> -#define	FALLOC_FL_SUPPORTED_MASK	(FALLOC_FL_KEEP_SIZE |		\
> -					 FALLOC_FL_PUNCH_HOLE |		\
> -					 FALLOC_FL_COLLAPSE_RANGE |	\
> -					 FALLOC_FL_ZERO_RANGE |		\
> -					 FALLOC_FL_INSERT_RANGE |	\
> -					 FALLOC_FL_UNSHARE_RANGE)
> +/*
> + * Mask of all supported fallocate modes.  Only one can be set at a time.
> + *
> + * In addition to the mode bit, the mode argument can also encode flags.
> + * FALLOC_FL_KEEP_SIZE is the only supported flag so far.
> + */
> +#define FALLOC_FL_MODE_MASK	(FALLOC_FL_ALLOCATE_RANGE |	\
> +				 FALLOC_FL_PUNCH_HOLE |		\
> +				 FALLOC_FL_COLLAPSE_RANGE |	\
> +				 FALLOC_FL_ZERO_RANGE |		\
> +				 FALLOC_FL_INSERT_RANGE |	\
> +				 FALLOC_FL_UNSHARE_RANGE)
>  
>  /* on ia32 l_start is on a 32-bit boundary */
>  #if defined(CONFIG_X86_64)
> diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> index 51398fa57f6cdf..5810371ed72bbd 100644
> --- a/include/uapi/linux/falloc.h
> +++ b/include/uapi/linux/falloc.h
> @@ -2,6 +2,7 @@
>  #ifndef _UAPI_FALLOC_H_
>  #define _UAPI_FALLOC_H_
>  
> +#define FALLOC_FL_ALLOCATE_RANGE 0x00 /* allocate range */
>  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
>  #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
>  #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
> -- 
> 2.43.0
> 
> 

