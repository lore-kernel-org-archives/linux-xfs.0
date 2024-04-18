Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FC7EDF
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414689; cv=none; b=o0TgKC4hNR/pcTbAkH7ETmsUl4SKhmAt40Iqq2eMxl0aakj8qsts+61EtgrR7l2m5FfqGip7AIikdMtw70UO1jIKkpopDKEKPQvvExALr0FwTlys12HuqcITrURff4ks5Sf4MC2g+62+bKZaIVHSsV7aU2WXlORQxDVMEHioa3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414689; c=relaxed/simple;
	bh=Q3Qirn57XIeppGyyK0u0+rzCXH4igXh3qGPVpeU5vwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=myFYhbDbh5FulVVGwOzkuM9MqDHqPDsKzbj4fkhSNEa6e7mcM41/2Z8PX090F7MLDPzvGOxsNpCkB2pJBwnLSmSsps26cxhUBPO2vXnvUIHKcQuKacoLyztvayqLbjMXI6m2hSKH2fOteGd8bHrgU5DWigjEKEKQ/+c4hFMmQmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9611768C4E; Thu, 18 Apr 2024 06:31:22 +0200 (CEST)
Date: Thu, 18 Apr 2024 06:31:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, bodonnel@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 01/11] xfsprogs: packaging fixes for 6.7
Message-ID: <20240418043122.GA23591@lst.de>
References: <20240417220440.GB11948@frogsfrogsfrogs> <171339158311.1911630.13437553389622374759.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171339158311.1911630.13437553389622374759.stg-ugh@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 17, 2024 at 03:07:35PM -0700, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.

I think the scripts need a little tweak, anything from now on should
be for 6.8-rc or later.

