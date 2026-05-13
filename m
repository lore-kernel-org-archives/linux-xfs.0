Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC4B3D5643;
	Wed, 13 May 2026 06:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778655380; cv=none; b=K2ZJM9Fm7XUvpFwzEPMq9TYVpCsbfbCSoKvpYCb72XWHWr8iv1Gj0bzr/tIIxRt6JqtUiJqp3hzVkmapEKU7M7AG6lfxWkQDBWj2LkmiZ1sB0Sd2YswI6cgeClEUr3btMjUTEes6IAbsIPGqu7tEHc1+7EEJEkUbREBs263QKlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778655380; c=relaxed/simple;
	bh=P5caj/MRFse/CJvpKQWbUktTehkszC/Sgk5XdsZppJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JR0t3yQWUn/VTFKmG5V9VbdRk0ITuX43SNWH2kCNj1lz6unC9gr+olpbghacdvt+wgIkxWHuQkiQrohPtd3+oF+fPZAPlMXQkuoEsmwrLGPLcQZh51bXj07VttyWV8m+LCSQtlEClgjqxMOiZs7ZbsD4K4L4by39jyHiZNEnXP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 82B0768B05; Wed, 13 May 2026 08:56:08 +0200 (CEST)
Date: Wed, 13 May 2026 08:56:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 08/12] swap,iomap: simplify iomap_swapfile_iter
Message-ID: <20260513065608.GA2250@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-9-hch@lst.de> <20260512170204.GI9555@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512170204.GI9555@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 12, 2026 at 10:02:04AM -0700, Darrick J. Wong wrote:
> OH.  Now I remember why -- it's to handle contiguous mixed mappings
> better.
> 
> Let's say that you have a 1k fsblock filesystem and 4k base pages.  You
> fallocate an 8G swap file and then mkswap it.  The first mapping is a 1k
> written mapping at offset 0 for the swap header, followed by an 8388607k
> unwritten mapping at offset 3k.
> 
> The PAGE_SIZE rounding code in iomap_swapfile_add_extent will round the
> end of that first mapping down to zero and ignore it.  The second
> mapping will be treated as if it were a 8388604k mapping starting at
> offset 4096.  Now the page counts are wrong and the swapon fails.

Do we care about this use case?  I guess you did as you implemented
his, but still?

> 
> A more generic solution to this would be to change add_swap_extent to
> take sector_t addr and length values and use them to construct a bitmap
> representing contiguous physical space on the bdev, accounting of course
> for PAGE_SIZE alignment.  Except for the swap header page, every other
> contiguously set page-aligned region in the bitmap gets added to the
> swap extent map.

You don't even need a bitmap, just do basically the same checks as
the iomap code when moving to a new swap extent after moving to use
the sector_t.  And it really should anyway, as the current abuse of
sector_t to store a disk offset in PAGE_SIZE units is pretty gross.

