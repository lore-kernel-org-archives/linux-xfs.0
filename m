Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AD513B297
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 05:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576484; cv=none; b=mPvNBv21LJU9j0c5iMOGxy0uVXdzFZTXjxBZMx61h5X0NI20PPt9whd7LVlq6rTdI4SBmgCBaKEWcsmziIwh7J1Dmv4l4emO9XWYJLRe3WrxU9KIAczNXGRoYgIEyT9T2RBEkdINgqFC0fDu9/G5JIMrLYzz4DQXPIqBqGilgrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576484; c=relaxed/simple;
	bh=EdSfq8/5QuYhK4I4OExU6toWCvubVv3RpnhNZssHfw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OFxuqO3cy8iZEhN6bgO1P/l6whqubYCvO9sPtExWHsRc1NjHRFy6lPnD4KUjpg/CLNYjhDNENSuhcoMgIRfd5m0WY7r2MwmoPWuJcgXX/ooVaimKMkm+PbTmdKrygiay0BIbezZR5zDbo41qHyJqCL0S6I/zXKG6o6zfeMxZHHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kFzV/lm7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kFzV/lm7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EWUWe0CFYH2FFB2tTLUhwjepB3GzecCxc/+SfBt1hgQ=; b=kFzV/lm7eQ9pQ6DQKy1/am0dgt
	o+RCcfvhZXqD2p6ZtzoFU8DsncTgFCV2MTsRnU7vrp7WEFuaVR/qSNU818aroROs/wM/PySvNCp+K
	/efCFrRNXbsOfMz9iAakuR11guGux5SsEodAoQAqImH928/HXqT0bDT1eGOR0pz23hvjrEhE6DJYN
	anw6dGe+3q/bPUBFlEOnQ95RG3pE25wn4q0X/hpPrrrhTvEnFvRbFPzxUlI6cG9P/qyhlvAxpTPRw
	1IQPXRtP9SZUBA0w1hsxXUsQ8yVecvWYD7Ul31dv0Lv3Q9JXj3lx8rKNp4S0rqm54qazsus2FFnUe
	3suC4KsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37qt-00000009j34-0WAk;
	Tue, 22 Oct 2024 05:54:43 +0000
Date: Mon, 21 Oct 2024 22:54:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: advertise realtime quota support in the xqm
 stat files
Message-ID: <Zxc-Ixh3eTNI1_SK@infradead.org>
References: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
 <172919073112.3456016.11369324005013611455.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172919073112.3456016.11369324005013611455.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 17, 2024 at 12:10:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a fifth column to this (really old) stat file to advertise that the
> kernel supports quota for realtime volumes.  This will be used by
> fstests to detect kernel support.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

