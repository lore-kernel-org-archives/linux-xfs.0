Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0DE23CB
	for <linux-xfs@vger.kernel.org>; Sat,  4 Oct 2025 04:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759551420; cv=none; b=WQ83dRm7s1LeKWYv8/xf+Ds5QSl1w1HT4H61zbhgAxbB98FZoyRa8wHi2PBAORtR05cHpKNrJdAcDBXoQSis1t9cVvYuveyVBJ8po+JDcuC1ZT1NsIcQhFdTDKC7mv6vdXx4ZrEdvsIZiNWdYn4/cm3TYsg1+djToJjEUOi8q2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759551420; c=relaxed/simple;
	bh=nVi3Twgq+4t+J6J1osJEsZSSSzbC6y5n1obipQ1ZTSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ux7unGfM1DCmET2TUsaBYlX0zZGx3w7xMp4i7OBPQMK6CnJd2vZ5X5cihqmN5sJMj21AYex9KE131bts6fGw2H35oVs69dGbkqAp7VwqKUMfknVv7eQKs9usN0EOhkbgGN6dL1ih/2R8eCAhBAtQS4zcmLC1JrP3nICRswQXP4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uG8Dx4ew; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uG8Dx4ew"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F7lpap4RpAkXbzGHD+2C3qLer0ZxETPtmwD07I6Mf/M=; b=uG8Dx4ewBlIRTpN2fVmw4WbAQe
	ENWsnn7nIQZG3xtuKsT5GND5HkvPzrkHAfhguozHdqlTy4fyDGeycMgjvldaWuPt3iRUb4ces2sZd
	HBkbx9Xf9BrI7x9P9ISUnUFucTMwERxHFvyeXHqVvehszN69+ngY/3qSyEdZG2ARwkz0aDQP41a2l
	j3NTy7W+7XHxVvupEDa9opr3bY401QDuxUNuIXibyeMi2NxOS8ifl3idfiIIKBJfVnQZ8yEjONwWW
	+/2WcFPNUAh0PPuIdfcPgcSfVT9ON3c/LCJGzd3rg3oOfsADTVdy7fVeyabBqy6hnr44yor9Oyznc
	Q++xhGOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v4tha-0000000DRZz-2EYY;
	Sat, 04 Oct 2025 04:16:58 +0000
Date: Fri, 3 Oct 2025 21:16:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aOCfus7PgLl812qf@infradead.org>
References: <20251002122823.1875398-2-lukas@herbolt.com>
 <aN-Aac7J7xjMb_9l@infradead.org>
 <20251004040020.GC8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251004040020.GC8096@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 03, 2025 at 09:00:20PM -0700, Darrick J. Wong wrote:
> > > -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> > > +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> > > +		if (!bdev_write_zeroes_unmap_sectors(inode->i_sb->s_bdev))
> 
>      		                         not correct ^^^^^^^^^^^^^^^^^^^
> 
> You need to find the block device associated with the file because XFS
> is a multi-device filesystem.

Indeed. xfs_inode_buftarg will do the work, but we'll need to ensure
the RT bit doesn't get flipped, i.e. it needs to hold a lock between
that check and allocation the blocks if there were none yet.

