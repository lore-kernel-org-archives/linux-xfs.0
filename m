Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C0F2FE56B
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758131329; cv=none; b=cfZlNIDYwoAtjvzb+uRRD3xsMGW9XL1uVqgFUAYDRsqy4RSz0MCv/eDHyMsOzjv38MFXAhusbAcB/2A/BcLryZxSyybGqS//aDmY9/WXJUIlXRJ3AUMtuy+GKCiNxDH+CSiShv07VGUcVYRiVmTOTwT0XWOYDAkffGWtKRNzJpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758131329; c=relaxed/simple;
	bh=87mcZeAv3v1QKoCHGF+lf7KTbg6P+OZkUzLDruC2lfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9zC0bbEKHfB4FvuCPIY56qhHJ1p0/4bfgVIg3ODrkKhBz4XAsSE1LbDpDwnMhLnqBcbrwAci1OBrduQTUUW+VgEPwnmbJNu4tno+GcMIQoqKPHxWYs3Cr0jjWUy2jzXrkhIiyGHJum7kFaSafCWdlh7fKqem9APMWj/9/mNvjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4295E68AA6; Wed, 17 Sep 2025 19:48:44 +0200 (CEST)
Date: Wed, 17 Sep 2025 19:48:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: Improve default maximum number of open zones
Message-ID: <20250917174843.GB18733@lst.de>
References: <20250917124802.281686-1-dlemoal@kernel.org> <20250917124802.281686-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917124802.281686-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Same nitpick as for the last one.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
