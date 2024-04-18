Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F9F1E48B
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414428; cv=none; b=bVdyi+hNhfCZfoC2yVvESVqFENq3RXNxnUhApxwT4ibyVXy9/L00rgW0UYxJQp4XLO3C1HdnurfRfr27UlR55+pAx3zq/wrBKhnu2N8iRk1vKm/UFzof5NY+StEIQGWJVaPQ8mtycx/Gv3tLDze5vR6QEs2MMBpyjBJAdQsMmDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414428; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8gbmAd9rO1yxdBifenOMa4/jLffMBQ99IEeDJ1qkDT+NNpHt75quEQq8QVY4fYU3tVCdiOWYd06fLgBSJbBBcOxkOMaeBbkqq4RhLj/5t/yng6Ze941/Twz0Np3KGyEn3LX4Vq6XMTuk+ZK8oqWMpH+W0Rb6PbsC/3wW/N+4H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c1DG/jeQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c1DG/jeQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=c1DG/jeQaShO7NeYqHW14ZGJ5f
	jMAuYasIyD1GSr+a23JryTpDfU6iD6t0cqs83i6ZqSc5vggVjUk3ML2EEuoLVzNXBufw4n/xzzS7Z
	qUmuWMf/foxZwHnp7E/eYuwDzHqNU+KfXMGFLxMlaPRyRpKQckYkkJ0tWNKiklRDrv9x8TmWPKDDN
	F0FFNmDpTmME9fG+NXlRb/OiH6RKroXNkEwUOCTK5r1qacSMRyYWM8I81Iw3NPyPkCaFzU2sMOg83
	1Qzf9OPTJ18odEF/rOm8ejg93GXWMUfQNBcpeXZMLzJ9dsyAWOvRGCY7eXBm2DcVQ1MXXSd3nio2n
	OUKWyfHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJMZ-00000000tku-01wM;
	Thu, 18 Apr 2024 04:27:07 +0000
Date: Wed, 17 Apr 2024 21:27:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v4 4/4] xfs_fsr: convert fsrallfs to use time_t instead
 of int
Message-ID: <ZiChGiGMgtjmezK3@infradead.org>
References: <20240417161646.963612-1-aalbersh@redhat.com>
 <20240417161646.963612-5-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417161646.963612-5-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

