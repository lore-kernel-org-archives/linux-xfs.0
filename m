Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E01B3AB5DC;
	Wed, 29 Jul 2026 06:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306942; cv=none; b=rnkic9btoBE6hAQQcDJDxJ4SYhcCx3nuhwv7C8W6k2gK+rBlh+RMmIvHoO817mlpDyIUnkRat0FfibPaI+MLcUW++HotxCDdDZdP2AviGnZ8udbs/l8BgQnIyspEa+5rUIWo4g+V78JRQh0AgpN1Ifkb9mucQ6u1vYz7LWcII3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306942; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrEYG7KVtmcXcwjwWai27LhzVDom2X7KQrostDmGgdniYZry6/DTfw3sm8XBNNT3CPwxhUK+K4ghaYC99SzSY4O0cVWx9iRQpEPbRTa1I0y/44rfOMpQBeIVGkzcRLDONvGmHzIWI5yJMjQeXw+GVDPegpBlFyLIOw21fYbbeUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AE3BE68AFE; Wed, 29 Jul 2026 08:35:36 +0200 (CEST)
Date: Wed, 29 Jul 2026 08:35:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: zlang@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, djwong@kernel.org, jiapenglin@tencent.com
Subject: Re: [PATCH v2] xfs/842: verify CoW after exchangerange with
 FILE1_WRITTEN on shared extents
Message-ID: <20260729063536.GC8833@lst.de>
References: <20260729025504.54586-1-jiapenglin@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729025504.54586-1-jiapenglin@tencent.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
