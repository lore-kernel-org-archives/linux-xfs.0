Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBBA381AED;
	Tue, 30 Jun 2026 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796629; cv=none; b=klxXn9HXjC4Zr46blUoI7ohlBcJm0nk3omTJKfSIzcs1WgNPqTp7Ae7wNftFD9qqt1NQ3lMSjBw/ciPQo/FUoF44n/vuJzOSQcla4+hCjn7SSsVCytGuiUeOgxgrNDPZGkKsWzEKZhMYIfgSmmkJL6I+uisBd5Sn4k+3ELAdSb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796629; c=relaxed/simple;
	bh=MiJe7isISgNG5OMPGsiPdUY/GJnVphq8YxWVf4mmKqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmX5Tm32Uuc/5e3zviBrK0+eHG/n4Whxdpe6McRbe4cY6F7ZTLsDczVTyB1gcuA4TYh4SPczQNRI9S/lZWqpGY3sbwB9Xj9HtaGmSf0FXVg7j6paO0LJ5OhInD1yBEDNijPTAOq/NBNmTHpU9+G9GVImLM0qrNnsvqvpx1dpWYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EB0468C4E; Tue, 30 Jun 2026 07:17:05 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:17:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: add a separate bio_set for iomap_split_ioend
Message-ID: <20260630051704.GD20771@lst.de>
References: <20260629125229.3400726-1-hch@lst.de> <20260629225831.GG6095@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629225831.GG6095@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 03:58:31PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 29, 2026 at 02:52:29PM +0200, Christoph Hellwig wrote:
> > iomap_split_ioend can split bios that already come from
> > iomap_ioend_bioset and thus deadlock when the bioset is exhausted.
> > 
> > Add a separate bio_set to avoid this deadlock.
> 
> What happens if &iomap_ioend_split_bioset is exhausted? 

mempool_alloc will block waiting for an ioend to finish.

> Won't that also stall the ioend submission?

Yes, but at least it won't deadlock, unlike the case where we're
waiting for the parent one to finish.  (multiply a few times
as there is more than one entry in the mempool, which is what's
saving our ass in practice)
