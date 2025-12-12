Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1DE2DF15B
	for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 12:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765542301; cv=none; b=ihedDfdi404ZDY++Kpi369FljvmWrluSTFedVueBmgxglxmCGbdak0Qr5P0XLih9XsxEgNI8yigverYk7sBLGd0lGzP8b9h2QrjZCesE7hxxbztllPu3AMz9+gN73Fpa7tixrwdkdE86p4F872YHLDzFgoh6/ssUdxIIlPKd+Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765542301; c=relaxed/simple;
	bh=NO1iFKrmKQcZzu+3V+BumcB8ZwMuHFgWkOQU25IF9pU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjB84sZSLlgsVgsj/Oe+H2Cr4At3GCWFtBmLmXxLKlyJO02rYxcOOKYL7+eBqxIrzV/G9sY8FtEKIlLKnb4gP59/kDoTWquID230RpvIwRukSMtXQoKefqgvfFcGIrUbcPnSaBNM/b+KIm2Jl1uvjGfR7XuOtXHdsb2I56+q+tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LX9Ab3ir; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LX9Ab3ir"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765542298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V6uNUdyRLE5MdUl0IH/UQNcxOSiD4sqw1D/xu3u1Rk4=;
	b=LX9Ab3irLKD34Kn3pQ+8mjiayQcjsG5ylGbk4OwWf7fabP7Wh9lXjyucqSAKUq4UPQNRXQ
	9IXmJTajjq61GoyUyDE0l/gYh7btmt4ju+QJn56r9qHGiHwbCMH7qzHrRfZbOvfi0wN3eR
	YBJnTB3mLBoxRbe8ry1SH4IGoqL7Sbo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-2pVXFB39OGaYP6eet0ChiQ-1; Fri,
 12 Dec 2025 07:24:57 -0500
X-MC-Unique: 2pVXFB39OGaYP6eet0ChiQ-1
X-Mimecast-MFC-AGG-ID: 2pVXFB39OGaYP6eet0ChiQ_1765542296
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B655180028B;
	Fri, 12 Dec 2025 12:24:56 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 965F8180045B;
	Fri, 12 Dec 2025 12:24:55 +0000 (UTC)
Date: Fri, 12 Dec 2025 07:24:53 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <aTwJlR6K04iD2E1L@bfoster>
References: <20251210090400.3642383-1-hch@lst.de>
 <aTmTl_khrrNz9yLY@bfoster>
 <20251210154016.GA3851@lst.de>
 <aTmqe3lDL2BkZe3b@bfoster>
 <20251212073937.GA30172@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212073937.GA30172@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Dec 12, 2025 at 08:39:37AM +0100, Christoph Hellwig wrote:
> On Wed, Dec 10, 2025 at 12:14:35PM -0500, Brian Foster wrote:
> > Well yeah, it would look something like this at the current site:
> > 
> > 	if (!is_inode_zoned() && XFS_TEST_ERROR(...) ||
> > 	    ac->reserved_blocks == magic_default_res + len)
> > 		xfs_zero_range(...);
> > 	else
> > 		xfs_free_file_space(...);
> > 
> > ... and the higher level zoned code would clone the XFS_TEST_ERROR() to
> > create the block reservation condition to trigger it.
> > 
> > Alternatively perhaps you could make that check look something like:
> > 
> > 	if (XFS_TEST_ERROR() && (!ac || ac->res > len))
> > 		...
> > 	else
> > 		...
> 
> I had to juggle this a bit to not trigger the wrong way and add a
> helper.  The changes are a bit bigger than the original version,
> but I guess you'll probably prefer it because it keeps things more
> contained in the zoned code?
> 

Thanks for taking a stab at this. I agree that the whole indirect logic
trigger based on res thing is a wart/tradeoff, but even still I think I
like this better probably for the reasons you stated. It feels more
encapsulated, and is still limited to DEBUG mode so doesn't worry me as
much.

A few minor comments below, but otherwise if this works for you and
there aren't strong opinions to the contrary:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6108612182e2..d70c8e0d802b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1240,6 +1240,28 @@ xfs_falloc_insert_range(
>  	return xfs_insert_file_space(XFS_I(inode), offset, len);
>  }
>  
> +#define XFS_ZONED_ZERO_RANGE_SPACE_RES		2
> +

This 2 block res isn't purely a zero range thing, right? It looks like
it's for a few different falloc ops.. perhaps ZONED_FALLOC_SPACE_RES (or
whatever else that is less zero specific)..?

> +/*
> + * Zero range implements a full zeroing mechanism but is only used in limited
> + * situations. It is more efficient to allocate unwritten extents than to
> + * perform zeroing here, so use an errortag to randomly force zeroing on DEBUG
> + * kernels for added test coverage.
> + *
> + * On zoned file systems, the error is already injected by
> + * xfs_file_zoned_fallocate, which then reserves the additional space needed.
> + * We only check for this extra space reservation here.
> + */
> +static inline bool
> +xfs_falloc_force_zero(
> +	struct xfs_inode		*ip,
> +	struct xfs_zone_alloc_ctx	*ac)
> +{
> +	if (ac)
> +		return ac->reserved_blocks > XFS_ZONED_ZERO_RANGE_SPACE_RES;

Random thought: I wonder if doing something like:

	if (!IS_ENABLED(CONFIG_XFS_DEBUG))
		return false;

... in this helper would shore up the logic a bit? Just a bit of
defensive logic against the indirection since the helper already exists.
I also wonder if that would help the compiler optimize this out on
!DEBUG builds.

> +	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
> +}
> +
>  /*
>   * Punch a hole and prealloc the range.  We use a hole punch rather than
>   * unwritten extent conversion for two reasons:
...
> @@ -1423,13 +1438,26 @@ xfs_file_zoned_fallocate(
>  {
>  	struct xfs_zone_alloc_ctx ac = { };
>  	struct xfs_inode	*ip = XFS_I(file_inode(file));
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_filblks_t		count_fsb;
>  	int			error;
>  
> -	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
> +	/*
> +	 * If full zeroing is forced by the error injection nob, we need a space

s/nob/knob/ ;)

Thanks!

Brian

