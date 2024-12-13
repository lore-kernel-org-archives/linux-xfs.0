Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B99718E351
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072752; cv=none; b=WwUD9qLTvGOBjtkQEXmXHVS5rS33wCAtRzzU/rTxVms9nSeYVQwyBluKx4a6gSLgpJG5v+rOIRfoGhdq6qVTQ9/7l6Ek6PT2ggCIntj4EvK/qLxjhUmchTc9tEL9WWdjP7XQvte9Vss6rg6fXHjoy8SgPlHZt4WWYpJqzzRpJ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072752; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REA8pf0M7leOlElnfL9zVCnGRZcqu3ZK2guexGE8l8qOYcKPQaEcAeUSvc9j71meAq4JowziCvViSpu4YqLN13vTkHf65Jn6HQUCsrFbkibv/q0FWC/fU1m4mDaKP0tikiHW8AK2jEFop6nfjlA2duaKxVadF0HEyEHY0v2FEcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nLn0Jtop; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nLn0Jtop"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nLn0JtoplA3vzVVmuyrQjfln6V
	GZUMWw7yCwiQ36PmJFrKrD0F6ze0HCKoMbIeljtq7/mG7ndB6ATJQ9uRRP7drj4b50H4f85mMpect
	+NWneeEXvXNOY0nZNrsAQCc4/6oX0w1MENHJLBWDpKU8fHc1xIMt4zgFcgdGrOEPFDITU5Hqkw0ic
	CKagos5Di9n5tufC9fII7V91Hcj5V928G/FpM+z0RuQuM6bamdWdacyOV+WY0UCPEpX2fsinHRHIO
	VH5md8SnFWC1Ryp5hgmc5aOO+oclSH+bVNWzpycBf1ASJ7tGv2o52oQJF33IQKUCwwH7lK4FQ1L8r
	bh04WVHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzXK-00000002uFd-3upc;
	Fri, 13 Dec 2024 06:52:30 +0000
Date: Thu, 12 Dec 2024 22:52:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/37] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
Message-ID: <Z1vZrsqDbDb2fafI@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123589.1181370.6617549529420695155.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123589.1181370.6617549529420695155.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

