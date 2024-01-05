Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F0E53A2
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eh5+XCbv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eh5+XCbvwGNm6mpBux+LQgUwnK
	sBjRG2qDVTMKh0MZdrxjCsODYyoalDVG06S8PAalQ1lsUL6P/xmHpictI9mASYFhScMqjASi9uC6G
	TfCSvc2qXv4YL5hmiuMBFGgsTyy376keWrdQF0U23EwuIzriAAwKHVf3iJv000/s0E/XX6ptSRn4c
	Vnl0NsBfhvMax3PCcp95yob7nQaFVeya2L36SLrbtjnEE1Jl5SXH2kcbEoiSGeauJuomGztE79UES
	X/UgLYLbiO6o6rdUJpjFlpL4rPtsVXY2ztZUDsi8N2TSCIzZBdmfMJErP+mk+CBniiRYJh/hxiFSO
	X/sYNP8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcwz-00G03Y-0F;
	Fri, 05 Jan 2024 05:40:57 +0000
Date: Thu, 4 Jan 2024 21:40:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: teach scrub to check file nlinks
Message-ID: <ZZeWado0FgBxXoU/@infradead.org>
References: <170404827820.1748178.11128292961813747066.stgit@frogsfrogsfrogs>
 <170404827862.1748178.9928565011228382272.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827862.1748178.9928565011228382272.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
