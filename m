Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE063BBF4
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724386239; cv=none; b=BlfoYZGNADRMCDsq7XLV2pw0VQQYNas5eQYN/bJW/rsvcIofYtpMYnx4LpZl4GPpZf4niiir2pLjoNE6Of/r60sE3crBDgN4UOK6ablrm2nq2FqpMQOs6eAMt7W/CcNiQClTH0dYVjRhbtnO0bLlZ0mzL7XuaV/QCPrT6oyAqlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724386239; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcHEonLvz1uJigoyPGGcWR6wD1k2DsKyHQlwtt7XBXFFa0a2AdpIgChwQtdKSW6l3POXxQbpS1SNJl+kMGU8Fv8Bc3Tsh60XhK6EMexZeKk6ub8zCnNsnt/UzAUF+WHow8CcDPzrf+h8Nj3ODYBGtek0jxfSGAJsxSf89NAC4KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NZ6SNfo9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NZ6SNfo9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NZ6SNfo9ug9lCtP1m0BP5Y9myv
	7waz5s85xaRK0hmgtF1wDiH8N7zWjTx2dVZM74kwJwRkG15heC/f8Pku3uwa5s6R0/sEecUb60DAn
	R+yNqBCF2LPYqZA/F7I/crorEVp/9LfTQLykpU5QvTYaujIa+TVwwoOfefzXDt5hvkgogwjmwDY7h
	nDbImDrCKLprC9z5og7uwbkcZXj4xfO9StTm0pWT4zNPs7qb4bBF3pJYHSLzpgNWaXcZqHePS1dLk
	JSS1OBx+9EFz9ByF3b6EHfsKVIwGPnDPMLmh3Q4Mloy4OXKRP+Y2EtI6LFHD7b80XS/cLZRK1XZgj
	J6i8Ws3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shLdF-0000000F9PE-2Jz6;
	Fri, 23 Aug 2024 04:10:37 +0000
Date: Thu, 22 Aug 2024 21:10:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zizhi Wo <wozizhi@huawei.com>, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: Fix the owner setting issue for rmap query in
 xfs fsmap
Message-ID: <ZsgLvToaqp9X0Yzv@infradead.org>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
 <172437083836.56860.11859978469978791125.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437083836.56860.11859978469978791125.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

