Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339B7185B56
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072639; cv=none; b=Z/vSiZpfki2Ols1hgnhTDmhKJncTRAtRaDFz/Q1NOWWzXKn7XUH4wnoBz013Ek0yId7RkpbjjMP8dysmJPM83KcONCxBJJVg1q8CEFNj34QWzRZQAvpPNtdB2Bjubiw7oHvc/tqwl2so3VSnU7NqgSc+XdxohKcrav/1aTf/Pns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072639; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MIx2FsNx1Z68tKzBwtRiq6cZO/aCjK1iiIHm9JqimtorpH/+ux6dH4lXEc0MejmvJuNSnO7Nj3dpv0DWph437pu+5tmLiK0nWPc3yX++wDc6LxGh5QA6F/I01eqCwINASzO4TJ4JfAQ889wd+70pOQklAw8GUgVnSe5+smW+06k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vOTgNfic; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vOTgNfic"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vOTgNficVSrPUTOKhL8eT398cN
	0a71Yek/HQ0f8yTR8GRt7/GYg1SEC0o5Km30I9JOWClIQr7Ot/1B9uBODWtLUId5Dngo/jC5AiqsB
	0Q1e2yfGQmiZ9no42yLqhD/r0jhgLWkETXPRio9OGspW8By9hAbwVyS1PEPjmBA1Ja3NKOgayg77p
	FYO9sgAZe7MjFd2/xnp93LtHDT1sjsrqbm/p9AvSZxHIY7+p7cB6A8vf0FvZ2etZXkJ/0oqg0gUX/
	kmbwFUlOOqyrTFMBDXUq3R2+E0F3nwbEn0+RRLHqbhSbTPfVKRa8KGPI2OKQ/tx24VG386TZbe5gW
	Lnqi9ZcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzVV-00000002u7H-3Z8y;
	Fri, 13 Dec 2024 06:50:37 +0000
Date: Thu, 12 Dec 2024 22:50:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/37] xfs: add metadata reservations for realtime rmap
 btrees
Message-ID: <Z1vZPYVWxC4rN0Fz@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123537.1181370.15688658549010481316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123537.1181370.15688658549010481316.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

