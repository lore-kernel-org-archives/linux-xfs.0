Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA45EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944334; cv=none; b=TKpB2nFYyq/pxMgf+1Gf/VA124iRsdR/U2MMpVhPMtWmK1JvqfN1oISZOxcCFx+qm/2G0oTmLhsmN67TRX9ot55gtSNaztBcAkcpeBBP0N/1lP7LyPYVpeE4nktX5tCYhUQ1OHlCxA4rSv8Y39MgpTB0F0ekUC0Q5aFRflT8kaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944334; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDJM82SML3srgDeFOj78/1Syr2LXx7N40Nw28jxnh96v5w0ye+m5BKfAiyt0WoFytOgeeP1+8zRBijkkXfIpN1ME7RxVbzj+XOv8sneCBfnGa5zQdoSS+fNkQWTi8sNkrEOBuj8X5KzecS5azxHPpRKgVbsVKImPAxj+BOL+fmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ln67JPsP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ln67JPsP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ln67JPsPSdYLBqLkWCX+Q7SPa7
	YbFdYheuCde7SeEKOQBlWbG4E/uXpLVO/axV3gdAanj8HcDYB7xTstXHqAklJw157FeAXQ4/Bv/u+
	3bfYzdpDJiaaTSPiQd5B/c93fmFtBldyfOC+tK/w0kC0lEA2kw/gwIyzlKoDMdy8RCCa3uc6H4gb4
	IDdKhHTtl1mVtkVtVprXqgeXIBUkGF7jVb8vWgJk7pJSEwjCgxkOI6jCynC617PQhdo4QHy0LSUf2
	yNufy6Ifhuj0vXZ7D//UtRwKDy7pWrkHfoi0de4Xou1+JfePcDlYaRq86LzSyMqFI3WGzBegfr3Ja
	c2Yyf1Ww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKVwR-00000007eTA-13yv;
	Fri, 21 Jun 2024 04:32:03 +0000
Date: Thu, 20 Jun 2024 21:32:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: restrict when we try to align cow fork delalloc
 to cowextsz hints
Message-ID: <ZnUCQ_RgDiV-UF_3@infradead.org>
References: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
 <171892459267.3192151.207856272423876675.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892459267.3192151.207856272423876675.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

