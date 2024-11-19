Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344A7150981;
	Tue, 19 Nov 2024 06:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996689; cv=none; b=qrd2h1IJouPIDqhk8FsLApLgI1Nv245L3lyL6D+B6LP1xUXkn13yKkVxkgOyDriNEua4xgPv2+kQULYCb0Nv6nf+3eZkOVRK7XYC+7ZwU+yfFHgeCp3IdvMjYdHm3L58j5CT+CP90KF78zuJjOWU5l6af+0DtiNDSXu2M7kq8Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996689; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fc3SPIEZd7E/zJAUZeYi2CJyKdcjhXi7Ha+AbJn04VaqGp0yIOSqGXB1mC6VmWM1uytI19LrUIP72lmcRL8dqHGZqwaPHmcF3nWInToh42AQc8objiJBQ/71lzs6SyzqmO6oiEbGRiSlX/f6pQ5WwWxaxh4AvGJNtNhwlneGuNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YfDCYHXj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YfDCYHXj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YfDCYHXjYfgj8zRFh9a3HYuoGd
	JAXsGDryBtvRettJiHub6RL1MXM6MGmayN4duhR0GRbNQjB2MahRKcPl05IK/BJrq9/6s84cFNbh6
	PTMqYtosHGliA/AnU8vEsMM2Xk2Hk3xbK6gqmbVFecxUChFaiqX3ZwdvOBl3BYWPwx/TOX8tzp391
	ddAY/k6E8xu7Ob8xV9HFkOp3bJDajGGEwNyBXKwMVJWPbP/fuFPm8X0mK5/6Y/CJG3O9IpyN7b/8X
	FuQQMP+fsI4mkDcLZTHuyFetytcnZtH9G+RZtNU8KTxMG48MzpqWdX6JwYfkUkTa2lu2PlfBlXOca
	b3CMej9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDHSR-0000000BV9Y-3mGi;
	Tue, 19 Nov 2024 06:11:27 +0000
Date: Mon, 18 Nov 2024 22:11:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs/009: allow logically contiguous preallocations
Message-ID: <ZzwsD2NQ1u0hDSiC@infradead.org>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064532.904310.16393171518805565423.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197064532.904310.16393171518805565423.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

