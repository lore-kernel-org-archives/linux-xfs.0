Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6145B145B3F;
	Fri, 24 Jul 2026 06:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874389; cv=none; b=ZfL3cLPSJWWh5MDNEzDgnGU7FW/NyXJBSsW9eAQ6AMmG9NmuZPC3WoL1rrAEAIKs3GRUBpjqh6Cvqqmnr5karrImxsqOqYejKjylwA53fYM4dDCGmcHJmi35feCCt6auTRSXk6f9oufNO8BE4aGq9O7uksVulN0/vis2hpG1ztk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874389; c=relaxed/simple;
	bh=TO+CSxuShwI80BRgdWJwH0qKYh1Dgnl6ikaiT+0Nmls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAf+BLXBQW7552w6VpBrKO+Cz9HyMRNuInoeFJwI5qUi7s6QaGVg7M3ZBluaF51D3QuPD58Js06TweJt7kgVnu6Kt9cf3UULOyhgE1EXy9sYePKVM2965P0H+2tgzbjfoMCVJZuiw6GfDhOgY2HitUViNVIBRRXY7Rp67nU7ztA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D58B68BEB; Fri, 24 Jul 2026 08:26:24 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:26:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/22] iomap: better read bounce buffering support
Message-ID: <20260724062623.GG4953@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-13-hch@lst.de> <20260723211004.GM2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723211004.GM2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 02:10:04PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 23, 2026 at 04:49:37PM +0200, Christoph Hellwig wrote:
> > Add helpers to bounce buffer an upper bio into one or more lower bios
> > using bounce buffers, and to copy the data back on completion.
> > 
> > Compared to the existing IOMAP_DIO_BOUNCE support for read bios, this
> > has two advantages:  by removing the special bounce bio_vec it allows
> > to the full and "round" size of a single bio, i.e., 1MiB when using
> > 4k pages.  This is important for good performance on HDD.  Additionally
> > it allows to bounce buffer a bio from completion conext, and thus
> > implement a "lazy" bounce buffering scheme, where the data is only
> > read into a bounce buffer after an initial checksum validation failure,
> > thus avoiding the bounce buffering I/O for most I/O.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Now that I can see how this is used ("xfs: add support for lazy direct
> read bounce buffering") I think I'm ok with this.  Should there be some
> Documentation/ about how to use PI with iomap?

Maybe.  Although I'd rather have a second example first before coming
up with definitively guidlines.  Note that even without fs pi they
should use bounce buffering for devices that require stable pages to
avoid corruption, but no one has been particularly interested (well,
minus btrfs where the native checksums make it more common).

