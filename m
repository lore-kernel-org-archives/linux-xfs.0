Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5DD2571C7
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230676; cv=none; b=OkEW1ghagzzIMcYpDA+dkQOdbjRGP1NzXxB+ytMvCRRyJU0ZEWPLQY9r4QBvf/1s4zEKG9wBMAG9R2edLBQsto7KAoBkNDwEVD78Wq5B+jYhUmxtkf1qQ2Ts1l4VKKoxmIlBo73qUg54qoNlb09lQxf8Hc/Mii1PFL3BYhnaU0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230676; c=relaxed/simple;
	bh=YQCSZ7GR3YJCi14RYj9ta/VvZkff5QF5ECqHtGyvn+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdsybZoR2KCKXYFykqIRSayQeEwZ5f60TlnxZ8mD4jpyHrhCv+Vq7uQAJ70h7wqavMLqs+0ARq3D1QVM213no3ESrxF7s14qMJo98FEpB43KyVLyqsNEbpeLL2WVH0xiaBnl/NPaWQQE/QXhu3a6V1lGWbuo47/EcWtu1JBho5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RIQmqLlM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RIQmqLlM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s6QjcJh7ynx0vz4w5UB4O5HxaDaob0Lb5Hxnp/vvLJw=; b=RIQmqLlMb1svyHpuB/DnYzUhJ9
	spyMJoWRXBPw9kNkB2z4un5Fqr6SUpbkhwoW48ak49H58YHBMJYAF5G9nRdyO/AM69oYlNy+hG3Q2
	9/9jlARC1BG4eRr5SmujkRhc/DfHy43sFxZZ5TM8NCH6i1KjLfraYHhJWnkjxsbsd7dewfqRm1pdj
	V3sQ6xVpyXLIIFES6DcgADnQfEyXDcXycpipyGMjbW2oJGNwOzNNLSC0Ikw0P6KqwQjCOR1DvIXPV
	1cph8AE24uBsV9WjlP8LBJLgQ85i9S9uhoQNItKJuEBVyYlAPwaAGuk7dyn+G/F3Zjw7MiRd8J9JW
	RGE05R/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLH1u-000000063V4-3PU7;
	Fri, 08 May 2026 08:57:54 +0000
Date: Fri, 8 May 2026 01:57:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, wilfred.mallawa@wdc.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <af2lkkYO_Y8CsHsP@infradead.org>
References: <177819182887.3486206.18149824043863236840.stgit@frogsfrogsfrogs>
 <177819182911.3486206.5193162010557711631.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177819182911.3486206.5193162010557711631.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Not sure if this should on it's own or with Wilfred's series to document
it and make us in xfs_io?

If the former, maybe Wilfred needs to resend on top of this series?

On Thu, May 07, 2026 at 03:12:14PM -0700, Darrick J. Wong wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> Source kernel commit: c6ce65cb17aa9321687d1b8a842487f839e1a548
> 
> There is currently no XFS ioctl that allows userspace to retrieve the
> write pointer for a specific realtime group block for zoned XFS. On zoned
> block devices, userspace can obtain this information via zone reports from
> the underlying device. However, for zoned XFS operating on regular block
> devices, no equivalent mechanism exists.
> 
> Access to the realtime group write pointer is useful to userspace
> development and analysis tools such as Zonar [1]. So extend the existing
> struct xfs_rtgroup_geometry to add a new rg_writepointer field. This field
> is valid if XFS_RTGROUP_GEOM_WRITEPOINTER flag is set. The rg_writepointer
> field specifies the location of the current writepointer as a block offset
> into the respective rtgroup.
> 
> [1] https://lwn.net/Articles/1059364/
> 
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
>  libxfs/xfs_fs.h |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index d165de607d179e..185f09f327c00c 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -995,7 +995,8 @@ struct xfs_rtgroup_geometry {
>  	__u32 rg_sick;		/* o: sick things in ag */
>  	__u32 rg_checked;	/* o: checked metadata in ag */
>  	__u32 rg_flags;		/* i/o: flags for this ag */
> -	__u32 rg_reserved[27];	/* o: zero */
> +	__u32 rg_writepointer;  /* o: write pointer block offset for zoned */
> +	__u32 rg_reserved[26];	/* o: zero */
>  };
>  #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
>  #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
> @@ -1003,6 +1004,8 @@ struct xfs_rtgroup_geometry {
>  #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
>  #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
>  
> +#define XFS_RTGROUP_GEOM_WRITEPOINTER  (1U << 0)  /* write pointer */
> +
>  /* Health monitor event domains */
>  
>  /* affects the whole fs */
> 
> 
---end quoted text---
