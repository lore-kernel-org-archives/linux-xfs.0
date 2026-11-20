Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191550;
	b=Lj9GFwKT175jaHEzehXCqba/kWAJFLUgXzFiE/mO28z7o2pYaP7Lnx8oKEKRG7AKbOGm
	 OmxWw0FjwX3EXMGUU1SVcYJOuzbJaAfuUmObskp3TTNua9fc6IyDscm8egrD39usKBx3O
	 kEpk38/Ydzvn/tQ6NcI7S8AfCxona/SMfuCbxpJGySy+AHZmxZi577KV/k0+3iXu4vW7Z
	 3AZqUYdpiRQO7dsdxbO/Jx1pgyTI1eDmuxfdwBglzyBUOVNYfNSX7HowMSb2gzXMtvu2Y
	 TPiEPASe9MmuOVU4HJfmhEBcABfiIZpn3a9hmp3h+aTk0fTwbPPvSBLVq3nwhFkp6nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191550;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=RYFWHarT3vgGc8NXoliWPsSv0p2Cr70tk7UKwNP8zQw=;
	b=2uGKn4L4rWdFi2A1+hMhijcgBPFQnkzuuQD4Pi3pujlZ/0s3oMeVKQ65mI1VPcRcirKp
	 8WwGbq/YhiJcCk3q19GRqn93IYofClke/SwiWz2n6iZoIRqDe7zeXJk2sOHkAMUf8G1eD
	 +gTSCLON8dT3MCvgNjSoNLjHgVg9E3yBEyKwQNDzfSJk2xrhIBxqFuQWIjJ2YxVPuuTpi
	 RfyE8of5WFAs2YtN1/7U1nIbJhu4RiT1GhXIzemhM1LS/Epq/pW6tB5qZSDbrQNfF5DQp
	 OtWTFn5zGe1VAjYkSd0QckT3pWvwXeHhGUBLCUu7dMLfyOWpFsZaCFYpmH0U24NEm2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=FrgdFp+1;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63868606A320;
	Fri, 20 Nov 2026 16:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63868606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=FrgdFp+1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RYFWHarT3vgGc8NXoliWPsSv0p2Cr70tk7UKwNP8zQw=; b=FrgdFp+18oou5B08b/mgB/EH3M
	fxny3NWTMlmISxa1EKMRXWElZ7lHiZLsKxByQ8trfPwwO92Z8p4O7uzeWAJBIyMNMFoHtZeQ1lX/q
	0l+2ZPE/ASYlMta7H9NWee6vkM2nDnXWo0ITb2/2Do1iYFpjYYwm/odjk8Mat5aOZ2vwryMHsKyDr
	LCcVLE/obutGIklrWy1v0nMA3XmdbE9+CeSWOvZGOmk40WVGKv55DQzx6/XkBIKG7AOvsrcYH2JKZ
	4iw5XsTFmSoquRsyQ8VhGmxCCuLzEAq+7R1S8GRIXL/WZh1qmbPR6oASfXHXj64UDcPiYX5HXoyY0
	iDkPFPWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURKP-0000000FXZ8-36Ac;
	Fri, 20 Nov 2026 16:19:09 +0000
Date: Fri, 20 Nov 2026 08:19:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ian Rogers <irogers@google.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	Elkin Cruz <elkin@google.com>
Subject: Re: [PATCH] xfs: initialize error in xfs_getfsmap_rtdev_rtbitmap()
Message-ID: <awBy_Y4-dt7ujpGO@infradead.org>
References: <20261119170449.1513687-1-irogers@google.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119170449.1513687-1-irogers@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

If only the kernel build systems wouldn't effectively disable used but
uninitialized warnings by default... :(
