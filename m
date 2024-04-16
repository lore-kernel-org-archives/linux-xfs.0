Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0719911720
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245624; cv=none; b=CISqtMgjghjuAMB1QXL8BFygU0hHntdGxskkWo6JY6eJVvNfKkCtBCLmgMVLvjoZwL/L374/nDu3HJriBWQm3E46F9is8maLvATjJG9c54G6Bsr3yt3vGS+v6AIfObdlWCXjWuc3UbKmWrhAucRJjFICU7wjfPnFC/xGbSL7SxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245624; c=relaxed/simple;
	bh=DaKpVoClPRqp1VwJ5TF34N11M84U7xhKJphpyBfD2D8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLgNWuypOKf/SFNAV/ts2yUnyppN28oc5/oWV0mNRSnzIu722eatdMq4TswzswtIs5zTJ9EUzbbFU2VGMZAJyixDDQ7rCbq/EyN8GniWYrFcc1ic7R11F3VyOP1SOfknuLSDyguN6M3CC8B/FBTIejDxDk6UlZ1Zr+fOTC77mRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nNYUWlUK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nNYUWlUK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LbhemHZDgTpYve2pRJaW4BLB/mCAKNOKACiioyMGnkM=; b=nNYUWlUKuR7N5VVl8Ml3IbwRd3
	+gK/GOzYAb6/rKh2TzprUjBm9cByxCis3eIlBSwIuG5wfvviIZjNVYygVTmwDSerZMshQbyqqRI1p
	01c/JIIFJwFpqNTR5KBtqrI2sYqqf0Vm7fX7mSaclejDGw0A2h/sMqWuTzKsKX91t1fkguPrWJYc9
	y5h8xwbrlWfSzsSXOvW5ndvspPMSicWdeiC9mh+rR90PwYsIJJKf2A5qgCW9Lw+J2FlXPJytiO1oo
	8/4M5i7kmXrxbapkJKmvStUgsrfTvYeRu65u/nEo3dBwRLwEXYrzGiMFzZtsn2s0etfDXafbsgVKS
	8/uQh3Cg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbRu-0000000AwZe-2lJp;
	Tue, 16 Apr 2024 05:33:42 +0000
Date: Mon, 15 Apr 2024 22:33:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: Re: [PATCH 3/4] xfs: introduce vectored scrub mode
Message-ID: <Zh4NtkXCdUumZmFQ@infradead.org>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030293.253873.15581752242911696791.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323030293.253873.15581752242911696791.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 15, 2024 at 06:42:12PM -0700, Darrick J. Wong wrote:
> A new pseudo scrub type BARRIER is introduced to force the kernel to
> return to userspace if any corruptions have been found when scrubbing
> the previous scrub types in the array.  This enables userspace to
> schedule, for example, the sequence:
> 
>  1. data fork
>  2. barrier
>  3. directory
> 
> If the data fork scrub is clean, then the kernel will perform the
> directory scrub.  If not, the barrier in 2 will exit back to userspace.
> 
> When running fstests in "rebuild all metadata after each test" mode, I
> observed a 10% reduction in runtime due to fewer transitions across the
> system call boundary.

Can you record your explanation on why we don't encode the order in
the kernel code here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
