Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A06B5250
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AQ3B3YK4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AQ3B3YK42BtMmSVSWnT8l8QhLL
	GkTzAzajt89rb+Cd8vZ8udJW/puxL+TSwfDelatC71WpSVlCbsnstGK6lnRheFT0KxVAnvRl8lEuR
	Kw8F9OOc+i/1866ueqrd0PlQL1eEZlmmjZJPYtIbCRTwUmfKcZqzoU83OnvonyxR7rlkvP0FsIi0U
	eO4JiFoVrzp4NIf1Q0FXNNe+dTchACYOFhMPyVxSTxtOyS1mwissKoH+78xttSzyFNkHJwG8qIGoY
	7o6p8FZx8KPQWSmNCUCdeVCYNac4uL1UID4nnRfp1CvGgaplZv9ivQccQXk3ryowBd/5iOpOWqgLD
	YHScvZbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcGq-00FwaX-3A;
	Fri, 05 Jan 2024 04:57:24 +0000
Date: Thu, 4 Jan 2024 20:57:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_scrub: require primary superblock repairs to
 complete before proceeding
Message-ID: <ZZeMNG7/d2QTXBFR@infradead.org>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
 <170404998726.1797322.10938356067740131087.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404998726.1797322.10938356067740131087.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
