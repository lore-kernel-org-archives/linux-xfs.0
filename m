Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888792E3365
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 23:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741218352; cv=none; b=F8LLseo7+RVD0/r3fJHzNUBzXemF8ZmHM/YJGZfYXnDsgsN3Ya0YFZMZOrpXXS8cnrCSTpnm+pqN/UjCsTBraA5bYGJjhccHM8qvvfmdCZmdtHfaVxgGW+3Udv3arc8HQE8mmBnwqAmLmgrLQvuVMBHUe6SVPQj2NLO8/KZRiAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741218352; c=relaxed/simple;
	bh=DD3wSyq/HOvS96utl+TEr7WTsMHlsBNOg/fxa+taFLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljrZ2poNcVKwdtxQCwgR1VirTES0AI4HlXFGSbSzTyqE1mY2ic+Go807m2j6bV75xjoYPJC9wNGxYuiwaekNEYjy0gP2ggiOgsjt9Py7kLSpaDRpORdUwB37ZDd1tPQ7bk7bwV9nbLYykWNdQ6dGQsdBf2XJKegae65i4/O5IIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0D7B868C7B; Thu,  6 Mar 2025 00:45:46 +0100 (CET)
Date: Thu, 6 Mar 2025 00:45:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for
 buffer backing memory
Message-ID: <20250305234545.GA896@lst.de>
References: <20250305140532.158563-1-hch@lst.de> <20250305140532.158563-11-hch@lst.de> <Z8jACLtp5X98ShBR@dread.disaster.area> <20250305225407.GM2803749@frogsfrogsfrogs> <Z8jeHjpn_VTjMFCg@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8jeHjpn_VTjMFCg@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 06, 2025 at 10:28:30AM +1100, Dave Chinner wrote:
> Yes, but that misses my point: this is a folio conversion, whilst
> this treats a folio as a page.

The code covers both folios and slab.  willy has explicitly NAKed using
folio helpers for slab.  So if we'd really want to use folio helpers
here we'd need to special case them vs slab.  That's why I keep using
the existing API for now until the block layer grows better helpers,
on which I'm waiting.

And this is not new code, it's relatively minor refactoring of the
existing code.
