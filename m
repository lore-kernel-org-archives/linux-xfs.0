Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4522C29B0
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711430121; cv=none; b=uhim3dTlnTTftT679NITea5r1bRAAKjcid7XUST+IFLYT4A6cPLHvaNctbeEw5OiY1XnR5x/nV7AFyPFFJ3M8YH9HLIrp/n8vlg+hbDrk1m2vLHr03uQQW5uE7y+de2oMLMjlP5lpsbcZaEdJow+arBFgKidaMOMj78J1vboFNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711430121; c=relaxed/simple;
	bh=hn1vfAZ7B+hIfp6N2LtAPNqP2Ue3HPnfF7WaKvWqY6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KC3A8ryVAGSN9Vd94XsbrtpkhBtzWl+ZXtNVPl7iwekmq24ZqQUb+9xzCSGV/LAn8m76Md5KIIQgJlo9BECQs9VBRMvOb04KKC2Mi2kKS7RZkCNXwxzUxf2etyZcTzjCiBCA1HVdnyDKwq+jXpOAaUPXaN6XTftT5CjtypcWRq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jDwDcIPB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jDwDcIPB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HaEboJkVHpZjeK13WW9KIsXrFPODwDd9ryIaJ/eFBcs=; b=jDwDcIPBb4sZTDZD5/2I7QokYf
	LepD8h4pFlKYSfqwtdFk0DeKfKjF8UyV9OXId+yhfLPiOX56NK8SowYISRGjpv+v1q0/UzzlIXL6a
	BwVC6nDn22kb5LWluQmtoXOCuKyU5eE4z++/sFnzo4GL3IQOxcamXCojXYX/eaPVwY5OPzuVEY/Rr
	Qfzoacc9C4IOizog7E0s5YHWi5U0IogF8DyL4P3J+4vlA+j8xEx+AXtf+/T4brJ1wHKQyffT/h60R
	Eh9MdiORFyNpySFCEh0GjfmY+fT0w3pogJCNutAoHs7KOx8wm5wcfl7Jo4kgVBQjT6P4azai74jxl
	OFwVnuBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roz9a-000000037MU-3TQ8;
	Tue, 26 Mar 2024 05:15:18 +0000
Date: Mon, 25 Mar 2024 22:15:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: fix threadcount estimates for phase 6
Message-ID: <ZgJZ5t7hoeckBmig@infradead.org>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128608.2214086.995178391368862173.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142128608.2214086.995178391368862173.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 25, 2024 at 08:21:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a filesystem has a realtime device or an external log device, the
> media scan can start up a separate readverify controller (and workqueue)
> to handle that.  Each of those controllers can call progress_add, so we
> need to bump up nr_threads so that the progress reports controller knows
> to make its ptvar big enough to handle all these threads.

Maybe add a comment to the code stating this?

