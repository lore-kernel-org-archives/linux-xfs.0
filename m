Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79B4474257;
	Tue,  4 Aug 2026 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785871739; cv=none; b=n//z7Xd79nTB7ZurstOClEIPAyDccwLYMVvc2Pyw0CxMsgjI1wRG2tds4wp5o7SKq+7GhBSuaeS3PCkAByhoB5dpQXu1yO6VLBN/j1HvbMnKwWfME0gg4x5trI9IxqVIaA4VLPfj6P/Meg6+Y2c2PJhbpFJQTHKPCe88H9H9D3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785871739; c=relaxed/simple;
	bh=OAzPQ7Pbeqr0hWjwOERI8ok5uZRMyttP38UnkhXkAyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pxyNzhfylVBnaI2+EwVwN8Lbg+65NyJI62Ong4Uaa888ixhznCleOTI37Oj+4JmtVNIErqsuUObWVX7xb7nMgo2hZPXOSBX5rTvk1yN8dN5ARepxMaEde7eUPx36iKRLB41NqxNIhujzMQyfAsz5r47JCBFLSRA9tc88tK8OM0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IPOxK2kI; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IPOxK2kI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WP6wjE7qBnj/GunjrqvRBraBLVBkydynCewnbZ45t5E=; b=IPOxK2kIjgPlxLgyvM+ibdufZV
	qhsZVGcuyTtaA3Pir2gF5JgsdoJrPXPRwOoFEIs4vLeWpzMOp2IlvrfnQCn6TauSmBSLIN5+SYmO4
	TyEWBwu6aV+rF2IyBtnbK3VjfRVkrMuFT9GfKrqwWgsSAZgroNijF/7kF0nFQM8g+aFSn1R44SMUu
	zT0iPzhgk/5R7cFv+K+DW3KSU4e6n+QqQ83UtnFyNsJuX1N8NAXlkZBMG3du1L8Uly/1tclAZtiB6
	GWcrf1cPozqPOjPAxleYmJW4CemcXafgGTzCoyywXua2bXD4ev8sEkIKxsshSTmXZynSWbbYAyDFO
	6NbjtFDA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrKol-00000004bOs-1Zgg;
	Tue, 04 Aug 2026 19:28:51 +0000
Date: Tue, 4 Aug 2026 20:28:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <anI9cztkOa1yg7yv@casper.infradead.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-6-aalbersh@kernel.org>
 <anIzawflI11C0FT2@casper.infradead.org>
 <20260804185603.GP3556460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804185603.GP3556460@frogsfrogsfrogs>

On Tue, Aug 04, 2026 at 11:56:03AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 04, 2026 at 07:46:03PM +0100, Matthew Wilcox wrote:
> > On Mon, Aug 03, 2026 at 10:07:55PM +0200, Andrey Albershteyn wrote:
> > > The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> > > flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> > > systems. Open code folio mapping and flushing to copy all digests at
> > > once.
> > 
> > Have you looked at the implementations of flush_dcache_folio()?  On
> > any architecture we actually care about, all it does is set one bit
> > in folio->flags noting that the folio will need to be flushed if
> > it's going to be accessed by userspace.
> > 
> > But, um, do we support mapping folios containing fsverity data into
> > userspace?  Can't we just delete the calls to flush_dcache_folio()?
> 
> I don't think programs are allowed to mmap the fsverity data, right?
> I know there's an ioctl that effectively allows read()ing it.

read() is fine, there's no user/kernel d-cache aliasing problem with
read().  It's just mmaps that are problematic.

See Documentation/core-api/cachetlb.rst where it talks about
flush_dcache_folio().
