Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFA4139579;
	Wed,  7 Aug 2024 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047081; cv=none; b=YzjjpiIHyEjmtTe1DSJX1TLrbRbvAxxotINsIEqTZmmPcaTcD4/7moeXBh3RVQu4XqGd405nIhONhtWNi1waaY7oi+jFIDMTztk26IPHBpW1nXZAOsFs8QE122lrEqTthFRtSuwzAmUZA6E7sO5PRiQuXUF1mJV5DAHLpM1kBpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047081; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liuBidQHpLDwjJjy8NbKfpdmKJ9KcBSxE0NAzknQFlF+xX9+DLieGEs5BbjOuYFRLTOkQhx981AHzNPw158qYd0IxGjJxzAfM3FfguGf+ht9hyswuz/eSeIWsCpBLWnsEPJxjGXu1/HFWQhLLHP/YXw13lvedCI80D8e0vrPOXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 46C9D68BFE; Wed,  7 Aug 2024 18:11:17 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:11:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, dchinner@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libfrog: define a autofsck filesystem property
Message-ID: <20240807161117.GD9745@lst.de>
References: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs> <172296825613.3193344.6788691411989910358.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296825613.3193344.6788691411989910358.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
