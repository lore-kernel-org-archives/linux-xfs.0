Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49913AA2D;
	Thu, 22 Aug 2024 06:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308332; cv=none; b=enpf2BZdQCNkWqIgdoeCAnA8iz6SAyU1IEROGByLa/zEP1Ih/p1DUlS1zqHyt/4JN298mL3aslcU2yUwZwszSVy6RnhkIU4WNNkvh5OwHu5OkxdAm3R+EmO1LJgtE8EfaAxlP9xM+YMUcNhMBvFFj602w8YFmWuOmcsNd2II0Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308332; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uqjy4n+CbsVChFz+aYNXRIe0cDKnW6b5H4NMHcGUymKilrcz6qrqS5hDdbiPrtXONrgGsDuWZSHWyBOAuS1m3sBAHqt+3nR0MDIODRs8Yg6mzZ0Is4ont2qkCZcgggICgfiNVhkWXF8M84nBwqBtqbpkdfVlGf3v+AgqXbjYjqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HVlmnkF4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HVlmnkF4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HVlmnkF4oWi5wrEFQxciXrXwta
	jBQiV8B/0NPYTq0VuxBSp4A1sGVvt5/vRsP75pNMNZShmRRE4YiD1SYe1J/MTw7JASHwoTJ0CiUcb
	LXidqV0k9B3xmsyIoT6DiZ//Pz0F3f8IBLrHZB98On6IDqevhYNMqryIXZhPIKYqbO35ZT7YwDoOW
	nQmmydj0W0f2UoQrKBgO0BUCxQ0kD/u+fU3AgwVbhZbrQqXuSmdJQFT6bysc7viymJ1GwsZVeTi9U
	fNumg6soSulfa7XNkz5IAr1HJzEEGnGvCf/vkhx4qfZwBxC5VQznoVNM6SlVxhqatkb2urkNO6xKA
	zBO5QX+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh1Mg-0000000BcGV-3LbR;
	Thu, 22 Aug 2024 06:32:10 +0000
Date: Wed, 21 Aug 2024 23:32:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, kjell.m.randa@gmail.com,
	xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs: add a test for v1 inodes with nonzero nlink and
 onlink fields
Message-ID: <Zsbbajk9ENJ4YI_j@infradead.org>
References: <20240812224009.GD6051@frogsfrogsfrogs>
 <20240822050540.GP865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822050540.GP865349@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

