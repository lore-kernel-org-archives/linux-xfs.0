Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF5F8C1F
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381029; cv=none; b=PHYRqaf0W6EFm+Ntdl1Jbb1KmrRZkq1hJky8cduf7wdSB5ZWPoNw0L7r7+zgIvoz1PypcqA5dBrEuYhwuykRRwiH/MgOJpYMeUrHDZWlFkXxDHwYA8JFXo44lyOcH8RRpUWBxxY+4myQ+I7neqqpwr4LetgUepYdp0kFS8FNcK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381029; c=relaxed/simple;
	bh=2i2G7te7N6efJ6hk4+/6UXh9vdLysMDNYz1S7jHXVM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWCfBcAnPfVescifDa34k2EsJHPQ2UzymofzMpMlqESmaFxlV9KHcpomFjaismq7+Y9dC95MeuUE3rQPA7y1j9pi5OKtrsF1gjtwTCI1RDmTtzfSdtI0kk/f4F+Mgp3/pnTRbgXJvlw1pJvx46fGDdGvkDKPVKgueNYkRB5M2ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N3ZRKsNt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N3ZRKsNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765381026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nx7kNdjA1lZpPkx97uOWPXQqOjfARIxpl6rp5KrqxX8=;
	b=N3ZRKsNtLgOT5TOQ/m5AJdmBULOGbfQUXCtClKhUqXGOeYtEBamvPh8UlJN5xT8HfxqrFX
	ifQgya23DLCjF2XfpZK5yvAjanrfBHbP4OGH6aQyKxHya8QyIseDRnXw3s4rxfnJAfCYxn
	b7isY8p6aKbutEQNuw9rmm8NbKwM35Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-P8S1yN8-Oe6iXeE59ew9FQ-1; Wed,
 10 Dec 2025 10:36:59 -0500
X-MC-Unique: P8S1yN8-Oe6iXeE59ew9FQ-1
X-Mimecast-MFC-AGG-ID: P8S1yN8-Oe6iXeE59ew9FQ_1765381018
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08ABA180066C;
	Wed, 10 Dec 2025 15:36:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.2])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E0C81956095;
	Wed, 10 Dec 2025 15:36:57 +0000 (UTC)
Date: Wed, 10 Dec 2025 10:36:55 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <aTmTl_khrrNz9yLY@bfoster>
References: <20251210090400.3642383-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210090400.3642383-1-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Dec 10, 2025 at 10:03:55AM +0100, Christoph Hellwig wrote:
> The new XFS_ERRTAG_FORCE_ZERO_RANGE error tag added by commit
> ea9989668081 ("xfs: error tag to force zeroing on debug kernels") fails
> to account for the zoned space reservation rules and this reliably fails
> xfs/131 because the zeroing operation returns -EIO.
> 
> Fix this by reserving enough space to zero the entire range, which
> requires a bit of (fairly ugly) reshuffling to do the error injection
> early enough to affect the space reservation.
> 
> Fixes: ea9989668081 ("xfs: error tag to force zeroing on debug kernels")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Is there a reason in particular for testing this with the zone mode?
It's just a DEBUG thing for the zeroing mechanism. Why not just filter
out the is_zoned_inode() case at the injection site?

I suppose you could argue there is a point if we have separate zoned
mode iomap callbacks and whatnot, but I agree the factoring here is a
little unfortunate. I wonder if it would be nicer if we could set a flag
or something on an ac and toggle the zone mode off that, but on a quick
look I don't see a flag field in the zone ctx.

Hmm.. I wonder if we could still do something more clever where the zone
mode has its own injection site to bump the res, and then the lower
level logic just checks whether the reservation is sufficient for a full
zero..? I'm not totally sure if that's ultimately cleaner, but maybe
worth a thought..

Brian

