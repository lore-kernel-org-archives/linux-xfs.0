Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B05031F9B1;
	Tue, 22 Sep 2026 12:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790080300; cv=none; b=LPFgCQY4ZnoW/mVamKLzYplgIsoxQBPyZ1uCb05+v6GynAOov4B/F6d2wowYVACy4WylQx4rYFD1FlWpaMDojxH6McE1b3kTkeiU+6w/4PEFuHCVMHyfiGLojo3OYhha8UPzuc9G6RKKizvE1mfbYy64Z5Z6/D+F8sd/yw7DzsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790080300; c=relaxed/simple;
	bh=4acLinblvO+DJ/0Svzfnly+VSxs0x6roKzp3IbJYr8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ko4gP+A1APBsmudBIX0rU/18HgUsv2EfXYKd45S1mNtoBl2wzwDFP7wVASnyA2GFfNjf823khX3PdafrTYQ++2LhH6nTwuI7bHo+fnIKG3OQ+LiDl3MjJw+LoYu0pCsEvFtqFiH9jy3uHTkkFbsPWkxmvaphzpsfA2ZIoIubyxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O9lB0YuG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O9lB0YuG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TPXKbsrM/p5YokizNFLlIdin91qu/W2cgdUmN8/lRek=; b=O9lB0YuGKZDCkQ8DXB6+cM6Jxb
	Vdz7hj+5IBq9I2eoCBE80UDaZ0sXjEGTAQkJ1KkKdfhRXy5sPf2wcFqN9UykbtzUhn38pWaktW+0V
	ziktouxY6s6z/XmyhKaIW777QyquH1xHK4+8F0bXck9rl8iy0Zgea81TBcsnbGuPGmDcpS5HETVgI
	pY3OSd7XfZy6Mx8VTlf7hkciScELm9IXj4x0yLKRpfgdmrz8uXADt9vLSq34gW6FP4ppS8CESscWq
	eaoOZKCId4Otg99jEvP8YBsnppq7qL2A64bLgYS2xnnZ7jekzeXufwzr4bAefvkU9UOshuyDhNrsI
	aScKJB+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8zeq-00000005JU0-0Nai;
	Tue, 22 Sep 2026 12:31:36 +0000
Date: Tue, 22 Sep 2026 05:31:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org,
	ebiggers@kernel.org, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 12/21] xfs: use read ioend for fsverity data
 verification
Message-ID: <arJ1KAvP-4fWVvzW@infradead.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-13-aalbersh@kernel.org>
 <arIrtgZ3-9zNuru_@infradead.org>
 <arJFUV3WDkY6zmfD@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJFUV3WDkY6zmfD@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 11:13:57AM +0200, Andrey Albershteyn wrote:
> > And I think you always need to do the offload because fsverity can
> > synchronously read metadata.
> > 
> 
> hmmm not sure what case you see here.
> 
> Without integrity:
> For data reads we get here. Here, while verifing data page, fsverity
> requests reads of merkle tree pages which WILL NOT go through this
> path as no read completion is done for them.
> 
> With integrity:
> For data reads we get here. Here, while verifing data page, fsverity
> requests reads of merkle tree pages which WILL go through this
> path as they need integrity verification on the read completion.
> Therefore, to use this workqueue for merkle tree pages integrity
> verification we offload data block verification to fsverity
> workqueue.

Yes, but we want to be able to use the bio defer path for other
things including iomap error handling (I'm about to send a series
for that).  So please always make fsverity do it's thing so that
we don't add really complicated dependency chains.

