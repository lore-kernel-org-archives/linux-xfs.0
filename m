Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625272FBDFF
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771393490; cv=none; b=L535dD3Ooxa/vCcJELwWfsu5dBvBbkC+YZA4IO+0RLBZAtqN60WqVCAAMXtycooNjgZZXzTSfoA5d5BcoIFgsXuystY6ZUS8TMnkvCHVct4jziVQDIKcxxkdYg43K2nG8EpENx7b4j0Fto6CxIriC+/P3YoctXmxEeOkS0YJH9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771393490; c=relaxed/simple;
	bh=iNxa/waRIO0WM3R3PTC9SMTX6xtkB+IT/75ngC9jCMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CeA9b2wHbcW3brd9+lk+w/wC6s1falsK9Wa1ttKYN3UpyYlXzfAPZ2ncltmQXxAZ5SHjydQzHnOU1LWdi2Jdv1oJB34Xq4s7T0ErsrV4XstUwrC4hWHBefmEkRC2yNyeeRJYlLeoQKYUhsqdGQMuhf2XgvEhOJchFP1N1zZ4WGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H/lpKc9H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H/lpKc9H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ebDthHKEelUagOIZJu1SLuVvcxenK3doCo9tpOncEk8=; b=H/lpKc9HSlHxg7dVSzr6g3gKfw
	On4ZEFw0BOngpmbQano1yLuQSOcyUYAFsH+lW3C+EvjEr2ebXh8DFlR/M3x/kOhoAln/wIlO/H3h8
	ByjlQ7TyT58JOYhyRl77XjGYyHOknsERzfPZTkBEXxmwmgmLQo9gdmlZrTHreJjwo7s6blvzpAvvS
	KERYf7XYuNkTPeIA8azbVZX61Ycbt2mOfKSGHudWxBJIky3zWz1qc34s/joLCIR6Yt+9JGHpSmPgF
	JbRaVMQNdqP7jR7Un4VhtmxKkS4+c5Ea7lyu2fHPQj8rRW8stD8CZIVhKadF+AA/NeLxU4Rspb/6L
	E4BCD5yg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsaMi-00000009Kb7-3mLh;
	Wed, 18 Feb 2026 05:44:48 +0000
Date: Tue, 17 Feb 2026 21:44:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 REBASE] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code
 base
Message-ID: <aZVR0G6oJIsnGkcR@infradead.org>
References: <20260212131302.132709-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212131302.132709-3-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 12, 2026 at 02:13:04PM +0100, Lukas Herbolt wrote:
> +/*
> + * Callers can specify bmapi_flags, if XFS_BMAPI_ZERO is used there are no
> + * further checks whether the hard ware supports and it can fallback to
> + * software zeroing.
> + */

As mentioned in the reply to Carlos, I'd just drop this comment.

>  
> -	if (xfs_falloc_force_zero(ip, ac)) {
> -		error = xfs_zero_range(ip, offset, len, ac, NULL);
> -	} else {
> -		error = xfs_free_file_space(ip, offset, len, ac);
> -		if (error)
> -			return error;
>  
> -		len = round_up(offset + len, blksize) -
> -			round_down(offset, blksize);
> -		offset = round_down(offset, blksize);
> -		error = xfs_alloc_file_space(ip, offset, len);
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (xfs_is_always_cow_inode(ip) ||
> +		    !bdev_write_zeroes_unmap_sectors(
> +			xfs_inode_buftarg(ip)->bt_bdev))

This needs an extra tab, as the condition should not be aligned the
same as the following branch.

Otherwise this still looks good.
