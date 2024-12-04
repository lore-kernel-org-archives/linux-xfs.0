Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBBC136338;
	Wed,  4 Dec 2024 08:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733300684; cv=none; b=sJUvrjJWiOLyPRGKpyXVUug5kcNFqpYYSAFRQJ+2t1Yk6aLSsZBx4e+M5iJNGNSL9xdqWeGVD4RTiLiF7TXt7B058qw31dGMQbQuztx3GkPTTSxrSgWVxOtYyXd7HKX45fVP+cmnVFu7bdBznix2Xz3QN/sLV556Kac0bbfzWjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733300684; c=relaxed/simple;
	bh=Vbb+LWzgbeKQpAD33xZntLAK0UD94Lkb9f42B+/u9Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQSfttGlXKdaYQp3eKmgHi7u+oB5Vgj/Hnq7TkeaaIl/6SHW/XC8vCxDezj9h+qUkszJLctZ2NiXbuZyRAui3N7BGFga3wElVxwlI7wMtT0ga3Yz7VMoXK39bg4L2JSA3/z3rEYCj7kGw3+9etv5kGX8W+Fdb1nNHAAj1jHYZb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1GRlokOO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1GRlokOO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tTultgpvICV49EytFNVBFsrb+ynUehgUrUeULSEp1r8=; b=1GRlokOOYg4t7+Fy4AbfCTdFXI
	LFg09Yjt2TIMpt0LI6H8Riw70HFSE01/4uVrGZea2hXO39BATv06EyMxh6YUT8lwXw7ZzFYML3bUX
	wh1AVufYPNAeRtQ6U7oet/giIePI+RGL7mDjc+Bds4WExqYQqicDmrwC12dfv8uFX7xCbsSvcW2f2
	cc2LGEIzOjf0pnPqa45mvcvoCNv32HTDYjzFqOgEMQhHAfCpJgJOMao5dRdWKbcCmK91KzLfbUY5L
	N5P3Tup2kBhXGXFmJYzjtMQJEpHcWJ4gspjs1n4qL8gC3gKQWRdgvSN7JmfF37ch1zelcWTJDoUdo
	27b0NulA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tIkgY-0000000BsGP-2EIm;
	Wed, 04 Dec 2024 08:24:38 +0000
Date: Wed, 4 Dec 2024 00:24:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/6] xfs: don't move nondir/nonreg temporary repair files
 to the metadir namespace
Message-ID: <Z1ARxgqwLYNvpdYS@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106602.1145623.16395857710576941601.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328106602.1145623.16395857710576941601.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 03, 2024 at 07:02:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Only directories or regular files are allowed in the metadata directory
> tree.  Don't move the repair tempfile to the metadir namespace if this
> is not true; this will cause the inode verifiers to trip.

Shouldn't this be an error instead of silently returning?  Either way
the function could probably use a lot more comments explaining what is
doing and why.

