Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145051F09A8;
	Mon,  4 May 2026 04:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777870729; cv=none; b=IjsCi6f0ahT7AJNQm7FFKKnW2ExDunQ/oILZ/MB+GMM03N3UIztNQXb1Ma7imMTNRHJv650siV+xPtWEO6L7APf7p3DfO4DxsMnphaLFkwSAuEI2CSgLQ9COR6V223N/wlXkqnSCyx0jn/aqRxEsOkJp5a35RNyB/lfM5N1nH+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777870729; c=relaxed/simple;
	bh=HDD2JjMSCwaAzH5cmnutTQ9kbbQjd8Obu8MwU/ju5G0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6f7eViIbyz3pPpIWwkDcl+wuySIBpBvqFsqbQWdTJfuKLkYNcY7E8r4FA5x1vYBUZDd1cl8mXMb0nazObU2hfxFOBzu9BlF3wzWwC1edCJDSYGSASXeEu5UrA6cVEK4n8HrrBNB50HBjVCgX9bRBeSe1cioI34+rT1Xzjk7uRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 75EAB68AFE; Mon,  4 May 2026 06:58:44 +0200 (CEST)
Date: Mon, 4 May 2026 06:58:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: pass a minsize argument to
 bio_iov_iter_bounce
Message-ID: <20260504045844.GA9353@lst.de>
References: <20260430132019.312405-1-hch@lst.de> <20260430132019.312405-2-hch@lst.de> <jgzzl7e6qzea5ohma2tdma2rndlaj4ouohsiwohpz22w3aiqvp@czndpvnggd3q>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jgzzl7e6qzea5ohma2tdma2rndlaj4ouohsiwohpz22w3aiqvp@czndpvnggd3q>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 01, 2026 at 02:46:51PM +0200, Pankaj Raghav (Samsung) wrote:
> On Thu, Apr 30, 2026 at 03:20:04PM +0200, Christoph Hellwig wrote:
> > When bouncing for block size > PAGE_SIZE file systems, the bio needs to
> > be big enough to fit an entire block.
> 
> We set the alignment to fs_block_size when IOMAP_DIO_FSBLOCK_ALIGNED is
> set. And we always set IOMAP_DIO_FSBLOCK_ALIGNED in btrfs for dio 
> reads/writes. IIUC, it was added to support bs > PS block sizes in btrfs.
> But in XFS, we set it only for CoW inodes (xfs_is_always_cow_inode is true).

Yes, I ran into this with zoned XFS on large block size.

> 
> The commit message seems to indicate this is needed for all filesystems
> that support bs > PS configurations. Am I missing something here?

No, the commit message could be a bit more exact.

