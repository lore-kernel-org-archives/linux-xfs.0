Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6BA46434
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736230477; cv=none; b=GKFfH+tr9SJHXsPwRE4uMfr7UMinr0nLWlwzEHe447Nj58g3CyBBZl+ShxVy9lqdEi4W56gqXb5GmiTzKxO2hq/jhNqYj+NGNDMDS1n0FYLeLUIFalSYGjVEFNa5cBFrEZyIzAMaumMHy5mnvPdv9suMBDiR9Pt9MAGj20RR5RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736230477; c=relaxed/simple;
	bh=/zkEadBnP4asB357KdUOPanrifH3CEQsDvZQtIK1PbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plY5CIyzPtU/VKaZ7GQCIoIdFhdWAcKsrHCG43QQWToAeVC7f6/HTCVmBGgTjIGf1ltgLXsHZ5gtQBM9776WTt/KDUJ/w3Sqna+4LQJDPJx0lTR1efoexhfP5ALKuQZA8Tn9hGgDACl9RR74C9FVuSKNA4zWvFM3+gVKileovpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Juhw+L4S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Juhw+L4S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=E8eWPWd0b5Vz+c5GZujuEQmVGjWciujdf9fKjHq2zcU=; b=Juhw+L4SpXCMD0JgSwJpyAsQDW
	UKOdvYwHeBcVZ9Xkey1f7mf4+alIcz84e7296Zw+PshO0fCNw9ChUl1GP92HRaMzqxHfoXmliWQ1d
	JT7APubgTagRaEoWUNpi52HSNhWD6R1ILpoWek2Xkad27h+41+CXZVPVoFcZW3kikq2oNrFxrNjqO
	8OxZm2RAnS/Tjo43JmbvCsCkAKzOMTA7rLCbCxuVdyVgCMtxD6u7oFbGUbLtIxFj8V5o3FDNMk0tF
	+X9ZowuPQZAtUw9+YcC7EDnGcf3k9X79Qa7hfMiAj0uDU0vXpS6lHc+wa7b0AlLjhQqQSuq04dkrl
	mPydcgBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tV2rL-00000003cKJ-1KLU;
	Tue, 07 Jan 2025 06:14:35 +0000
Date: Mon, 6 Jan 2025 22:14:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Sai Chaitanya Mitta <mittachaitu@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
Message-ID: <Z3zGS9Ha13I8VBtI@infradead.org>
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
 <20241223215317.GR6174@frogsfrogsfrogs>
 <CAN=PFfKDd=Y=14re01hY970JJNG7QCKUb6NOiZisQ0WWNmhcsw@mail.gmail.com>
 <20250106194639.GH6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106194639.GH6174@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 06, 2025 at 11:46:39AM -0800, Darrick J. Wong wrote:
> That sounds brittle -- even if someday a FALLOC_FL_WRITE_ZEROES gets
> merged into the kernel, if anything perturbs the file mapping (e.g.
> background backup process reflinks the file) then you immediately become
> vulnerable to these crash integrity problems without notice.
> 
> (Unless you're actually getting leases on the file ranges and reacting
> appropriately when the leases break...)

They way I understood the description they have a user space program
exposing the XFS file over the network.  So if a change to the mapping
happens (e.g. due to defragmentation) they would in the worst case pay
the cost of an allocation transaction.

That is if they are really going through the normal kernel file
abstraction and don't try to bypass it by say abusing FIEMAP
information, in which case all hope is lost and the scheme has no chance
of reliably working, unless we add ioctls to expose the pNFS layouts
to userspace and they use that instead of FIEMAP.

