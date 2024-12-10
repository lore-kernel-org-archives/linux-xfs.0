Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5293522ACFA
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811291; cv=none; b=kXz7wvDGRajd5kMhPSl5riYinljmNvK4iEKwdcyQfJ6UwVEDYasSpyiIe+X40Up+VLRiv7YDiOSgpuVIRmoWxHqNk1KAgafo92EEf1Aa7ee1+UdDuIQmzNpQ5qF2Rx7ZMxUPf/YF6vdeAGQzMQFJdXykTMVbdr9IxqCuKJjI1a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811291; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0KmfCALF4nD2cQ3Q47iM380ISpmA7sQeUEh89pJEJL/eScVh4SzaTfHQOm3k0P/+YvWsr0i9CPFbgv4Hlsoato6qWTKOPkdHvb0YJPepCPtk3KEWIItOOKfOhQDJ6ghchQnjlOuQ+muVWkwKgYkdzbOC7H6SzaUUWGh/5o1P6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HqvGDTMp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HqvGDTMp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HqvGDTMpXCHE+x/9A4CvZbxh78
	lrxj/CDzWi/QmiK3I+Ap5w+LG7KkTB3bAhVu7s0vMtCduoUOrnjUu2KWNkwKBMaaskALp/2h2TcOm
	2JyoSt1frIOe5sqLWwjWVwY8qbqfU/SsXvmWXN0pZe9xizW/3fAMmHn3VsrHtBGNWt3nIDoT6N5CF
	i3+9xzg/PFF4aDipcJbCUPtEF5pxxr4Kuc52lB42z3JR5D32lle0j+3JRkzd/hpbMcLtIapcd4gks
	YGoOUoFENc71vfncPwKdgwjjyohcFGp/IwJS8iTQYNn9I9tFQgTEieH9oY/+VWyQ1qgYS8Fp5+4i1
	GYt6DIEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtWE-0000000ANwV-03eh;
	Tue, 10 Dec 2024 06:14:50 +0000
Date: Mon, 9 Dec 2024 22:14:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_db: support metadir quotas
Message-ID: <Z1fcWZ_40sWjxMts@infradead.org>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
 <173352753263.129683.13463573262283190371.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753263.129683.13463573262283190371.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

