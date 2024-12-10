Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CAF79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806404; cv=none; b=lJIM3BI2ovxBp5huguC2IrHyKTVGg86GBrXGsqbcDyoaXyW4ZHzKn374C8d/G4HhPLaUvCGSUYRujwAT+Qrf4KjzIW2UriAbIHXzBihIQG6Z2UJSJav/JT5rNuFMDvqG9Ln35TTkYPJbAoLxkc0iGTCiRPZC95gyJa9R3tMNn6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806404; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjIrTAC9UvTMQvLFgW9CF0dblncPSnRhahYoKEbvB07HtypPBM2LRY2FYVRhKVSurslJpGg82TUgZPo7gIOgQB60l0OKfSOpTOYrQ60ZHRFSNLAh6sN/C0e78k9w6qo0s2cSYsZzhjmkLVGBFztd1U6R0vzUh/jUXKo4zAL0zcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P89/stYC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P89/stYC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P89/stYC1pKaFX7eXSelA6myoo
	a57k74Z/6mEM/rGUPlDtHyDDDaB6uQk7L9Mop4J/+5KnEcHqdQVgV9AmYSnUQRR7ZXhXVsurmig40
	BJOkjsYFMtyjizByHqe39DGqm6tYh9jLhoJ1KkIZHs/Ztkb6kb8Bfm4mKi2cDPzmP1GFt1pcRvUcI
	162MykuZnZ06vAR2FoQaGJqSy4Ep1J2553kCGpMuZmfkkrpgK0A1tkU4i0BmqPCgoGLEQMBDMdWlv
	j+07b4T44Xov5jA3gO+i3/h97Yp4smRzUXdKhbUN3JTZa3+DkH30pjqlKgGg4NICBidw8y97b++lv
	Ttho21hw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsFO-0000000AE8n-3Tq0;
	Tue, 10 Dec 2024 04:53:22 +0000
Date: Mon, 9 Dec 2024 20:53:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/41] man: update scrub ioctl documentation for metadir
Message-ID: <Z1fJQmmrlgwF9e9n@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748315.122992.15391921034612434643.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748315.122992.15391921034612434643.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

