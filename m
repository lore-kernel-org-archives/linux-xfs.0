Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A14544D72
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 12:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081442; cv=none; b=tWWp2K098Hqh+GfI17vkLVjBIh+hGnPVKCGfebYsxFawlGRBOm4cPbTmF+A0sYqZVoxsARml5VQMpmXkaWDosLVaQHYkRGVUEdAwhUYhlb+p1tFyVqi+llAUiaRABdiZu/ZlQWQiYVo1zluNw3T2sBgE6+AozR8n4aHGzKyxG+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081442; c=relaxed/simple;
	bh=tLAUHd/itfeZAtA5o1MRKu2+oEjq9FRJQk/z/S4qiZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=blbgOO4tDocwE1uwGyPKDl1agdkoW8NgmtZpHXtRmCZ+3XHfsOQlS7zmJQCsQwH7GFaIOWSDT7EcsNuUiNkRRjfWQ72fANE34HxAwCHMEztvWeIoJTlJgRAG2RG6zwt666zqWFZEWoDJvDeBwQqIoAdbtEcoqMVYgTPTtx0TBJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z11NYkpP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z11NYkpP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5v2OziYQDpbQqzEHM59H4odT+VXDLZ+l4vbPkmP8LcU=; b=Z11NYkpPRjn1EpOJx6QF4tiQuZ
	i7xL+Zwm5rCU3veUaLpNo4c9+WXwnwe6gL+j+RZxvw2FGpWzsUPDSs0zVOK+mVBvn3zex+DPvu7Fl
	igXf5aT8OrV6LdpYnQuimV58zqAPegp2nL0mL45DCYSaI6QnSNhu43szb/jWk2RMu9K7ACfU3O2B1
	S4SNHJVEMrZZbhW+MaiWlv0LTKq0dFvYLMtN3i5roVf8qfEjOQP1pJDKUo1KyPsa86TkSKYvLabT5
	UVJA2i7MVI0FMlN/Er7ETL/iUpguS+mGutGx5Ttu1gzJysUQmIr0ZdJvpahWfE3MFQpNnbWOAmJ5j
	9RwwvjXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8zxJ-00000005Mg6-02Ko;
	Tue, 22 Sep 2026 12:50:41 +0000
Date: Tue, 22 Sep 2026 05:50:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Alistair Francis <alistair.francis@wdc.com>,
	Damien Le'Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH 1/3] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <arJ5oJeAOezhOGsP@infradead.org>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

It looks like patches 2 and 3 in this series never made it into
the xfsprogs repository despite being fully reviewed.  Can we get them
picked up?

On Fri, Mar 13, 2026 at 10:24:54AM +1000, Wilfred Mallawa wrote:
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
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
>  libxfs/xfs_fs.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index d165de607..185f09f32 100644
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
> -- 
> 2.53.0
> 
> 
---end quoted text---
