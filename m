Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E791E525
	for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2024 21:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710709872; cv=none; b=kVmNiasLNvOp0G/Fak0aT4L/6WedOnf5Oxcys5+BKiIHkBXS6/0UXJVXDSJhaqfa5U2xo/YBXLsgKhaXAplbqECZwJtHEd0u4z957veAozPeTTYBf5oNQS6KYlK10eDNhJrIGz91JO2fGOaV839C3LYdMvq7x59QZwMoDWNtYW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710709872; c=relaxed/simple;
	bh=u/Ux2q1g835SS1mdmntYi2B8tIue310ODMzVutJGBE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKiyjgC/2fGlLtVERgLFoPh08XExsroW+Ni5QjdfwU3U9VVc7rMj1hu8wA+J4s9MSEnSlojPiLUwTEv0aQgIMvII/buAlUaUNIiwOKe5iGg7Kecmm2Q2Oz7GPg9RfBlRovY2ZLfLNLGwn1KUdNW/i8TfkIorIuR/RpeeHl/NOh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UwNevHnY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UwNevHnY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/KYLcF0OM0q1sFiRMv8qFLjTzpEigbh8xXpfgRsR0VE=; b=UwNevHnYtdjIOaZIQTC1kMKd5X
	Y4PQFBCrC7nOxv8Hf2EIKfblutGhGwIIVzVGcWBdiN6Rvcp5oQ2REexpFAMx3pVhJiukR+pg3mERE
	sqDj4ThA/bReSUVOdGfZhwymn0JpwzhJLcC4CnXNElVlaMDGnHKA8zj4N3wCSHoOksQK6rI9ZCI8B
	tLVy8nTF4jvPDfWwLq1hLdwKhcSXETujYdTCn8Ed3w7X4NgRAasohezwwLYCCW+pAw4e2j/wimZna
	PxAaNA+lxyxqx3uzMq4za5Cb72RBxi++gKIK1hEn2JqmZ7akwcm1w3cWsTgBp8rH9AOLc/r5QSnu8
	Yylfv5iA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rlxmf-00000006SWR-0qgV;
	Sun, 17 Mar 2024 21:11:09 +0000
Date: Sun, 17 Mar 2024 14:11:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs_repair: don't create block maps for data files
Message-ID: <Zfdcbax4CJ-Cxynw@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434829.2065824.5706231368777334384.stgit@frogsfrogsfrogs>
 <ZfJbZp0MO9cidwEX@infradead.org>
 <20240315000256.GW1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240315000256.GW1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 14, 2024 at 05:02:56PM -0700, Darrick J. Wong wrote:
> > Maybe throw a comment in here?  Or even add a little helper with the
> > comment?
> 
> 	/*
> 	 * Repair doesn't care about the block maps for regular file data
> 	 * because it never tries to read data blocks.  Only spend time on
> 	 * constructing a block map for directories, quota files, symlinks,
> 	 * and realtime space metadata.
> 	 */
> 	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
> 	    (type != XR_INO_RTDATA && type != XR_INO_DATA))
> 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
> 
> I'll change the commit message too.

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

