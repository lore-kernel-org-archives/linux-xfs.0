Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276B14685
	for <linux-xfs@vger.kernel.org>; Tue,  6 Aug 2024 13:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722949625; cv=none; b=RxVXgWv+zIl/jpxxFkk79NoNUW1Mb7f16+RuUgEmJyqFKKU9qW2/ngDoKlfB5UXfe1e6L5c8ETIOiFBzuhk6aS8AEomIoh8BfTeNDAOB+LnEOAqZs4NWuj6Dcf7SDvHlq5A8a04wkAH7lT8TgEeD2JEjO+Ns9rDw25kGhsAqeiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722949625; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zh5bYgI9Qo1eB0NNyiLhEg3kKFQlMtCOk/wm+kHJXuPjvlYUTYXrai4qv5Uz5B0u4/P1nrec9BBFYn2HthEs55ULVps9tEl8mNVoaiwLLsr4j24RIvDTBhi/RJA8zolC1s5HjJAx2eT6FLU3KHHy4lUWREcEKF3jqTM92vkONPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UosIt2Up; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UosIt2Up"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UosIt2UpQ3D9/e6fkMa7JtrnNN
	xTE/uZ2PgNiLyiK2wJOMD3Z+DuKb+CY79ral+H2JxBDA+rZGcc9I59aMNor0gQbXQKsFZh/NTNFvY
	K0dJNA6GQdNq++SYS3ZJg3AtI4LYl/Mys/UXw9T+OQEPoT6hqWyKwX+wicgx92sD1bCt+P5hKIskp
	ahhk5cjk54zFGS3rkFzX+5qVEHz8M1sp8BV+7P5VMO7/KrBxT3NzqD82/C0dinttQ740AktPIMbf3
	tjXKDPB7AedCH0Uv3I5OWbCF8ZCJ4Vrn99Gyzmg0gkyqG79gMIeiinwJgi6jtowK2Falp5seO6gp3
	NM+FwJaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbJu3-00000001dNX-2rSi;
	Tue, 06 Aug 2024 13:07:03 +0000
Date: Tue, 6 Aug 2024 06:07:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: revert AIL TASK_KILLABLE threshold
Message-ID: <ZrIf92w68n-4qAm3@infradead.org>
References: <20240805184622.GB623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805184622.GB623936@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

