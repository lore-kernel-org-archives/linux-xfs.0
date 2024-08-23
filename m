Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157C74D8B8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390256; cv=none; b=qCM1NWn4MUvkyjNlzFhmUO6ZMb7uIH0yADsxxbPrdA/gbcBHsorSjHkWaTE9PWR1i2hIm4c4paJNoe7+R1F2xFnhiyoo7M40y92/iExfk4rCQA1+NAYMy+q9KtrREQKektI1rwmJuqmsUgZ61cDZCzOJU94KiwYTCpSfsPwnLic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390256; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsWBH2iZbaH7n3ZG6dFOXJ+wmG2h+I6NSCuZV+uKsbplMACjc234r00bTa7n0PozTUCvHgCN670Q+kKpDQ7MXwxtqrQX1g7kQHEtuvhCVNLrtI8dV38DkjzlveYyoYfpEOJnyEttPhUtwmHFcnAT78C8+H0+2bCJqLEo2j8vMZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1foKO6+E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1foKO6+E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1foKO6+Ef3Wd3/VPvAZqPnE8dH
	BJFdQY7d2t4QhjGhVzm2Crk5ZS5bUqfByOGM4f5ugZOGAW2L8e3z/YxLpeSO/eWNfo3V67LFaNxEu
	UE21LxlCuIrE9dPKgr6kxoJhKrwmAHFameuzkRD8ZlvpNWHwKv59qW8di5S7CLs2WG//+lC3JxWbW
	kupcJr2YNp0QrR5s8nvEsDCvYaw+0pfVqNPI0Jo02H/Fa4nSOoY+8Em3xjtE2eAUf4RjEiRxbUUnN
	g55L/lcR0flzLiImuP7JS95KoipwXJEku4x3ZMp5s0QKpCcsnMJ5f7xpEiamYWH45OcXnhlfioWDd
	nq/3NKbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMg2-0000000FHfr-2vnA;
	Fri, 23 Aug 2024 05:17:34 +0000
Date: Thu, 22 Aug 2024 22:17:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/26] xfs: force swapext to a realtime file to use the
 file content exchange ioctl
Message-ID: <Zsgbbqm01_CWQGBl@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088799.60592.14096570051407234430.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088799.60592.14096570051407234430.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

