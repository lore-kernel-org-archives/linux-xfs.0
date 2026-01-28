Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BF92DB7B4
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 03:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769572025; cv=none; b=Xqd8eZ5X67NRRd2sGoJrucNkP2LiNmeRExshSdKHRoDmKrGRneF0Q26qWPYJGTiHqavT99HVuEfvCRGYADWthE1kWGO+jjDS9fOyc+C9X3IbSDBeUH4tul8qRygxcLWNDr3hC9zMiGs7HVN2VQNArWZRg64qsox6He/USVhxXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769572025; c=relaxed/simple;
	bh=KgHifRE21TAx7FWYqkQw6MdVjlhWTBRwQJWmOk4rs6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8IruYM54TzcKKLBEs2p1R1uLOq6dxUIyPyiVuQgGtdMsr2tThKCsS1JpEWuA/o+NFU0YNyuoHfNMX7lb6Fqea6flqfJAX7zBa50WkW8b/gKk17NNMTEOnmNCtQTrKvTWKc5nGYukP3AzR5F+jvLF/9MXRmTteYHd8vuCrBz5QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0BD35227A8E; Wed, 28 Jan 2026 04:47:02 +0100 (CET)
Date: Wed, 28 Jan 2026 04:47:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: don't mark all discard issued by zoned GC
 as sync
Message-ID: <20260128034701.GD30989@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-8-hch@lst.de> <20260128013818.GG5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013818.GG5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 05:38:18PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 27, 2026 at 05:05:47PM +0100, Christoph Hellwig wrote:
> > Discard are not usually sync when issued from zoned garbage collection,
> > so drop the REQ_SYNC flag.
> 
> Cc: <stable@vger.kernel.org> # v6.15
> 
> > Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> What does REQ_SYNC even mean for a discard, anyway?

It expedites a few things in the block submission path basically.
And deep magic in the I/O schedulers, but I'm not sure if that
even applies to discard.

