Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF00BA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903476; cv=none; b=t43j9n/iL+uJjks2QRWWLxICR1GceyBLEQBUee6TXe+FZwW02joUbw8Ga6/jZgjnCYwAXTJ12vXogVwY0ZvYePfUSHIxDbpzvQasSk1ZSFhfTSRZVUlD4jlQxno14HFTAdYAA2V3MnEI5JhnYzODeTGBQK5qPrz7fjIdV6ManD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903476; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2KqocHFBjDrLgEaEAMCD0RE4zYs6FNGuZeF+eF+RxRTNHSnIITZ2vwpaS7dugR8WgJUNf6mt0hzGllaGdtwwzVaxlr83gFrzozBwyjJKwqMak+mzF+rZUx3zlTJwav7N7na55s1UJqa2CEODVsn16jcXDPa9kN0O99NyAhf42Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C222D68B05; Tue,  2 Jul 2024 08:57:52 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:57:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/10] xfs_scrub: convert scrub and repair epilogues to
 use xfs_scrub_vec
Message-ID: <20240702065752.GF26384@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123226.2012546.5857433986892075792.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123226.2012546.5857433986892075792.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
