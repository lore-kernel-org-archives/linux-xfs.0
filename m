Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68D263D
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 04:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720673099; cv=none; b=ilVOlLws464dPoNYh8CeTc5TSiDDAEWUq+lJctBMMRxjL0DQ0mgtl2jhjEYIcsDlgQBTD7BbNC7kV+A8CxmfWId3xT5Y7/SCNDaPC18KsxVxgcsp0gnkSSaqd7+hU8bimccm7dOIw/ixM1KygTDxx2I68nUaHmeiak3O7uKPGwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720673099; c=relaxed/simple;
	bh=uTwdKVJJRkY3HkCYx3vpHXbXs5vWMvhyxkOQkaLw3T8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pG92W12RoxPwFlRi3KOijeLETY1W5RNUh0lpAmdtotQMRm8AskMw4WPz7NkQ/7L3EjbzFunVliwZIqSmNVJV8qMM7VDJjJjEm6XrHzr0z3SA2q1UdGbuunQTkU2FKUKrd2vX3oIzaNDJoPHc74+59OguD15497JeNoDd01Z4Akk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=du155tz+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="du155tz+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uTwdKVJJRkY3HkCYx3vpHXbXs5vWMvhyxkOQkaLw3T8=; b=du155tz+ldKXEUEEgJ8U1Ef0BD
	EdAxIINpOlolT45OmEMBrtmzj5n+NRKL5N+S5OwwXALXAAx52RduEVkW2E3Xv6Xd4AFZPgzXs/4yd
	dAccg5MhyJ4eP1WDFeXGxnwaTtkf3hVqfnHl/oGn6yE/6Qz8+7tQXMJLVTyUOUedekkp7/ANOjhzr
	bL1ioTJe2qvS5Kd5D09cygBzKTi2nw8utKCxbMMICl527D8WOVRFWnl2B5S2Mpc0FwqWzZbcbYOc+
	jpCejeQKmTcaS1kIx9haQCapni2JIw2k2rYJXy4T2vexnrKZI4CVolgvpewsqjcNKXkX5xOfdVoHf
	856jH0Og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sRlft-0000000ChRD-0nuF;
	Thu, 11 Jul 2024 04:44:57 +0000
Date: Wed, 10 Jul 2024 21:44:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update XFS_IOC_DIOINFO memory alignment value
Message-ID: <Zo9jSWWE4fP9Icdx@infradead.org>
References: <20240711003637.2979807-1-david@fromorbit.com>
 <20240711025206.GG612460@frogsfrogsfrogs>
 <Zo9Zg762urtBzY1w@infradead.org>
 <20240711043614.GL612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711043614.GL612460@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 10, 2024 at 09:36:14PM -0700, Darrick J. Wong wrote:
> <shrug> Is there anything that DIOINFO provides that statx doesn't?
> AFAICT XFS is the only fs that implements DIOINFO, so why expand that?

Because it'll just make all the existing software using it do the right
thing everywhere?

