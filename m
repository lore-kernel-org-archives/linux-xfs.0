Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA22F171AF
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 05:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724735927; cv=none; b=OvcMbvYHI0CEB5wziCU+RJj794tKgb+ni7Ho1wELIJGsOYoZVzHwNemv86LWtD0AJ4bFP9BTPn99aajsxzF2H+7P5pNk23XMu3yD0HdtHxjDw3HnCyPCDD6LuJAyqV86KiZT9+hZKbC+bcn6BieneWaHQMdNJHPSDqpu5noShtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724735927; c=relaxed/simple;
	bh=iuhENakpoJqoxLBZdI4r4RD8iLSrSq00yYmrUIf7DH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6MhiMVrUuawAI0cX0+ca0rROW+tBUNUvSxfNd8+EkwQPlR35t08YIS/HsHVXpaJc82ZXiB3dAUuIWxXsAvEpKkMbwS0b7lLX+Z0aM40nmEfGf50NRRg068DxIPbSJg2dw+UZs2yDENLYGdYf88ifNs1G2f0EYbfWjsgVJ4Zbe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zCPWtasb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zCPWtasb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+P+UbMogebRzRtZA9m+fPseeXIGaZ8IhyvOo+TfWX18=; b=zCPWtasbmiu2IG+qWqpjSjWKwa
	RLevpNfWC1zoHqQVlTyK8/EiypBOH9hdaI2LtXv86nJZ8s0Bllt1My/UIUpAQe3T+Nmky+xNBPwsV
	SesQp1uVKdmhCoUIUtdphQDenc87+qMyLp3KHEAU5KY1onGWuff+Vy0TklpBshq+dD0Qn7x6U4YO4
	sfenO0OREcVPYSwcQhYbHb9yuMvVIivDF2s4zG9oI5BnnARReM4LQbupDWwjN+rdM2NpEV9D9JJMi
	LnG4VfB0C4bvFxkX8LFcnEVbJE6Pi0HG6bQ4ysOqId5xVV2GEEJZedETkGilfK404UvvymGcZHGa1
	qKBVoUpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1siobN-00000009qV3-0Yhh;
	Tue, 27 Aug 2024 05:18:45 +0000
Date: Mon, 26 Aug 2024 22:18:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <Zs1htb6lliBEWZW9@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
 <Zs0kfidzTGC7KACX@dread.disaster.area>
 <Zs1YOAdBx9pRaynK@infradead.org>
 <20240827051719.GJ865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827051719.GJ865349@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 26, 2024 at 10:17:19PM -0700, Darrick J. Wong wrote:
> > allocator.
> > 
> > > /*
> > >  * xfs_group - a contiguous 32 bit block address space group
> > >  */
> > > struct xfs_group {
> > > 	struct xarray		xarr;
> > > 	u32			num_groups;
> > > };
> > > 
> > > struct xfs_group_item {
> > > 	struct xfs_group	*group; /* so put/rele don't need any other context */
> > > 	u32			gno;
> > > 	atomic_t		passive_refs;
> > > 	atomic_t		active_refs;
> > 
> > What is the point of splitting the group and group_item?  This isn't
> > done in the current perag struture either.
> 
> I think xfs_group encapsulates/replaces the radix tree root in struct
> xfs_mount, and the xarray inside it points to xfs_group_item objects.

Ahh.  So it's now a xfs_group structure, but a xfs_groups one,
with the group item really being xfs_group.

> 
> > > Hence I'm wondering if we should actually cap the maximum number of
> > > rtgroups. WE're just about at BS > PS, so with a 64k block size a
> > > single rtgroup can index 2^32 * 2^16 bytes which puts individual
> > > rtgs at 256TB in size. Unless there are use cases for rtgroup sizes
> > > smaller than a few GBs, I just don't see the need for support
> > > theoretical maximum counts on tiny block size filesystems. Thirty
> > > thousand rtgs at 256TB per rtg puts us at 64 bit device size limits,
> > > and we hit those limits on 4kB block sizes at around 500,000 rtgs.
> > > 
> > > So do we need to support millions of rtgs? I'd say no....
> > 
> > As said before hardware is having a word with with the 256GB hardware
> > zone size in SMR HDDs.  I hope that size will eventually increase, but
> > I would not bet my house on it.
> 
> Wait, 256 *gigabytes*?  That wouldn't be such a bad minimum.

Sorry, MB.  My units really suck this morning :)

