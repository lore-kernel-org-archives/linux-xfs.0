Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A39376A0A;
	Mon, 12 Oct 2026 13:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810811; cv=none; b=pFejLL0CqVEuW21BrDWBMGhhvJnRaVHyh/M8MDBpN9nx6LID51WtEXw+Nm4Fbxlw2kfSsUjaoLlS3wVAarYOCDB6ReVdMWGOJlEZ4Kdtpj14BwvHV9C2h19pTmpb4Jd498sLrL6On88P3wNKnjvMtLNOrNys2Erw9i6irwKnrOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810811; c=relaxed/simple;
	bh=g60zjaHcLt9Z0l6BRHQGCgBqz3q08l4wJyjvBYzSlrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NLVtzsOEeC4AnAlBX7zFVReMQTqQauMjq+EgT6r+0LJ6JS06FHw+YmmtQEIjCFMh66ICeG8jvabhRN6CLcvCcWSNtbAMhhpkv6xtMdXCGnuBQG6/yKpaxX1NeCAD59T5HHifLD/W8GURYzBJxJSX76nGajmvTgM/vlnR+D81kd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GN9xE9Y3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GN9xE9Y3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NVUvzfuqxM8prQmDibFY4k/P/SHbWNpyOBrlu4RyS9E=; b=GN9xE9Y3ryjc2JifopKqwmcilG
	iq8YuTtCWycxyBSfwHbDB7gkSs0YGWxvVPq6i8LHJ6u5RRKC5351Deme9mglM1LOTe2QAw4h/5YMf
	kSIzuDcrLjxjInuKA1mJTAcVtwD4Mi909nymXQldAUH4eD9eRYdenhrGKIqnESn+cdU3G1Jr6mOaX
	XiS1tbgBGw5CLV6c6SEoXBcgWSLYxdw2/EcwjCEVqc6LC2EADlUG6MAWAiDnwX2C/cAVCQpa75GMJ
	51T1bdMgehppfRlOcDrVweKaEGHX6PN+caSpnb5/yeNAtZMjyXmAqnF/DYFnAyGxwCe8CJ7VWpoJa
	+r4Iz4GQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFqM-0000000AXW1-0pg6;
	Mon, 12 Oct 2026 13:13:30 +0000
Date: Mon, 12 Oct 2026 06:13:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: don't set a metadata directory's parent to
 sb_rootino
Message-ID: <aszc-qxaQ1Q-4EhM@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065816.1058822.16755886855029594169.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065816.1058822.16755886855029594169.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:59:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that it's weird to set a metadata directory's parent
> inumber to the regular directory tree root.  Fix this even if nobody's
> ever going to notice this because metadata path lookups don't access
> dotdot.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

