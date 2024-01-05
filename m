Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3091DDD8
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3kFdpFly"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3kFdpFlykY0PIjKi8WNMq7oZcQ
	ucTPyCtP0ZxtVp5b567M8dJkKFDk/GIIaApJqJQgorET4enGFyCK5C0i5yD8wZpRYGh9MCGk6fFfx
	9F68bY3oGeJm/mk1/rEKfWlfgXcHLfn5oWqQWG/F6w/3zOH8gBCvTX0n+F4GFLUeR7cSUyI5A3G0k
	cg3PBX18MvNuQt+PfWh3lucMS5AKt0LlyxEzgBP34hTbfCx/NTo1HxovTy1UFpR4rXA0hMB1IMW9n
	wXeBZwQ4qn5BX348wN1OjstbQDhVvOVcLRUQHTlt9KoFwKYu0gyQe3LhxhqWFUQthDWGgU+NbdmgL
	mNyhMhOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcyH-00G0Bu-0n;
	Fri, 05 Jan 2024 05:42:17 +0000
Date: Thu, 4 Jan 2024 21:42:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: teach repair to fix file nlinks
Message-ID: <ZZeWubkjQHNXi2k3@infradead.org>
References: <170404827820.1748178.11128292961813747066.stgit@frogsfrogsfrogs>
 <170404827896.1748178.5615067505170676300.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827896.1748178.5615067505170676300.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

