Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24111EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944934; cv=none; b=O6k9oihBDeZPF0a3hl2ye3l02fhbrL7okUOI0WC8M4a64EGwy1DwfqR1CZBKJwbTQAHqDEn/Kqq1mSc/P8mk2OyH8k6+ZuIChMKOBdNj3tnvnZUCNXAeB4j6584VtkmeB0gN536hJiFRaSHF8awt47yia05YGDp24OFPvhu0Osg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944934; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dg9O07BUGSpUCaW10S0jYFD/7dllbic77+KtLUFFATsjv5oPQCHdQvei9zjkYONl7WboTqxEb3ZyOprl17H4zojH0vC7otSYwpSlc0R2u1dUTt0lHdn5cj1eiuRgJJEmmZoHeU7e4lCqmcl92DVGKaffHXI7cY0GwThz0kXbF2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mn6u4LFz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mn6u4LFz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mn6u4LFz4d7j1n1RmjKaO6ntCX
	PxNVjTqx1zgAfQ6Kseoz3/CaLd5ygBF48RBDVAz5FcAqIAdb1rfXUc5zgy6H0LbWodZ55JXTTHhlR
	SMn8B5c+/QkymRicGXgb+1RnYoelfxAyM6F+YT28K2P25eF0ICxMxSvX1efNv2ukOsDVpypoDFWTj
	3QKWAuPTPHgiAl7F4FnJvBY/7pcnnSwmYH6TkFQrck+4BLbCaSJu7krobmUfeIMETcv20JCxLFL5U
	EmyKpcxhb0JRGyaGsLa63tXHNrb1f3WzcKeKW+yX0ldGBqD4LwANbe7W4SbK2b/z06bztzL9C26uG
	XkicoNOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW6G-00000007fjK-3WjI;
	Fri, 21 Jun 2024 04:42:12 +0000
Date: Thu, 20 Jun 2024 21:42:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs: separate the icreate logic around INIT_XATTRS
Message-ID: <ZnUEpHemHjOQeHlD@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418155.3183075.2421928430504613482.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418155.3183075.2421928430504613482.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

