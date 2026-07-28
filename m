Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6404437F312
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 04:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213562; cv=none; b=AXZs7cRB9fqeilxrG4NnE+ACGQ/apD4EuIR3QALCk1ByjwnwNV24IjvYDkdRJC/qAFrCxAD6LYgrojmOCiXbMz1N19UxUzLzAIPpEt3VC0ABwSD9Zc52XIPagMcktxnTqEWTfKzrE2adCaoSod84jl8HOmyAf9VdUyJ+XVuXDQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213562; c=relaxed/simple;
	bh=PzHmKQYV2yOgFn3XDdFWRvmw2dKcmeDzKqgO+DcmIQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SMIu7hXtT5b1FGreMp4ZzXm/l8QMN3wT+3Dcw7wVLv29Tz+whX1Wj05NbZEpGli2Fhh1OHSeFY9/aQR0OY9lfG1JVPaQKD2axY1wSH0ASRVsm4ggJx8RojJziQMEnX++rnCtQW+MzjVENg58aTNEvDoThVwTHPi7PGOX1RWtPls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C070568AFE; Tue, 28 Jul 2026 06:39:18 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:39:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: split out a lower-level xfs_buf_get_map
 helper from xfs_find_get_buf
Message-ID: <20260728043918.GB20064@lst.de>
References: <20260715145147.95654-1-hch@lst.de> <20260715145147.95654-4-hch@lst.de> <20260724164427.GQ2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724164427.GQ2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 09:44:27AM -0700, Darrick J. Wong wrote:
> I like the idea of factoring this out, but I can't tell from the names
> what's the difference between xfs_find_get_buf and xfs_buf_get_map.
> 
> I might have called the inner function __xfs_buf_get or something.
> Dunno, don't care to bikeshed this.

Heh.  __xfs_buf_get just keep the bad naming of xfs_buf_get  But
I can add a __-prefix to mark it more internal.

