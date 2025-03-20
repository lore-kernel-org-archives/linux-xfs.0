Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0120819;
	Thu, 20 Mar 2025 07:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742454304; cv=none; b=nUSHgcsRJQH06hTsYePO8pSRKjX7Drq0Z4LjbFgdzdy4PTsEHnUBvS5tknHEnx6wVq2UPOayRkauAbY6nMYGrQsl0XkNrXA4XEPNqLijk9DvaRe6EYLuQT1QuDZaGWmIGa2CTe8XOhwMDZkNZdWbJKc04JwH9AJsnEa7xrS/wk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742454304; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBnoJ/l0Cgcb1rt8GNz9/q9ha0okLXCGZ+G95cE3J9BBgKt5K0eituUQkpp2aTRVNX+I0ViliSJ5+vgiacQpymuBLLsXmQVDHtJJzyn9tFvXxu/bBT8GmsbiLBpM9NXbiHSgdzIWndzB4kCdDT0zP/g434cf6sdGV70t4pHnZ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1CEqFZfE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1CEqFZfE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1CEqFZfE4A1fmQbfWanYAyA6Bp
	4iXh8zCGp4GB3lKMD30kT6XMVyPhBqQuzVefmkTmC6ZTVC2+YMmlMLyboBIMhY8oGI2RtlHVJl387
	G5SOZoTr2PQIrVc4HGWQHDWMc5HS45/6giDF77Ad4CSkCb8n6GOpXNdeq0qV0Hsa3QMxTkDpTo/u5
	eq+edP/YIMwNIFlX7ig/7b1tC4Ldy9bDv0iKRsuZh80fPiVkdt1nm+1xaCRKbZS9kanoasoQTy2cd
	SOo9Ukp6Z6nBiR0bWgYwiAIcaG8Uv2oy2moM4eL0akDzt8LFsLBZGcQo4JcGLUb0xz0pPbUgxcwar
	juahsmOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tv9xd-0000000BMgM-41zE;
	Thu, 20 Mar 2025 07:05:01 +0000
Date: Thu, 20 Mar 2025 00:05:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: cem@kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove duplicate xfs_rtbitmap.h header
Message-ID: <Z9u-Hf6VookA4-7r@infradead.org>
References: <20250319034806.3812673-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319034806.3812673-1-nichen@iscas.ac.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

