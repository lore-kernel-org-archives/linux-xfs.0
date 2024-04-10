Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D687920E3
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729885; cv=none; b=Hk7l9GFutRKV8ktjh5LOTFM/xYNzYl18vy6Oqe+yk1NSnjJMx+n7zvOm0tsfbENZcldiTaTYvpBBRsTdh/W3HaJiRZdvx2LH3Jpg/rL+m0HQK+G8T8fd344i7+apZa3pp181r3JOAm71gJWIvXLc32/D9qda4dtVUpco3f/T/M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729885; c=relaxed/simple;
	bh=PfjDjm6H28SQDfNCH5gqaFjey42s9y43g8UyVQ8fAIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VLy5xvyAg18xdBz7pEf4A2zFQPD7k9VOHNAWbO/2ujzDQtw0/jl3EIdj54+U6bmRrLgteht/6rb1cjDpdl/c1EdNb041g2ox6lNIdP+9AhkrGRKfhvJT73qpVKNKplPWUWjTbwA19hiJzKrdzeW04ZEmsQCe/+9tZdKhFSrpSf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1PBgaKsq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1PBgaKsq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qXFznyZ3s5kcxo+aSOaH2gceoS3aTBFzvKOwCPwKL5c=; b=1PBgaKsqI9asU4oS/OgP782n7F
	oD0OQz8Dxx+CmFybek8rR4nLbZJ4ww8sE8z4ieT/Oc4PtN5Sv4wcDmK50x8h5cI67dxm22yy0JwgK
	7yGKTMI0drXgpfWUxbMaJYw/BfYllbL8vZpZ72db8zJ+0l41yTsCdeJOK+SKBGsyU/C2ap3QGb+7T
	+0VSQhRmNJtbdqnXXp2uzKeRCflpmsFV0IcpiwuuCKLIwLlvy6o9sMTj11AZeY6TFZHXXAot2Bx6Z
	7galeV2rYuKiNF7dXODZMkSeo1GnWyRDVx2Plpg1pyt6IfDSgTs9UPSSY0iv0AjlAWTPTLDl1mwHN
	pYUH5nbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRHX-00000005Ljq-0SCg;
	Wed, 10 Apr 2024 06:18:03 +0000
Date: Tue, 9 Apr 2024 23:18:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: add xattr setname and removename functions
 for internal users
Message-ID: <ZhYvG1_eNLVKu3Ag@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971004.3632937.5852027532367765797.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971004.3632937.5852027532367765797.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static int
> +xfs_attr_ensure_iext(
> +	struct xfs_da_args	*args,
> +	int			nr)
> +{
> +	int			error;
> +
> +	error = xfs_iext_count_may_overflow(args->dp, XFS_ATTR_FORK, nr);
> +	if (error == -EFBIG)
> +		return xfs_iext_count_upgrade(args->trans, args->dp, nr);
> +	return error;
> +}

I'd rather get my consolidation of these merged instead of adding
a wrapper like this.  Just waiting for my RT delalloc and your
exchrange series to hit for-next to resend it.

> +/*
> + * Ensure that the xattr structure maps @args->name to @args->value.
> + *
> + * The caller must have initialized @args, attached dquots, and must not hold
> + * any ILOCKs.  Only XATTR_CREATE may be specified in @args->xattr_flags.
> + * Reserved data blocks may be used if @rsvd is set.
> + *
> + * Returns -EEXIST if XATTR_CREATE was specified and the name already exists.
> + */
> +int
> +xfs_attr_setname(

Is there any case where we do not want to pass XATTR_CREATE, that
is replace an existing attribute when there is one?

> +int
> +xfs_attr_removename(
> +	struct xfs_da_args	*args,
> +	bool			rsvd)
> +{

Is there a good reason to have a separate remove helper and not
overload a NULL value like we do for the normal xattr interface?

