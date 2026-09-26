Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76663612F3;
	Sat, 26 Sep 2026 06:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403310; cv=none; b=g2b7UEkFsAAnoE+1EQilVpNUgCcpSSQCGaBCo41d+MRgTQQyRyRzJAJWO2kH2zyYi/FSXeWN6dDokMnXC/NsAbkSLo3aQtxLIIVICbo9bJ3UeLzzjY2nXT0Bdd4tp1a4gQIrskQ7Tc/Jpdg0EixzDvaBQEmPe2RDBczZPaMb9mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403310; c=relaxed/simple;
	bh=ybfMbt3QWGUxr4etQ28nY8SAVnkrVyEn/3gGGS4yuaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eEJisdUOen6eiSzBlakXrHxZ27K6774S+EHWA0elGtrgg1S9GOquJWf8D3LI6qHUlZ5QHyGpbRNKkSV9imfIz/Y8e90s2BSVJCKCW55OQ+eiMFYGFumxskQPCUMbUYxPXQBxkjIV1Ivre2KaPSknoXZi+Vdzf9b8SnAwVzrcgyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5F2D868C4E; Sat, 26 Sep 2026 08:15:04 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:15:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/21] xfs: require file system block size alignment
 when using data checksums
Message-ID: <20260926061502.GF20636@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-14-hch@lst.de> <20260925232456.GH2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925232456.GH2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 04:24:56PM -0700, Darrick J. Wong wrote:
> > +	/*
> > +	 * Each checksums covers a whole file system block, and thus sub-fsblock
> > +	 * reads are not supported for file systems using data checksums.
> > +	 */
> > +	if (xfs_is_rtcsum_inode(ip))
> > +		stat->dio_read_offset_align = xfs_inode_alloc_unitsize(ip);
> 
> The allocation unit could be larger than the fsblock size, why is it
> necessary to have such large directio reads on a checksummed file?
> Though come to think of it zoned mode doesn't allow rtextsize > 1fsb
> so this question might be hair-splitting.

Exactly, allocsize is always the blocksize here.

> 
> I think you could reuse xfs_read_bounce_minsize() here.

Not a bad idea.  Let's see if our header mess allows doing that as an
inline, as doing function call for it would be a bit silly.

