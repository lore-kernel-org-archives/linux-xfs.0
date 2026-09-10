Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EE23C1F3A;
	Thu, 10 Sep 2026 09:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033589; cv=none; b=ZTolIShkz/mgvEh/iKKNl+f1V4d1rgy+tZ3UuukOPhD1v2QmmpMMdYfiCDjjOR7dPCyczL64VF9iq4nhQbvhkntAMy+gBJguGBuSoZ74yMbnfLVItxRaFOayKsxpuCjY3AdwaToWrVgH+yozaIKsDwMUMKq/lm4Urbp/YQEC5zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033589; c=relaxed/simple;
	bh=XZL++IqUbRKg6wTIpQdZOVHMdLCsr+USMUQYnRXuw0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hk7jo9PlJ6fwQfNk/KrOIlCBJfDebrwakjfiP41mHeLuNNyMB7d/+18UqwSHOyeUsd6nLMn6ojFd4jLY4AymcY9abz8jErBJYFmEFKZvJ/SrRpk+6gV1eNP9AUKT29WJg9JO5KLWsGpiQCaB+98uAS3e3HtgEeNwmMToqZQ8bGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 85F7368D05; Thu, 10 Sep 2026 11:46:21 +0200 (CEST)
Date: Thu, 10 Sep 2026 11:46:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: use correct jiffies comparison function in
 xchk_maybe_relax
Message-ID: <20260910094620.GG5330@lst.de>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs> <178901989959.361651.2838640248053656232.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901989959.361651.2838640248053656232.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 09, 2026 at 11:01:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that we're supposed to use time_after_eq, not a raw >=
> operation here, or else jiffies wraps can go unnoticed.  Fix this.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

