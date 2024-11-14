Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739170818
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731566623; cv=none; b=LWK/FndOLd8f02cArgVPcEGbGPCEc8jCMixyy5k29Kd0r2yi88hHUqRtrIR9syYkYLSuCqSbDpSY+s0vNpep66mJKN2iigQSGEDWaq5iNGc9WfiuDbLYf8G/PDjo4Ljw1jhASIkvVkNugBO9fo44mDPsxuLxfva8QQgqJycbvFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731566623; c=relaxed/simple;
	bh=ZS7IPD1VsIErCPwCdlqijTVWY3LZ2ZeoH/xWJfYAWkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azxNQcyay8cRholwCzaB3VD/ar42A/aySmp7Sf+yoPwbrx+eAcA/3CJ2onric0re+SohzX2Rpoe5PiP6W/mh65krIvgz34LzIDL5+YXoQ+1nS/QyFd8Rn0idBjuBVJ3W5Ne7X5l590/OBSGCBqTM1jOhUyamXnRX8l5rh8IA2So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QN9e6AHJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QN9e6AHJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=2scGtf3TTNgmVKsuhKXnU7om+Khh339YO3GYbZaJVJY=; b=QN9e6AHJ6m13v6mRVw2Pq8O3SM
	pqHABEDJPDy4OBLHdnv/6BUL2DOF4O9EhHPqq8GHB/Y7bZlBVgYFhmI3Qtt6hrPmDnrNO3YN/xeRm
	f89n9Nbt6UwxLU1II9JlqdU8KQJeVZaYmEd3/J3MREoo6Z+3TYoOsddOUWLylbn8nphdbGxFJ2NmH
	31biDnKG/fSdcb+byn26vb9VrZXs8OCXa3YlOCaoDS/LrhgWVw8lktUIPzdSOL2OAlvDC0gSwGsy8
	VkGncLJD1h/JB68RYzinzwLRNZcf3q37m/4sqWRarhQq9EUfi8pqp3JjJTUlc708TzjS0oEq+tD5F
	4nNDIFgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tBTZr-00000008z2U-370J;
	Thu, 14 Nov 2024 06:43:39 +0000
Date: Wed, 13 Nov 2024 22:43:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULLBOMB v5.7] xfs: metadata directories and realtime groups
Message-ID: <ZzWcG5sC7VvGC6mf@infradead.org>
References: <20241114062447.GO9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241114062447.GO9438@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 13, 2024 at 10:24:47PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull these fully reviewed patchsets for kernel 6.13.  This
> patchbomb corrects numerous paperwork errors in the v5.5 submission so
> that we can pass linux-next linter.
> 
> I have corrected my stgit wrapper program to invoke git checkpatch
> before issuing pull requests.  Despite its name, this means I now have
> automated checks for tagging errors in git commits.  Freeform text
> fields that require a lot of parsing cleverness to check and that can be
> corrupted easily buc*********.
> 
> This is now being resent as a v5.7 because hch pointed out that I got

My 2cents here:  don't change what's in linux-next for these kinds
of nit picky warnings.  Linus hates last minutes rebaseѕ, and having
two patches attribute to your instead of me and a missing hex
digit in a Fixes tag isn't worth the hazzle.

But I've added him just in case I'm wrong.

> 
> The following excerpted range diff shows the differences between last
> week's PRs and this week's:
> 
>   1:  62027820eb4486 !   1:  0fed1fb2b6d4ef xfs: fix simplify extent lookup in xfs_can_free_eofblocks
>     @@ Commit message
>          this patch, we'd invoke xfs_free_eofblocks on first close if anything
>          was in the CoW fork.  Now we don't do that.
>      
>          Fix the problem by reverting the removal of the i_delayed_blks check.
>      
>          Cc: <stable@vger.kernel.org> # v6.12-rc1
>     -    Fixes: 11f4c3a53adde ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
>     +    Fixes: 11f4c3a53adde1 ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
>          Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>          Reviewed-by: Christoph Hellwig <hch@lst.de>
>      
>       ## fs/xfs/xfs_bmap_util.c ##
>      @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
>       		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
>   2:  cd8ae42a82d2d7 =   2:  3aeee6851476d4 xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
> ...
>  68:  dcfc65befb76df !  68:  eae72acae5a564 xfs: clean up xfs_getfsmap_helper arguments
>     @@ Commit message
>          fsmap irec structure that contains exactly the data we need, once.
>      
>          Note that we actually do need rm_startblock for rmap key comparisons
>          when we're actually querying an rmap btree, so leave that field but
>          document why it's there.
>      
>     -    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>     +    Signed-off-by: Christoph Hellwig <hch@lst.de>
>          Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>     +    [djwong: fix the SoB tag from hch, somehow my scripts replaced it...]
>          Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>      
>       ## fs/xfs/xfs_fsmap.c ##
>      @@ fs/xfs/xfs_fsmap.c: xfs_fsmap_owner_to_rmap(
>       	}
>       	return 0;
>  69:  87fe4c34a383d5 =  69:  f106058ca77fa9 xfs: create incore realtime group structures
> ...
>  83:  1029f08dc53920 !  83:  12693186fbb282 xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
>     @@
>       ## Metadata ##
>     -Author: Darrick J. Wong <djwong@kernel.org>
>     +Author: Christoph Hellwig <hch@lst.de>
>      
>       ## Commit message ##
>          xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
>      
>          Split the code to set up a fake mount point to calculate new RT
>          geometry out of xfs_growfs_rt_bmblock so that it can be reused.
>  84:  fc233f1fb0588a =  84:  52690d80b09ca5 xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
> ...
> 110:  b91afef724710e ! 110:  d4918d151be0bd xfs: don't merge ioends across RTGs
>     @@
>       ## Metadata ##
>     -Author: Darrick J. Wong <djwong@kernel.org>
>     +Author: Christoph Hellwig <hch@lst.de>
>      
>       ## Commit message ##
>          xfs: don't merge ioends across RTGs
>      
>          Unlike AGs, RTGs don't always have metadata in their first blocks, and
>          thus we don't get automatic protection from merging I/O completions
> 111:  d162491c5459f4 = 111:  54a89f75c4d972 xfs: make the RT allocator rtgroup aware
> ...
> 139:  13877bc79d8135 = 139:  c70402363d6d27 xfs: port ondisk structure checks from xfs/122 to the kernel
> 
> Apologies for the last minute churn and paperwork stress.
> 
> --D
---end quoted text---
