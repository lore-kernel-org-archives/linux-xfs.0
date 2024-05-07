Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3B16D1C8;
	Tue,  7 May 2024 06:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715061982; cv=none; b=RexPLrRTla5bzNuTgncbCKb7hmBXa2ZdJ5QXV83pt9dKCMTiN2d3x82bRrvTgakA1kpnZi2BNEeegWCuFPX/3sMWMg0PdlDTWHtaotKQvXNG7gd09uHvJzXGj9D7pwRu8pE8Rrxa/tHiX3GTXKVMyB0vz4YdjhM0J1r+KsjoLzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715061982; c=relaxed/simple;
	bh=kq0iE4Ltuz++mXgjo8EXa1DxZTvpmf9jk3QNV+WGZTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnW1NFEdIYSNtlt1vNVOE/fypBw+k8fKQ7zbcPEOYxe8lMnpsL5NmT7nEcxX54sA+Bg3+aumo2ddlDAW0maqj1cHcckWo+R7gNOUaMIUf9b2JHb7jagMk6rdBUBBQpvorm0OxecWldl85cfEAH5WdICv++7qN0DfYzzgAE1IZ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jY+4x5NE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jY+4x5NE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AbyBUhF1bZR9QzFx1wqzPcMYZQU9/Sfuec0QHc4Ti30=; b=jY+4x5NEQ57r046QXBQyh12aaV
	Q0kcP7nsaiQxk0TujJcJmmB3DzHR6560Kp2VpnrUWoz1RbzuQwudmHvlig3XZFfjvmCK1uKSybQoQ
	tFlQ2aLMNrfSdpG8EoBn0d3oi91PfqGsmJ5Q65WDkKikWcTD30tS9uvj25m2Qv71FPhEiGSNVP+CW
	e3ejvgmwPdApmsDMKau6IhFtqdyQqRCXMHHFkOr1G4d6NJyG7NgQB2oMFzcYiEqgU7wis7ii9/CAG
	5khYwAS4qVTDsBCB1fzO0BnPGBTha6rzeczrAhGxl16drwMqmgbbL+RKq3G8fsk8GB+pNiMBmuEnt
	8l0ePAtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4Dxx-00000009mYM-2Fks;
	Tue, 07 May 2024 06:06:17 +0000
Date: Mon, 6 May 2024 23:06:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Message-ID: <ZjnE2SjU7lGD0x5A@infradead.org>
References: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, May 04, 2024 at 02:27:36PM +0300, Dan Carpenter wrote:
> The fxr->file1_offset and fxr->file2_offset variables come from the user
> in xfs_ioc_exchange_range().  They are size loff_t which is an s64.
> Check the they aren't negative.
> 
> Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")

In this commit file1_offset and file2_offset are u64.  They used to
be u64 in the initial submission, but we changed that as part of the
review process.

