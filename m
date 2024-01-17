Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BF62374F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 18:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705516225; cv=none; b=hTg93nkmsbrJxZwIvBnyJn/aH+nTm/emRtXgoYHRDURQT5SXuy+Q/Mi5VnqXap9b/JhvHMaJMMbl/XjbzT+ei+9sIbUz9sLg/g6Av1A6/W4ppbHeYxVjiInFDqJWKRPsFcdZ2tj4nn2QC3tAJLY6xA1znjr2IV4Zz2fyFni9F2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705516225; c=relaxed/simple;
	bh=U1Y6bThSCfeTcl50Csnax5pgehSYTO6nRl5n3lQwMxI=;
	h=DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite; b=j6EBRsUycj5Gf82lMG968rIQxfo6wVKP8IRlm4BZEld6WvJyI1f5mIrnnmK1HBnOVvAm003RqZ/X3oXItnpZ5TxkHhZcwRhQDXU+mOP2tERBuaT+xD6zPb1ByiPuQ3vsfSx5EXV9n+AsTnDVye7Qh3Mg4ZQLwZy1zS3KB0bkle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OPHOFsbF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OPHOFsbF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gZgg8rLfnuFM61yiwGHLF4E9G7JTYdZwHjl/LjafGKs=; b=OPHOFsbFuwn3jeWOCAnWS+m64K
	YEdRnx6PdMFPNTsoAOUcuZrp/u+D3FRiI8Y/MqRHOA8hi2szYa2PJCLsWIdtEH5ma5hf+EJxgtMgL
	0OAacrLRk/8mvuwlX0RVuRk/6Br+23onIBabAN+6NEpU3EWv0epnCUQ3kkPzVrdUuhV5O+Pwa4GbD
	a2b3k/0+k3TU+RbdBLPFn2xPkqTCHeBzVuJP4QL661tlTBiuCmI9GUgyoCk5qaYO2P0hKnb5dBj5L
	8pnXkr33vqKhJUKJ82uPOMqpae1Mf0e5+0bP1wBxf5b5PE5v24gUy5de3a9hCqirGLUVd2Isn8g6p
	HSYY7MQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rQAgB-000NFa-1R;
	Wed, 17 Jan 2024 18:30:23 +0000
Date: Wed, 17 Jan 2024 10:30:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: use directio for device access
Message-ID: <Zagcv3rWRQMeTujZ@infradead.org>
References: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
 <169567915609.2320255.8945830759168479067.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169567915609.2320255.8945830759168479067.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 25, 2023 at 02:59:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS and tools (mkfs, copy, repair) don't generally rely on the block
> device page cache, preferring instead to use directio.  For whatever
> reason, the debugger was never made to do this, but let's do that now.
> 
> This should eliminate the weird fstests failures resulting from
> udev/blkid pinning a cache page while the unmounting filesystem writes
> to the superblock such that xfs_db finds the stale pagecache instead of
> the post-unmount superblock.

After some debugging I found out that this breaks a bunch of tests
(at least xfs/002 xfs/070 xfs/424 in the quick group) on 4k device
because xfs_db tries some unaligned reads.

For xfs/002 that is the libxfs_buf_read in __set_cur, when setting the
type to data, but I haven't looked at the other test in detail.

Should I look into finding all these assumptions in xfs_db, or
just make the direct I/O enablement conditional n a 612 byte sector
size?

