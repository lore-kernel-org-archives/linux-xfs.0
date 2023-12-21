Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC3C9477
	for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 05:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P/A4Cm+u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P/A4Cm+u9Cl1ByorE0FbpbH4Ia
	xbnk8CFuETFCq3YW2td65/oiKH1vSRdExe5Bzr55p9YzVl2xKuBbBF1jBJKo/0fz2Lqq10iyDWsOV
	Dh/C/VH6vl5Ga1KrYeEP9Pz3n5NCH0qBWlqOiAgIHjn0rySJj5ojbrI3RPaZb7YIxpfkcPcbOWNCm
	LKS/0fmJc253aeHdwxdcaiLuWUz4rBTbzesty9cKVWUAPOF8uwIhI8kr+teDNxa/PHSIdABnki8LJ
	034bV+sFc+12DfofidrTGir7iL8pf1MGcOrBJ+n8CleUUSA6CiJeU2EhgvRcwDiEgCHesMlZcINtw
	3fHLtlqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGBvN-001ls0-2C;
	Thu, 21 Dec 2023 05:48:49 +0000
Date: Wed, 20 Dec 2023 21:48:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_io: collapse trivial helpers
Message-ID: <ZYPRwTJpKdapvmgB@infradead.org>
References: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
 <170309219107.1608142.4643674100831010643.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170309219107.1608142.4643674100831010643.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
