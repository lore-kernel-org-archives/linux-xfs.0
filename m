Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5730E3DDDAC;
	Mon, 27 Jul 2026 22:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785191340; cv=none; b=plXllDHtcjyfQp3Yfp55dgV+OwMNsXOrluM5ygf9YOAHZ0blBr9Qq11uMlq+ZPHktflm7MCQMND+GGB5wgwZN8lB5RbRHJusVXhy8owGt1yLZnzF6i/2mUhwHsZ6+KhulVFh2Zwes/Kqc5PTqOMgczPzbac9Sg17YuymYqePiPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785191340; c=relaxed/simple;
	bh=LnBdwBW4ikRKp4rtHiSlP0YcIuktuDnENHaGw0bKzbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hijQWYwJtZHbFrK6+GdQj52OUMVoF5EPX1SnR6TExHEul9pGIPGS9uhUjNf9VwSHyh9LuPvfp5d1mch31jrZoh5NYDXEeQXld9w9ApZ2OMSCdN3cGnbEAgwUeUW7QqATym/k1Ax+QXnDf8jt0oFcJB2Ws6n0AqOa44Ii6q8mKi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKxSLe0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKxSLe0F"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E525A1F000E9;
	Mon, 27 Jul 2026 22:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785191339;
	bh=U183ff5YkJREApMQuHbGeteiW5HSlDdg8TQozjGE480=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QKxSLe0FrHIyWmFUP2mT6t74D7sHq4eMzfe1tve/IELVhzTxFGWKHpXNG1UDB8+aL
	 auZHdDGNh92ub8ylXC5GAuWg4wOC6aXdMq00i+51dhnf+lFdOtNu7i2/Obg+apQJx4
	 Ve2HX4WIZorxUmKjSNs2O7oDdqi7Xn1t4/xFxsB6cv7mReWo9YSAtsG6jKmwK8TWAn
	 HXQ8gqRvPKEJZ6ebIwr15C1eswiV2cWs92BF8+G8iCmvQ/XozRKO4ZHeH9+546x5GX
	 nskvqbFFBnoru0uDhs0SlIrXrBjFfNmsuRUnNfIXx2QBgQPmj7vAZpmliTdX8omPPt
	 z/Jmr5NE7OYHQ==
Date: Mon, 27 Jul 2026 15:28:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de,
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 05/21] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260727222858.GH2901224@frogsfrogsfrogs>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
 <20260727211758.1116539-6-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727211758.1116539-6-joannelkoong@gmail.com>

