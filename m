Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8488A3B47CA;
	Wed,  1 Jul 2026 10:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903411; cv=none; b=i5d7mBZOULMWBaMrMPvg12AehXf15C6nwdorObdb11xWCq0p3Mz/JZAkCLlRUYMe7M7c7CHsG/Ec+SYm0nOSTRUDTgBwUEbS9xXs1WxfrbiEk9wWw6JT2njEGW/dTH6X0SMdSF2fxJHVjaQXqwMJllcf30BH6i3h/xg9q/zbX4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903411; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ncbiHoYDRsVtAuJw25Wc12yUWCdaB52TMLFw+gcTVunaVj9j+xbTozNn/hXM0PBq6T/+TtFs8PGZ4YGYtIdOcwCiX7gjiv1IoAD6X+AuKbpAHQRiJuMYm06chZSY8g9Wj6JDfi5+00E7wTNijIqAuOSCStFl/AjXCu9XG8L+HRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tWrUxdPf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tWrUxdPf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tWrUxdPfeS/leZsFdso2gHAQ8z
	CrkJIYcE/DpkJVvxoH5p59TgmxIA/fmnHyC/qXbv1fWuXyBYnr+W5hUKb2BDGWT24vu3gv+G81IvG
	DNpxh5bFOu30qHk3cjQnfAd4HYq0u+QZaI/om83WOodxP+j+iwfgHx1OZ3YdQ3+wQmMFrtzB6LEu8
	+p9ReiRmSVoH0CaHESZkyVx6VsjaEeMYYT5FjcxbfIa7kzzqF3vhMok/UIhQlAXq1lzm6/faAS57p
	+tOQ210QX2POUaBhQzj7v/AkgcsFWccS7pk5kSCNIeQ8UPrK+F2qjR7m41sOHxRSv79rVs0kmqIGv
	dzugLtuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wescX-00000001Nmg-0yFG;
	Wed, 01 Jul 2026 10:56:45 +0000
Date: Wed, 1 Jul 2026 03:56:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yousef Alhouseen <alhouseenyousef@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] xfs: use null daddr for unset first bad log block
Message-ID: <akTybVPbqATq8-Oj@infradead.org>
References: <20260630100607.7150-1-alhouseenyousef@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630100607.7150-1-alhouseenyousef@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

