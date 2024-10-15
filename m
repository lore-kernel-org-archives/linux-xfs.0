Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6B14C8C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 03:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728963050; cv=none; b=C/fwujSFT1hXmDFuozvVT6ChIeR90iaFAg8rWlqqD48YwLTSj0cp0Sfi+gJdakYNIRfwjkCNaSWaKgALOXNAVfCcKltEpTsxoqHNniQQiT8wsxMvK8f1hbGLEVlvwHbBnLh+IBmDU+8kQ/D0Vnlhx6K9lkw7KVo+nk/66Ysth4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728963050; c=relaxed/simple;
	bh=iBqxFAYPaY427QEfTQs/CO9UtOSVBEN1hnTNv2mWBmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQUshMkF6dozNp6bf7ZyMKP9hKCwvNJnr+flmfnnG+adkffWW6MfgYyVBbchqba6xmTLG5oCv9Dqtp2LywtwhZKh7u+EkpHNr88ZM7H1xPQwXttI6v9Gp3JLAa1DZc4aXBrx286CyIw2KSE/B9E/e0w17xxCZUgRxbN7ytKk4IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u+f6ldIb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u+f6ldIb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y4rqGjC+dEfaLyNfv3BamCbQtYyFdb/qLI0Vq3WbjZs=; b=u+f6ldIbZjdzgGBtcL4EWCkAf5
	f2zYXRZ/EywgCsjzCzL6x1swzGRMYaptgWes3A8tLBPLgDX4obwbqrjgeJlCQInVHoEKe7vF0kYN1
	xz5O8cIj20f7545Z4uNURh9NGQIWpyCNkHDJEhBwv3spNhs+cIWPDuR/55Q45qesB9fLb0wjmTPbV
	6WnxH17nFMN8XBj6DNMjNPAOV5N/AwErR/oyMEGhjH0dZ2yBNRU0mpLWN5o022pIIWs9eP0rlxpFe
	RkGw7jqmNo7QC6gIOtwQ1pkehDg4YTJbFhOZ/XyBAwN8jnBrGWc5/EH1BllimmKXN73cZheiBhSWc
	JtmSah9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0YGm-00000006z6a-3V5c;
	Tue, 15 Oct 2024 03:30:48 +0000
Date: Mon, 14 Oct 2024 20:30:48 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	"hch@infradead.org" <hch@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/36] xfs: export the geometry of realtime groups to
 userspace
Message-ID: <Zw3h6JUJZa0SZisW@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644412.4178701.5633521217539140453.stgit@frogsfrogsfrogs>
 <ZwzXRdcbnpOh9VEe@infradead.org>
 <8ecae4c5-aeaa-4889-8a3a-e4ba17f3bf7c@wdc.com>
 <20241015011432.GQ21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015011432.GQ21853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 14, 2024 at 06:14:32PM -0700, Darrick J. Wong wrote:
> Hmmm so if I'm understanding you correctly: you want to define
> "capacity" to mean "maximum number of blocks available to userspace"?

Well, what we want is to figure out how much data each rtg (and thus
hardware zone) can store.  This allows databases to align their table
size to it, and assuming XFS does a good job at data placement get
optimal performance and write aplification.

> Does that available block count depend on privilege level (ala ext4
> which always hides 5% of the blocks for root)?  I think the answer to
> that is 'no' because you're really just reporting the number of LBAs in
> that zone that are available to /any/ application program, and there's a
> direct mapping from 'available LBAs in a zone' to 'rgblocks available in
> a rtgroup'.

It's really per-group not total file system global.  So the reserves
and privilege level should not matter.

> But yeah, I agree that it might be nice to know total blocks available
> in a particular rtgroup.  Is it useful to track and report the number of
> unwritten blocks remaining in that group?

Maybe.  Not rally the prime concern.  Note that for the zoned code we
can do that completely trivially, but for the bitmap allocator it would
be a bit expensive.

