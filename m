Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A915517BEC5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081350; cv=none; b=u1J/su5Xg/m2oVtfvXLPFwUnmQNkQCoiACsx7cUSoiEoSAneEKQCtv/Sk1eVBht2jeCBmye5dj/lRTowdaXUuHXZZdvxddRluBrgiF5Thnjdyv/s5AzVme2CaGOaIiY0Yjpmeh9aIB8yESB2tuJCCmjaE46ApU6Bdy4VhIz5wNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081350; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/lO7QQx4PDP9DZnIuym0eluIkVcGZhcMHQ3Aut3GToTpIG8Wg0MKZVCz5Y3GzjLz/DHLflE7KhMTxbN0fOs/dai5QoO910HhFQ6Tbo2i0kTQyImqmGJLgd1JsK0yLi9mkXxiM3wtRITpfSFDaVQy4N3zZrDWEKAx+dAu5MMR50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EBgaLuun; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EBgaLuun"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EBgaLuunuEdNt+YpJxCmXGlUcC
	PwX+GFk6hKccy35IWot+XgkkzXrGHux2Ix9FNgC1oHWpOm5AJTnFmtOY8lFp7Jfw+PSs4tHL+AFm9
	JTHLGSRY7TNL7GaU1h50kT+BJ2o1cpZuxI50Nt+0A4MTf7QO86kGBoYxszepBmNzl/RpIDY+YgsWS
	7NRrV195DzgIVJhFd9W7qiudZm02ENAMEf7Sojipb5xNqOXLVnNkmoF7edAF61ol/aajG5ilkv8wT
	UFUdEe8jySaC0AgLhrS+YktMkro6/A7OvRmM+AJE2o3jPbs+bu9zquqWwfhEdBIP8rUWx81d5pKsm
	IiMWEcOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1m1-00000003DDk-13DP;
	Fri, 13 Dec 2024 09:15:49 +0000
Date: Fri, 13 Dec 2024 01:15:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/43] xfs: recover CoW leftovers in the realtime volume
Message-ID: <Z1v7RdLjhn28P5Mk@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124944.1182620.501748507607212517.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124944.1182620.501748507607212517.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
