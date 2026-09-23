Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04CD3546C0;
	Wed, 23 Sep 2026 04:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790138646; cv=none; b=iiLaDP0XHjF4nmMqJT77zRUfdcOxVbXSZo3rrHsjzljljBZ8rCUfyByz5r5R3DRdECPvCdUYcfeZPkorsoDACaIOJ5cOcmqLbpfhZRyWn2Db6FmBbb9y4p+PvEzPyaw2uPf8H/0RyLZZ/v20V2GYKLNFjOhJ7TmLIE9CPLoWuQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790138646; c=relaxed/simple;
	bh=3K1In4nT3i2HdiuMdKKzMjhK07IZEuKn6Ukoh+Vhlys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRqzfC6h2lCUVHF1tmHdac/LLMvqHPInqAYsNCk88pz3Irf7hKDUUfe61gW4g4LjxEyyg3ZK+Av2MwFzdbPCR4SNtQTV5GBWAHnSjl7XSwdEv0jyiYG+G4sapk/R+iPAG4vmhUY4XVrhaWMGhSvLeCDGi2bMIPHObfaswb3vf50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JOydNZmk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JOydNZmk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3rrTkfCLkv5vG8mm0BkucV5d5ipKmcNjzN+oEKrrF4Y=; b=JOydNZmkvLmfHed3Px4rMYO9fW
	ovH3G1XC9S1RqxA9m4xOFtseOap20xWrt11xXV9ro3mhmrMkwLiQYjNx9DJ5OU/jVvreTwXo7wkz7
	E1RmjRTmmDGMGPxsBWYQg7xSUEeom5MHDX9CHR1Q4ZreWi/JrfahFI/iCKtQ8HNGSMoQ2dhqsLcdd
	2SfRB5K4vBZ5g/6EgsFwSXMO/pALL7eqXnGTTnUKUmY+YTY/dtuus6GWDlk6fsqjUDYTUemDMYNPE
	1Tcaegw/NCnx2HYskpeIz3PqJkEAbcypYR6nU9GSgrKqBcV4Y/NKFmDUOpnxl/f+lLsiPYVaScByF
	3j9NSTaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9Epv-0000000780Q-3ycD;
	Wed, 23 Sep 2026 04:44:03 +0000
Date: Tue, 22 Sep 2026 21:44:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>, djwong@kernel.org,
	ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <arNZE37P5khvkJYK@infradead.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
 <arIszDCcy0VbRVFp@infradead.org>
 <arI-5Ejg0Xw7OVmH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <arJ1dfejt4DyCsvG@infradead.org>
 <arKAqsuSoxvM1yKt@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKAqsuSoxvM1yKt@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 03:27:54PM +0200, Andrey Albershteyn wrote:
> > 
> > Yeah, but what is the ilock trying to protect against?  ilock is
> > the innermost sleeping lock and protects modifications to the
> > inode fields and the extent mapping.   Higher level synchronization
> > is done using the iolock and the mmaplock (which is already taken
> > here).
> > 
> 
> hmm maybe I don't understand what you addressing here but don't I
> need ilock for xfs_itruncate_extents() used with this transaction.
> So, doing extent removal.
> 
> With this function I want to remove post EOF pages from pagecache
> and then remove post EOF extents on that inode.
> 
> iolock is already hold, mmaplock is for pagecache truncation and
> ilock for extents removal.

So there should be no reason to hold it over the call to
truncate_inode_pages.  I.e., you should be able to move the locking
and ijoin below that.
