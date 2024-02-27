Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FA13D68;
	Tue, 27 Feb 2024 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045577; cv=none; b=jnqNSkGTzMWBv1qN4eczKFS+XzGSCnKOJUn+LzV6XCR4ApjR/Rq9sbO4oaVjOtfwzYusVqwEvwSsBlGLplFn6v1i7w70muCRbXnU+9hObyf1aNv1zz67/Dr51pN+mKilK4ECzV8ZPiatKcCv+BN8hNcHbuY3Dpv2aRDIWL3rCn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045577; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0TivrvNWA0gozqUhHwzKE6iQ29SLMVQ4O1Ndy05dQVndIUUzK9519YVlIFbB5AsAqEEbAD4EobP9L3m0sacWU7s5rUMs+Tiav5BKJksTDcwDY2i9w3NR93ZSrTmWfiZiRhefBgi9gkEIjoA7fYik9Ye6hy3NHjVx/aWGbSgG7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tdtAHaQf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tdtAHaQf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tdtAHaQfdsd55gZneygjyBCTkR
	ox1llmTUqqUoSUpiZne1yKNgkZdZn8ItMMzw/LChJDqk9MdWTaz0hczyDUSFAQPm3PXb9zcw/OBB9
	1kzKRLh9FIdJ8JgaH7WN5ZHhTU+m23agmMragp/qnUd8pYL00Xg9fkE8fKzoEgwIc1sMY9Q8Qa8NN
	WZlMk8US6e59a4MID9GtZS7D7klzOkmBiU2LM2YBPm3jOP8sLChXuyJAGsuQlJHew9+v0JIoAbLKS
	Q+JKuZEjMeZM6baPEKzRuKZzEFVzPw0yu3itFZAwFriztQw02wxBjjqo3CrZ2+X4Zd1kg6EQNhlfM
	NnkHs/qQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reypC-00000005ecn-3bBO;
	Tue, 27 Feb 2024 14:52:54 +0000
Date: Tue, 27 Feb 2024 06:52:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, guan@eryu.me,
	fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 2/8] xfs/155: fail the test if xfs_repair hangs for
 too long
Message-ID: <Zd33RotpdZJwxxET@infradead.org>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915247.896550.12193016117687961302.stgit@frogsfrogsfrogs>
 <20240227044100.GU616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227044100.GU616564@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
