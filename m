Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uPwjElpC"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D880D5E
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uPwjElpCG0cvBOS1tUkSEdDrHU
	PoSfwORHIK3nM/UFxE1hOklDJSBzbRR2LCtTfv+b7LbvX6FkCajuFG1gklHyiOyETUjfeZ7Iyf9Sv
	Qvf6FaKxRujwGa1A5MCTKZnHYPgQibiYNoKgisA6I/LjZEM7B94xnVeOjD+mmIcdxWOw6VhGhhLiO
	r/gXN9kqBD9lt1L/H8Gmk29u/YmfNe0pyPD9nAchzO+Skd9bDLvRidQG+CJfFXD4lGRj3peuoVVN6
	YgQQNfJJ/8dqJX888HeY3eHCs//9IJU5Bh7rMQQf4dZzWc0mPK4Uda3jCWlErDsi430ELvE8JxeRT
	93ham4zg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63Gs-003uri-1J;
	Thu, 23 Nov 2023 06:33:06 +0000
Date: Wed, 22 Nov 2023 22:33:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_scrub: try to use XFS_SCRUB_IFLAG_FORCE_REBUILD
Message-ID: <ZV7yIkNwEkiZ0OJI@infradead.org>
References: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
 <170069448598.1867812.14219015115936264152.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069448598.1867812.14219015115936264152.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
