Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199F012D1ED
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 07:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720510364; cv=none; b=lvNB4jXdw0evbHQk511eC9+GrOH+zo6cb4B2FzDTD3l0j7LA/NmGwVcuPEnkqWC0821oPZKE47DKNenyM0m2HBvjX7zC2pz/Hexn6BTDZ+RDbTKziqB3l000Ja8kbtMe4HKf2wutLmBEtyVWcmykjeAGSbW7dTNCIMQg1z/Wiis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720510364; c=relaxed/simple;
	bh=Y6mPSrTrftF6dL3SFMHnuAL89vLPm+kNfkh6lxp0xxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zxb91KDOSmjjVoO/dk0+BoemnVKXmaeZ+gZ+5BFZsA2uv695hXVfFXPmX49P/z1Ey8ajvfGNBLSTZyM1SEIHNVDRQ0zVOfxDMGeZuqcstfqeZdhFXjTXSIteF6hc9F3I5PumVUsHbI2QIvxA0TDQJBCCcO3FYb6XNJ7/jtv+orw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 86B5A68AFE; Tue,  9 Jul 2024 09:32:39 +0200 (CEST)
Date: Tue, 9 Jul 2024 09:32:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: remove duplicate rtalloc declarations in
 libxfs.h
Message-ID: <20240709073239.GA20803@lst.de>
References: <20240709064401.2998863-1-hch@lst.de> <Zozk26g3EoJTamEA@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zozk26g3EoJTamEA@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 09, 2024 at 05:20:59PM +1000, Dave Chinner wrote:
> Not sure that you meant to remove this man page when cleaning up 
> libxfs.h...

Heh, no. That manpage switches between a checking in file and a generated
one when switching between upstreams for-next and Darrick's patch stack,
and just keeps f&%&ing things up.  I'll respin the patch.

