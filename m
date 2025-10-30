Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015F8336EEC
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 07:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761809253; cv=none; b=U6MMv9p2H8Mz9CYmeUsgZJN3k79SBVJNuhHkXkBSPli64fn3kGd7HFZ5sxf+POxETiw9lPVBis4JD+0wo0VcPWKXYsOFh2aiweiCqkpz0VSEc8QCaPgyTl0qL9QLrSnZE19gFPrpyneBPcCsS2B2terSagu0KvRrfYqHMgzwO5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761809253; c=relaxed/simple;
	bh=2fFLuCB/DgE+RjrwIhBTEQQGd2A4QbH4z+OM8oO0haQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfqpQ+VONYa1dlg7mNp8Hu/DsZ8cdOkBz2kt6JgT4GHUusWtuzT6Pn8kvUzZjBMYt5pi3WhHVKPmCVib7hgNI8Nm/5W9M/xWac/Ye0lr8iTaVB2oR4j5i5uS4naayiI5co5ajUBz/CBV48bVDGnMoTSudoFPJfDWmjU0UBbBv6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FrkQQ7L5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FrkQQ7L5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B1mlgg6vn7EAlPZNY+5lhKrczDHjXic62Jbv/BFRLzg=; b=FrkQQ7L5RCR4i6dPstrmfvRrsF
	OX3xAlhoqQ76+LQ6JHZ/bgMxYdl6eD3kfM9rd9NsFS+ESY9N7uHEFsmGUh7VDIFHIKe73RRN8XEjH
	4H8Q8khm2pMPLRtkId7Uej3DW1wcJYNqLxxLs1ZgOf4PS7Hy/23HzGYOdBSJ6J6h4ziibuTXlUCk1
	HxJhTT9n2MmsgqyHXLG/KELEAxTMf9byc8DZBewshX98Cb2JSZSQwP79iWJdH98V5h46WK6n+Zjvr
	mapzIKAzK24sSyUbwckFyGjYJKFzUGWWAuwrLXrdhAyNX9QRW82cpvht4cM4l5P+8KzJ3N3k8pmP6
	XAFSfxvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEN4D-00000003d92-0JCf;
	Thu, 30 Oct 2025 07:27:29 +0000
Date: Thu, 30 Oct 2025 00:27:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, yi.zhang@huaweicloud.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aQMTYZTZIA2LF4h0@infradead.org>
References: <0e89b047-cacb-4c23-aa83-27de1eb235a5@huaweicloud.com>
 <20251029175313.3644646-2-lukas@herbolt.com>
 <20251029182255.GK3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029182255.GK3356773@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 29, 2025 at 11:22:55AM -0700, Darrick J. Wong wrote:
> > +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> > +		if (xfs_is_cow_inode(ip) || !bdev_write_zeroes_unmap_sectors(
> 
> xfs_is_cow_inode() only tells us if the inode is capable of doing out of
> place writes.  Why would a regular reflinked inode be ineligible for
> WRITE_ZEROES?

Yes, this shoyuld be xfs_is_always_cow_inode.

> I don't understand why this bdev_write_zeroes_unmap_sectors check is
> here and not in xfs_alloc_file_space.  Shouldn't other callers of
> xfs_alloc_file_space be restricted from passing in XFS_BMAPI_ZERO if the
> block device doesn't support unmap_sectors?

Othere callers are fine with the software fallback for the block zeroing
helpers.  But this is a good question that should probably be documented
in a comment.

