Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B51157A72;
	Thu, 10 Apr 2025 06:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744266269; cv=none; b=IRjJXO7zqhO2FO9EfltJo0sC95sJbc/9aalGSxjjVpi2cknFgrApIcW70HpUzQr3hVbYjIuNuQ9EXIrgSUfCLazc7z9RLwyBA2Oim+8mATNOLJVOv151xxI3sMrr17z4nyejzzgJoVYgWvckF0ay1KU3A+072qvckSkE7ewMLes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744266269; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKQsN80RwJ9RbrjR1GDAfKLOro0F6Iw/pynXngRxDyWkokzuQK3Ph7xrxy8zd+2Czc/xeJp2Ym7jYS6bhGErE9y2+c7f+sKC1yg5u53mXyqrC63OkMSn5S5zY3Epz9Or0l+rDwoFOJm7T8LnrIH4JZy08nI0b6uYBvVX7Jv7DS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LqASFRL+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LqASFRL+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LqASFRL+MZ5PiYAtsn50+prlc9
	1+zTi7p8SUoq1VfijgOwEVjXdJT2asseUmw0+r5oecReciXgnccnS7Bbt5VWZzrnJGkAxUVoP8qko
	V7DNzNz2YOWqDrd1bCx0JLxRB8FOycU8CEFBjWlTVETfmeRL6HKCNiN9vCbHT8Mn2nhkn+ummlgnK
	C5h3OEiwl6wGQAKOf1dkdwONfHCcnqtwVQoYiIF43bDIpcKhAGncWmaJgCjoXr0o1KeikEBCQ/9xC
	+wRBf7K05qxwdNKcekVo1RleeMR+/HYMp2rfX7DwrpOkWRUFxxCF5RjQ3px1wjrzrwOyHPrMojH5Q
	WOAb8knQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2lKt-00000009MHR-2dPN;
	Thu, 10 Apr 2025 06:24:27 +0000
Date: Wed, 9 Apr 2025 23:24:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/275: fix on 32k fsblock filesystems
Message-ID: <Z_dkG46LrECfWO82@infradead.org>
References: <20250409151612.GJ6274@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409151612.GJ6274@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

