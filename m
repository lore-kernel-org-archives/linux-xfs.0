Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CDE8C0B;
	Wed, 19 Feb 2025 07:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949666; cv=none; b=Rse1XATvS3YOuawEU3wFg3z4q9a1hQKUZjavf5EVI/z8j2sROg6mPTYLQWNtKSImxOdCu5RKyjgEdBRl8DpPASviAzT5OIceLtZVGzyv94rmE9/nWJV8oOX1xwOSWK88QYgrXjCaY2Ae75lSx8b6uf/+RcDHYu7D3/4QzHn4oiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949666; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5sglB6PVor04cxL7Xb7x3QfLcrqGuTuRxEg2yVnwSg7gXh8MwNep+GChpF3DtNMlXeRZkOAlerHZH/Wgzg7rMmflB99bups4yIeGI36V8Qw1Kum6G9hEAQOwH9UBNS5jyy3RE+t9A4FjwnOLtWIPuzRedk5qQFG2L16ILNYBH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kqe6UmZ0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kqe6UmZ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kqe6UmZ0mP9CR76yg0Pwb13E+S
	xhn0ElLlhD3JrCo1B+B0JvfLbsPaR1kLX9m4me24rYdkPCIMFxDgESktngI7YdiL/dsmoZF59IOM0
	FvNNwt4eDz9p6PGxp1+I7YZzxazkB38RcX0A7m6a9mb82E+4x8ksOJmFukHQAiLdxN9KITQZs9jBa
	+7RO6q18gSWfBLDumjIISPUNiHkBRJJEp6gwtEmVFW8THJnLcZbXcMV/mdyQ10c994YTG8pPFyk7M
	YOiOrzu1+WJfDWb/EIfsnxwbFZspIcYIgUU2zmPoQGxPkw8jelICNG7lHoDSo2QpaglUxPfBRGf0D
	LqT2ov7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeOH-0000000BDEq-0txA;
	Wed, 19 Feb 2025 07:21:05 +0000
Date: Tue, 18 Feb 2025 23:21:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] common: enable testing of realtime quota when
 supported
Message-ID: <Z7WGYZm9WlOla4De@infradead.org>
References: <173992590283.4080282.6960202898585263825.stgit@frogsfrogsfrogs>
 <173992590313.4080282.15839149250128680885.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992590313.4080282.15839149250128680885.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

