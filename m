Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D04E6E614
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 05:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724735840; cv=none; b=hCDt0DcqUGPn2EjmgXlh5n8GNk3+Yii3y3Ik0ANq+zmb5+f4VZYHz2qp8SiDT+LDTJuWwCp7nlZyQxZTXtOF52G0U0UjWeFM60WYvvUSeYcqAHyKIz7MIbkiEvBDVp1iF0IuUVzDPGXV3FWlJqs2KB4DWTWIIiTPFRG9darfBY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724735840; c=relaxed/simple;
	bh=W3OY/mQyKoGoXq04KZsORsxxWc5N8eYJhpdSaSEE290=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nue7KH8hRfFTUO/LjKLCzdEcV01TtMei4xu87xpzFhO9NnFfb+bKDWAYfKV6xFRdIHxEz/MRUjd6xSLHsyfORb8ivtjVZYpI1na1WVYpD2mGs5yF4s+ILqdHjUWZt7wgWJl8jIyH6Iw4i70/h9+4kKJ73ELqHxLYWumBjkpxGc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCFEWo+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCFEWo+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2FBC8B7A3;
	Tue, 27 Aug 2024 05:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724735839;
	bh=W3OY/mQyKoGoXq04KZsORsxxWc5N8eYJhpdSaSEE290=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cCFEWo+TeZpvNXrQtV1JHu5MgK3/+u51Mj0g5PZ/lfHDea2MIsZdBRBulo+H4VGo5
	 4bwKeTdl3sRCPSRYcpVYfP/RPA+iMpIh4vLoD5sNlY7Cjq20sONORh1bFfL0Zu1Qe8
	 jGJsSLL3YCKyNlQu4RZEBlGfOEVbQCSTLLgYjTkWAcR+jAW7PiwOb2YUQzD7p8CH/i
	 XLF7Ef8IFBVvYoOOL1j6+Lt5jKg8gFkqVLwMtUxBDynA1JfFCXBPgyKMVfyjt5tcLM
	 4MYLDSt26MP3prewmetnKSXJT09Hjo3UZE/aCbm3rzzEh7Sz9FeWt9alWNcE+1M9Vf
	 uTyIhaeQ9cS+A==
Date: Mon, 26 Aug 2024 22:17:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <20240827051719.GJ865349@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
 <Zs0kfidzTGC7KACX@dread.disaster.area>
 <Zs1YOAdBx9pRaynK@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs1YOAdBx9pRaynK@infradead.org>

On Mon, Aug 26, 2024 at 09:38:16PM -0700, Christoph Hellwig wrote:
> On Tue, Aug 27, 2024 at 10:57:34AM +1000, Dave Chinner wrote:
> > We're discussing how to use the sparse fsbno addressing to allow
> > resizing of AGs, but we will not be able to do that at all with
> > rtgroups as they stand. The limitation is a 64 bit global rt extent
> > address is essential the physical address of the extent in the block
> > device LBA space.
> 
> With this series there are not global RT extent addresses, the extents
> are always relative to the group and an entity only used in the
> allocator.
> 
> > /*
> >  * xfs_group - a contiguous 32 bit block address space group
> >  */
> > struct xfs_group {
> > 	struct xarray		xarr;
> > 	u32			num_groups;
> > };
> > 
> > struct xfs_group_item {
> > 	struct xfs_group	*group; /* so put/rele don't need any other context */
> > 	u32			gno;
> > 	atomic_t		passive_refs;
> > 	atomic_t		active_refs;
> 
> What is the point of splitting the group and group_item?  This isn't
> done in the current perag struture either.

I think xfs_group encapsulates/replaces the radix tree root in struct
xfs_mount, and the xarray inside it points to xfs_group_item objects.

> > Hence I'm wondering if we should actually cap the maximum number of
> > rtgroups. WE're just about at BS > PS, so with a 64k block size a
> > single rtgroup can index 2^32 * 2^16 bytes which puts individual
> > rtgs at 256TB in size. Unless there are use cases for rtgroup sizes
> > smaller than a few GBs, I just don't see the need for support
> > theoretical maximum counts on tiny block size filesystems. Thirty
> > thousand rtgs at 256TB per rtg puts us at 64 bit device size limits,
> > and we hit those limits on 4kB block sizes at around 500,000 rtgs.
> > 
> > So do we need to support millions of rtgs? I'd say no....
> 
> As said before hardware is having a word with with the 256GB hardware
> zone size in SMR HDDs.  I hope that size will eventually increase, but
> I would not bet my house on it.

Wait, 256 *gigabytes*?  That wouldn't be such a bad minimum.

--D
