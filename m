Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85A814000
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708671121; cv=none; b=uLp/Q3xE54pNXnMcPQGw7H9iBMCw4wCNHK11FBgtf22Sy8E6QlhiJlpMkh3DMS52hr/whzCo/tueDO9EOHvBTOXhrfrMBI72Xkulzz8v2MwTIdcS4Rs+4mk67OSrsGxLlKOy1gSR3trqkVCqphLE3YZ7s77nSZEnZ3rudZlcVNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708671121; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTvSLuxBi57o9HHHZnKKsgdk5bj1U+LwoFZgX6+DUQPo2OT9PRD3RaS5nPZ3snt6DXfbfd1EC+Gllwbq8VUc/9s6C4WnDyqmI09gLNQkCAtZVHCHLvDEQkzbk17TDgmqmEO36HpyiY10CnXaShGHBVjL9PAeGS1tqV+WpN5tMBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M26CGCb1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M26CGCb1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=M26CGCb1LSwoeXOaYTElqHYaIb
	Z7oYO/uSz6GPJeUyVxPMEi6a6GX+FmApEsgb3uMYCRHEZwE926/qTfsiuIfikUQ6adr7yEGWKKfZ8
	h+Hgjqc7YrnLQA/QWMLvWPbHClUWkqrqrgwvX7RXRd5kOsPO6touXBTfULdNWCG1kcVDtBQ5sMREs
	Edy5vHsOZ2rdQrUeocbz7ItNunlBlFmHfqKg2X6qu41Wk86WMEsMRYlP9feDaTPu1/labMaFHdZWb
	rAEZNauXcodBcpiNlonV1ziBvrQIu7dHwT4j0Go4MUHt4BaavNZgkhSZYvDH8ZcLXXpbC0dWg2T17
	mD2Y3+Xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPPT-00000008Dk9-0siM;
	Fri, 23 Feb 2024 06:51:53 +0000
Date: Thu, 22 Feb 2024 22:51:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: don't use current->journal_info
Message-ID: <ZdhAh7P0tqftGmJN@infradead.org>
References: <20240221224723.112913-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221224723.112913-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
