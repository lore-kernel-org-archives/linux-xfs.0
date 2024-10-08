Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218322B9BB
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 04:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728362114; cv=none; b=H6AIBOtBqCL/0OWuCLxay4jNhg9s7RutHJ9BZrNeJvyPf4jTa7zrrA5LMLsItRQ1UpF3Tfq8PmI+p0vHTLDABmj3QItaW1ykp1Ma1CNoBih/5bFFoYfhfmlQwibKRRrxYJa/sTjy9256tVX5Z+nMmeasAaEUz4qqexZenhJbWsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728362114; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZRxRI4sl61eutlFn0XHS6Ohw1HYytBHIIH+Ixx6QYJSt0gAao/MBM8u4zAMWD7J14WmODPl0s0vTIl9LeHL5jfxuX9Jy8UYWga+PDZCLe/l+NDYO1JB+YxnIx81iU2QGOTlGM9txr3fuxgU40DY1RymQXsBmfgQD6wgxD5bKeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HHZ9iZiR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HHZ9iZiR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HHZ9iZiRvuncL9/Wu5UPL3m7Ls
	DagqV77ahuNrPa7HDUAXF9Ep2EmtqyBbpxFjiIIPCiMqcFwPYghh9/iYUvf8kwSq/paPq9Z9GhEgu
	rSoX3801nUfqQlZwwAQ25YTVWsZ4jSEuPzrRP+tUiUlwTrr0AhnXP7rBrYNaDyA7kw62xjrbgnZgX
	+OV+Q+KsgB7w1VDdC7+E88ZrRYB4gQPpwX/9DbkcjK0/GUlhcVK8EPzjacCgPgywz+YEJ2s0pjSji
	WD/TzDbTnQnmH5EdTkoKG+ADjimGvqFWRifPHbzKuDSUv15fktEdz5J0yoLKIGUbKODbo16QvYG1I
	jNCNLGrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sy1wF-00000004Uvv-3A83;
	Tue, 08 Oct 2024 04:35:11 +0000
Date: Mon, 7 Oct 2024 21:35:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v4 2/2] xfsprogs: update gitignore
Message-ID: <ZwS2f_rlCyeBcvw6@infradead.org>
References: <20241004115704.2105777-1-aalbersh@redhat.com>
 <20241004115704.2105777-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004115704.2105777-3-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

