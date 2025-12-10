Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE372C0278
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 06:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348119; cv=none; b=dHADUU6BD0T/RTmgkm/hf66hTeGf9dmD+hfQJP0PbQGswg1kdo6yh6rPKLcoIIEN/YI+KddZMVBWcVLBXSEL9NUWR37ySFlZJWnrdado7w4HCeGvMBwUVcdrqEqBjDuyZiuD+H7YA2MtZlsnt0A+aJ3ShGxDoPlCgU/5dYMJTFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348119; c=relaxed/simple;
	bh=6GMdZneBRr5+yq4OpOl+kbmo1TiKaMNv++9JNce15sI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhjD/BQ2esqqWuzyYYbsacTp3PbsHWftFl4MsVqw+VtoV49QhKdMxsfEqIXO3/UxpVF9jixsiUazmxG+fnjbVjace5284Ci20FSvG34L03xiBOooynu01T6QjsQKdM2mrEWc2pqWcCzcDfovIYYfdSQV7sDYLbcAc8+vRDw6ufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EI7+3wKK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EI7+3wKK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bHPi20lytp7tmU58uDu404dB1JNFK9N2iPhqFS4wk+c=; b=EI7+3wKKA8VBG4+V7WgaX96ySD
	hwBwUx5nbKqZ3fKWB9ymvOZ/XzKfuC3+aYr4AwRhWS4N1BPbE1PRGGO91NuQ/E306p4Q+oLoIWiBX
	rCs4R9LMB6va1NOcjz6aADU+FIgT/xeEfA5aaIToh9ZeI0hLif/X1jtXrMa6NxFnSRqTzfCCjddhq
	tuHr18K/78WPT1bKvJS0Pm2A+JWqynzsgqAuA3hdskQgpbkWaJPsVXQj6/vVtoxfG7bf+nEMXWYTL
	AedScZcH/QKVQove3BOR8yDqvLEzbm47oAi08btby/2gFDxaRg2HgAyPLjU7CBpW/T4zwA3jYiN0U
	QhOwoLcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTDgh-0000000FAWv-0wfs;
	Wed, 10 Dec 2025 06:28:35 +0000
Date: Tue, 9 Dec 2025 22:28:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_logprint: fix pointer bug
Message-ID: <aTkTEzOzDEYQuZX3@infradead.org>
References: <20251209205738.GY89472@frogsfrogsfrogs>
 <aTkEXwp2zbbAI_jI@infradead.org>
 <20251210062620.GC7753@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210062620.GC7753@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 09, 2025 at 10:26:20PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 09, 2025 at 09:25:51PM -0800, Christoph Hellwig wrote:
> > On Tue, Dec 09, 2025 at 12:57:38PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > generic/055 captures a crash in xfs_logprint due to an incorrect
> > > refactoring trying to increment a pointer-to-pointer whereas before it
> > > incremented a pointer.
> > 
> > Oops, sorry.  This somehow did not show up in xfstests for me, where
> > did you run into it?
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 ca-nfsdev5-mtr00 6.18.0-xfsx #6 SMP PREEMPT_DYNAMIC Tue Dec  9 10:29:14 PST 2025
> MKFS_OPTIONS  -- -f -m metadir=1,autofsck=1,uquota,gquota,pquota, -n size=8k, /dev/sdf
> MOUNT_OPTIONS -- /dev/sdf /opt
> 
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Full log here
> https://djwong.org/fstests/output/ca-nfsdev5-mtr00/ca-nfsdev5-mtr00_2025-12-09_18-36-11/generic_055.full.br

Hmm, generic/044...

> user aibots
> pass suck

?

