Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5218E77C
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723126129; cv=none; b=MrNoJh+2Vo4SEqT7tj2kGBEzJdvANjjz7olovffDBO2EI3MeTCEy+4SgKBABeS5zhqL+BDgrOGrDDM4sNU+m0gGUO8z9+KIlZha7c+2HSaPmPs601/gNQmzMH1nOYYYCDNPCXYo/guFg7iKKPdsClZ4p95/v7itvzMeqmI3COtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723126129; c=relaxed/simple;
	bh=nysc038Byv2wqsc/9aJGL5sgBpcm4CDonSQGiWwCPeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Du07V6ijzavy71O2Adgi2X5Yepo7qSTcBRlW4Ht2VTQhYFLtASmeoN+FK9e3AZDz4eKC5TxaqWxfHtcnTNAJuSYOt1A68ojxOiq5BfhzlVZxByugoTZmJDf1ltHsyoec8gdCxIxLtNUrP4XafgbXbPjTki4miSRwdcuZ/VF1C4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 91F5268B05; Thu,  8 Aug 2024 16:08:44 +0200 (CEST)
Date: Thu, 8 Aug 2024 16:08:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] design: document new name-value logged attribute
 variants
Message-ID: <20240808140844.GB22326@lst.de>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs> <172305794118.969463.1580394382652832046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172305794118.969463.1580394382652832046.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

The subject is wrong now that this is not generic name/value but
specifically parent pointers.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

