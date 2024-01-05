Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429CD5396
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZFp5tzMC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LPxkje2NqEUTLs9c2ater6iMdecLq6B94u5y4ODKjyU=; b=ZFp5tzMCTel74g2LxjXguUsf6s
	CZTJ7HB9mVD/N0mUmlomsGnNkJOjmdd8PIMAH+inZwGQlHdZz45W1C8dNIo8ZIBN+5r/6Ubsyc4b/
	9MnnbM1DebJbs6sG4Iba/kSm2rLhFXEq55XIBK9nDdAyyDZJNBA73utun/BItq9iipmHClDObq3zk
	JcVye3TL0e7rZ3ij5TDUwwOefb9XdSJbnYp2VudkdMm9EoZPq5jLFDFhJbX9Ydxgozhcndpjm97EB
	D3jdVjROQYlDsp0eCL5FZKSovCdQE4HpsYX4xLXVsxxy7PGYlB/Ns5fZ2Wdjp8bC1w+VmLAXRloGx
	mNFyJoKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcTy-00Fxe7-1K;
	Fri, 05 Jan 2024 05:10:58 +0000
Date: Thu, 4 Jan 2024 21:10:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Neal Gompa <neal@gompa.dev>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_scrub_fail: move executable script to
 /usr/libexec
Message-ID: <ZZePYkMKSgKbvQjp@infradead.org>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
 <170405001950.1800712.15718005791386216226.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170405001950.1800712.15718005791386216226.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Oh, libexec is back, that gives me strong 4.4-BSD vibes..

Reviewed-by: Christoph Hellwig <hch@lst.de>

