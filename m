Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF42D18030
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818881; cv=none; b=cjWvMTPZpeceDjp6afZFisaBvLL+Az4GoB2V/n4cEZXdRWWoZl+L9ZeKGtjCa3DmVlhWw1Z885mybQUsNU6akjGCoW91wQmApQ2jNDCNYJwKRae8bsD7SZ4TQfMc/iHV+RXMiEcXFVDkMd2ZROeG3LIIb4ziezm1ioyVZWRQL8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818881; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rk1edVeu3mx/ngsiqSMuE617jCuFzLts+9birPPwJtqF/dPtCNJG2WjVOoyLvL1HaedF+lh0YTeeDeEoWKFBLsIeCxzxcIdspZWf5LlQqUitLGB+T17LBGEbG3+7WeNRDMSh2IWQlr5lmlLIGDuars2kPFDpWx8Yac42zZLjwXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D446968B05; Wed, 28 Aug 2024 06:21:17 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:21:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/10] xfs: rearrange xfs_iroot_realloc a bit
Message-ID: <20240828042117.GJ30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131661.2291268.13799708059982137215.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131661.2291268.13799708059982137215.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
