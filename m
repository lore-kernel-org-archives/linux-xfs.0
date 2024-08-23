Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29434D8BA
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388155; cv=none; b=W+A6nGpyXA20RRgboqny99h8w6IyCJLuKqYbh5odlVIwrAG1xBjGMe90sd8L+dKUMO2K7jIckSLu0KZk5hVScUYeC9IVFMYb1ym97kt/aWbsoy92b2EKjLtjNB1YDQMGLFM/Uysohj+Yj2rQuTF+XAvNSvj5V5cQ599yybSNh5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388155; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mv4MiybvCddzV5wdcOQqkxTxaCO93bGh6XS2zoB9DgCdbiF54iAqV/zgNLsQQCesQJtsyLI9wKKxXBr8sza65GFjmfn4GZTxqEYlTaTh5FjtgQkuKn0/qIA8VeA6ZSLNG/t0xpYVRajYsbqPI8p8TDS2mqEIXaais57+CvRUWJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dZg8+qBv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dZg8+qBv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dZg8+qBvuSx8Z2+84podKxRvX+
	pWXm5xwHmgNVB04YbCg4FZv+VIk+kgmI2Gu0EITny7O5ppr65XJGZzi0O56Na2xXWg/nU+8sBIA5p
	NE7q1kIRynKT7Qu3QwsyMJsFs1Ow52QO68Nd6Tg6WWsbH+qoon7zqVktKN9BaZmuWR9VB9l9zJEh9
	6wMiLO8LzVhNVDL1ZwofIdB1WpNA/V1/1kEcMy0XWrYnpmzKtdimVxfV/WzR584uGim5hV9PIAemF
	kE9KmwUmcZAdV1e28BUcfW83dW9NIcI5SNqjbEfLXpTDDHLplSxjqRSy9tvNNk+iSV+LIyXygy2rc
	/05pLNOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM89-0000000FDbx-2FNc;
	Fri, 23 Aug 2024 04:42:33 +0000
Date: Thu, 22 Aug 2024 21:42:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/26] xfs: mark quota inodes as metadata files
Message-ID: <ZsgTOVGsjVmqZznt@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085382.57482.14690905616222566309.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085382.57482.14690905616222566309.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

