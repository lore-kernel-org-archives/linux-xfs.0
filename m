Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF594A64CC
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 12:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475283; cv=none; b=fWSOIIYU2zv46lQaLyDxEoqG/rub9PwIdT5WHah7rdbzbE4xkpyxvQGf22HOeNV2cop2m6xm32KSiWoW+0RdkepoMk7UhflbgZOyYkCpoZX/p1PdJz+GLGH6rEohyQVpYK8oey1oicesL7Gw7xb2HqQBXM9M5a4Z51pMgWXsYtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475283; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFLOsHJIqjpY8dMpukl7ObG+KiirTU/SeuwCD6dNZm/7eth1wHeNC/dUbnOF/OlQX3ra/Xtz1nqWNFx6xMlG01t1v+pppTJCWgMevSIC8Zx0dIhztNK/fn1F3Po6diSiEBZgaqJolTO/BXgho56rtYmU0nGLWpOJF5jknCxe/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jvnpcto+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jvnpcto+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jvnpcto+/Iefey/fb8yvGQ9hTW
	RSlrtx8Dr8eabmxcxbov4zByRKvXXsf7MSQX9OCB9vtg75mlO4rSJe/lQWM2qc4PCeWDh5uWmhF9W
	BP6R+hEWqggpXDemqpju3w+PuYCOSSXQ6H3y99Az/h5O4rqncijc3HKUFqV7rFLXMmyxR7jeh59bx
	7cYGZ2+w+/F/94hS9F2KsB5tvCr9ODkq7kNgR/FIpn3iZYAiXKn1SrO8A4Hykjpr3L+8I8gnIHvvd
	pJAaZ3dDTz3kAcKQR4AD2i+pWKq54yQp0MpS3zOZG8hv2+bVPS43D8JKw4Me475zu9nq1h7oJLm5S
	QIbFbxbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6SGX-00000006Uhs-4ACb;
	Tue, 15 Sep 2026 12:28:01 +0000
Date: Tue, 15 Sep 2026 05:28:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_spaceman: port makecfg to use xfsquotactl
Message-ID: <aqk50W18LVZYD1Ae@infradead.org>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484936.2108717.8402857786114618949.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178936484936.2108717.8402857786114618949.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
