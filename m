Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3568029AAF7
	for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 16:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763138727; cv=none; b=YVerQcu64Ywad89CWJsbJXAvXHDhdt4n/a9+7dy7POww69EurLTjkhqALIkoA5sEWoGVPoX8fgSET1gXxv1Z17q5Q2ehTzAglRHAAE5ZKp0RVsTSjvj+FmhTewBxtTcuPORxk9cynsXexOJi6M7O1eapAsyP7Qru2Wpd4qnGrP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763138727; c=relaxed/simple;
	bh=uCp/QGbYBDQtYfShRsx9X25+YfjOj9LHTd0RTD0rPGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWQcnLLOqD33qcGR9QSsTeYTvANs/0NBk53Bi3J8u6LzhzT9xf+a/VDtflv8OvBXxkGYvB/z71tFwfQWpOd0M7WmNmtOtLZI2PQen4S+h3jtFokei4MZSxygB2DPa6UYEv1bLRGaWEkIZJeiyhlsxiXC7hPBprqWbiqyXRnCKPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mBob1Lgi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mBob1Lgi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Df8mvjEsnwaMnF1iwpcMgLIE5GjfUQiqhcK7fuE03Yg=; b=mBob1Lgi/r50UJqjfqh4EO2kNr
	Ss7I1ppgU9diLfWOTEu9K7bcKFR8GBhOsRGO5tPKCCguI53s5KPoXNWQ8wPi08IxNTYJz76s57NxH
	zUyCD1OWCZQkN7qpTYhed89TEhe77NvFVTZH6ZZZETmjo0UHH0y/Rdz9W2HI9I+THGo34rx0DFInL
	SSWE7HT7QgvjbxIoxT4+GLfIho+vxTMFpMTG3SCOTBnzkyRMi5h0DX1HIuaxglp974K41cllGeD4n
	bhrTheB4NdrFRoodlG5SrIiDTUScPudguksjL8RBmISOHQndCbuvMSzXOCS9iUc7wulAN80kjU4mc
	wBi1Iisw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJwvL-0000000ClD5-3yit;
	Fri, 14 Nov 2025 16:45:23 +0000
Date: Fri, 14 Nov 2025 08:45:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, hch@infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aRdco1GtU5BK2z6C@infradead.org>
References: <aRWB3ZCiCBQ8TcGR@infradead.org>
 <20251114085524.1468486-3-lukas@herbolt.com>
 <20251114164436.GE196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114164436.GE196370@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 14, 2025 at 08:44:36AM -0800, Darrick J. Wong wrote:
> I think hch was asking for this indentation:
> 
> 		if (xfs_is_always_cow_inode(ip) ||
> 		    !bdev_write_zeroes_unmap_sectors(
> 				xfs_inode_buftarg(ip)->bt_bdev))
> 			return -EOPNOTSUPP;

That would have been my first preference.  But the current version is
readable enough, so I'm fine.

