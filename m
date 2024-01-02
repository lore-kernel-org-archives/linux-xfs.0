Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63343D313
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jPL0oIIn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qIU7NNrYTYZmYubqAA+1GJQFlLHWQD3ccDcLiym3iSQ=; b=jPL0oIInC5s954KwR/EekLqT4w
	NrFP+N9af2xVLFJgndYiXYAWXr/hBNks2+PNw+rtTM8XuqIHP9SM9rngRuqkdPt3snKoFhHsYe4D/
	Um7l31vZTAd6qSNZP3Czo25HCHyxVfHQZFj71VTpNBvuYfigaluTLdEkz4z3uBTZ9jwRDFtm8sZqH
	MvXM/RiwFkZEG5KAthJ7DbhwZqRHnpQncD3m9608DacobnZ0LEVHFvStIojq5mJ2W7HbWdlSyfERV
	J/JKtw1JuySyvbGDfmC5Zr+cRStQ6koxS+AB3UVn5dDAxSPG1kkUQl2cotiDc16o8NcJ5rPop2khs
	MGkhdOiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcDM-007d5Y-31;
	Tue, 02 Jan 2024 10:41:40 +0000
Date: Tue, 2 Jan 2024 02:41:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: define an in-memory btree for storing refcount
 bag info during repairs
Message-ID: <ZZPoZAb4jd9tvaOi@infradead.org>
References: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
 <170404831037.1749557.13971406924347839328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831037.1749557.13971406924347839328.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:19:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new in-memory btree type so that we can store refcount bag info
> in a much more memory-efficient format.

Can you add a cursory explanation of what 'bag info' is?  It took me
quite a while to figure this out by looking at the refcount_repair.c
file, and future readers or the commit log might be a lot less savy
in finding that information.  The source file could also really use a
comment explaining the bag term and what is actually stored in it.

