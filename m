Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF07614280
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941961; cv=none; b=UE+cVtNoaCewIz0+8ZWlu/iaquez5SiPwy3kcxPN8I7kIz7aCUHNNEjyA3PPBll85rWk+O6BSdUrjfQisIrKCZz2Xvx2W3NdG6hIPMrNwoAi0xX22DMHUB99SiRAkmFivRK4qXRzX7/fb/kWQ0h8kypa0z5cWNYSRVygJ70RGtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941961; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFak+1CN193P0XCUewY8wsXuIAv8nE9rmH0izHQK+ivsDmkYH1KzEVR6BEW/lmmNimRByF1lIAFZXCzIFoYjtBrEx+xricKJ3I/d3TdWWNWqIVo9m3rVTuWr3PxDOrJbQMj+4w1OUkjs7SIfCqFpvt4WyHmomEcDaHFS0yaaGT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1gOZRNQ2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1gOZRNQ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1gOZRNQ2CCi85PSSNbxzaxgPsK
	MU0+a+ZcptKYTP6U19o+mRaRkmTdRlXfOmoz+V1FEM8DcgGif/d/EAGu+XwAv1nhDtGsi42tkuwM9
	5RuMxRsS3kypDqj8i7Y2feYX8Bu6PA14raKQUJnHQBihKgewfo5oLqtL512Nksz239FfzolxZja9S
	ZD3P+v3jlV9HeF+e18KK0TPJjRlQlfeEY+Q0GncPS9ScV5l7J5QLgqYy6b+Z4zdhP8Viub9FPlXFi
	/16A7kpGTIN5liea6mIBEDXiwzuLLKKzFdxzLRMAz2sCzMlVdq0OVMUJtKv0PZKZK88tfZ/z1YBRu
	wbRZMrjg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reXrz-0000000HXIE-0XPN;
	Mon, 26 Feb 2024 10:05:59 +0000
Date: Mon, 26 Feb 2024 02:05:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix scrub stats file permissions
Message-ID: <Zdxihyt3zzHW8pfI@infradead.org>
References: <20240224060140.GD616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240224060140.GD616564@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

