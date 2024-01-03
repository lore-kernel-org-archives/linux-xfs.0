Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4006418036
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 07:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P/Vv/nME"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ndXdtiyEOV2FH6m+NOS7QdXPzMupf7YfHTCXSUUsk8c=; b=P/Vv/nMEgJIXNpgtcDq3MSQ165
	iMS7bjM7ByYUgrHjuRK/jjKu+uzseHsO5XjMnhmqtowo+RTxoR/gjVkFZ2S9JlGubt8lQYd4cWam9
	qukrh69mD5278S8ARHb96OOIbAI7UFKDvawyjgE+UWOUffewPUOJB0jODn5WgiRT2xRNSTSRwgX44
	rpaky54bhr84/C9sP02oEJjPlf4gI803JCkPYmUTPUsVFzw1wZNswaS6E5Um45VxN+GSv/etCicRv
	V/k0PIlZGrWkJkU65ruwokvzP5QDY5D9mDChZtWhvvqEeA53Zd8nY/1KRIp3bNQdgb8fhaPxs+k+t
	uYRz5PPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKvq2-009zqz-2f;
	Wed, 03 Jan 2024 07:38:54 +0000
Date: Tue, 2 Jan 2024 23:38:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: repair file modes by scanning for a dirent
 pointing to us
Message-ID: <ZZUPDv9xQSwXx6by@infradead.org>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
 <170404827036.1747851.13795742426040350228.stgit@frogsfrogsfrogs>
 <ZZPllihxlutug6c9@infradead.org>
 <20240103025019.GM361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103025019.GM361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

With the updated commit message:

Reviewed-by: Christoph Hellwig <hch@lst.de>
