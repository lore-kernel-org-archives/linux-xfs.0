Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C16C198831
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 07:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964520; cv=none; b=WysCo8qi7N83TGUMrSVNex8X5tEzd4P3oAwjJa50ZXVWt0KuGv7RDvxcXAZjJ9X2lBj8XBqjJf4LgzH8p/8fGdZkvRsBabpUUvfVqwBLsHzNH7Nye5tLf0ovtcfiImbAA2yzOHt5Ezzy1smYozt8dae2jCReOmE7zQK4oBP2l68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964520; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSU+9Kf5M2s+qGPNrOsri+chWRFKtASIpao3jA2QFLObLSMCZLxXCHft1osrvpDVyYjFfajM14aMGYEQoSRKUN0vjmWkPQRsHMvdiG2ZGYFNQ09pPcuXybE8bWapoYofL6+1cDcIbcBUj/BGWW+RpOmdcobEnIdBN5Eo4cb5xbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7CE8E227AA8; Thu,  7 Nov 2024 08:28:35 +0100 (CET)
Date: Thu, 7 Nov 2024 08:28:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] design: document filesystem properties
Message-ID: <20241107072835.GC4408@lst.de>
References: <173092058936.2883036.6877146378997138277.stgit@frogsfrogsfrogs> <173092058966.2883036.11288763605027275979.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173092058966.2883036.11288763605027275979.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

