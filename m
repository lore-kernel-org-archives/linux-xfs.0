Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F60713777B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293784; cv=none; b=Jx8GiQfTrt6zOSoizKN+LoIXNVJ9c1nrhloa+VMdnOxhkbRRdqKDE7swegAF9iWbUErt/AAp3DhIGDo6/PyUCSOG6lYXUA7KbYA3W6PICDkBeGs+aDyTWo2eAbyhZTBcN39rQbciL+IBgzcOJosvCUri67vw5u4XzgORSX3ZZJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293784; c=relaxed/simple;
	bh=ZR+RXxA29RjvjjC/QIIRZxGxriw5OvGsOGSdSn8x2DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYXDJHTieG/Yd6wYrA4IrFGn6VwhEVudO1q7MxZNUMZNDWSbLLTEUCVVJeVBL0OU4w2cV1iZo7X+g3QZlrIPEYrLKhl0krRoRrTg4owSDE2cpvAMEgl0KzRcH4iVMOdCEV8f2ZWBEgFvUn27D9SL5+a0SlLF3mks6BoVCuieJKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y2A2oBNi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y2A2oBNi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uJo/WvRoI+R9SnCoeBNEeIupXDrzX957U+oMdRvDZS8=; b=Y2A2oBNi9X3nwgd9zFciHC1Cr6
	oaf6M1vkJKdRrJ51ppevC9PQEUUzkHXvPiwPDBJ48t9LFhvnYHV9q8Bo7e9WKNwglrMj/uILUzdCh
	RbS2+7ctiuYfvdl6EvszgRwBrVEAyQ+fBXnPWNBD4OdNzU4AOGAY2TRMipGeUeP/luDkR9kiAKhhl
	r9UZY8svkecwQO9byOe2MXCARDS4FwWQlqXq5nGlOqgNbeOqc76fY5jdrsR5r7C4wqOmj/GOlsLSu
	qp939mSfEROgcLjC78HbJl1PINV1HGGSdGFzSoaZjy0lHoMS4bVn6eNXJXttpQrm2N25fypbqne0a
	XWgEdPfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwnyg-0000000DQv5-3peB;
	Tue, 16 Apr 2024 18:56:22 +0000
Date: Tue, 16 Apr 2024 11:56:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 3/4] xfs: introduce vectored scrub mode
Message-ID: <Zh7J1tDb4nEDkCKo@infradead.org>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030293.253873.15581752242911696791.stgit@frogsfrogsfrogs>
 <Zh4NtkXCdUumZmFQ@infradead.org>
 <20240416184652.GY11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416184652.GY11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 11:46:52AM -0700, Darrick J. Wong wrote:
> "A reviewer asked why didn't I design the interface so that the kernel
> determines what scrubbers to run and in what order, and then fills the
> output buffer with the results of whatever it decided to do.
> 
> "I thought about designing this interface that way, where userspace
> passes a pointer to an empty buffer, and the kernel formats that with
> xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
> was.  I didn't like that, because now the kernel has to have a way to
> communicate that the buffer needed to have been at least X size, even
> though for our cases XFS_SCRUB_TYPE_NR + 2 would always be enough.
> 
> "Better, I thought, to let userspace figure out what it wants to run,
> and tell that explicitly to the kernel.  Then the kernel can just do
> that.  The upside is that all that dependency policy and ordering logic
> can be in userspace instead of the kernel; the downside is that now we
> need the barriers."

Maybe it's just personal preferences, but I find these a reviewer
asked dialogs really odd.  Here is how I would have written the
above:

The alternative would have been an interface where userspace passes a
pointer to an empty buffer, and the kernel formats that with
xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
was.  With that the kernel would have to communicate that the buffer
needed to have been at least X size, even though for our cases
XFS_SCRUB_TYPE_NR + 2 would always be enough.

Compared to that this design keeps all the dependency policy and
ordering logic in userspace where it already resides instead of
duplicating it in the kernel. The downside of that is tha it
needs the barrier logic.

