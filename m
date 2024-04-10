Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5B213CF81
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 07:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712733836; cv=none; b=btm9eDMKiLcBluco3ijdbrHC05CA5xEhkhFcLXpFus3iMrGQ9mb9+SG//IyfJEdECVxqBq0I1w8HQd5ldTJt+9K6gNttw0KZcGv1/i/rYjf6B/ksB9VjbNJQ8L/OVqRbtS9CuO8MQiEBFMmHlvrGPI4/t00bf68sB7yFfH2QJiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712733836; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVc2eNiglGRrosrkMIhFXLshcPyg/yil2JNb7oe0KMyAmMEpI2NEmjuQQWtvHSjrn2zgPxY8nQ4BWOuh881jM+DOetPWNpcnau+45AQsOq0wzilaZQQPdMahvDVe/fu7bZ4HO7rIinuTc1BXCVJJF10ITfKnn1qgOiXJoGXtVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wf3YyV5b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wf3YyV5b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Wf3YyV5bJU4SH+o2IXUnqsCRDA
	Dj3Df3bKA/fd2Tlr+XU3Ew0Hh55QJltsY9dqflTSAMODwjuynWWbX16hKZHy40FORr2EAwqzbuF5H
	6sYSMhMVXLlezlRdiPdew2Des5FDt/cFe08ECQ99FZ/45w7OmLH4sWFaT9r0nbmOuVlZzeYkotZji
	2gudqF5HNPUtgh2u73G2rRAyiTVa8wDy049ObHJMrMgDnrNcaOn1RkxCz4SVllRZmqIPcv6deJWkz
	jm/NY0XEN8CbRokQ01F8iXU8jeHbPmzoDeQM9qti7Xfh/S12pgHMJE3yVY7p0HC+kCkVsApzStX88
	gb+Bb5IA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruSJH-00000005avx-0GXo;
	Wed, 10 Apr 2024 07:23:55 +0000
Date: Wed, 10 Apr 2024 00:23:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix corruptions in the directory tree
Message-ID: <ZhY-i7-6_b0Jd8VB@infradead.org>
References: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
 <171270971657.3633329.10442760339468169655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971657.3633329.10442760339468169655.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

