Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BF9136352;
	Thu,  9 Jan 2025 07:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736406060; cv=none; b=gnP06Ff1x5qCUA1s9sMP1+vVUQ2ijxuleWqRynDDEOsX1SaGvZ7vEcSQyGySJndzO1pnJclwkfiE9iDfg0yfsB2bAwooPUlYtHpKzc5ZVs9CNCsBJPK2+ONbk14kGtNkSaINFcCgR+IfmVVfBo8e137RQUxgy5JmlYrNKh+zQqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736406060; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6WS08L+hHVbwhtKHvgAYaWDGw6Qj6tJp+mGMaaYSX81fzY4xxU6lqpSOfQFfhAQTvE0wsBky/EOJ7ZL5ZFsg1+7BmoBRnTY6C2lSUNvf2rliMiepYaMzqc5lw4n6hEGLzdfNW25bDcaumKiKJ+QRvHbsAhJfUSmZ36DNyFNROM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C67TGKXt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C67TGKXt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=C67TGKXtx/XZj1/l/uZAlaq6OL
	9aIS89PM9Tl1ysNOWoRIMbUYXM2Jzlm2k9CwDyl5TJy5FHkB+oj4wTJvCtvPMPcBG9/F/QZnXWQDK
	RwBOWdIqKYxpc8vUCewWKZR20yvNWJtNpbupdQ3t9hr1V53Evg9ZV9v9tM3UA2DUWdRFfyD9y89QJ
	uemJtG47HIK+Xj3ezJQzgGYZabCoAAL2+GeVlWnsHNYbc+eLQTysaTW97oopcW0Dj9TB4OjKN7UPq
	oH5tFzYtvHy43jOBEXuQ8du/OvHfRBaMXci43Pa2iiMqCFt+VO8hLzHr37Mo7gXU/M+yxvzP+W+I6
	0dNDaviQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVmXD-0000000Aywu-3OG7;
	Thu, 09 Jan 2025 07:00:51 +0000
Date: Wed, 8 Jan 2025 23:00:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] iomap: split out iomap check and reset logic from
 iter advance
Message-ID: <Z390I1F-RKRBgY5J@infradead.org>
References: <20241213143610.1002526-1-bfoster@redhat.com>
 <20241213143610.1002526-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213143610.1002526-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

