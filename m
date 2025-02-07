Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9E63D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905771; cv=none; b=OMcClfxJGaR77ne/YOnIqPXfAl11CjeRnFkISRKQ1j5ka8zd1sY70bWqzPGPRlo/EZVWcTnoSpZfY3ikEK1TTb0ufr6/m9nR1sazvrmECASa5sHQ2knd6hq+fZZdvEqIYy88rd9FShesTsys8VjXapsU5vToHb/4fRzOoGwPeAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905771; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZnRf1BIWhfSLqgG0QUoaPAeWAa3nbr53BqD+Ka1x+ktxB8jtUikzYHgIJc01s1OgQrMgptVjpYUFY2qwQU8DSkSu4HXM02v9kr81yTstgnKTi6VOf4DPMc1na1NwVog60NBGL7IRIbcwPToBk/Z5UPh0JGTV/phTBdU9cufvyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jOED2HHb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jOED2HHb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jOED2HHbn6YznWUyAQ/wL4Lqpo
	hSaRMz6oWw+YawzcyKbgQhJf5on72nIIIoyhfnUjFJwx7wDW28ig6J3rV4I6e/QtiX7pr7LWKkOh8
	KARAPO1y1Kq6BYjjHJ0uYKkoA32Ck1zDh4MNVpMfsn92MmSCCJ3O5JLiJnkkkpeQcUnv11J5ANTEy
	caZuE7RIvrtiOzGDL2H6eI8vNZrv4kG3iiEUV7ULplpGXjnUJvVd8ifpPM1ywdp/dPJM72PpMmCVC
	N9EX87MLG4CkE4eeUmvNEiABKEjJjUMridyFmReHzG4GpUKoFPUiD5V/47c8Z+QUa8hzf1HB1pTj6
	bcazBiaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGpF-00000008MQh-3JWU;
	Fri, 07 Feb 2025 05:22:49 +0000
Date: Thu, 6 Feb 2025 21:22:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/27] xfs_repair: refactor realtime inode check
Message-ID: <Z6WYqVI-7zVKr8nf@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088356.2741033.18413230775534572246.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088356.2741033.18413230775534572246.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

