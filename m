Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FB152F6F;
	Thu, 28 Mar 2024 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711645749; cv=none; b=AtjNmSzttNiOBLtYWhYNOXeV6FsXcPNZropdRP2SJSgBRAP7XBsatTW5l4unxsvfnyBZ7uYKnWmtNGbm5MfKIzyRR4pqoVXvTe/NFnL1Vr6InI63nmssKO7BFvBuTvN7roqSRwqzJJK7/u3XN4202ZJQfivD3yfunJb2pHfSnqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711645749; c=relaxed/simple;
	bh=rdBT8kIatNE2/tMAWC6QZ70RjF62nq+PbJ3i3k+0GkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWKvktMz2Z/+RRDqQmN7H2zswMby0VIUAvM0mBIrb02jwkt+0zH5bW30v6CdEDeErNDjYU4UUebpzekRsw5FF7nTxOm6lBNjxoJFmkBhGXVHZ2HB7rgi51DD/SFfz4oYW58fLiWdt5Gx+tVhJHILTGvGL/Jkntvvb1VB4b7iIAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9497668B05; Thu, 28 Mar 2024 18:09:02 +0100 (CET)
Date: Thu, 28 Mar 2024 18:09:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: don't run tests that require v4 file systems when
 not supported
Message-ID: <20240328170902.GA503@lst.de>
References: <20240328121749.15274-1-hch@lst.de> <20240328135905.fw27fzpixofpp4v7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20240328145641.GA29197@lst.de> <20240328150542.GD6379@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328150542.GD6379@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 08:05:42AM -0700, Darrick J. Wong wrote:
> 
> The crc=0 forcing case seems only to activate if
> XFS_MKFS_HAS_NO_META_SUPPORT is non-empty, which happens only if
> mkfs.xfs does /not/ support V5 filesystems.  Maybe we can drop that
> case?

The way I read it is is that it is activate if
XFS_MKFS_HAS_NO_META_SUPPORT is emtpy, that is if CRC are supported
and it then disables them.  But only for < 1024 bytes block sizes,
which we don't actually support for crc-enabled file systems.

Maybe just drop the 512 byte block size testing from this patch
entirely?  And with that the rather oddly named
XFS_MKFS_HAS_NO_META_SUPPORT variable can go away as well.

> > xfs/096 requires an obsolete mkfs without input validation, but
> > I guess adding the doesn't hurt
> 
> Why do we even keep this test then?  Do we care about xfsprogs 4.5?
> 4.19^H4 is the oldest LTS kernel...

Good point.  I'll add a patch to remove it.

