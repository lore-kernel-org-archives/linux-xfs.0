Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB2118E377
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081126; cv=none; b=tBy+P2D1BaegXOx960bxx6HsxPGvGL3kMWCP6EGgJ/E2HPCdjK0tRd3hkSfkLOP30L3sYYB3zUuCoVyZeAohyEblQg7ObR6L0sYYEDwl6Lt955+RTB4N+uAi/0VZmy9jYRFlR5y2EKa+jIf0o5IPNV/NlMGK22owawlTAWd8p7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081126; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDxzUXrs4t5MGa8x55d6kTKlSXsjrWLFQWYOG8U/mYyllyspnDtiVIN4E32tHkS/2CmFP7LQx3cp8gddjVCYVtgBrYnvh0jlGi35ygeVhcV4fYmfT/HUbVxegcvwzNdL6bw5l97JDnBEqT+kTwePEDj/r7AkjQDrkdaJ5B/79T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PEji3YU3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PEji3YU3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PEji3YU3FOipSvPsj7NDpS6/Yu
	03bfSiqXMznnz6N3pvLLSghGGDhMKRH4900wcn0nnuLxn48kfw7Nvaj+TuUfdvR2L9mctySJPdYX4
	b42yG+1UE1SamHBJT37WvhdN+nXSWqmzWiQozm67pFVqcH0akoeFe7/P76pMNv3ZdA1yT+IsYnAkv
	YSoJmrKn27XCkwaK/pegHqQBGDZSrTeSV3fP5QlDdMDZroQG7/bMfS4AIz2N+vKUxt0duaeNgQwda
	9wP8nk7Z3BByaq2e0eKCcKqrUTrEp1qzdFnztTj/W4HhxXmkfbB6e+G2SRBDgKj2vc5dajw1/k2Ip
	1Mn/BsnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1iO-00000003CUB-3urb;
	Fri, 13 Dec 2024 09:12:04 +0000
Date: Fri, 13 Dec 2024 01:12:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/43] xfs: wire up realtime refcount btree cursors
Message-ID: <Z1v6ZMgwtGedsPbz@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124808.1182620.5439413915170337325.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124808.1182620.5439413915170337325.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

