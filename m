Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338121946C7
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 04:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730263506; cv=none; b=URmYF38UctANgzoV7/Ogdq5g1MJ2K7GIlY3ZIJ+q61JG6O7vxhrcgvBQskq3tIHB9tXsWWx7WHvwL6p3RjsFqDRqz0hWL8NAJEQW82DsSBoLT8UF+RdILmySP50MQ6UMd8TZTZ1qmE6IaOZxfJncqPgfoF+8KD9sGQG+J/4Yx3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730263506; c=relaxed/simple;
	bh=Z9X4fYsLIxyA6TiGqXzaAxAkn1RJHfyxAV5+ti77B40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4myw/4VyUjttRyr0nmYWWeYLTHW/0lnXekQb4zn+bP63tSPH0PpFxuN0pxLOoHDpeBHl5+0KA/6czqxUXydhstp8oYjZx1QhSN/JL0LcTjrePfLmF52ek2e0YNt7Xk9eLtjD+gKgOAStZRas1QG2MS/0vRc3IBwZUq53Tj8Fmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9581D227A8E; Wed, 30 Oct 2024 05:45:00 +0100 (CET)
Date: Wed, 30 Oct 2024 05:45:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: remove xfs_page_mkwrite_iomap_ops
Message-ID: <20241030044459.GA32257@lst.de>
References: <20241029151214.255015-1-hch@lst.de> <20241029151214.255015-5-hch@lst.de> <20241029155649.GV2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029155649.GV2386201@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 08:56:49AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 29, 2024 at 04:12:00PM +0100, Christoph Hellwig wrote:
> > Shared the regular buffered write iomap_ops with the page fault path
> > and just check for the IOMAP_FAULT flag to skip delalloc punching.
> > 
> > This keeps the delalloc punching checks in one place, and will make it
> > easier to convert iomap to an iter model where the begin and end
> > handlers are merged into a single callback.
> 
> "merged into a single callback"?  What plans are these? :)

Well, the good old iterator conversion originally from willy.  His
intent I think was to avoid the indirect call entirely for performance
critical calls.  I'm more interested in allowing the caller to keep
more state, and to allow nested iterations to e.g. make buffered
out of place overwrites suck less, and to maybe not do synchronous
reads one block at a time in unshare.

This was my last spin on the idea:

https://www.spinics.net/lists/linux-btrfs/msg122508.html

I can't find willy's two older takes right now.

