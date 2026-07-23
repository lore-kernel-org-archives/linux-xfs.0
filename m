Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0D4175A7D;
	Thu, 23 Jul 2026 20:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839979; cv=none; b=Yx830EexjsPD5mcWk0FGwVY1tpgYT+DW7DWbyQeIULs1IiNqC+G+wIRcKLkSnlei8/tOowij9VjRqIp/DGGW8JD4qmC1SyBo/A7SYTVDYMZd1oH4i2+5Qq+a85rJlIoJAlus5FWv4UmMj1ilODgWJ4FJR5fsgcxueMqFhuPQwz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839979; c=relaxed/simple;
	bh=MP8/KSEWXojV+Q8hfZkZRlWZH8KxFMOq2RJ8zTIemC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5fnR1Cz612C3t1wLBLztCEM63V+0bmczINFH1i3PtNuNaUiGbh0C5Llrt1mJcO2+gfSQXyeeFzpaeY6s6+07IkjNOglBeG9V26YK5ItKckiSvBxutlqcqAVSoQw0KfMnlk+h7rHbkTnT+c4ENXgXR7uLzXagpRZvr1WsCfQHQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GvzL7kHJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GvzL7kHJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 074161F000E9;
	Thu, 23 Jul 2026 20:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784839978;
	bh=voyyMaDWE/QwOtP0Z8qBEUH+l+bBigIF1pjz63XI7pE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GvzL7kHJYAHs7PZTmInr0HU4W31Ub3T469Qa1jSTPNINKrXtwxVctr+gwa02sSwZe
	 CjaHwPMbg01Ql6vb4LDxxSVEBZvoganSS/lNuvCR5iC3Nq5iYGZFGgZlPivggprWUT
	 ZJKdkWfL2ZkiiEXWh4stsyZBvdN6sQ6tXk61kheoZvDs8XfGgQhU3A8mPI/vmmRnHu
	 nnCJYah43eV13wL+6XZ3/oV4WyQQg6+b3rxSttZmm0D7C4/Ia9fyVOrdsHhMAO/kC3
	 SLn1T9ZCDbXpX2llBguhQvgEhIolHPZjc1VIgjbC2ERLFsi2qzmGKg+G+IeaBEcV7W
	 Heriq6WcsUGjg==
Date: Thu, 23 Jul 2026 13:52:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/22] iomap: add a iomap_ioend_flags helper
Message-ID: <20260723205257.GC2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-14-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:38PM +0200, Christoph Hellwig wrote:
> Add a helper to initialize the ioend flags to the values that can be
> directly derived from the iomap.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straightforward hoist,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/ioend.c      | 10 +++-------
>  include/linux/iomap.h | 12 ++++++++++++
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 34f71c8b5ebd..b1bca36de430 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -216,7 +216,7 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  {
>  	struct iomap_ioend *ioend = wpc->wb_ctx;
>  	size_t poff = offset_in_folio(folio, pos);
> -	unsigned int ioend_flags = 0;
> +	unsigned int ioend_flags = iomap_ioend_flags(&wpc->iomap);
>  	unsigned int map_len = min_t(u64, dirty_len,
>  		wpc->iomap.offset + wpc->iomap.length - pos);
>  	int error;
> @@ -226,20 +226,16 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  	WARN_ON_ONCE(!folio->private && map_len < dirty_len);
>  
>  	switch (wpc->iomap.type) {
> +	case IOMAP_HOLE:
> +		return map_len;
>  	case IOMAP_UNWRITTEN:
> -		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
> -		break;
>  	case IOMAP_MAPPED:
>  		break;
> -	case IOMAP_HOLE:
> -		return map_len;
>  	default:
>  		WARN_ON_ONCE(1);
>  		return -EIO;
>  	}
>  
> -	if (wpc->iomap.flags & IOMAP_F_SHARED)
> -		ioend_flags |= IOMAP_IOEND_SHARED;
>  	if (folio_test_dropbehind(folio))
>  		ioend_flags |= IOMAP_IOEND_DONTCACHE;
>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index ff9afdd39682..2541ebfabca0 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -415,6 +415,18 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
>  	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
>  	 IOMAP_IOEND_DONTCACHE)
>  
> +/* ioend flags directly implied by iomap flags */
> +static inline u16 iomap_ioend_flags(const struct iomap *iomap)
> +{
> +	unsigned int flags = 0;
> +
> +	if (iomap->type == IOMAP_UNWRITTEN)
> +		flags |= IOMAP_IOEND_UNWRITTEN;
> +	if (iomap->flags & IOMAP_F_SHARED)
> +		flags |= IOMAP_IOEND_SHARED;
> +	return flags;
> +}
> +
>  /*
>   * Structure for writeback I/O completions.
>   *
> -- 
> 2.53.0
> 
> 
