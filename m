Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5146454BC5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 08:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602455; cv=none; b=X04Ma9b1MvLP1JPP3vMOCDzMcA0mEi/Me3QLc/jiT6RG+N3M/7tQ6iR9jaiP6G9zqMhcSsz5NYfq8+sXwe2xOe6o2IoGK9V0wEHvYVj+EuVxqnh36UpLhg6wAtoQxhmBFXeUlLU/l52u/J5pES29xI9+IVXfuTEsfbsPF0IiT+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602455; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NbGbx2KnGYyZHUaMIUCMdLAXe3UtKTrrzHG4Mi2pZbMh6kzebQQSKlvb92NZxoQBWXoqulrWE9C295JZ/utAUe6bR53P+WD3srM3mNH8hal3U8N8GZbgzsbmUTqEZFCOwZ6E6FmFQ7CcRx9AZXxDBmPeJ3OXJlEW9JNGsl6ZIsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uJZZIl17; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uJZZIl17"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uJZZIl17ooDTMCuEGdOSqt7yqH
	WuarhGxhU8+sM/r7xeM4+pnMW50kI+JcO8OMsywnyD/dn683i1sGy2psOJEsLSQJvolbFQqx6A0IW
	43HBkhjrcnb8Hg675+eb7kvbu42oii9GxwtkfwGlXEk7n60U0S3vWM5gthi9AG5WvDkcnngM6WnWl
	c7s9RbiADrr7pYFVuov8ghe3Ozm2/xMpzQsQbsGJ68NOagiY+6LWbzg/lnleAn4rgPa3UIxG2jiRR
	kwNOXlaiuWqz/1gpRbQGVuetj04r4ocshL22HhHMfL84P3xke+uwRmfJ+su4ZeqZQKmgblHe6UwJB
	kCh9l4kA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUjFy-0000000FeX4-370B;
	Tue, 30 Jan 2024 08:14:10 +0000
Date: Tue, 30 Jan 2024 00:14:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/6] xfs: allow scrub to hook metadata updates in other
 writers
Message-ID: <Zbiv0qmeEJ-Uzm7E@infradead.org>
References: <170659061824.3353019.15854398821862048839.stgit@frogsfrogsfrogs>
 <170659061886.3353019.596403778386618930.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170659061886.3353019.596403778386618930.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