On Mon, Jul 27, 2026 at 02:17:42PM -0700, Joanne Koong wrote:
> Convert xfs iomap_ops to the new ->iomap_next() callback. Each callback is
> generated with the DEFINE_IOMAP_ITER_NEXT()/DEFINE_IOMAP_ITER_NEXT_END()
> macros, which wrap the iomap_iter_next() helper to finish the previous
> mapping if needed and produce the next one. No functional changes are
> intended.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Nice straightforward conversion! :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c  |  4 ++--
>  fs/xfs/xfs_iomap.c | 39 +++++++++++++++++++++++++++++----------
>  2 files changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b733225d2864..768cabf6250b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -859,9 +859,9 @@ xfs_file_dio_write_atomic(
>  			NULL, 0);
>  
>  	/*
> -	 * The retry mechanism is based on the ->iomap_begin method returning
> +	 * The retry mechanism is based on the ->iomap_next method returning
>  	 * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write is not
> -	 * possible. The REQ_ATOMIC-based method typically not be possible if
> +	 * possible. The REQ_ATOMIC-based method is typically not possible if
>  	 * the write spans multiple extents or the disk blocks are misaligned.
>  	 */
>  	if (ret == -ENOPROTOOPT && dops == &xfs_direct_write_iomap_ops) {
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 0536e2aeddcc..71c45be8c652 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1037,8 +1037,11 @@ xfs_direct_write_iomap_begin(
>  	return error;
>  }
>  
> +static DEFINE_IOMAP_ITER_NEXT(xfs_direct_write_iomap_next,
> +		xfs_direct_write_iomap_begin);
> +
>  const struct iomap_ops xfs_direct_write_iomap_ops = {
> -	.iomap_begin		= xfs_direct_write_iomap_begin,
> +	.iomap_next		= xfs_direct_write_iomap_next,
>  };
>  
>  #ifdef CONFIG_XFS_RT
> @@ -1089,8 +1092,11 @@ xfs_zoned_direct_write_iomap_begin(
>  	return 0;
>  }
>  
> +static DEFINE_IOMAP_ITER_NEXT(xfs_zoned_direct_write_iomap_next,
> +		xfs_zoned_direct_write_iomap_begin);
> +
>  const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
> -	.iomap_begin		= xfs_zoned_direct_write_iomap_begin,
> +	.iomap_next		= xfs_zoned_direct_write_iomap_next,
>  };
>  #endif /* CONFIG_XFS_RT */
>  
> @@ -1274,8 +1280,11 @@ xfs_atomic_write_cow_iomap_begin(
>  	return error;
>  }
>  
> +static DEFINE_IOMAP_ITER_NEXT(xfs_atomic_write_cow_iomap_next,
> +		xfs_atomic_write_cow_iomap_begin);
> +
>  const struct iomap_ops xfs_atomic_write_cow_iomap_ops = {
> -	.iomap_begin		= xfs_atomic_write_cow_iomap_begin,
> +	.iomap_next		= xfs_atomic_write_cow_iomap_next,
>  };
>  
>  static int
> @@ -1298,9 +1307,11 @@ xfs_dax_write_iomap_end(
>  	return xfs_reflink_end_cow(ip, pos, written);
>  }
>  
> +static DEFINE_IOMAP_ITER_NEXT_END(xfs_dax_write_iomap_next,
> +		xfs_direct_write_iomap_begin, xfs_dax_write_iomap_end);
> +
>  const struct iomap_ops xfs_dax_write_iomap_ops = {
> -	.iomap_begin	= xfs_direct_write_iomap_begin,
> -	.iomap_end	= xfs_dax_write_iomap_end,
> +	.iomap_next	= xfs_dax_write_iomap_next,
>  };
>  
>  /*
> @@ -2168,9 +2179,11 @@ xfs_buffered_write_iomap_end(
>  	return 0;
>  }
>  
> +static DEFINE_IOMAP_ITER_NEXT_END(xfs_buffered_write_iomap_next,
> +		xfs_buffered_write_iomap_begin, xfs_buffered_write_iomap_end);
> +
>  const struct iomap_ops xfs_buffered_write_iomap_ops = {
> -	.iomap_begin		= xfs_buffered_write_iomap_begin,
> -	.iomap_end		= xfs_buffered_write_iomap_end,
> +	.iomap_next		= xfs_buffered_write_iomap_next,
>  };
>  
>  int
> @@ -2214,8 +2227,10 @@ xfs_read_iomap_begin(
>  				 shared ? IOMAP_F_SHARED : 0, seq);
>  }
>  
> +static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
> +
>  const struct iomap_ops xfs_read_iomap_ops = {
> -	.iomap_begin		= xfs_read_iomap_begin,
> +	.iomap_next		= xfs_read_iomap_next,
>  };
>  
>  static int
> @@ -2302,8 +2317,10 @@ xfs_seek_iomap_begin(
>  	return error;
>  }
>  
> +static DEFINE_IOMAP_ITER_NEXT(xfs_seek_iomap_next, xfs_seek_iomap_begin);
> +
>  const struct iomap_ops xfs_seek_iomap_ops = {
> -	.iomap_begin		= xfs_seek_iomap_begin,
> +	.iomap_next		= xfs_seek_iomap_next,
>  };
>  
>  static int
> @@ -2349,8 +2366,10 @@ xfs_xattr_iomap_begin(
>  	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
>  }
>  
> +static DEFINE_IOMAP_ITER_NEXT(xfs_xattr_iomap_next, xfs_xattr_iomap_begin);
> +
>  const struct iomap_ops xfs_xattr_iomap_ops = {
> -	.iomap_begin		= xfs_xattr_iomap_begin,
> +	.iomap_next		= xfs_xattr_iomap_next,
>  };
>  
>  int
> -- 
> 2.52.0
> 
> 
