Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9563749FB;
	Mon, 28 Sep 2026 05:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790573732; cv=none; b=Hfyq+mj2ldL+1tI41VIAggCaXutYJjnX+JjAC7FRq6Z7eu8R9lFYSVPrEqbTvQUn7mBhYaafKAa6q0sHsCmksCGzk/tbbLRCXaRledIV2R/GbnEK+ANHt2n9qe3YKNQ2DN5LBVclCqoEPY0SX2O/VfS5DkvVKfYgrxdD+GRP0RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790573732; c=relaxed/simple;
	bh=QmQpa4BiTX/nQN6NPtjRKn0uy4eRApPMkWmJlNfHgq0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFqyOE9ecYl+ee9/GZXQjlzKD5sO+rNYGDZmHRpuaf43cOYAGGqp1fXWGHvaaLJm40Ryu8qOhrBiFms7xio8Tz2MLPtsyN0yKhnupvHR7pm2ou8QVrov8k5JLjGc4hu+B2mMslkacnzWrJXD+5yICw9r+/DTeM/77WolCbIZ3hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D836A68BFE; Mon, 28 Sep 2026 07:35:27 +0200 (CEST)
Date: Mon, 28 Sep 2026 07:35:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: djwong@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test libxfs handling of missing RT devices
Message-ID: <20260928053527.GA19314@lst.de>
References: <20260925051519.3002168-1-hch@lst.de> <arkF56Qtd-kQS9jH@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arkF56Qtd-kQS9jH@zlang-mailbox>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Sep 27, 2026 at 08:20:12PM +0800, Zorro Lang wrote:
> > +_require_scratch_nocheck
> > +_require_realtime
> > +
> > +if [ -z "$SCRATCH_RTDEV" ]; then
> > +	_notrun "external RT device required"
> > +fi
> 
> I think "_require_realtime -> _require_external_realtime_device" already covers
> the "_notrun" above. I'll help to remove above redundant code when merging.

Yeah, _require_external_realtime_device would be better here.

