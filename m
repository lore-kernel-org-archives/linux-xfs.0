Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA09D2A1CF;
	Fri, 17 Oct 2025 05:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760679991; cv=none; b=L0Cd1Ve/4gFwp9JyHPXYayehLoxpzfhEwE018nmyNet4wpohVPgwBOg8LfYrLnnn7GK9Orbpv+dn+8On1F33zrNgnp10At2thvYIDOCR3AZiVtlmej6oBKa5EqJxUJIyAMnmbYZVG+eEcftOcMy4mgeIla0yBot9+AIzAREluHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760679991; c=relaxed/simple;
	bh=PIznd6H6Fl6vqW7NHwjoVPI/CVxWQsRXsj8lsq4EKzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGV9lrTGPWPaki6Mb8y2S7hQIP2/oD12S1onXbQHbUevJcURattD4ibhxXZIkTGvnY4qOY08V7+db6V+TjCEUKxQHB1ZuM6a2JQbCQpatn5yDHuhSi89okBh5kyE6C5vHpndkW3kP2hlMxNGjtbSoUGCOnRvh/9RoUoNfbj6azQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ugh86Z9t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ugh86Z9t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yEy9Qh8orVwQF3P/yhN+lhv983TJ0cN/dcJmwhvz99I=; b=ugh86Z9torzYFL9ziaVIKshzJN
	biJNicYGiTA05xEvUplKBnbuuIm3oU88ZnwsJuNOSaC4oOqRJU0aSxcZeyKaOmQ/zwSRzFLwFGni5
	ll2fM5go+fpGaJbDMeCX9lMQTAWxpTzcSOgxTpKGlOTMxc6duZhNGT7uW8nZ4cMts0Pk701XLDpbL
	QZF1625foKMt29owRupxRQrW3DBsbf9+jhCD3Qdu9CblY5qePZjv9+JrZuc70byjaKDP7RHmabjWR
	lVyQCRPlq8ziAJIMfDwCRCn0hHWk8x7maY40Hymx8lySFgNFFjmMt1VDdh9kKMBumiB3w/ca70+qM
	o0H2kKxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9dIL-00000006eMD-2OrC;
	Fri, 17 Oct 2025 05:46:29 +0000
Date: Thu, 16 Oct 2025 22:46:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH v2 3/3] xfs: quietly ignore deprecated mount options
Message-ID: <aPHYNSGQ3HSTThZF@infradead.org>
References: <20251015050133.GV6188@frogsfrogsfrogs>
 <20251015050431.GX6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015050431.GX6188@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 14, 2025 at 10:04:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Apparently we can never deprecate mount options in this project, because
> it will invariably turn out that some foolish userspace depends on some
> behavior and break.  From Oleksandr Natalenko:

Assuming you are redoing this anyway, could you format the quotes
without the mail-style "> " quoting?  It reads really ugly in git log
output.

> Reported-by: oleksandr@natalenko.name
> Reported-by: vbabka@suse.cz

Normally Reported-by: has full names.

