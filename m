Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B1B8C0B;
	Wed, 19 Feb 2025 06:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945126; cv=none; b=jSxefFzxN0xeyHfE1NklL9Oanp1RbLIIVkuyCFqcTmq4mnA7cHuIMXyFemihDE0xZpUxhUdf5UH/1eX2qsCuhheRvdtz7A2Ko1vBV3i6NlkexZ/DkjWWvrB25jWrZdC8mqRiKyQyPu7laCM88oYCjSO4QYOjfYcqM6Z+OEG7XAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945126; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+3G7Up15NqcA3UO6FCdpw97AhzMJyG7AQl4STJp9F2QSP4gJVc3spSi7NH0SkJo6uMbopB94s09jDci1FYtN9XcN/q3KaE6iRnRw+ovsAi1zB0AiYboEZecgDtoKFttO1tMPpP0OO/A1G+9rwYXQvP/VWBVp2u9T+DSifJgEAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RixeE8O/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RixeE8O/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RixeE8O/1XUxyGmiFqRQdC4K6n
	JfQBn3JiBonXcrAPYKjAtZd5zvtWpo7aeFsWT/K5BzXdaM3kf1aTl3UABNtYYvSwtjaK+YmuOGqgb
	F/HXgGq7iDdpa7/39R+wG1+4R5Vpt+qbX2JcQweeos6yoKPipPYkOPvdR9fJRNy3ZmPg9eE7cG1wX
	4RdrSqxEgFjfA42h14RB4drHXUUwkt9E7KJlgOb1PQbTS2mVzs9IbOVC6gEjVCUVQHIH5xyCT6BTO
	+ealeLzlsiCyZ1FoEifvBZPHCE8d481abFuNAGuptTW2jhHS3GRsnbrb7+T9vSsln2nr5sJNvfn0y
	qvgFTcwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdD3-0000000AzeD-0imn;
	Wed, 19 Feb 2025 06:05:25 +0000
Date: Tue, 18 Feb 2025 22:05:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs/509: adjust inumbers accounting for metadata
 directories
Message-ID: <Z7V0pUMwXR8hXD9-@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588171.4078751.10552424872825170445.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588171.4078751.10552424872825170445.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

