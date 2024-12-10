Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C00D226179
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808242; cv=none; b=Hvlivjp7vxmQdj3CfbCc59jdmnpghX8Ei9XVpWUu5VNMH0SQXJMZckaMX/gw1ajMO26kDbA1y8uV+WZfX8XCuyXeoOO1blngYea9JEIk+A+TU11yMXXFG19hXw3Ql5TEjbVElKnglwvQcULqBbE+0Pvc/v71hjpuKNoX16MMdpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808242; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOmzgLOLmGKA+IlhFBWNlESG8rZkhLW+Aa16nEp532hV8kcJuJv98Gt66nYQUd3nuYWFSkGi7dIn0W+/J9ZS7X+zh8A8AKey6q7Uh9OqbRe4gZcqyzXESoqAc0N4dFTQfF6SzRqGCOabhGNkJ1lzCfj1Ncdwc5WtrhCKs4UIZkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i61TnVik; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i61TnVik"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=i61TnVikss1gUf8Yu6xOMZK1qt
	n3qd+aoFKuMU78DBx//hjiHdd9DM6OvMZSZIMxBtV8AEk5aIXoOojNWIrmbuzRwD4OoTGi36FWse5
	ZihfvrTSJ3O928epyVgrMHnfx7dEjhxqVpo+ryxuO9RbmF+Oi+vrcJ9d45O0+UU8u69EYClxLm05k
	kRbuV0ehuXD64mQzx6yxrfZ0T1Q7QVfb+5DoMNOiB6nCIv+cBDQkJzXIo3F4BOGkXiQVYK6WSRYRB
	FWTAXoOlo/XCxu5Bte0PfwLGYKbf8HIPUE1geTJ6K/Y8wL5xu7A9rPlrPkZ66b2V2I9ntw7N+KmCW
	QRvZa56w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsj2-0000000AGyR-2nDm;
	Tue, 10 Dec 2024 05:24:00 +0000
Date: Mon, 9 Dec 2024 21:24:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] mkfs: support copying in xattrs
Message-ID: <Z1fQcDc-jiFfMS28@infradead.org>
References: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
 <173352749362.124368.16120119760449034051.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352749362.124368.16120119760449034051.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