>  fs/xfs/xfs_file.c | 46 ++++++++++++++++++++++++++++++++--------------
>  1 file changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6108612182e2..dbf37adf3a6b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1254,7 +1254,8 @@ xfs_falloc_zero_range(
>  	int			mode,
>  	loff_t			offset,
>  	loff_t			len,
> -	struct xfs_zone_alloc_ctx *ac)
> +	struct xfs_zone_alloc_ctx *ac,
> +	bool			force_zero_range)
>  {
>  	struct inode		*inode = file_inode(file);
>  	struct xfs_inode	*ip = XFS_I(inode);
> @@ -1274,8 +1275,7 @@ xfs_falloc_zero_range(
>  	 * extents than to perform zeroing here, so use an errortag to randomly
>  	 * force zeroing on DEBUG kernels for added test coverage.
>  	 */
> -	if (XFS_TEST_ERROR(ip->i_mount,
> -			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
> +	if (force_zero_range) {
>  		error = xfs_zero_range(ip, offset, len, ac, NULL);
>  	} else {
>  		error = xfs_free_file_space(ip, offset, len, ac);
> @@ -1357,7 +1357,8 @@ __xfs_file_fallocate(
>  	int			mode,
>  	loff_t			offset,
>  	loff_t			len,
> -	struct xfs_zone_alloc_ctx *ac)
> +	struct xfs_zone_alloc_ctx *ac,
> +	bool			force_zero_range)
>  {
>  	struct inode		*inode = file_inode(file);
>  	struct xfs_inode	*ip = XFS_I(inode);
> @@ -1393,7 +1394,8 @@ __xfs_file_fallocate(
>  		error = xfs_falloc_insert_range(file, offset, len);
>  		break;
>  	case FALLOC_FL_ZERO_RANGE:
> -		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
> +		error = xfs_falloc_zero_range(file, mode, offset, len, ac,
> +				force_zero_range);
>  		break;
>  	case FALLOC_FL_UNSHARE_RANGE:
>  		error = xfs_falloc_unshare_range(file, mode, offset, len);
> @@ -1419,17 +1421,24 @@ xfs_file_zoned_fallocate(
>  	struct file		*file,
>  	int			mode,
>  	loff_t			offset,
> -	loff_t			len)
> +	loff_t			len,
> +	bool			force_zero_range)
>  {
>  	struct xfs_zone_alloc_ctx ac = { };
>  	struct xfs_inode	*ip = XFS_I(file_inode(file));
> +	struct xfs_mount	*mp = ip->i_mount;
>  	int			error;
> +	xfs_filblks_t		count_fsb = 2;
>  
> -	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
> +	if (force_zero_range)
> +		count_fsb += XFS_B_TO_FSB(mp, len) + 1;
> +
> +	error = xfs_zoned_space_reserve(mp, count_fsb, XFS_ZR_RESERVED, &ac);
>  	if (error)
>  		return error;
> -	error = __xfs_file_fallocate(file, mode, offset, len, &ac);
> -	xfs_zoned_space_unreserve(ip->i_mount, &ac);
> +	error = __xfs_file_fallocate(file, mode, offset, len, &ac,
> +			force_zero_range);
> +	xfs_zoned_space_unreserve(mp, &ac);
>  	return error;
>  }
>  
> @@ -1441,12 +1450,18 @@ xfs_file_fallocate(
>  	loff_t			len)
>  {
>  	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	bool			force_zero_range = false;
>  
>  	if (!S_ISREG(inode->i_mode))
>  		return -EINVAL;
>  	if (mode & ~XFS_FALLOC_FL_SUPPORTED)
>  		return -EOPNOTSUPP;
>  
> +	if ((mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ZERO_RANGE &&
> +	    XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE))
> +		force_zero_range = true;
> +
>  	/*
>  	 * For zoned file systems, zeroing the first and last block of a hole
>  	 * punch requires allocating a new block to rewrite the remaining data
> @@ -1455,11 +1470,14 @@ xfs_file_fallocate(
>  	 * expected to be able to punch a hole even on a completely full
>  	 * file system.
>  	 */
> -	if (xfs_is_zoned_inode(XFS_I(inode)) &&
> -	    (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> -		     FALLOC_FL_COLLAPSE_RANGE)))
> -		return xfs_file_zoned_fallocate(file, mode, offset, len);
> -	return __xfs_file_fallocate(file, mode, offset, len, NULL);
> +	if (xfs_is_zoned_inode(ip) &&
> +	    (force_zero_range ||
> +	     (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> +		      FALLOC_FL_COLLAPSE_RANGE))))
> +		return xfs_file_zoned_fallocate(file, mode, offset, len,
> +				force_zero_range);
> +	return __xfs_file_fallocate(file, mode, offset, len, NULL,
> +			force_zero_range);
>  }
>  
>  STATIC int
> -- 
> 2.47.3
> 
> 

