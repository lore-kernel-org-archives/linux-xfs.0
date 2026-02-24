Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C429A39E6F9;
	Tue, 24 Feb 2026 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771944721; cv=none; b=FuB4+cBw0Ko+jqguKBQRkNLO2GfnAo4z2jPU223ItVzM8h8Z/ftfseJw/GdryrDPtg5VAy1tZvGN3fTb8yHWwfKRCsAWNWBfAKugffaH+PXmRh0IEGUOevF0rH/b2vPKswHfW6O2Wq4iIPxNkf7GZDp1/Imd4lzjnn2BUKnXkxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771944721; c=relaxed/simple;
	bh=iyIHMDWafRDoQWMxBuWvwQXYG3m2tJZQ5KOhoIR+TDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f9Mam3ybSFiLK2agS3xp8F+hsezprqgS+DlTZ8D8Hssjvax6ydoYi30583sEkV2hMPHk1iP/j0IWW8PQk8A142/4q+rywYF5/hPXrKW3Ch5Di+M1p8VynCCNbP/1yJzvUCDDfYYnqkyIUin180en15EHhJtE1mUs2MAewh1RWQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2604668BEB; Tue, 24 Feb 2026 15:51:57 +0100 (CET)
Date: Tue, 24 Feb 2026 15:51:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH] fsverity: add dependency on 64K or smaller pages
Message-ID: <20260224145156.GA13173@lst.de>
References: <20260221204525.30426-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260221204525.30426-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Feb 21, 2026 at 12:45:25PM -0800, Eric Biggers wrote:
> Currently, all filesystems that support fsverity (ext4, f2fs, and btrfs)
> cache the Merkle tree in the pagecache at a 64K aligned offset after the
> end of the file data.  This offset needs to be a multiple of the page
> size, which is guaranteed only when the page size is 64K or smaller.
> 
> 64K was chosen to be the "largest reasonable page size".  But it isn't
> the largest *possible* page size: the hexagon and powerpc ports of Linux
> support 256K pages, though that configuration is rarely used.
> 
> For now, just disable support for FS_VERITY in these odd configurations
> to ensure it isn't used in cases where it would have incorrect behavior.

Do we want to throw in the towel here for the forseable future and if we
ever need to support fsverity on > 64k page size just do a on-disk
version rev?

Because if so we could just simply the pending xfs fsverity support to
drop all the offset adjustment and simplify it a lot..

