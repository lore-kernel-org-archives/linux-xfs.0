Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06734156991
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 07:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734505854; cv=none; b=KLeD3FrNGdps1dBp9zDDIA2Nb+MCPOh+dFTJL9LzGpmPO39rIUmK1R+sUVlRApiQdLKyN8fKmOsN0l09LxxtGqfgnw96HrCRQ7zGQjBd/NqVRLTx3qWiBTzoDtGwXtQmJNo+FTDi9sRIrCXlfDkMMjslxNTn4tB3+osbLhyyEdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734505854; c=relaxed/simple;
	bh=Bn3g8Ig8n/6EyYk+paPjqetONfnvV8LRgb3UPeTmCkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L4M+syXOcnvkIoOgPIi00YDyPBCw42rHzTX1xuH9x8+fs4NeG46TU4zUmXgxk9bBAtZt7nQ8s4h44g5VDegPfmOYXGMMSlphxiCQqWalP+OmBjhg0eSQPow927icm/EMfHNSlPFpXsB8Ujc5MUaoFLJVdPb7np7MHPjW+vqlL1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5312168BFE; Wed, 18 Dec 2024 08:10:49 +0100 (CET)
Date: Wed, 18 Dec 2024 08:10:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/43] xfs: support write life time based data placement
Message-ID: <20241218071048.GB25652@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-42-hch@lst.de> <20241213230051.GB6678@frogsfrogsfrogs> <20241215061902.GE10855@lst.de> <20241217171447.GL6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241217171447.GL6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 17, 2024 at 09:14:47AM -0800, Darrick J. Wong wrote:
> > We've been thinking about that a lot.  Right now we don't have an
> > immediate use case for it, but it sure would be nice to have it without
> > needing another incompat bit.   But then we'd need to find some space
> > (3 bits to be exact) in the on-disk inode for it that doesn't make
> > otherwise useful space unavaіlable for more widely useful things.
> > If you have a good idea I'll look into implementing it.
> 
> How about reusing the dmapi fields in xfs_dinode, seeing as we forced
> them to zero in the base metadir series?  Or do you have another use in
> mind for those 6 bytes?

I've always seen those a general space reserve for things that could
be useful for all inodes as they are fairly large and contiguous.  For
these three bits I'd rather still them where it doesn't hurt too much.
But maybe I'm overthinking it.

