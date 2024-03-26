Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C7A1B7E4
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432517; cv=none; b=b8sz9BZ53Bab1jFf2UiiEu70DzcLOBdc0OzHfzjFJ7EEnABMTxClh6ybs26IThlpf+gwDZqbpznXP7ihaEmR9H+vSVOZFG7Mmn+HIundjipblMcsyQtOEnVR9FxlT7utQlVq8Hjj3+T/wCTt1XirxDkmLClpibvWEheB7yVHM+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432517; c=relaxed/simple;
	bh=RtIw/c1T3V/3KMM9ZMOh+/6XXPFTZANs65TpbgwrOV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pd9eMsRMFHfp70CudiF+vIcC2qOyPZy8i8fdbycpDY7YhUquCfNhvJVUl21BvajsQHrSsYk29yCm3d+mBRRAqJ2PnUN9g+1w0toeUv9N/qt3junpBRfZsdn05Jg7QfNMMvMvbs3dp7uA3GOKkvwMKRkSeetKTBgsvfevJcKuIio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R580IE0s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R580IE0s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5EVAzD08QTpK26Ubo5EKzejJm6qWIrdvaGD1PFH1aIY=; b=R580IE0sUxYInabPRYMvSpGPyK
	ORs61to/k5xqp2ViPI4bCJtgIempmLLLaOVQql45zQzktTkTa4Anr7u7Bs/WiMlelQV12F7IBQThp
	03mxU/Q68NsxSn4pq6whsFAQAk/Npo01IVX5kzrxGrXAPYFbityXYK1t7Jp/PsZ+Nqnyc6NtnSgCT
	1gMvuFbQnFL7MjmmCrkhXfQjt3laMp7P3JSm+C1w3WEJ8WB0Xl96KdZkx9FUZ3JqtShSr6+w8dXRu
	I+q+Ip+1wfPPxrIYIJuunksAESV9QS8NUia60fX9H9msiuzWkuZTrpki7QMhWblU/GkZ2U8yRHZSp
	9JG5iJRQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozmE-00000003BoX-3dAy;
	Tue, 26 Mar 2024 05:55:15 +0000
Date: Mon, 25 Mar 2024 22:55:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_repair: compute refcount data from in-memory
 rmap btrees
Message-ID: <ZgJjQgFM6ei1Cknr@infradead.org>
References: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
 <171142134722.2220026.9096244249718663362.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134722.2220026.9096244249718663362.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +#define RMAP_NEXT(r)	((r)->rm_startblock + (r)->rm_blockcount)

Maybe kill this just like we did in the kernel?

Otherwise this looks fine.  Note that it looks very similar but not the
same as the kernel code.  I guess sharing more code was considered but
didn't work out for some reason?  Mabye document that in the commit
log?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

