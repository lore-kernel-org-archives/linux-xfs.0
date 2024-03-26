Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189C1B7E4
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432539; cv=none; b=rHaCE9ZyUAmeVjDPbQU1j/13YlGAf4MQSg3vOtWIB84nlPa3OOu5JPg7IpJjiIXM+pCeZXsuPj27WL7SP6kcVVG8ujUfnEu8yAJSbi0sBXbdTZZyH6wLlDiOb5EIyesn32FL1I/mP9yWwdi1S0niLfKMZC9QsJ+JItfDj0IzFGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432539; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ch14WhEiLl+iykLCDzkDGz659fYGFm/Fm3Eqau9hn99f1o2FljAjmWqAK/FT1ju3xg71yCl3vRXKpSZu74jTmmPFrRJvfGhRqF++x1BCPHDZ73Zr4DT3fRrvM2G2ZjjsmeK6X7Sqy6iuwCrWWAvjf6hg1Zgxu08AegG2NZeZMCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=skwVB6pL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="skwVB6pL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=skwVB6pLoeG0o10gRmroTk8wGp
	590zUPqGhGrSHRaquKTX1RKXr44H0F+3h9vkfTCdWWWy8PDe9vHqG59LLSyczcIzPlFPwALSNuMos
	ARfdZY1MDIkZsv+njDSsNf4qksIL/mPorv//FjDIYojRHfmpEN8qZxvRKAzn4tVNsCQOxdqegA7T5
	MPkwxMbprh/qE9QjKRVm4dJOwoD88GKecVCUBfJr5OsqZWiakyDixD0cl0N2bRlzCg1VH/0MW8j6p
	iTlySv1Rf2h5CXhMClSjlKa/DBg2L8N33uf/760TKvjZ7TsWJsvudQMWf2DgHcsX7guDbRgtWvY+X
	l5sYNFTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozmc-00000003Bte-08Fd;
	Tue, 26 Mar 2024 05:55:38 +0000
Date: Mon, 25 Mar 2024 22:55:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_repair: reduce rmap bag memory usage when
 creating refcounts
Message-ID: <ZgJjWdFAGR-nKut1@infradead.org>
References: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
 <171142134736.2220026.1392869335782730880.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134736.2220026.1392869335782730880.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
