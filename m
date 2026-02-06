Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FFA2AEE1;
	Fri,  6 Feb 2026 07:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770361245; cv=none; b=BG2iCk97Q4y++yN2tN3C0uwFJ859NYK0zPtZHGcyq5Arf65h+oTAUQdaSofBEEhSjBIru/SPuU9eAmYxsSz8IdMJYes5NFG8MMkHtyCEntwfTdFGLnT0NbGm+Bv9OfEMvDSh6hP9scc2ADluRUyF8VBNwMTmDu+NpJhpq192VQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770361245; c=relaxed/simple;
	bh=5RkE58I9bnJUYy9fpyAjkANrjCa9fz9cE9tSkRjbU6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XK6/5z0ArIPPcFEtirZm1A5K07in4FOY5YuzFwUZg0UJ9oFuVvdn99Yor0dAaTc//F/XLHlgnRH/cZEgdTCF/bJ2cT0NE/iLTGVEq0DO+t8pviDS5AejrNC6z0rFZDayWyBdRiClkDgGPQ2KeSbYwd+F2xw2edI/rhkW8b/nH1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DCD468D3E; Fri,  6 Feb 2026 08:00:34 +0100 (CET)
Date: Fri, 6 Feb 2026 08:00:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
Message-ID: <20260206070030.GA26818@lst.de>
References: <20260116100818.7576-1-kundan.kumar@samsung.com> <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com> <20260116100818.7576-4-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-4-kundan.kumar@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 16, 2026 at 03:38:15PM +0530, Kundan Kumar wrote:
> @@ -99,6 +99,11 @@ typedef struct xfs_inode {
>  	spinlock_t		i_ioend_lock;
>  	struct work_struct	i_ioend_work;
>  	struct list_head	i_ioend_list;
> +
> +	/* AG prediction map: pgoff_t -> packed u32 */
> +	struct xarray           i_ag_pmap;
> +	unsigned long           *i_ag_dirty_bitmap;
> +	unsigned int            i_ag_dirty_bits;

I don't think bloating the inode like this is acceptable.

As said in my reply to patch 5, I think we're better off with more coarse
grained sharding anyway.  i.e. just track an ag per inode.  We did this
for zoned xfs by pointing to the open zone using the existing and
otherwise unused inode->i_private field with great success.   You won't
get as good placement for some use cases where files are fragmented over
multiple AGs and you can please near close blocks right now, but you'll
save a lot of overhead searching the alloc btrees, and probably generate
a write pattern more suitable for SSDs.
