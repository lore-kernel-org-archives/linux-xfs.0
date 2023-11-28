Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p5b7sBOq"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE438D4B
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 08:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g9CRSUUFqCI2aWKDlk9WPt4NleCS80rqVnN/CaaJkdw=; b=p5b7sBOqSzPlkW3o64aaMZlYT5
	d7gUDclFdUc9mNS1kA0mkJ2PzwS072kTMbLcfM8GhwH3aKBBCPPi/zWwofA6fvDUXTZEtRAxWIS3S
	k7wjtWOVU8v1a8F1emhxmdU1wVQf0RlTnckO3n/oaZEb9zXjXBtxYYOkUH2T13T+4LrRzxHqVFFAK
	i+HMwIYDqDN4Ae58DJHo4iShzQ8eVyfWUgdzOYhzecaCFD7es7P/x5uCP69Ugu1H4vPJil+wXdl64
	uygiGIGbu2QMi+1huS5o+ubxV+lNfhuZpzSOu0wWA6FZCLr0KPEz+sdix11cqt0yLl592PN6YbbZt
	9lesU5XQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r80cD-005mCT-0B;
	Tue, 28 Nov 2023 16:07:13 +0000
Date: Tue, 28 Nov 2023 08:07:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair refcount btrees
Message-ID: <ZWYQMWojr7rDEWtT@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927076.2770967.7087594594339344950.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927076.2770967.7087594594339344950.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Besides all the nitpicks that are the same as for the previous two
patches, this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
