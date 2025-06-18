Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964C01EE7B9
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 04:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750222226; cv=none; b=idOR18LaORX3kRxIwXU34G3hfzLVhhOuaLCsbXWhjxOvSKtw0Q0ZklVogUpsPe0W8+p+NkD5heFghDjdBkMo2tTay45TCNo3ycc5bZswR4+bOXpFNOn52cWCsUsETpbQd/pFrDT1SqOFdxnTN5hGFL0ip+Woo4zq3c0+RHhqOro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750222226; c=relaxed/simple;
	bh=CnU1iyi12sf3wjn1H1ivEPGDhjLsI5ofOOSUulwyJcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+gtu2443QadrWcfVa5OdP3kwCxWOKT/xpDxeEpQ+vngINhiAQ1jSBUHiHx2piZPqQl5Zs7SFAflIOdA02gGSvB7rajUNRXwQxUT6X8PA16qHt8qTyhC6/bNj8R9AouWFnT1OnHSmeeBnQW00JWOx2C9Dasv+npiHwJW0oc3WPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5AE4B68D0E; Wed, 18 Jun 2025 06:50:21 +0200 (CEST)
Date: Wed, 18 Jun 2025 06:50:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: cleanup log item formatting
Message-ID: <20250618045021.GA28218@lst.de>
References: <20250610051644.2052814-1-hch@lst.de> <aFHtqTWIueE9IvOI@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFHtqTWIueE9IvOI@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 18, 2025 at 08:35:21AM +1000, Dave Chinner wrote:
> Do you have a git branch for this series that I can pull?

git://git.infradead.org/users/hch/misc.git xfs-log-format-cleanups

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/xfs-log-format-cleanups

