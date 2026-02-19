Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6840832573E;
	Thu, 19 Feb 2026 06:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771484255; cv=none; b=WK7i9CZC6r+hu4xpsA+bEk+iOn7yXetKm4NFKuw1G8USb28D6foFXJBW0GRlX0Ue8MrmMYlJ3vvjSeNgBWEwUPPnz2ys+64YRkI534gPMEiMe5NdBAY9JU+Mb8ENB9vS8i/DXAwYcaxdBGvhlJVwjjdB40RAsRv4GnCdXBp87X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771484255; c=relaxed/simple;
	bh=siNDDHC2Qsava4Liu8SG6xWn9t2yAWKHTfnjil3TERo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRmZLwY+AZYs15r3+UGjlp6Kcwfrifk8m0crPJfpJK4xDJ8hS4pcZiBHMWVvD1yqxYRe8D5eGS3u4q00oYySmpabSzl6Zk1RAb1rnoACt0WZVpSuEVggE+8i18ooLskd/p+5F+8e30kVbSA/MXmEpvlLdrqO4CCIg9FtcC1D5EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yhVIluwh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yhVIluwh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=emWGeeKxyS2COm40JCrrRkHVhmqtYlgxw2dlaswuuJw=; b=yhVIluwh+KsDJ2JeqFd15NFeW9
	vgz9V/FxAXlCzlgRYR+SaRG5lnZoW91x3gUOmm6bNbW4OVLTNPEf/Yvmaxp6xvq9c+kX074u8aukt
	9Lot6rQ7o7Sij3ctdUolX0IvzYpDrptxT+NHyXyZz56PZxcuL+dK7eRrj076o8CGnBT6oGKVvvJn3
	GLqe0F5oOeWTypinto8Ik7Vjg+PQ4mI4GOU664lTjUHtM6Yv+K2EqOi0oOp9hSOqFgVhnvjUkEra1
	Oh9EhvIyjjvAzzTF1ZgBzh5dLOgbZ+jPsgYOVLvXGM/ucTtCUu/Bncow4AjDwbsPm/PtNOK9qziNK
	b+MCym4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxyg-0000000AzwN-0A3R;
	Thu, 19 Feb 2026 06:57:34 +0000
Date: Wed, 18 Feb 2026 22:57:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@infradead.org, brauner@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] fserror: fix lockdep complaint when igrabbing inode
Message-ID: <aZa0XkylrjTYR5pg@infradead.org>
References: <177148129514.716249.10889194125495783768.stgit@frogsfrogsfrogs>
 <177148129564.716249.3069780698231701540.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177148129564.716249.3069780698231701540.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Allright, this is basically a dumbed down version of the XFS ioend queuing
just for errors.  I don't particularly like it, but it's probably good
enough to fix the regression:

Reviewed-by: Christoph Hellwig <hch@lst.de>

