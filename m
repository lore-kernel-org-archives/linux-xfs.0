Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7798493
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390041; cv=none; b=Uh8cdOUb6U/StyOkaVjdDnH7IYPXruNH98+KJ/suUklNAIVIcnU0KFP7WgDXlJK5RXpmgArX588ypEpZ7BIU5Ia+Lb8I1HOROrN7Bxy1EfckvXQhta7UxCDZh1A/2Bag1dTINFKDkWqLN2DkeySop+NvHGUnOyFufXr88l8VKhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390041; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sg6KUx19Zlc0/6s9RJE+nZW4MSq7nScFSC5ZsXwCClPSQlYCXmE3PKYFKlsIc3M0g8Rl0hbkMDaXRcivu5sIfLtTUc2ASqPZKC9QomHcNhDO9FIhMYRuSAA/sFlnYaaGRIiLHbuiNXCJyiEpxkg+f93KqstmNv0ELkRgO0IrBG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kMSRZDvm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kMSRZDvm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kMSRZDvmxlaleRnj/+18iktAFA
	sOyu5qpf98Vk+M1bZ00PLfNrGJhG4GvzR99zOeCPiR3cdzi5XWVHLz48Vxw0OeyDyLHK4kakkXilw
	Cf4TZFCEY1/bR1dCzzSUMEiPqaKJMIGRscT1xiEVegdQ15nV/3VmDt4K64VVNppX/SGUMInNhc1Yi
	nn9zoGtg1gP0o7HcCSXnb/p/zKNNktWRkjLsifohV5DItK7gFjloP8GC9WC2yS7xue5WI+WK7+5F0
	QNtLxmrOi26k+uhcD357CZ9PZr43JcPaDTt4R2epaQxD04IuxZWMjy4hVjF0GFzbX+K7B9aZGQUk1
	+0zLl7sw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMca-0000000FH0h-1TFZ;
	Fri, 23 Aug 2024 05:14:00 +0000
Date: Thu, 22 Aug 2024 22:14:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/26] xfs: convert sick_map loops to use ARRAY_SIZE
Message-ID: <ZsgamAgX3H-_dMUE@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088657.60592.5339918682104748305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088657.60592.5339918682104748305.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

