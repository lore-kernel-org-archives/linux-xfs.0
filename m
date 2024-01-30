Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489E54670
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 08:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706601852; cv=none; b=Iwwes/d2ShWQ4ECHMv8LtCCFROJizMHTmcsWGTqEh4p71nBnMdyBksQBu8GcIzcorQjk4h1hnXI4n2n52xKEFpCRZD76Bi1X1EPS/AIfJxXLyYmkTRzNGPEfC6ETbR25i+mC8QCIEY6XZUPEftFkwP1WaFCpCHr0cab5bYaBgRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706601852; c=relaxed/simple;
	bh=pTplPhcr7Jj1tNu8hZF5DQZqKIFSMW6pSexyZk1i1BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCISJa8nqtdtzOAmxPlcYh1R5uzKjU2vdRMLMeqQIMq70TkqzYneOe++azWw07GeLOoXuMh71cET0SqU2toY9JrqdD2rH0Q8YhR/eNY1PaPslNePdHujVW6Gza+px28xynwubSZNWdQFvQPTelTxPDhgeB7FlQRA8LHFIrbI1cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B472C68C4E; Tue, 30 Jan 2024 09:04:00 +0100 (CET)
Date: Tue, 30 Jan 2024 09:04:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/20] shmem: document how to "persist" data when using
 shmem_*file_setup
Message-ID: <20240130080400.GA22621@lst.de>
References: <20240129143502.189370-1-hch@lst.de> <20240129143502.189370-8-hch@lst.de> <ZbiR1Jj0gwxAPVSA@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbiR1Jj0gwxAPVSA@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 30, 2024 at 06:06:12AM +0000, Matthew Wilcox wrote:
> On Mon, Jan 29, 2024 at 03:34:49PM +0100, Christoph Hellwig wrote:
> > Add a blurb that simply dirtying the folio will persist data for in-kernel
> > shmem files.  This is what most of the callers already do.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> I noticed today that drivers/gpu/drm/i915/gem/i915_gem_shmem.c is
> going to a lot of effort to call write_begin and write_end.  I'll
> take that out as part of the shmem conversion to buffered_write_ops.

I was planning to look into that, but I'll happily leave it to.
It also calls into ->writepage in a somewhat gross way.
