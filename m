Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A707B48BD2F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553226; cv=none; b=BT2z5gOMnOme5/ShdJn1bb5iEXE3qhgYgOQ9O9mR3hBSgrfNIdDxzDn7WSduGSIaU81k3QdyWnRxl8jJg0RSMlRyfy4kd1YCPn0gfbA4yJVEpXKZtIdo5AOeRkwrTqX7svPXHiH57mwInZ22+n7Ln3Ujf5ndA3m3xgxDrN23fN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553226; c=relaxed/simple;
	bh=6SK8xxTXlxmYh77PCQJlMOkWlN8rYirqVH8y6xyJuR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBhNRJJyso+S2R13+ou1N77JSfiRDZ4ssfJI4/WdYQrBX0pWPkraf0Jr20SF9mokL/yySjB2OxBWPsB/hand9Yz8bDOpx2N1ewoL31Fs9Ms2fIXLKcQshVpyuLvi50y4aCj2OsKvECukfFPEyyqiXELmfNKjqAiGbQOaskiT9yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CiGsLdt1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CiGsLdt1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N3xaqHtsp8FIcnDxhMj21fXjWtHw2iL99U7x5vrz/YY=; b=CiGsLdt1LYM+rFkLGQZ+YcwE0E
	30iTLh7dy7PISaLCMQsVS/N3bR1o/sKAEZyMJclKsD1dx95ybKB2qq59tgspZw9AdxAdQK2HlMW33
	mHbgnVs+Av0qDvQg1zWptTg1hU39gsCydQotTRFCVAE1kOq6tLJ4fXZRWm0yTfY41Ew41UPtx8o3D
	k+qk6jv/SnfEeCb7fFtQgLiTQ9rXT8KdwsdEHvThAXiQUYJUYshZqlXRD9UNx6sBY4y58vbWTBwgN
	kQvTwkHpyrNNO+6MfZJVoDTCiG++lc5QhXhj9c82Z39i8e9nGN+9TovDzMXCgpiGzjmN2BcgTpo2c
	SRDL9arQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS49-0000000FTQ3-1msu;
	Tue, 03 Mar 2026 15:53:45 +0000
Date: Tue, 3 Mar 2026 07:53:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/26] xfs_scrub: use the verify media ioctl during phase
 6 if possible
Message-ID: <aacECdb8HaCNYb4N@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783656.482027.946865669068210433.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783656.482027.946865669068210433.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  	if (disk->d_fd < 0)
> @@ -266,6 +267,18 @@ disk_close(
>  #define LBASIZE(d)		(1ULL << (d)->d_lbalog)
>  #define BTOLBA(d, bytes)	(((uint64_t)(bytes) + LBASIZE(d) - 1) >> (d)->d_lbalog)
>  
> +#ifndef BTOBB
> +# define BTOBB(bytes)		((uint64_t)((bytes) + 511) >> 9)
> +#endif
> +
> +#ifndef BTOBBT
> +# define BTOBBT(bytes)		((uint64_t)(bytes) >> 9)
> +#endif
> +
> +#ifndef BBTOB
> +# define BBTOB(bytes)		((uint64_t)(bytes) << 9)
> +#endif

Is this really something that should be in scrub and not in
common code?  And why the ifndef?  the 9 and the derived from that
511 would also really benefit from symbolic names.

> +	if (disk->d_verify_fd >= 0) {
> +		const uint64_t	orig_start_daddr = BTOBBT(start);
> +		struct xfs_verify_media me = {
> +			.me_start_daddr	= orig_start_daddr,
> +			.me_end_daddr	= BTOBB(start + length),
> +			.me_dev		= disk->d_verify_disk,
> +			.me_rest_us	= bg_mode > 2 ? bg_mode - 1 : 0,
> +		};
> +		int		ret;
> +
> +		if (single_step)
> +			me.me_flags |= XFS_VERIFY_MEDIA_REPORT;
> +
> +		ret = ioctl(disk->d_verify_fd, XFS_IOC_VERIFY_MEDIA, &me);
> +		if (ret < 0)
> +			return ret;
> +		if (me.me_ioerror) {
> +			errno = me.me_ioerror;
> +			return -1;
> +		}
> +
> +		return BBTOB(me.me_start_daddr - orig_start_daddr);
> +	}

split this whole block into a helper for readabiltity?

