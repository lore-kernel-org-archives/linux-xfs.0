Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AC427FB8;
	Fri, 24 Jul 2026 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900523; cv=none; b=hkdWEJmy/tLGbaG/g774jnLXOFqsZL+w2YXEYfzH7dKO+Q07CRaANlMtHqamvC30iDeJwIe0KlqtHTbruV2L4tWf6tvuXrlz4P+7rSYEfgYmCdyc4SScJm2ozfTUuzcrGOOKX2O1BZQ4DB88QQk4eCOk6HVhiM6m4KXa/P0vPuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900523; c=relaxed/simple;
	bh=q1VNfFba334prSWOSiFlszl8EoXXOfafwX7FwBIpBH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5agHcYvwEHVMJVd8On0I++vmxoIBlD2teo1UoYmerLunnvAjvcJEPFAQb1Z+P0Js2mLcgZjL3m5rcjvQFH6Ppwenr8oImxGBYMHhaDu0wqbQ9HGaNYNMo3Dj7VqHeq51TYywV/0TrrqNRdNsEqAWN6rlOotC6u17GpY40I9Wcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A4bNKseQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A4bNKseQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q1VNfFba334prSWOSiFlszl8EoXXOfafwX7FwBIpBH8=; b=A4bNKseQ0bCLlQDZ9rmgxYXhLN
	5zFYHc5grlbf2b4HaWvZ8s3oIMVBRlgyCzg7MyKcIGomKINNTSkPyCgBDEDcF3e6Zai2/eDRqGaRa
	7bIjaDVoBJaoOrrzDBb8mNCPGSIA0lXDFTLGq/uCQC4IdsWVwlod17WV4OOkatS5xQ7GtMHUU14gv
	PtmscZNMzcnRFp4gv0/XUusp64kLhaNydJPwUNoJWABg/DRqkCMWT+ncpDVrVQ4KhTZZ9HGjNv0+H
	nMMpAeUnrXD4ELv0MT6tvUF8x9cXzQbNigsRM8Z+nJLRoonxsGJ+qTq627Z6YyoyJTm6O75gJ4P+m
	VLJrpteQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnGA4-0000000GVnU-3Kyz;
	Fri, 24 Jul 2026 13:42:00 +0000
Date: Fri, 24 Jul 2026 06:42:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] xfs: fix nofs context corruption in
 xfs_btree_split_worker
Message-ID: <amNrqHvm2I57S8un@infradead.org>
References: <20260720050522.3101824-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720050522.3101824-1-yun.zhou@windriver.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good for now:

Reviewed-by: Christoph Hellwig <hch@lst.de>

