Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED87567F
	for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2024 03:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724989445; cv=none; b=UiKtWACV/2LxDlINsq8c4uaqrFvPmPuaLaZ57YZFNBTmyQNsYz2x6bunnaIEIzq+4VzNq4S6M6JSR/k+9d1q9eqGvC5U/DNoq5kUTeTrS6yfGIjSDSF/93fdcj0CzrFdS0XpxAkTEJO3IGJHRwQRH8Sm0k0Km1rVmWu7Dcq+sTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724989445; c=relaxed/simple;
	bh=Ps+qyXw9sw32MTLR7B9UFXbdNAosT4uUratb6Hdivkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXyTYLypbbNFwV3LW50Jp3YtRYcXmE+82w++xxPMJ0ILc4ieEmFZmRyz+PKr+1Vk7eoSM4ds2nYkC2bgpN3MzUyafb8WWb3kKei6wZay5reY7Y7CC3IeQcv+iH6tVX7wNUwmG9f/0/xBlu1Jwe35AG4efRS5p5Vt+3EWcZgdJLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 60B8C227A88; Fri, 30 Aug 2024 05:43:59 +0200 (CEST)
Date: Fri, 30 Aug 2024 05:43:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 04/10] xfs: replace shouty XFS_BM{BT,DR} macros
Message-ID: <20240830034359.GB25633@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131573.2291268.11692699884722779994.stgit@frogsfrogsfrogs> <Zs/WSw6fm4SyyyW4@dread.disaster.area> <20240829221029.GR6224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829221029.GR6224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 29, 2024 at 03:10:29PM -0700, Darrick J. Wong wrote:
> I disagree.  With your change, to validate this function, everyone must
> to check that the argument type matches the sizeof argument to confirm
> that the pointer arithmetic is correct.

Agreed.
