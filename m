Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D24282F9
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729165; cv=none; b=PoaZ4VPpTzAjPUNmG/PndTOds4rXw0yTW6BtUxxIm+Ka3EuMdZDjlrrKDpU67PU3sxzcmi6oHuAnFCsZcx8M/kGpWAjPtd4LcYDL+Y9bDSo5zbH8KB60uxTC0Fa9evWN6abbciy/NQlyHb3g+OwsB517wEfmiveuEiQGOI/7nUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729165; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDDRHqXRnE+WuQ7x4V6W+tyYirH3JlNwf2Zlj3rbWMtaqbCv/lm8dslqy2Oz8bqKM/+AEyaubLNFmxjXLoJxD7bDp8/THJ2uR7N7uzujsBU+xa+5xmzfpwWf1SjEzn8R1UtkuCO7F0TcKd5JV9b+6fmpK4dVQQbt3zvF3dj7UzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vp0tzAls; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vp0tzAls"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Vp0tzAlsscdONYxPs+5SkNWEB+
	UEjMMDaE6rLfl4+yaxwl7Cby/q1KxXNntRONfl+40iJ6QFS7je51a8jSTjhD0zdR4GE2pJMHURuQp
	4kO9zRo+qwwT9cq0CEjhV4vK5qTAZCELHKn24S9ggq5Lv1UipGiwuPbpA5PC+/x4+4dxa9i7y50Fu
	l35S979VBAgDWBEHAjjJPU0mYWLsSDSzmcFLp9LWHAibNFXahwUYY0Ls9Im+FzG0cBufbH5x+dDOn
	Oep6aOQMRo+o0y1l3qdypeEppU+3btIB/MS6xRLgYd5YVuekC8jh26wTwy2T9MbhZ2XCaULDsju/D
	49KsfkVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruR5u-00000005Iqa-2waW;
	Wed, 10 Apr 2024 06:06:03 +0000
Date: Tue, 9 Apr 2024 23:06:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/32] xfs: drop compatibility minimum log size
 computations for reflink
Message-ID: <ZhYsSkVOsC_lzEyw@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970075.3631889.13494808585016033882.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970075.3631889.13494808585016033882.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

