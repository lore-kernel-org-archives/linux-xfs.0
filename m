Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91D7396597;
	Wed, 17 Jun 2026 07:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781679834; cv=none; b=d33T+U14S+1UWIVCkhGzjeIyRtppc0dQ7JNkKRw+o3p2VCcF2EHuQD8a4t7qAJvizzFlb2XuUdXGpURgIJ8jRrqtXTLJ/++HyaQmL0gABvgM5iePdgehsHzjH2HIfcBTghnq40CuXGD066rVc/Eo0XmesoduCLad5eyI/zOxIcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781679834; c=relaxed/simple;
	bh=nMa3YAwZItF/5RVvwn/ygVpBzqnCAJgCwQQSo60qd3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKiS3tYfpPvTwbIcT0pwtmGqVEWowGQhzCNMPnVPemhRd9LWxp8qkYmRNf0OtisU/X10IyrcixbcOiwuuCAPIKlDKr+Bs9XUpmBZmV5yYDLqYE8pHNtqS6tEQzyBEByw6JHOpoD8heRLMwHuB8LXBAwrn02NEdBhyGzqoKjCKzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yPOHm6xQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yPOHm6xQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nMa3YAwZItF/5RVvwn/ygVpBzqnCAJgCwQQSo60qd3M=; b=yPOHm6xQA3r0jfZDbmp2Q8rb+f
	XzG/O3aFyGkxf3g6iKvMmzD0JqbtLdItKgtXuMPeQlR6N5As8fnQPo/G+0Bn57nSY3xV9zZEMKxXx
	7EhTzWEa4KTjcduBgkjgXrXErjwMwrv4ai/9nfSrZZsm7mBotlYJfc55yJTujNfLjKXb6vvgepWkF
	zDFmtU3XpfUQT7lAFpBTL05f0OWjwdTh1zMaR/Fr9frUNduAnw8zlHJjkRePIq13f3xGu3ETZLCE4
	3U7NgR2jO8+oFh6mC0FGI3yTXbk1TKkEyxrllQaymCOT7MXyXc9mpwgMGJ/NXE2Kk7gPzWXPlCI0Z
	yumOUoPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZkJT-0000000GmZD-1zJk;
	Wed, 17 Jun 2026 07:03:51 +0000
Date: Wed, 17 Jun 2026 00:03:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <ajJG13-yjnsPixhq@infradead.org>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <ajAJ6lXJWcko4epj@infradead.org>
 <20260615154048.GW6095@frogsfrogsfrogs>
 <ajDeAYs79j4enacm@infradead.org>
 <ajH4WwBqd_uyqQNj@shinmob>
 <ajI9U04nCpf3u3l9@infradead.org>
 <ajJE7uG-FPWnOAH6@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajJE7uG-FPWnOAH6@shinmob>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Thanks, I'll try to prepare a version that does the proper feature
detection.

