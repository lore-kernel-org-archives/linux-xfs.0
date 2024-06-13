Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A558814A62B
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718303829; cv=none; b=UA3bmp8HzVTkv9cPUUnSBXrUQcdSMyCGNlwCM7BYVs28YIKbwWyIQjz8CRaosGbu93Bx2el5mjKV/8wlDys8cYuJXykaC00WhEYGM48+ylu44yiEn1B2ts/j0qlD2ROPItuV5AmJop+VydCFc5LV5F9493mGbTRbQjlomLbZy8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718303829; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yxh2LAxYDC2FuU7Ies3MLCfzidagyiaaXRz6dfwwONn62G1Oo3dL5fqp9GXGauWbC/MkGcGQFS5vehZWZygFfdXX/GAz3sk+chJktNt+wFb2tWNzk60F2ot10Bxe//nU8wc1e1MTOlkQrA7sKtckYDzXkx31pRgjK1VzVcir7PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qaW+ixiw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qaW+ixiw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qaW+ixiwVtRpaZ7KskYj/9Hgbz
	pQeXezgO52Do+i7cG6+uk418MpTSyvlagwAAneMGuMwKxsCQZp3vswgRIeNWyV8/dfod3x8m93OdP
	O48JsU7epT3IQIO6N/RkxH+DiKD64ox00vOuooUyKVqMicFqDY6Qon6grBqbAKJ0b+pWy/9fK5a6A
	Q72YqN0lupE/RFW2ax16y3yfmU/gTTMt4SrgGfwM7BkQvkS0O+2DcIhloWYv0wOYUcGxFbJAuQMBt
	dboukvF02zsFrVyHjQjsbWrhgzHHrOEKJNq19lo9CiaoTUtc1iOOy5aIHnwn7oH2yaJQVSXc37vv+
	Gupnvsbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHpJr-000000007zd-1LAS;
	Thu, 13 Jun 2024 18:37:07 +0000
Date: Thu, 13 Jun 2024 11:37:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH 3/4] xfs_fsr: correct type in fsrprintf() call
Message-ID: <Zms8U1DpwLe5SPBm@infradead.org>
References: <20240613181745.1052423-1-bodonnel@redhat.com>
 <20240613181745.1052423-4-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613181745.1052423-4-bodonnel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

