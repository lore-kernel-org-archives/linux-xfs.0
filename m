Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0492543C05E;
	Wed, 21 Jan 2026 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977953; cv=none; b=Hgc5dw6+qqsQiHv3lk2wpME49CL12+bu/neByvprYoT1tL8Yc0dtPSNmPSHmWZEYkaNPx9RfeRR1RPQE59WfwiG34ESugZ/QnBSgIHiow/7c9HZYyg7axrG2ixzOK5rqjfM1+DxyhWZwGMuZSvOdhsQhTY9uEBKmSViVa8kTX+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977953; c=relaxed/simple;
	bh=zu6e2c0B2GxyaBE6fV53AJLob/hSPX8bUgVnvDJw3EM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMtrok7VQT/W6+0P5D6ZbJGdH3QJ4wRy0DJTKPpcW228qbqT39J0kn/8AvwobqnGtQPROkRhFA32YEQEOl0bXfn4G2JeSgO6cC5AwvRN87XaHG+N3vc0SHXQKDlCqamcdhjBYluPJctkSJpnxKGxvDd4TLcXHVCgqk2YwHGVGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2DavkoAB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2DavkoAB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U/QJo9QukllBSaIZPueXzZoW60o0xG/9xoDvoF8mCx4=; b=2DavkoABVIpfOj317AoUvUpv5u
	X+HHkN1l9CgUh512quS+b8WLrBknQm6VhFKGAqX62K0+VlxT0pzh//8pcH9X62LG9aCwuLqH3Aqzw
	UyTNzp0EyP0QNUaKFpuQwhtFsHBX9ZAreGYGxnmtv9RTlyYdhxpffbR04rkOH2Sd6ID8AJ2iG05nW
	5FXfWxeGj7m4wL9C4cWw6FmxjR/n/sAJxoOokGhcTF4uoaijP/+TQtv/SWY9gsHTs4KmUz+YNPR8d
	++LLNY+v4+l56qyYFBvZtcV6Ih34iZDb9nO/FG2YhaC+IGL/emTk3dJd6OirFI27A7+nYFqztZ9KQ
	QjJlV9eg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRyR-00000004xpe-1HTX;
	Wed, 21 Jan 2026 06:45:51 +0000
Date: Tue, 20 Jan 2026 22:45:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] misc: allow zero duration for fsstress and fsx
Message-ID: <aXB2Hwdp2eDIDptn@infradead.org>
References: <20260121012621.GE15541@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121012621.GE15541@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 05:26:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Occasionally the common/fuzzy fuzz test helpers manage to time
> something just right such that fsx or fsstress get invoked with a zero
> second duration.  It's harmless to exit immediately without doing
> anything, so allow this corner case.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

