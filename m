Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3221F92E;
	Wed, 15 Apr 2026 05:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776230563; cv=none; b=OW4Y21HovvxNwFeCUVt+sTVHmpDWIGKslK7DP9oBouWk4Yb19c7nByyDtct+76AS4zacIs0nVe2aefmhfln8BoE9hWKARM3DSjW+/X3dZI2eSM/CNyPnS91FbT+hlWFWFTK/HmBiWsFLAUh0hmgg6euFbzQkhVj08fbifVbMJoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776230563; c=relaxed/simple;
	bh=lDDyIubimtCVKveVH3CSxqvrrwsxg7UG7AAiFlhlrV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWsBY3u6Ob86ZaBsK+7gNMRgtyXiZfoQH6d9H8DKs8/wJoRAb0F4KSuR49tN5EzstMV/YEB6yfT41IVRvEOT9PDDMMkvZu2gpAezsqZGDnEtJzMnmMOPEsEPVfcp0+lt7ayhIHAhN1A9jBf6tmKPn3Y/+ZAS+EWtK5ZcRLuqWeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C036968C4E; Wed, 15 Apr 2026 07:22:39 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:22:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <20260415052239.GA26559@lst.de>
References: <20260414075613.544106-1-hch@lst.de> <20260414185914.GB150005@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414185914.GB150005@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 14, 2026 at 11:59:14AM -0700, Darrick J. Wong wrote:
> > +_require_scratch_nocheck
> > +_require_odirect
> > +_require_non_zoned_device $SCRATCH_DEV
> > +_require_non_zoned_device $SCRATCH_RTDEV
> 
> Seems fine to me still, though I wonder if you still need to check
> SCRATCH_RTDEV if you're opencoding the mkfs/mount calls?

This can be dropped now, thanks!
