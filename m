Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD0376E0
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389146; cv=none; b=g2vkYbTj0JF2XD4WTbr+qx/OtQQsfZ+J+Z/mwOVFj6IPjXmalW2IGM71rD8SvHrlWJZw0oT4ilk6m8zZWpgELKqZJLxfO3eHVMjmCa74vYcjuHqtjfd4uw1yma3NE255UzoMbXRX/OTF/S9RppDe+waivREW0/BSlS1VHwdZmA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389146; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyNelvp5U7BtbopknDCDCcxGpiu4wqfu5+I0h5cnzXkIEC3sSMvNzpLE2MRs0cHx0raUs/IjXpVuVR9VrVsumm19/ee/D7GDctF3LgTST8OBcyTeOHzHscwjjmTpGpRKbPNjYRDql9ICSIx0rOeEnkuFBzKth5KBG/OX17XIgCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DSl1++FG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DSl1++FG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DSl1++FG9RQ4i1LvVoQtSlYvmj
	1ClowVoUNeV/N6Efxlj7IaYnLLVsCBDz6Ca0oXu3JU+cuHkavCjMsZRwOrX7FxqNOrpOBVkDW+WHy
	Tg3OV6jLOtLggUjDdXzkenUgMW9JetIceLzlV1lutcdU6I56ucgJGbT/AhZJu2Xn/0JFrdR6zymiC
	JBX39kzbGr2L2BXnmeu1fT4/n19NDOo6OxDSkH6t9v+eDJ+A95nlN6kfu3JdrKsjHkFwIg1MuL+Tm
	hVTiUkGQw+nyJb4WIE4NC9k8S0fzdIA2/Oi30HTk0c6RTC+g1T7eePOYgfibiNv7rycROyZ2PsxF6
	xeWr2vkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMO9-0000000FF7N-1gH9;
	Fri, 23 Aug 2024 04:59:05 +0000
Date: Thu, 22 Aug 2024 21:59:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: reduce excessive clamping of maxlen in
 xfs_rtallocate_extent_near
Message-ID: <ZsgXGTjGXmCAllrY@infradead.org>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
 <172437086737.59070.10832733339991521324.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437086737.59070.10832733339991521324.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

