Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435023D75
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710382119; cv=none; b=Ue9JbFsvhDxAUuISIT1yks4omzWMIYGgYPKgrk5eqR5j3UjjbWdUst38ji0LnPISR7oMd3nSM61s8/Wkw0P9e9KFJQk+irnv2qdZiczt9SqVSlYx+B5GEJ1/zSDYpRs2ZPCIGGxflHgsP+HuzGeyvFqcG23RiX/lgrLaufAX9Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710382119; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lOpDZzvMO/fxIwR/hCmZNhtXeN2OtqcAMKukTF4TELY7RWwwHmbuCalGKAv8XByxoqUq/TOgdbAIUmmF7swvCcfksLCyMBTbPJivp+8G+PgXyhDGN2ZMm4uPWR/yCzD0uXBWAiuBgcSGUlV/ommhXz+RlAMmt8GcEUn0c7286wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mDuJO0ax; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mDuJO0ax"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mDuJO0ax5kVzo2+SiOQ0/5Ea9z
	pGdkVIk9fze/bMr4vZlJ4z6CCFlJcUzdoYdS9Br8pNTfIlh5q2lJkV1aC2noVFCXdd1GLYgzmrT8b
	+lmRB2i/UlFiefP/a/BW9MDzToa2Jruah8DtJ2FZdjYix0QHDJicAn4C/Kmp5MVmteN/HIWfOJisx
	muV2XhBXEHFPXtxtWSLa3Qmm5iQAOAwyC8HuAWPoDE2RLZZkcMkyuaSHE0gTiescao1EvTXp/XdSI
	JjGIvd9UML1tl5w0wW/7pTsHUuNKyYs/7VidEtuMo4CezyLbYR0X2mefUGFOF4bhebHMcCJNOdIxe
	+eIXfMNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaWL-0000000CeHY-3YoE;
	Thu, 14 Mar 2024 02:08:37 +0000
Date: Wed, 13 Mar 2024 19:08:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] libfrog: create a new scrub group for things
 requiring full inode scans
Message-ID: <ZfJcJceyOIDFetJZ@infradead.org>
References: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
 <171029435218.2066071.72866513594224796.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029435218.2066071.72866513594224796.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
