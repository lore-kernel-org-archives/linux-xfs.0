Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256D315CD60
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135929; cv=none; b=ZyXNcr8vsWcq69+9HeBS/sXythyocHctNqJhadZppaXssVbg4BkGwD94JSt4rdqA4EQqes2rZY42iKN9mgtfkGtkSFZ25wRkmSBCWMWojNJfEa+X7pRI7uPge+c/X8tUpgNn0eQuKAXZFfRH8ziYiLKFgPlP1ptvaoAQlo950ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135929; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpi5wufs+LH6Wr8MWtVfAYPriVCRaJA5r8zca/FY+XPPCP5fddipdDBDEr7rnW38QX/WBIuM/8O1rQLB4PKZLvpeQYoMn5HI8XuuW1w1TiyWF6yc5kTESKInF6+vmRwrjQaQ9EvWcO96iZpOt93kyxsJYUruZl8PHRIMBGLRaLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tilbev4z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tilbev4z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tilbev4zXyI7Ah4NLQGh6KuOic
	xtD/Rt984mI3VwbI7r15c6bsx9oE+NORjt2eKz6xU4BHduG1txJjB0yeaMc4+n1lYitx2A3g2JvTp
	B4kMbPAh/EPCBae8N1s3fCffXyc0AhTM+AP0Z/53sQRxvs0exPd/fDFc/JJG2zfJpdL8p6k1musqx
	SoY8N9bk/6sTxaW/cZ3JCz6rBVi1alF80SU4k/yaHsPLQxPTXd8fCIkgkk5x1zcnuxnsvuxI5a5qQ
	KOCSJ/FwhOoBdARjjHsLpJMECF4McPYyTVwS9ZEqWC2TdnltaHW/wBDgpa1IUJIGFpRThGkwwVy8Z
	CY0B6xsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMKV-0000000A0KU-3O6o;
	Wed, 28 Feb 2024 15:58:47 +0000
Date: Wed, 28 Feb 2024 07:58:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 7/9] xfs: validate explicit directory data buffer owners
Message-ID: <Zd9YNwFLkGshghnZ@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013209.938940.3309854812632138786.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013209.938940.3309854812632138786.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
