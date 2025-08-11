Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472902D12F5;
	Mon, 11 Aug 2025 11:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754912623; cv=none; b=GlHlM5bFZjMpmG/hKQ3K+IwDVrR8rJdJPCmzUABQTaoM3zZDZyE5WBL0SMcVsDiXOg90ZzB4vgrGc1+xqHJYcnfuxULmErphDPSIj3SOEdlHNdsEZJvb5LHImhTuz/hfjJmaKXLXyTTWLzGP3x8l8ISSILCP5lswYeGymkLnSkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754912623; c=relaxed/simple;
	bh=vDOfSTyaDKm9qIzU1tftk6AfsmG88YiZ4f11kGku9mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJEmsUiDqOi1ysYpZqtkKtUlDHFufTcyrUBsL7MRFsf9GD+iuX03Scj64ZjqvXXtw517BDewfoIH5zAG++f6F/KQXJKaM1DwI5h46zgIcarJrimKbbS3RWKJu3dj/gqoKRNK1QrHlE4+BwOghZ0iNqRijbr9/1kblY9R1/u/iUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B520768AA6; Mon, 11 Aug 2025 13:43:37 +0200 (CEST)
Date: Mon, 11 Aug 2025 13:43:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, ebiggers@kernel.org, hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 02/29] iomap: introduce iomap_read/write_region
 interface
Message-ID: <20250811114337.GA8850@lst.de>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org> <20250728-fsverity-v1-2-9e5443af0e34@kernel.org> <20250729222252.GJ2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729222252.GJ2672049@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 29, 2025 at 03:22:52PM -0700, Darrick J. Wong wrote:
> ...and these sound a lot like filemap_read and iomap_write_iter.
> Why not use those?  You'd get readahead for free.  Though I guess
> filemap_read cuts off at i_size so maybe that's why this is necessary?
> 
> (and by extension, is this why the existing fsverity implementations
> seem to do their own readahead and reading?)
> 
> ((and now I guess I see why this isn't done through the regular kiocb
> interface, because then we'd be exposing post-EOF data hiding to
> everyone in the system))

Same thoughts here.  It seems like we should just have a beyond-EOF or
fsverity flag for ->read_iter / ->write_iter and consolidate all this
code.  That'll also go along nicely with the flag in the writepage_ctx
suggested by Joanne.
