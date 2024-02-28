Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB747146015
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135882; cv=none; b=aBIu9vTyskkyUMmd5Mpq67QN2sZ6ut4FKtPnAntE+LxHIOqzZcXLbzSyG6A5e2DM40Von2zmDDw+mV2GxU6mgAR5hLOs/vokqF+hEi0vT93Knm07WEyS2G6kjrarOVn0YwZEeYAYINZCSrI2FT7rNGo/0COtW+3Xhj7cA1MvHjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135882; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNeHv6cezXGknrqxNj6CKc7CbS7jxVySFo1cCFF75SGFxtOtv9c09t35KtsbmkprO/dXY36ozb2gZ8ZaSvV1L7uPiiyWvJqQtmvsQ5u/elvmkc2x5neNa4ihIOrJMrLYDG8yQBJExWlqjsrYNLRSubnwEVLroTncPJKUuP8VQyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hv57MNWG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hv57MNWG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hv57MNWGL5MB1HljqxU9DX8MXQ
	QvDRdC3WVnaA05FKOpGc7KmY+AnbRvn2oBHwKeQLiAX33PgRUkibuw39Q8mhwwmjkoPc4byCLghG4
	QriLD/XZ1aJwjIPjZ2kQHr7aV5qu43IKpxWD0YVO/8myeC5pqPiD48jNIbxZzylk4HqVhSReVHzGx
	Dpmb66AErsdWjDNS2cXKGpDR5ofGA2bo1fYvHZpVZpONcRRRB87csPbf5+RtIqUnAo2TWKeTVFepp
	V3kY/oA7jcI3aRK9tfQPUlA1VVbhFFX684KTawGLGF1WOLLVMbOlGPrcv14bKq5pFrPGEIkjjeWaq
	2c2pUQ1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMJl-0000000A06X-1mN9;
	Wed, 28 Feb 2024 15:58:01 +0000
Date: Wed, 28 Feb 2024 07:58:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/9] xfs: validate dabtree node buffer owners
Message-ID: <Zd9YCY35kVjp6r5j@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013176.938940.10819725378237151085.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013176.938940.10819725378237151085.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
