Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE56B3B47EF;
	Tue, 30 Jun 2026 06:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782800034; cv=none; b=a6NuCMWLM1qA+KkNqQLJ6RwFB8VODzj6UFAYjaboHuP2O4taPXRmqTNJfwQl46Uql1y2Rf3P8C4J3EvY72Vsu3j1crCOdhBfbZacZyTYXo5jwLfHtdwzh9sMq4PfZhPXMSSowDhD8biaZlmFO+weBJX1LmT+Dc9EdrOVFrL9AmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782800034; c=relaxed/simple;
	bh=Bc01lfYAcVRIYsr/y6zZtnCQpZFWkdX+6kg3Hobpn8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVykFR5Qio11hzAq8jL8K9SBTIK7BgDSdElCOSyDvNqZSII3gEN34AxLE7Y02p0guefvWLagO/xQed+/wR4Ia0ikE5vxR/1yC3u2RgKdA15FOOk86+604JwDYGE0eD072zPWJ1wGzN3EL/FNlxuEh6IjYNCA7PAtS1FL8WUhOA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ve6m+DED; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ve6m+DED"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bc01lfYAcVRIYsr/y6zZtnCQpZFWkdX+6kg3Hobpn8Y=; b=Ve6m+DEDkPbM1S283T2X1xo12E
	caxkcOyml2m/gXsgH7+S/Ji109myhZBzFWnAh5xU8QKWRZtHuRFXbmShHLah5DKYttmHU9PVBjS9z
	oszU81bgzaIsXZROzYiwYbRUI5GaOrTKWJ6PggxT+fQuU77iDbetjq/Ra+ybxMzoANA1g6D+ninfT
	V2ld9cNWgv+Ed7hKP5kUkXwdl/zXpJB9QVt9ANa1TZR0OXvBIBvdms/AkvFLipd1/Qj3qUsREXbjT
	cfIA9aXAgFgDcacIS4TSFcFPa8SE1T4brdU079V1PGUmpS/PvMJm+K+vxeMQNQWhgO0/xcG8BOx/1
	E2nHCtjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weRjB-0000000FtE9-19q6;
	Tue, 30 Jun 2026 06:13:49 +0000
Date: Mon, 29 Jun 2026 23:13:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com,
	pankaj.raghav@linux.dev
Subject: Re: [PATCH v5 1/4] iomap: factor out iomap_dio_alignment helper
Message-ID: <akNenZzIz1vT2-CW@infradead.org>
References: <20260629120124.25223-1-changfengnan@bytedance.com>
 <20260629120124.25223-2-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629120124.25223-2-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 29, 2026 at 08:01:21PM +0800, Fengnan Chang wrote:
> Extract the alignment computation from iomap_dio_bio_iter() into a
> standalone helper so the upcoming simple direct I/O path can reuse it
> without requiring a struct iomap_dio.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

