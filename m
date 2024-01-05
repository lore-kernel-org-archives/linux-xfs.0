Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70426524B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zVmvX1Rk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zVmvX1RkF2CKroMX9mFXLvhVTB
	VdApnx7VHUPFB5o86N8vI1Am+vV108ujlbEB//EKB+2qUby37TQt0dcq5j5loWb9pT3L55CranGGO
	UOPh8JLE5+IONZoGckL6uMQ1tnn7uq1VUAVTW1Kse+ViijqOm2b8SEap04MXITxF9AIzKVeAfAlf+
	tL+g86ydaOVZVn70fbc3NqQoNYXkldZkFqJBHJckJDn3YVL9T0i1vYfXfZ06lORZt4MEaT4i5H0bF
	QZRG1P67ZmbjF6lGaEQA2VkQUxJuvJZrdzl7//zVTANBxubM61IWyMiZzFRlqBLiXtAbe0dcU7fFM
	OT6ezOHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcNf-00Fwu0-0X;
	Fri, 05 Jan 2024 05:04:27 +0000
Date: Thu, 4 Jan 2024 21:04:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_scrub: start tracking scrub state in scrub_item
Message-ID: <ZZeN27jdmbLfFoDr@infradead.org>
References: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
 <170404999877.1798060.11854009505263504940.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999877.1798060.11854009505263504940.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
