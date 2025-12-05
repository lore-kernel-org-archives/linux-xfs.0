Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1129130AD0D
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 08:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764921967; cv=none; b=H2/QB6THMEO/7+jmdkRvhc4XGJOfFlQDDC6xVOJQ8paZCZfWXOF4FD6lbg8Zov6Kpl3GhGRjG84iisdUQzo23Zt7+sfnPK25Xh3LlUDzABsq6tplEncJrtcOLxBcAi1ywihpI/vDkoOY8aVdwODmT39Avv8q5WB7nz9lxfKXR04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764921967; c=relaxed/simple;
	bh=S5OnLDYyiKsfpGJOkN7QlbwhJYOdoOtqpqxu1EtmvWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XppBl0vvL9VqlDDmoYVV/hgQHL94/YOQykuBZ9J0wzIZFOp8vzY8Qc7Y3eH5XFo5CfNxKOAvE89SSBplwu2VlCP9wMCqsPbnEnxlUE8if2DSLq5eF0oZKQwC+88tyw+XCwzv95ySIcHiMKKUXLSeiuE4smvRf19EIXx+B13owaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LdxetfaX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LdxetfaX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+JhxQyleXxSRxlm36ZpSNVLmZwm9ffeOKmXMIcXZ+r0=; b=LdxetfaXThfo+96tNN00pa7JL4
	0Qen3Aq5y2jE53GEhICe28F4BoGrsO1Xvgk21cS6HsnxpX+/cVkjDCBfFtfxMaLsPM8/EAN6gGDMW
	Me2fNQKdr7FMBymPF/5wBYZtgsuPOuXTEkh0LaBIOHMf7f0rawP+D66KgwpzoL5cr2+2FN2rMvqSz
	9dLTnjFrw/FTjYZyWZQZahW3m1MCMyz7Yj2G4dDtf4Fezvl0zOMKZd/sOjXRcI7nlpdPJPPh3QK1z
	/XGEOxBEZrr21vAfAHwFTr7Zwf+SVgl5ykeT6I4yV0NGHnc4FaiWUmKSyZWauJHMRh4o4O2BqMvQY
	lfKW68PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRQp0-00000009CYS-02bU;
	Fri, 05 Dec 2025 08:05:46 +0000
Date: Fri, 5 Dec 2025 00:05:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix a UAF problem in xattr repair
Message-ID: <aTKSWb-wR7pQ43Mk@infradead.org>
References: <20251204214350.GM89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204214350.GM89472@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 04, 2025 at 01:43:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The xchk_setup_xattr_buf function can allocate a new value buffer, which
> means that any reference to ab->value before the call could become a
> dangling pointer.  Fix this by moving an assignment to after the buffer
> setup.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Do you have a test case for this?

