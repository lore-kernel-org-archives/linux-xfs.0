Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1624433F8A1
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 04:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311575; cv=none; b=b9fhTvZATN9QAdCgeB47Mp3xtTUNzwTX+GNn44f4BaOiEfGqeaU5HsZ0OvnawVJTEaLFdX72QIBMv89JMB7Fn+wSenxt9M0K8nTuwXnABFseNZWKirI9lL6oHwyivOl9LGoY/o3EPaoTqPvGlotAIcBneQnd38guwcidirlkn5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311575; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=In4SwNyp2eopQT3VSClT5xWWNG1lrF25JKIk1BSEbfhA7JLZnRV40QmYbsh1OWsqa+0okC12+VcIq7k9zsPnOBdtsyCBQxwzxY89vcmBUkXWdhjrtWse2DanlHHoLVksKdUPHCBUEFupiPBiUsWw1aRhzwNOlEbe8rZjxn3baJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 39E2168BFE; Fri, 25 Sep 2026 06:46:01 +0200 (CEST)
Date: Fri, 25 Sep 2026 06:46:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org,
	sandeen@sandeen.net
Subject: Re: [PATCH v4 2/3] xfs: introduce xfs_trans_cancel_error()
Message-ID: <20260925044601.GA2216@lst.de>
References: <20260924151638.38535-1-cem@kernel.org> <20260924151638.38535-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924151638.38535-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

