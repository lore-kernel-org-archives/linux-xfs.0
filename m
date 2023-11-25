Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XMPKOIWY"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD92CE0
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XMPKOIWYTG7PUtE9TF6ni5FTJq
	uIOKd3+wZNQICMzqfW8r6EgpMqhgRA7DBh/BSxOi1/YKZNTGbohiFvk75YDqjnXhNo3K5QmZ84LNk
	3fATmDUXZ6MyjF9gE3pG9WOlucdy9I1Lv1r9RBNpiIuy4PH78aL6AN0wc+/gp3/zu7mdjAdbXcy0T
	GQyFv9kVIB5bP4V1k0Ci6VEiELneYkW6Ye168FeB7U7mRYptzVRpERtBjNieuyJiWtZKMe+Dm/FbT
	PZHB50DoLsLdkrapUc9wALo80Z/WC0UMRgp40WbewQfLXvTKwBdDnr3sj1knM+I3T3verx8p+YLML
	nzo9t34g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6ks7-008a8a-1v;
	Sat, 25 Nov 2023 05:06:27 +0000
Date: Fri, 24 Nov 2023 21:06:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: automatic freeing of freshly allocated
 unwritten space
Message-ID: <ZWGA04BwpkKBu7/V@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926192.2768790.6648304136876480355.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926192.2768790.6648304136876480355.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

