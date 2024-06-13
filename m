Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B45143C75
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 13:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718285715; cv=none; b=Dn749P4OpMeVCPnIkTRcZYjzpxEBOetWUnP9ukh5Lb4pqcQBGrFmnoV+1F/tm+NfG69WC1qkZjL/4Zc9ELq8s80MMrkCUxhPaEaUt2l4orwpD+4QXMfUW1ZaT7mkSaOFLSKfySwqJUwHHlyRelpd7bXJZBAnIUmBjcVauM1x0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718285715; c=relaxed/simple;
	bh=bGxLaSAl8uVGqqAOKj9zNRQm5SW/UKde37q0YvK0iFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AiHiU9u47altkuL2bRAAqbpEgKOzAFAYDPGtT55WxB2OyHpx3lqKJ9UmBJhnMJj75xijCDfZHLCXlbX/kKQBBwBXlla1DalDAfNqzC7zBnhmkwxx0h8l3h+qrS8JZKunWJiGS+xaq1hQlouLiQU+dWVIiEUkHXs2giDj+1rzuJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lee1mN71; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lee1mN71"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bGxLaSAl8uVGqqAOKj9zNRQm5SW/UKde37q0YvK0iFA=; b=Lee1mN71L/vz6GB/owcJr3Go5Y
	nWAGbMIkPC5G0X2tvcxPBupg/Jdbo61j0RAvIqhmM1YTtl+YVLx14F7escbqQHqZMxk9CUzXxspDP
	qOKrifkT8KquZedx1K560anabto7MBjDqjQOGV/loOWqhgxBMo+nWQE4WbkAdblln0AvnOq9sM+C5
	Kk/6xFlMLrnospwF2Ms07y+1ezYL7j8ibN7ePnktNBiSrNtR3zdHE4ELCLoPYwtC+wWTxjGCRL497
	cHNtoG+brKwtHADT81lmnEB83kYyzoCUFKcw6HhoRNjPZthLbp2ah3giiGScEilLZ6q/IwhzyhV/Q
	gTz+rJcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHkbf-0000000GkhA-2xW6;
	Thu, 13 Jun 2024 13:35:11 +0000
Date: Thu, 13 Jun 2024 06:35:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix unlink vs cluster buffer instantiation race
Message-ID: <Zmr1j7bRXDjM2o8R@infradead.org>
References: <20240612225148.3989713-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612225148.3989713-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This also fixes the reports when running generic/251 that I reported
last September:

Reviewed-by: Christoph Hellwig <hch@lst.de>

