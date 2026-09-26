Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB636D9E7
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 05:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790402366; cv=none; b=Y/tYtCDp7f+fcVPlxHaXML4XH3KRQ/9paaLt14PeGJaNweb9ZZkmnklmP1Vwh2EQB4HumjxVDZXEqRwoqCb+pMlVRmBvSMuA1q/3joM8GiNUHE1Irh4hRLN5MRRuiOn5xkP/i/0uVKkMX4DTjrsR4Sd4a+6qsbE20l6CPAXcQBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790402366; c=relaxed/simple;
	bh=dsId0W/sG2pi5FPy+2fA15mSBaiPVPjs0pixQqh1AgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSTL2s56JqpuLqQs22yVux2ILzZheYKzNlgjJt8EEkAhfUJLx01MmKHv6NmEB8KQR/MJCX51/IgBnJbziS+48SCBm3Bby65oD8256VijllYC8cuVPidB1dqPAy8aXGzgw2EQTNV2Z+mr1loEbV4cI/NVMQ7va8qBifHXpLJ7roE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5FFC468C7B; Sat, 26 Sep 2026 07:59:13 +0200 (CEST)
Date: Sat, 26 Sep 2026 07:59:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] libxfs: unify buftarg handling with the kernel
Message-ID: <20260926055912.GA20636@lst.de>
References: <20260925051336.2997014-1-hch@lst.de> <20260925051336.2997014-5-hch@lst.de> <20260925223716.GS2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925223716.GS2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 03:37:16PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 25, 2026 at 07:12:50AM +0200, Christoph Hellwig wrote:
> > In the kernel, the RT buftarg is set to NULL when not realtime device is
> > present, but libxfs still allocates one, and all users instead check for
> > a NULL ->bt_bdev.
> > 
> > Switch to the kernel model of never allocating the buftarg, and check
> > mp->m_rtdev_targp for NULL instead of just ->bt_bdev.
> 
> Might want to mention that xfsprogs now matches what the kernel does.

That's what I mean to say with "Switch to the kernel model".  But if
that was to subtle I'm open to suggestions for a better wording.

