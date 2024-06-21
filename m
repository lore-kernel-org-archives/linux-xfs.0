Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791D5EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945572; cv=none; b=mRRvzyxVMjQIJh5EDfNY9FgFzcCgjmkwxDOUKS1D/WMWdVjgNngcQ5XqPvjuCeijdDGtkWTeYkWgMNL6F6iQzvOLTWN4JVaXz3beYTIYDlE2+KCbOhYhi82+TvlSXvnqM/UJ1LpJkGX8Xb8haUheIesQWCk36RriNAi8iSqV0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945572; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/SXXka575mG2LTm0Xxp8uQeSu7EG7xL5orHsgHPb0HcYwK0kvdxJQUWTZPvbXhPP75yMEDo7WLnkMjsqAywtS6KapgyI/+6g632VYCaCQ018aWdGZBcv0UZXNAsM+n2vs1cBcsq80RRgLp3Nd1vx41iyuseqxyvrmyMSwYPnWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zYCa7vZq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zYCa7vZq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zYCa7vZqyx7GgbE814Pa17So0K
	Ha/yysnUqBHzQKtl7wUn3CUa6uEANXdYFV/2EaMkoJW/eeEMaUB2UzYzPI/U826Du6cWcOGHai0tO
	OcD3CAse2ntCjllWODia7pgw/2rRlGWFfY4r8bqGTZaKSnBT1/1EFe7G7SOFs1bIhRSylFoBW23ZZ
	xMVXcgHa74JBRDvOoo9P9QY0CyznOfb/1QUDpeQBRUAwJWWvR/W72Uj9zMOmXpZfhqHG+m257dxde
	DXmdfBWfIUM4XXTRQBQ41UXY870CdG066Fjg3+65P5i4ZwO/0J154CXRk2W6pG+5hPrhwsJkx8FNP
	6xURD6Og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWGZ-00000007gs2-0Yow;
	Fri, 21 Jun 2024 04:52:51 +0000
Date: Thu, 20 Jun 2024 21:52:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: clean up refcount log intent item tracepoint
 callsites
Message-ID: <ZnUHI1uPO0mFofE9@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419841.3184748.9309858987645162456.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419841.3184748.9309858987645162456.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

