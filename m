Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5CF330334;
	Fri, 27 Feb 2026 13:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772199807; cv=none; b=dAYAbr7eDFllhXwS6MaLBx6U7rlzQWHRDkxFykEC+aNWdZnN0sVPcIq424yIKGO0oxTvnNYzkDdAnfDqwWNQYyvG911s18zUJU3akNEUbKMe9n+Y6LH/Dha/GLd+GnQU/c1frFtF9ob70dsEbZVCWC9IocuKSQz5cCQ2MeD02K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772199807; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=juNzqppJxO33Q2Q0/5DuYikRzRdiP0uK1QhtjW0spgcIiazCv8P1cm7jHWUVUoJsK5Oq7FbOWcoSowW6dJdL7C2zP8DiF6jkqIHsheDV0+gFf98sSd60f+vI5toCuLG6w0NlnsNgzjTlo5Ycxbg6CWre+3yeYn2m2P+S5Q3704M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0q3AJLxr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0q3AJLxr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0q3AJLxrrVZzygDRVwWdmqdUQM
	mcYqfrUXvtrJtgyrnkrOjt9XlTJ/ukqi0LnHbEUj9Wnege44AWRpfD5a3qydjKaMcMU+wyfF0gGTV
	X1a2toGPZ2+YgcrBeiYkJCR3bhY4OHY5eH8UTFlRMbLUr2HOf8+xDw/0UgZhhn90vvJFAc6FKy952
	YOi5HUuEIl4lhAz8/KPUXrk9OYYa61FDMo4Qq6pejKp70CUynIGm0f7mLsao1cgwYkq6MKLEdk+aG
	/YLAHmLN6XkKFHMtVGOR2fOUxBnm8Fea65Zl4Ir3p4dd4GRsw2rYuzuDukEdeFovQTbW0PJAy1bkV
	dYSXObiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvy7n-00000008OKV-2rnY;
	Fri, 27 Feb 2026 13:43:23 +0000
Date: Fri, 27 Feb 2026 05:43:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] iomap: reject delalloc mappings during writeback
Message-ID: <aaGfe2b2cvFCwbm1@infradead.org>
References: <20260226233442.GH13853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226233442.GH13853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
