Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C07022ACEE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810749; cv=none; b=AZxvj1ZJra34qqTLXTuzpVdxHXyk1GlFZFeJ9EWVl4uItwlSK3gCoLZSVBAbfoq2EuBMCpvcjTEZcP1P6Dl3fJdGVs6rogoUBomGLfaBx1KrIK5Qt9KnDruuNMjmFgQ/uJV/xbhx1vgXDK6AmmKmrBy723fLiRYa9CxCu95N6Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810749; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y21OaMZ2yn51vabsOhYGI2tHghDZNmaBRF6p8akRSK+hfDhcgonGpA98q8oQuS1Ddon/DelA7ASB3/FXQJ8F/eh66iWgOVoGGDwrHYnz+Oi51nFUQBo3wvc/hpQ93JuKF/9QqkBlTEg0xS5kYq+fscDjD9+8ZkbB1oHZawXhXAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u3+cf0hi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u3+cf0hi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=u3+cf0hiIlszofAkFiLytCCkQz
	35jyXPN+ZCBTARTq3ioHSWs24qDF9zKzZOa2UgaRfwi5kO9d+x7HluFh6sYW3j6RaW4Ei+Vd+iY44
	FHTVtgM9vqq4Xobpi6fkBi2vQ7CuftxmJJvZNgIwuE+m4kGj+GSD/KBtJra3/YaIXdZSBwspb+my2
	2DEJpKrVBysN7CIoNnyDpVZUw3Id4xjNZMNM54oCB5cKyl1Xq7E7DEXq9OGEORSO7b1u8EWAV9a/S
	dK1n8tFPUutkriLpwkz+VPK0Cp+Glm5ijBmYhA8wdHFK020U55CpyX8/lH5yRgY/OThgZIUaeFYju
	WWF1VJvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtNT-0000000AMmD-3YNX;
	Tue, 10 Dec 2024 06:05:47 +0000
Date: Mon, 9 Dec 2024 22:05:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 49/50] mkfs: add headers to realtime bitmap blocks
Message-ID: <Z1faOwOFeQpnjZKr@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752694.126362.14739180271347119851.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752694.126362.14739180271347119851.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

