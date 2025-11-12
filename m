Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262212C0F71
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762965582; cv=none; b=sWzSemRMl7BTKailic24cNFovdPXZgB7tebFY5WIbPrcFJ057GLCt3IXBmzRJkmDyVRBuGZX1KjpsIBZJ3bvdET1Ge6+K1gZUAhsSNr30eF3NYbewDVNjWMozDwfdNdS/HDu2cGl7NHy5IFEyje+ypWOM7Ipe2TQF5t6MeUgVgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762965582; c=relaxed/simple;
	bh=ntb48M4UX/LxN7aqJUnOg6yPKNvWSGRflfpM39+enPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UraQVnu1/WHTn35wLitk0zLrrgNoLxxY/fExSf5enjwHmneBg2fPNsboFJc+o1PNroadfc1sXgbRQajMloMIdejUVR5rdCM1n5bAmcSRwDJ7FfEb0+eNtm+GFWFK6b5D/3vSENZb+nIut3kzukUBd1Q7O4CexeeKRHCpB9zqaBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qX/3AVeH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qX/3AVeH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DwpffCTPcEQHXE/nmITzMsGBK6AQnPoCd1E5+krNqB4=; b=qX/3AVeH7OWXXbYAUhLD1W2g23
	ZzWlZl42ujfbUqfv3DLJ2UZ4svnzdQH15Jt7OY7jj48UyqnFAnw1JFHHdPL44VgJxnJlo/TNJa++0
	F+ZcEjhObnMDfcF+SxE5Okh8wW6yAYavJY1nWfavPsGKFucZLGudeYarZbGlPr2NeTDXW4ULKqUU1
	cmP4oJJmy9E1Wok3el9z1mL2lETQitP8oHxMVeHuounYo6D4pboB3cmm3ikkFdcnbzuMvJ2eQHaYT
	ooh1BIPNSy9Ko4xA7U1LxqPy3OAHmLg2Ikj1HItwEEDDqs7fLosqRbWafx/9hCS/35U3IWF77oRzW
	6DGc4BQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJDsg-00000009C7P-1r8c;
	Wed, 12 Nov 2025 16:39:38 +0000
Date: Wed, 12 Nov 2025 08:39:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	aalbersh@kernel.org, david@fromorbit.com, hubjin657@outlook.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] metadump: catch used extent array overflow
Message-ID: <aRS4Smu72bIwabJn@infradead.org>
References: <20251111141139.638844-1-cem@kernel.org>
 <NM5nTfOcdVh4Bz31WhekwpUkERNHbF4mHQTkHyzB2nADKWkzKweM2xvo8AyVGHJnBk0joWMby8EL6pNvIVmKQw==@protonmail.internalid>
 <aRNGBoLES2Re4L5m@infradead.org>
 <t2d73maqm4uxsipsacb423dcsg3u6dy3gty3u34wlj3zp4xfgw@lalkwdrmkj2b>
 <20251112163608.GZ196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112163608.GZ196370@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 12, 2025 at 08:36:08AM -0800, Darrick J. Wong wrote:
> > > used really isn't a xfs_extnum_t, so you probably just want to use an
> > > undecored uint64_t.
> > 
> > Fair enough. Thanks!
> 
> Does check_mul_overflow work for this purpose?


Oh, I didn't realize we have that in xfsprogs now.  Using it here
sounds like a good idea.
