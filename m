Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EFBF507
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724733498; cv=none; b=hFvJlM+ASzViBAfI+swciOoEtFjIypRArKupc2ja+ea/nOkHUJO5GshNB14ROo8WIfCfhqG10KfSCxKrNujo6y4dhbY/MGIu4Yfvt5dCT6itBvExjs7ngD+YXaUBhnhJDqEWdY3Nj8CTg3KCL1UcbqpdIxubroAVNXCqjvjrZP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724733498; c=relaxed/simple;
	bh=XZqhGdAJwoHxiaDDZnYcXwmgEwbAQmGLn3u/oN2mPNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNTNBg0yfdYsddtTIx68l2MUx0k5BCAkzAfdhPpPAOf2WPqjxl0RFPga441cxLSXa6mz0E+le68t+cUPrWjZDSaVlhAeDynkYlyJyysxbgU67SQe1MIq5W8l+PnvdQDvTUT44qLwfYzamzqGQt4lR4XCpydO8WanP2UxugJkElw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mparv4E1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mparv4E1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uKamNo9yoDuusn8fYAmJjQEz9iA3jZsbIcV03GuAiH4=; b=Mparv4E1GbsojXTrfRcJufzegh
	N16VKf04b/O7A7OcM6womR3ZmnPypdDJhSA9NLro1JlQvFO8D4vOBBXf7UkzauPuKHUjIWvQZCVKe
	M5OiqNQbV78v303VJ1njBCbw84e0OFJh6z2WWPRVlTkAXaUnoKR2x+fjW4qdICFPQpw7pTCLu36dp
	SPB/rfFP8RocToJV1sC29BgFnh+hoWOlL4ff4DD1eOZeITLnYavN3gUEbwB8cd8h1PPXKESO6Fh+b
	9qOaHgS4K9Zc6hflBh9Wot1RsgYS6306bJ409yPZMhqL5zrXa70CvFvZwbwdNn0ufP6NoD1dRpcg8
	LgulPUsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sinyC-00000009iqj-0wEh;
	Tue, 27 Aug 2024 04:38:16 +0000
Date: Mon, 26 Aug 2024 21:38:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <Zs1YOAdBx9pRaynK@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
 <Zs0kfidzTGC7KACX@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs0kfidzTGC7KACX@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 27, 2024 at 10:57:34AM +1000, Dave Chinner wrote:
> We're discussing how to use the sparse fsbno addressing to allow
> resizing of AGs, but we will not be able to do that at all with
> rtgroups as they stand. The limitation is a 64 bit global rt extent
> address is essential the physical address of the extent in the block
> device LBA space.

With this series there are not global RT extent addresses, the extents
are always relative to the group and an entity only used in the
allocator.

> /*
>  * xfs_group - a contiguous 32 bit block address space group
>  */
> struct xfs_group {
> 	struct xarray		xarr;
> 	u32			num_groups;
> };
> 
> struct xfs_group_item {
> 	struct xfs_group	*group; /* so put/rele don't need any other context */
> 	u32			gno;
> 	atomic_t		passive_refs;
> 	atomic_t		active_refs;

What is the point of splitting the group and group_item?  This isn't
done in the current perag struture either.

> Hence I'm wondering if we should actually cap the maximum number of
> rtgroups. WE're just about at BS > PS, so with a 64k block size a
> single rtgroup can index 2^32 * 2^16 bytes which puts individual
> rtgs at 256TB in size. Unless there are use cases for rtgroup sizes
> smaller than a few GBs, I just don't see the need for support
> theoretical maximum counts on tiny block size filesystems. Thirty
> thousand rtgs at 256TB per rtg puts us at 64 bit device size limits,
> and we hit those limits on 4kB block sizes at around 500,000 rtgs.
> 
> So do we need to support millions of rtgs? I'd say no....

As said before hardware is having a word with with the 256GB hardware
zone size in SMR HDDs.  I hope that size will eventually increase, but
I would not bet my house on it.

