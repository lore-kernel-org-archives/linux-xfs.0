Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA155C1A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903590; cv=none; b=hg0EJ7DG51s4o2kx2VBV2F4xK0Lcggo7qNnGnPb3XD9iPk/kzXvX25GtlO/dsaWY7/UN2A8L5ioIRKsUTKStw9pDQKwcvvaq7oClH/1nuHRS+lOfy2AOsIm98lF2C7LZ2c/RcTupQazBoR3Kw4ymOunUtwrv+LEVb0sc1M7vO/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903590; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyxlBNjRCNzzYMi/tiJEm+M2Bz7Nt5PdvL5MQ4PLLZoWrLO1CznPNaH64+YKL/YyUERveODLiWTUEYtiH7eEa4A8kQMFn+TSCyxvwZi2eIZY4InFRhDwd1qe7BSPeQ1UNrbhP6LQLjAK9SbxCCRi4rYWt/AdGIB7Ztcgd+mtYDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EE6868B05; Tue,  2 Jul 2024 08:59:46 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:59:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/1] xfs_repair: allow symlinks with short remote
 targets
Message-ID: <20240702065946.GB26672@lst.de>
References: <171988123583.2012930.12584359346392356391.stgit@frogsfrogsfrogs> <171988123600.2012930.8636977551669222212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123600.2012930.8636977551669222212.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
