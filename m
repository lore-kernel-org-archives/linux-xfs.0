Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A05A5243
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="knb4Mgcw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=knb4MgcwLI/3WF2N76umb+mCyt
	48roPQ0n9b7esvAzpymnzj1GfvQuwL/4rc8tPY1k16J9XYZ+UoBe6LWFvLgiSMhPCD4MaucuV4FV/
	es4f1eeeXIxOCYJAd1zdX94LhKGpL6eArPIxtc1TTmMY9hWC4hGOb0UzaEhGoXkoAqP7ii8ij2EAZ
	/n/QD4o2R4in65sxoX8AKyWV8W+HX6S1575M0dclAnWEeSgZDb/4A/1HQKYDUlkShXSZYDYV9BMHP
	YggMFSUo/flXvVeMcfJRo+B298rihn9KMxVPhyJA3gdbXjkT8IQ1bOQnG94kQupH5IoWQ0Hx9ECzT
	T0gGAnTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcMs-00FwsF-0h;
	Fri, 05 Jan 2024 05:03:38 +0000
Date: Thu, 4 Jan 2024 21:03:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs_scrub: check dependencies of a scrub type before
 repairing
Message-ID: <ZZeNqnn/cDIp+qMV@infradead.org>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
 <170404999539.1797790.7472502131864497541.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999539.1797790.7472502131864497541.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
