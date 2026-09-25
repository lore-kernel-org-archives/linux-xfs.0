Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C514219E9;
	Fri, 25 Sep 2026 05:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314978; cv=none; b=h+wu4w+vhbq6nb14TrAor95oN/T0WHKkBUxUKyqdhurmE3MnNcprTaDK4qLQbX64mX8m9jkoOG/muyxjNP2cINvbbur0BkV9cku73rbctxPHwQtWxRknAr8h7qCNRRQpFaQX6NAgi+WrOReFDOnR5ek+vV+eKiI37Ooc6H6Uo2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314978; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knynmcijv1a/5ychhgCmmHY7MZi3LKIUQ56UmpLQK1dCUoNV/lLxUDExRt3MG6nlu5dlq1WiQ5qwFww/umi/srfJLJXv3Efi21IPtkMHoyWpTgdyj7V0+7nQ/9im4cjgff+B+wGCWw+2c82ayHjNugmOLnGXUxEggKMojVZ+GIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qyTNOlTi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qyTNOlTi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qyTNOlTi30bpnhrzxbq85JeDx+
	26b6lXfdgprROFNyQou4DpIVi9j3b0DO1STLpKO2eELdhBoQsMBieyODK6jMJa2Ozb9eTZyIO8Nz4
	53uwgT3WlnRix2XAjzEllh8gQ/0FexBuqX+01/J08WnvyXjAvymmdJIRAbHI1CqQH2m9FBGfrHxlF
	DdXMp3Gd3hv6bPHuXshLaFf4hl9/pTrIUlEVSpY0O8yfFP3TbpccIMLCaD5zy72eLN9untGXGK+2M
	/jKawsTVJNw0SI/FqNz00XoijcYAlK2Dej1emjAujVTdJwSLLZfWTxPtQPVUkyl670qey3/ub5t3X
	gUe2xoqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yhy-0000000Ci7v-48kR;
	Fri, 25 Sep 2026 05:42:54 +0000
Date: Thu, 24 Sep 2026 22:42:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: check fork type against dabtree block magic
 number
Message-ID: <arYJ3nis77bEGdOF@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932303.3344850.1246558346723808401.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932303.3344850.1246558346723808401.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

