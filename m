Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BAE5243
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SHMlCuso"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SHMlCusozefGw+ocpyX/ynaKuJ
	OXPgPh5jWVu2D2ckkFiTkPGL1b6tOwT6l3TNTweVpvLdFZO9Xk1+SnIIsiMtpWsgNwGDBqLHVVfSQ
	UXWcKugEKFb7G8MA67t2GTdxyE6LWIYWbzrYR05xF5XAdZivTwJeQX/bRkSu/fNthkjyIwyB4qN5T
	pQxwldtQhrVXovHzkRYFUashJ0cifEE4GkujP6F+/IAAZMTHnNciBp51nHbQFpeziP/48nCjFeCbW
	L/7wSeR3E7Kx818Y8cIJ4843/a0xCfKGsOw+lByflq1Sva94hwXIhxBvNZJ2HeaQPNrLfUoO7QD9E
	i7AKOInA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcLh-00FwoI-2v;
	Fri, 05 Jan 2024 05:02:25 +0000
Date: Thu, 4 Jan 2024 21:02:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs_scrub: remove scrub_metadata_file
Message-ID: <ZZeNYUs8JVGk5nyp@infradead.org>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
 <170404999499.1797790.4054299004240774717.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999499.1797790.4054299004240774717.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
