Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA5F2F1FF6
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 11:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762516619; cv=none; b=dGizPBrG61McCXqSpkebV+1DF+MO7qTGn7IbtlQkeKzXlWKlJvzaoYuh815zjiYZX6SoV7EyHbw16d5icekXkshVKYPi/xrz7NAH1BdHuUt+qnP9NqeLvQjB5ZNNfpONM0T46oAoGTOJFj258JRPjVSIXWFBwo5Na9ib6xsWkzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762516619; c=relaxed/simple;
	bh=VbKKNes2Ocv6zHZ1rFNFXu46kLIxTEx5rAjcclCq2tY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amWpuRGqVtDT/OhEKW9iaGyWF5fhRv82IkDPF/CiqWOLZWQd6rI+ZT1RmY3y/9P9ThSxTlDHuNRGNilbAZo5VrUQeOBPBQIIG7GuSdKoeHXlcV3njrkxdYI282R2bLH8rWXRwKLaESoccUKW1VMzlMYZE4i97oSFtyQzomYhqlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wj3rO9yM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wj3rO9yM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=crM93Jt6kQoYuvHxYK2y+8UNU2aAUccPIwM5sQULkPo=; b=wj3rO9yMobbl5Vsw0eQOOordTi
	XhpLLDJWp8MbGwax3Pqd7ECQZKaC2Px+qSe/qEtfb2g4yq9Kyq+kVugUNWvuBmfxJ6rTHKWQkXbRO
	Gqcsm8uZdK7MqCNkoR+1NCq/ScjTzbKEBB/zgfrnHnXLD6YZgyeezXth58Cg/6YUNwrSoZOy4IAjG
	RdNIicONb3CgrHB6pA5l5swl6Lyv1bByAbY0J/0GcyIebNCwlrZhBnInEr7uO50qzTL+tFos9tE6W
	3Yx72P14BkzqT5FLmc0fmIOsTVN5VdNHudbRsIiSUlluIgtM8C5ApkPGrovL/ArM2ZS5LIyl3hL0U
	SP/93rgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHL5K-0000000HFpS-3yPB;
	Fri, 07 Nov 2025 11:56:54 +0000
Date: Fri, 7 Nov 2025 03:56:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: generic/648 metadata corruption
Message-ID: <aQ3ehsu2NNNsjVQh@infradead.org>
References: <gjureda6lp7phaaum3ffwmcumu5q2zisatei73o6u2mgvohkkk@n2i2bwltxjqu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gjureda6lp7phaaum3ffwmcumu5q2zisatei73o6u2mgvohkkk@n2i2bwltxjqu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 07, 2025 at 10:42:21AM +0100, Carlos Maiolino wrote:
> Hello, has anybody has found any issues with generic/648 recently?

I haven't seen anything like this so far.  I've also not tested 2k
block size any time recently, though.

