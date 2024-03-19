Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7AF51C3E
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 07:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710832996; cv=none; b=e/lACK4ov7IP6e007yplpe4pLojBeoufGYAlTQuPjyiFOHQJAM205Ia1OpqFuLEFxq2WWN4kw18sWZgZIT+jsp7qY0A8dbVw4/Asm/9CBpGKZg0tyZ+mMuQpkFdiDvu7UNxz9Ti87I9Y+P8OmvlaLrhtBst3uprh79g43i/tpIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710832996; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=td4E8q20VTihUKndqrpdSnkSCvJQRjicnnctmOjwT4t+O/d/PrLGLcc0KOFzISkI4whFf9zpXTIdJszqc3m6gKJVFyoXfPeWLoKEdKy/sifWjVYEGJcCApSYYy5leHDsgap7OP5uMDokRZrDNYoykvUJ5HNUSa6OU8qhikI7pn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Dst6lqj6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dst6lqj6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Dst6lqj6rdy/L6b6NOgTqIWQas
	ycZ6uhZrGnPsdKEUNI71aPCifxOoIZHcjr8q5zAXhGaMd+cqaowNq2GaW0mivXaJoQsEwD3s9ZeNQ
	9+i3cwB5d6jip4YGMEC41O+v0LpW5h7KARGksut4tP/FLs6nKGvRreSV/MnSa20vDAB1MQX4vwE0R
	TNJCPSgvTL7Cz7+ySV+vwiTG2adLvAI2+DQFyZnN5nnrY3SpHs39VuIp4YtuRiTeYl2lsyVr5bEWK
	WLBst6kA1dvrvVEIib52LFwNvwXAo3uC3e9eyFOTiTjIRjnlFcYnQ9yfLL5KZMfH1ZQ7T0b2FqvKI
	mBgATeHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmToX-0000000BgXR-15OD;
	Tue, 19 Mar 2024 07:23:13 +0000
Date: Tue, 19 Mar 2024 00:23:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: buffer log item type mismatches are corruption
Message-ID: <Zfk9Ydfwe_QY8qhh@infradead.org>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
