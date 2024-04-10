Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE15810A13
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729962; cv=none; b=Hl7t2i5Tp968a6OyK/emedb4guT0vN0qsRQ9uEDwHXOxSJsY255C8WkyYtWfFo+l0dwiAws3RzNmjgbkBHBnQmUrUGz8s5SoNplOaaZ0s0bKUiOSNSblaV8HkuHr8vCAWRvO0lB7Eu8Otq9aw1JSGw5vzdwIMvtCUj+Y4gAKFbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729962; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQpHVJ9YQcHECi96tDGXfDB5SIhNgKMG4kNTh/fGnx3HOglEiapMmNYq4Fgva3MA1DYAXtBx7XYK+msY9krDSNKP116R+lwWxo8ipt6vuQgQKMYGyZLQR/TiGjORg500Znei7qrVK6D7IjUoaxuTulpanZpaogkjGzsiXHrkBps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YIk0XFkQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YIk0XFkQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YIk0XFkQdb6T1EeIGKqf/BxVkz
	0mg6OYuas4xYSKTq5m4GxLaxB2DTVrKGX21n9lCUR+2DVgIAlb05ZFI4dKyJzfxpmxjLqMA11E2Ds
	Y92TCku6Icf2oZI6AZGD4ZVkJIMDBKJ6Jh967mN2fPRg7pHNQH+ox/KtWwFXBD6LqCu5OR9TD8CxP
	cg0qcYD9qSC65wj+JqonL6ZNaM3VbHtzTR5uny62MX2VpYjM6L+nj3PJXAQWY9HaQp74wS06cXfwH
	CRpXQIHU7EejIOJ8mRz3y/7lb8wSzujEs06rBlexW862tz5Er/1UMeeZ9zTkSrxOXLM4qr88CjNC3
	S0MT+j4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRIm-00000005LuJ-29zH;
	Wed, 10 Apr 2024 06:19:20 +0000
Date: Tue, 9 Apr 2024 23:19:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/14] xfs: implement live updates for directory repairs
Message-ID: <ZhYvaAJ7LgXKV5nA@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971054.3632937.16105709238262852876.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971054.3632937.16105709238262852876.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

