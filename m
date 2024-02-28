Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD72B15D5B9;
	Wed, 28 Feb 2024 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709136251; cv=none; b=ewh2OP4pjgqjmpoO4BYRn1A9OsJFTWzLe8CFOXyePbHxmMNici5RxB68sdXgr0q57PKDpwFLV+ojDhhzxp2X2h2gQ+CyZXdy0U/xEO8q0p6p1SdUS2itGuc6fyXGFIf/Re5d/prbcPS2p1pDQMj7UxD5v4r89y4rTNMPy3B0+4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709136251; c=relaxed/simple;
	bh=JOncQd7djyWyj0pYQHO1bQH6CeYed5+Z52UuZX6yiW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IiyPUlJ7P6T7ZAly5kWAkZJKKCsPgKspw77ttRxbuu/+kfOxnbUyyFsc/QAQBytjb8AmcsNvWZWkMGdRMdRl2KdwZT9FSMoqDt06F7c30T/mmno+zeCa9xLFKysi4JE4pyRt1R2+0ENrjL4P1ZJSFLmMRpHIctkr6EbH+ZjiBrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YEuEswzT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YEuEswzT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CIoiU9T2Tt79FPp3KY0c5tYyRPaWY724I7angXbZz3w=; b=YEuEswzTxXV03w252Fd8lNY4rP
	/t1DJ/3O3js+/jjZms2RbCYUlglxg16Q0qbw7Oxy7zVXWO7LTLzrgFqF4Q2omU80iIpnuiWzVB1bs
	5dKiE2GazGM3iQ9XvMemRuG6pCzkJh+QiMCe0LNAIXk7VIVqGsRauxjimTgt+bQuYCPUbg9GKaafT
	tQlHbwpiN0UFomWW0nUWiJaw0gZ557X9fIyVl4tLlnOgAcSMCKf4loDN+EaAkB+YI/vuJNF/pWLB4
	otCRBBkWK+HU4sVtmEmSbfzHhOGZIZwhCuja9H5kvuXSns9tWvKRMwB5sFcLQorcbpTM6ZxmM5wed
	rfAl8dTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMPi-0000000A1g0-10sY;
	Wed, 28 Feb 2024 16:04:10 +0000
Date: Wed, 28 Feb 2024 08:04:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: check logical-sector sized O_DIRECT
Message-ID: <Zd9ZeiWiaxncmxk4@infradead.org>
References: <20221107045618.2772009-1-zlang@kernel.org>
 <20240228155929.GD1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228155929.GD1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 07:59:29AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 07, 2022 at 12:56:18PM +0800, Zorro Lang wrote:
> > If the physical sector size is 4096, but the logical sector size
> > is 512, the 512b dio write/read should be allowed.
> 
> Huh, did we all completely forget to review this patch?

Looks like it.  The test also is a bit overzealous as for copy on
write file systems we can't do logical sector size aligned writes,
e.g. btrfs or always_cow xfs.  So we'll need to find a way to
check for those cases.
