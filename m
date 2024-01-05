Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825BB538B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QiF6btfN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QiF6btfNHwTgu7T/PK/DJ0eGLM
	2H8HehV8HmVcYSzyQqW2auiKulh15Ts9pJJWpWw4HGodUWI3umJV0OfFpVU/GWBt6NQtrvhgdkU2D
	MPLM5dK1cRJCUYgS7CvTSwHcOSRvvk31KCpogkrUYwydMjYmyeOhFCMnIvW1Ch8HXzmiQYW0Q5mVV
	eltOLgw8LRB/pX9oe2xu3GHQzfc47iOUunmvNJqkfCUyUomuC6nJUwUzE865LdL++z/fLFlLKoKJK
	SHOB8SSnMgFKKjcNE5eAfRtNSQv0MIfMOqgQxrZfuV/D/HLMoRpR3SJh8wZGF9keB2wAgB4EMTepO
	sA4vyrOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcT2-00FxZj-0r;
	Fri, 05 Jan 2024 05:10:00 +0000
Date: Thu, 4 Jan 2024 21:10:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs_scrub_fail: advise recipients not to reply
Message-ID: <ZZePKCSiykE8KwZ9@infradead.org>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
 <170405001937.1800712.9925405322044646768.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170405001937.1800712.9925405322044646768.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
