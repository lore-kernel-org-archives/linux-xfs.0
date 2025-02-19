Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C6EEAA;
	Wed, 19 Feb 2025 07:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950075; cv=none; b=n6CxC6PpLR5LiZQaXCQIkmhUN2ws77i8c12YSy9J9odIO/p3hSSaCr12FZJxdaU73s9y7cZKJfwJtgln/FN5cy7rbXuUk6V3tKe4NqfiCTV4caRTMpuDZzIaVG2qcRRcMLygt7mehd5bnDPy4LtC92qb85P0MXfc7RUh5RTNq2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950075; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2cFCZAN6NyEo2sWTHtwa8PkvYp5qKyp8Mkf2vRlz2AlTjBnKS4D+FimEoigF3moShGx2abHlwd2ia8VEvg2qdTOOfkqdU2MWovedpYaRMrpcOXQAxBas+ES4sk0aWylag3HwjRAZ4DWr6acc2pNthrq4l2nd3ukIkyTzgmOA/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MWsiCkeD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MWsiCkeD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MWsiCkeDFKrzQAE3F53yDZRKGE
	XNaM3M6bVGW3Z6heMtRJFAT7aEuj0MuX6suYYYiROBY8MhKwj2Wgy6YgNlTQwKSKThma6G8e/SRy3
	zC3kDQmp9seL/g3Ao2IUJtT4et1ITs41u3ojcgcmJr/E+9TgnUqLgCNVwQ/UI86/nOB3mT9tmRwWX
	cSakJ0CjaV+Yft0DHatnO36UJZKJgrxByYPlq4l+BWHXxz3Zvw3z6VJHp4SoLolKd498X6LKd3aO1
	gQvWgD5bBD5+u1gsM6DSb9fjHaWYd/+WC8zSnyqFm9Qt+uIpBMzRHZg5dK3+PFZUmY4CD96LUBC8H
	jtRHJJEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeUr-0000000BF48-32g0;
	Wed, 19 Feb 2025 07:27:53 +0000
Date: Tue, 18 Feb 2025 23:27:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs/3{43,32}: adapt tests for rt extent size
 greater than 1
Message-ID: <Z7WH-e71jLaroz59@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591239.4080556.3578802214204172288.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591239.4080556.3578802214204172288.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

