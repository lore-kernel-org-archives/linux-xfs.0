Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D4912FF8F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367315; cv=none; b=jVid2mTRliGlz/Tl7HgJn8mP3cD30hGOLlmBT3IMFG90z7mVIYQ3BYMZ8KlR10KM1/cAodeYtsf4Qc12f9LXh9Aj12Tovk3PlyHTJ1epEKdHEl19/Fupy6WU35aBre2xM3RdJhwJDTv8dIpAe7kCJExHTiGKDL99UHn6FLMajHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367315; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tW9PiOBX3FXSs+5snhnZAVW7w6RUXci4K35/L6+P5fdbOBAPiYgAprCldlwU/+lUKqHCYwRYZ/NU8T0TGdy2oD758KYky2aIIx2hPrhcwsMBnP4t6S8tSnLpid2k/acwjQVicfj9/1nCS+szKA2CBP0Jw/m+LI+eL35CUfCk37U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U6OFfqaU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U6OFfqaU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=U6OFfqaUOI/I8XasR8u0UVkUEt
	x2yt3j0wFNrxwkZ/L8OfFwOpOqLRe2jrzwTwqyYxtyYB4bzo3mDH3bBij0SqgVkW70nmU4zyqVMg4
	5yp2XK9Camr+lDZLlGrk75LEVPJS5LXcDE88V11HIO0TE3gzP/26MlV6mSp/qf9ucCxUMz1L9Z/5B
	yBSs9xj478O+Zpn9BEZcVDFu4oxBqqyh6FLKUn58lrTLA4yiPlDmFJDXzZfIby/vLWkzUcuhcytXI
	io/oSJ2Xkv7dFwJ6M9sJpbvwPBmqWD97NJcsfHHzdwPTm8Shu81+VAG5eVnAeqA7CbqKyzRMswluS
	8rek9Ssw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rx76f-0000000GZAq-1bQm;
	Wed, 17 Apr 2024 15:21:53 +0000
Date: Wed, 17 Apr 2024 08:21:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v2 1/3] xfs_fsr: replace atoi() with strtol()
Message-ID: <Zh_pEcbm5lGGls_N@infradead.org>
References: <20240417125937.917910-1-aalbersh@redhat.com>
 <20240417125937.917910-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125937.917910-2-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

