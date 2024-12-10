Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE2835967
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811342; cv=none; b=TCoQ/fNHSfm2YGLe+dwaMV8zcBEIrbG/RZM1jg3FF1h1g17O4r0omBEOt7Q4vJ1mxjLVBHFvF9D8JKyP+W6pFVayEYcNt6AC/oKJnx3XWujCYWqDnbUDjqp5XHJ/ZzvTDR6SwHi41m99s5jY/fqIxgaD9NFMRKD/civGnu7faSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811342; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mah57XkVqf5IeUw3sgqe18LUAQyaSFK5h1Yv3YY62LgDruHwHBemVlZRRQrQCZAifBQBJNxau1lXlokGZUeffrRNB8kGe1zAcj+lxcMPxg9Wq3huiFJq5bhvRQhxojzzTf7hP8iEOb6kjbJJhSKEaHFUbwbLroOcYWmZsMYT1NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lI9SqqIy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lI9SqqIy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lI9SqqIyiH1kk/wnfe4d2+Gz1G
	T/wZUq0cRKzGE87JpbuKF4i6fGuc3xYX8NCk/v5Aaw/5UoA2mwsKzcsbfemvkbhvmQY683YIfdPFo
	0oZSEWpozmUIA/hIZF2paoCiOClnY/W7uh+jN7Si4zaSyzogrPVhwx8G8UL/T+rhfGCBrn4GEesGk
	O1B6W/MdCizwiKAyiCGkNF/TEtKzBVCXxqRpGllxnD2jdw+kaHCsZJcaMLrk+zlrTobtYmoGVRAeY
	aAYrD54AHxHGDprQoSJoN3i0ePI2otgAScqs6mHHeo2B8ydG4gwqo8dL0k5nMgnhUCv0nIfV8EHYC
	wI/HB4zQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtX2-0000000AO61-3iSH;
	Tue, 10 Dec 2024 06:15:40 +0000
Date: Mon, 9 Dec 2024 22:15:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs_repair: refactor quota inumber handling
Message-ID: <Z1fcjCUiIft8MmAD@infradead.org>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
 <173352753279.129683.18254140495168515228.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753279.129683.18254140495168515228.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

