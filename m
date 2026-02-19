Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50CF308F3E;
	Thu, 19 Feb 2026 06:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771484024; cv=none; b=Ymi035ViUdfmcgjUXe2pJ696qXCAr81CJ4Q57dEsOCdAn4smWfBYZtl7h6NL4aN4vO1JnVdQCL95joj7hZvYQNMktfp9L315TfxNNKQnuIQL5Jy+XqSAvRvltWPHMTDo2ybdcP1evRZTIrFyDHHyXGWKaKhyx7N/bwg5RAK+k6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771484024; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvkVMddq2rx8XCtMle8uVvNvOKtzaSVIjTX/+c75gpwaDZvduPZ05RGOxmF1WpZC7jUOx7T+nPC3o/M3E81gnpkuW6Ev5n/SzRIV2qQnLPPTZvhINN+cWEBTkO9tkQZkMOlbwLAAF0H69y6J4MnyIejQgr8VtjPjdJY25Z1Fp5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xx3CjcmL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xx3CjcmL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xx3CjcmLuJLUe2iL8MjV8bcWww
	hDoU9viF0ws0BxBj/CQgOuI/xcZd3QD4jTM5ADT5LHNsxh54n7PFXP2qmFqhkSGWlQc96cC9064/I
	IQL8PYeFRdlpizxiiUscpIRlmHidtLdSoARb8bKeDe0SmpI5NufLc5i6owguplSccu9woxzJulnHw
	tXmnjH+YhvMx8eWfSmpzfcy+n4lkxSafb8l+DVaqyieLHIz+qEsaQnfUr+3JY9gMXdVAZJ0BYDriV
	MOU3xTXpPTYfkz/NvkAwfeUpkHfUBb4gWNwCn0q+uSZCBeohgnNMeYgXC2f02Cev075ZFiX+NY4cv
	pvDt08gw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxux-0000000AzeC-2JyZ;
	Thu, 19 Feb 2026 06:53:43 +0000
Date: Wed, 18 Feb 2026 22:53:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, amir73il@gmail.com, jack@suse.cz, brauner@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fsnotify: drop unused helper
Message-ID: <aZazd28GQXMKpIJq@infradead.org>
References: <177148129514.716249.10889194125495783768.stgit@frogsfrogsfrogs>
 <177148129543.716249.980530449513340111.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177148129543.716249.980530449513340111.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

