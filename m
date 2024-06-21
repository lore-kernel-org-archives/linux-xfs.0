Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC62EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945057; cv=none; b=Wy92nTDC5NGAhdC/kI1xKCG7ZljYhgmQ9gPFuzNjeJDP4oPVOLVZ4Y0jVBws0EfANEcleBWXZ00aIe9gpCmk08XaalEZemD6jJS08FF0iTfzgrnn9b05BwrPl4Vglu+7Hp2IxqfwYe+r+byJ9BSw8auX1BtHd69YH8mqoNb8b7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945057; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OU1TyqItNgviOg0+CQgoG1lWTQJS3LtX4xd/b46I+pjQidS2Eeis+1R0dhs4wT1hn7BWV6h9wlaHkoY4bcxAdTK2e4Hh5TSmg0HDjlDt6F08bxPrL3LjmRaI7iZPyLSICBS7/MJqGfjC7V08VEELCzSNBhNcNUNdTD6LhkBeaaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ssR+lcSG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ssR+lcSG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ssR+lcSGxCAyjPedjqHAYv6e63
	Sz6nt593Yy7woFFMIx3GpT7YBw9yQL3gFHQDl7aUWB8S6A18gdZvjBosqiAk5wWlHXt6u+F6k/ahw
	L5Sy2lsFipj30E/vN0PhB6wJra8kbY26S7KkYmmlk2kcdPGlJBpzBAjfFJHmK1MOT7jL2Zsr40Qwp
	68nrZ2QKWuLDBgk0nACkl7QgQT4dZhnJ00uUXjEXIlzCmW5P3D2nVbZmoDeYkgOT9Y+ja3JxdwJO+
	R0y5ZmUqkWu3VZpslCnp2b4+QlfrH4uC0Rcx2EAXYkoUz2e3Ozrm6gpAidt3RIuKb0pjqNhoUKv5+
	1b5JiHtg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW8F-00000007fsE-23ZQ;
	Fri, 21 Jun 2024 04:44:15 +0000
Date: Thu, 20 Jun 2024 21:44:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/24] xfs: hoist inode free function to libxfs
Message-ID: <ZnUFH_9FqoxYK6pv@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418208.3183075.14235352813217094391.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418208.3183075.14235352813217094391.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

