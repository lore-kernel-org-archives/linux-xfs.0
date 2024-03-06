Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A3A605DC
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709728525; cv=none; b=LsdfPAnH+Wf+uVNGxE00OyJnVqX/PxO7Vehuusamhtb+kffIfvwV0ur15tqHY3aUrPJ7dsDAxd52mZfRJBi3GXmnBZLJIHKiDsJIwaxKyQ8KujQ2SQWORowqCQiKBHN9urGrDEFm4BH+jiyxyljEpoFTlEdQu66uVwKNlkH8aZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709728525; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2ijMzLNnIl50wC7rn25bycL9qQiCpQq4nC+DlREDzP7qdkIDd/J4Dw7rH33UcUizNsnvF2eol0oRUBvh/i8Oy8kFvuhF/Ko/8eUXPYOljgmkDu0kXTVeg391ljuWohnDCgOuUN3kLwzBoHmKg9zX6t528WcoxlzUFxkiFQ0DbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KgHNJokC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KgHNJokC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KgHNJokCy/GUf60W3jTXPQHGwU
	ShIzTtAC65fvIUK/2u5JXk1LVSOUDBqPq+QjhYKjxz8h3Nmv0GNCLi/d+VzK2j1Q6Gg+C+WAIpnPQ
	7oS4/kmZ3+Cv1eHZRTvtDSt2IPGw3g9TeIoexaJg6rdELFHUyg2EwYaYXtf2WHH1CVAtYdeUFoiTk
	YfKPlfxDSqakLm5iJ1CRNrcggTxasqqxF2fbUoxZ6FP3fZ/J5iKTOrTxy1nJAc+13ZL9Z8ap8+roL
	agn/mp8M3wcCirFs65+3xtbSzfBwFi432lb5EAqoKluuqFs1Ktj/Ol+l/ysT8jlGvOR+FiLU2GQGk
	0/MI2Vpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhqUW-00000000DUm-0IaA;
	Wed, 06 Mar 2024 12:35:24 +0000
Date: Wed, 6 Mar 2024 04:35:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH] xfs: shrink failure needs to hold AGI buffer
Message-ID: <ZehjDCvwhLe6xgNy@infradead.org>
References: <20240306011246.1631906-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306011246.1631906-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
