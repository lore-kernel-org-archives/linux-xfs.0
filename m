Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3484AEAEA
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855357; cv=none; b=knljzVVENRFOdZRxUHvnEVN+kWx9V6mB8SuVDOwY3OKR6QNo93oaCURG8XTI8ETbuq2N2PFWPSScal+AcuTgCiZLVMN2ENdkY4kP9BZ0HQzqU9U0Wxr+NZHyogFiROTCc0x33r6hN2KTkYoGqhQHgzuu2xZ5tZDVUT8ZkLKaPtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855357; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsjdTIxKeRXPtKA2kxz7NUvtsrcIXbYLX5S3/iC829GoTcwkwhJoCVU+bCey5mTMTXXSf6wfkZG6YBmrgFaEXtk8iA+nImBEjBorE8W2ytQLSm8uihGYAebvdaYIKOVwk0x36aQpRLYcpwo6/ezRz3nM/k9cyL3PnK2wyBFYxt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LUrfnOdX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LUrfnOdX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LUrfnOdXr2O5GIocRmnpLOY+oE
	wP2jFw7pQzlf7u002djIsNKmjgq+aqrYzWQLrTUFD9meTJ8jHSt77FOS5PGg6Gkuia2Ke2u0ZEKFk
	WzAlE2s113nk1FYhpkHFCH/3Ncr4lYK6LjgoTE+ATHHBoTvmwzjHnWGfeZgGj/3NkWlpqD9l7ES5v
	hTt4jaSOEhKMVfp0/fxMkuaJfglrqoVXmOMU8nLgBGjGhPK3R4zzoxVZafwRWsTctRxftvSXQ1v0Z
	9aFxKdpXVOacZfEaGkJYKISWQUzsRL0TFrF9uMIeAeETAGaWU6AUGIC1VJTu55196iPa9E7TKIqEf
	75T1p4SA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn35-0000000AQB7-32u8;
	Fri, 02 Feb 2024 06:29:15 +0000
Date: Thu, 1 Feb 2024 22:29:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: hook live rmap operations during a repair
 operation
Message-ID: <ZbyLu9_raVJIdF-2@infradead.org>
References: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
 <170681337508.1608576.7152826825431557169.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337508.1608576.7152826825431557169.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
