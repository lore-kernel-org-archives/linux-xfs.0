Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200102BFC60
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 18:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911474; cv=none; b=kBzOZSmIwpILXCka/xC5NbW48u/yUnkvxQQB79+cKQDBTJ/E0uyDBZ9k3yWg8bjjVvrmpatSVaNbdq2lSx7vXVAEdAB/zvYjyjyO/BMb3ehofHrUZvM+KuJIouuUT800E+spbm0ycDHo+LG5dXCizB08I1GSLuyY3F7A74B9T0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911474; c=relaxed/simple;
	bh=LcvwziyKoU5vCJpm7TRNx//aFEbXF+WcPlTcg1ooYuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPzxPvMHLNo0ZwERrnWDx9dPt2AGN77hmGje5oxF+SuMDYtM28LCf0few+ABBEYd4GLLQVZXQ1N2TOa+o3D4ptd+29okSXkGzZK/4LnDlvEpPFeG2W412FUFH0YmpGYIwnu1C4lSnz3r+MXxlfqi/6hu2F3ChCJX5CB+tCzw00Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hU/GkXXB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hU/GkXXB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765911470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WecPa+N8FBjvn39oITufuEvUB8y8qFKgU9aO0mQzHt8=;
	b=hU/GkXXBOlMT4HoW5XryNwDkYaeOZjw1TCV33ZFFhGMBQQSzVPwSSOyr5TLv2t/q3czFcH
	hxhl4yt66Bxjco4HEx/tjBVcNsq/coEwoOhqX/tGrwGrMHP0c4tKYjCeoY0T0H+c4ASoKq
	652S4YzzK2PER0hRenSKomR/wLC37qY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-WnNvztyjPoCBkUtmCBvbYA-1; Tue,
 16 Dec 2025 13:57:47 -0500
X-MC-Unique: WnNvztyjPoCBkUtmCBvbYA-1
X-Mimecast-MFC-AGG-ID: WnNvztyjPoCBkUtmCBvbYA_1765911466
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D67E180035A;
	Tue, 16 Dec 2025 18:57:46 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.2])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EDAF18004D8;
	Tue, 16 Dec 2025 18:57:45 +0000 (UTC)
Date: Tue, 16 Dec 2025 13:57:43 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <aUGrpyS6BG0CD-kn@bfoster>
References: <20251215060654.478876-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215060654.478876-1-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Dec 15, 2025 at 07:05:46AM +0100, Christoph Hellwig wrote:
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
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Changes since v1:
>  - only do early injection for zoned mode to declutter the non-zoned
>    path a bit
> 
>  fs/xfs/xfs_file.c | 58 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 48 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6108612182e2..8f753ad284a0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1240,6 +1240,38 @@ xfs_falloc_insert_range(
>  	return xfs_insert_file_space(XFS_I(inode), offset, len);
>  }
>  
> +/*
> + * For various operations we need to zero up to one block each at each end of
> + * the affected range.  For zoned file systems this will require a space
> + * allocation, for which we need a reservation ahead of time.
> + */
> +#define XFS_ZONED_ZERO_EDGE_SPACE_RES		2
> +
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
> +	if (xfs_is_zoned_inode(ip)) {
> +		if (ac->reserved_blocks > XFS_ZONED_ZERO_EDGE_SPACE_RES) {
> +			ASSERT(IS_ENABLED(CONFIG_XFS_DEBUG));

JFYI the reason I suggested a config check was as a safeguard against
forced zeroing on production kernels. The assert here would compile out
in that case, so won't necessarily provide that benefit (unless you
wanted to use ASSERT_ALWAYS() or WARN() or something..).

A warning on WARN && !DEBUG is still useful so I don't really care if
you leave it as is or tweak it. I just wanted to point that out.

Brian

> +			return true;
> +		}
> +		return false;
> +	}
> +	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
> +}
> +
>  /*
>   * Punch a hole and prealloc the range.  We use a hole punch rather than
>   * unwritten extent conversion for two reasons:
> @@ -1268,14 +1300,7 @@ xfs_falloc_zero_range(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * Zero range implements a full zeroing mechanism but is only used in
> -	 * limited situations. It is more efficient to allocate unwritten
> -	 * extents than to perform zeroing here, so use an errortag to randomly
> -	 * force zeroing on DEBUG kernels for added test coverage.
> -	 */
> -	if (XFS_TEST_ERROR(ip->i_mount,
> -			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
> +	if (xfs_falloc_force_zero(ip, ac)) {
>  		error = xfs_zero_range(ip, offset, len, ac, NULL);
>  	} else {
>  		error = xfs_free_file_space(ip, offset, len, ac);
> @@ -1423,13 +1448,26 @@ xfs_file_zoned_fallocate(
>  {
>  	struct xfs_zone_alloc_ctx ac = { };
>  	struct xfs_inode	*ip = XFS_I(file_inode(file));
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_filblks_t		count_fsb;
>  	int			error;
>  
> -	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
> +	/*
> +	 * If full zeroing is forced by the error injection knob, we need a
> +	 * space reservation that covers the entire range.  See the comment in
> +	 * xfs_zoned_write_space_reserve for the rationale for the calculation.
> +	 * Otherwise just reserve space for the two boundary blocks.
> +	 */
> +	count_fsb = XFS_ZONED_ZERO_EDGE_SPACE_RES;
> +	if ((mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ZERO_RANGE &&
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_FORCE_ZERO_RANGE))
> +		count_fsb += XFS_B_TO_FSB(mp, len) + 1;
> +
> +	error = xfs_zoned_space_reserve(mp, count_fsb, XFS_ZR_RESERVED, &ac);
>  	if (error)
>  		return error;
>  	error = __xfs_file_fallocate(file, mode, offset, len, &ac);
> -	xfs_zoned_space_unreserve(ip->i_mount, &ac);
> +	xfs_zoned_space_unreserve(mp, &ac);
>  	return error;
>  }
>  
> -- 
> 2.47.3
> 
> 

