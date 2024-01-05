Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30129523E
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hOqlhnOn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hOqlhnOnBE0URw7rj86i8glcaq
	ezhoMjxkGPipAayZZ9AnkKgH6+EQ+p/SaAna0Fx/pGQ9f6tn4HB/+QqNhp6F/MuIqBiw/CVAW97hV
	/F27+8+xxIjEBsI3MtHPNhaoWnjyWwRYckkN9QwN25M+C/g1r8ogt/0eNDdEY081En6j+EfqPS2tF
	cus9ky1mr5Iy34q7BRVbVWMhVSFfC/9MMHL+GQJh86mzQSEiALeMoFkO+cwmCDPqBn9krAOiQ8O5U
	HZw25XjYKMhCZPCywujVJQw4EP2JTlHwzXlnrgB2/46gaiRjVYaj4Oj7IX3uofVqcmWakChA+9Lew
	XbL5W0Jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcOF-00Fwvz-2U;
	Fri, 05 Jan 2024 05:05:03 +0000
Date: Thu, 4 Jan 2024 21:05:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_scrub: remove enum check_outcome
Message-ID: <ZZeN/zv+KkTjGtq1@infradead.org>
References: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
 <170404999891.1798060.18030688801562632472.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999891.1798060.18030688801562632472.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
