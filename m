Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D04239E67
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909012; cv=none; b=j6tanYUZBeSunX6D/ETUZN6PyoaCGqR/Y0kiWUsGUru+h78TXyfqOPuotM+VHbIeCbh3hkopHo0Tb7kQ2iv4W9Le0lbIL0RxK5hbGBJMTzGzHhwMcSjXUSCtNnFXSS8eAptmAw7Uf+oYJTF66pkofmkx9igfjeaXOiOa+BrUDns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909012; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8QI3tUbzTOiCaky2Zo0Ago5qww6nkwonObUNCaHOoNkQjxMWaMDOrU++FHNb7E4IdDMd2t4RbqgKaDOvZ+u6hL48luXT81+qI/NbBQu33JJTxS/WHWMT2NKt1g+MYRdqAXQeZ+2OkeMM+c/mrO6NXuUODjFV14qAiE2ndoQ+W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IiCLOQV/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IiCLOQV/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=IiCLOQV/+SrUWoLFMKlhEwdWAU
	5u33vIQLio95nfPTjfVIgw71hbFAXxcTg1/ax4I9ZoU9Zrx7V308G9cp7Pi12IudLs+xT0BXUkPky
	yexuXaBVyPqu744wacdd8rO8LioItn/a52faHAWvgHeFzA0H/wHATodhIus+7gsTL0K/tbdTUzjWX
	ygCxSducXQzJD83Qy5YuZm1YiAIYde7oWguYpg4BjRQEczBn4FQCy+5uugZsXFh20uzRApgoRJsbT
	t+VO1O/sYCFsSMooX2wIpJqtFoqmCWT6brJEj+2oDNloBAfvHw9ZvoparMD9vn1rZZwArOEsMqIt8
	1CmzP7+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulQ02-00000007NAP-2tAB;
	Mon, 11 Aug 2025 10:43:30 +0000
Date: Mon, 11 Aug 2025 03:43:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Nixdorf <johannes@nixdorf.dev>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] libfrog: Define STATX__RESERVED if not provided by
 the system
Message-ID: <aJnJUqa9O4rcfMPZ@infradead.org>
References: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
 <20250809-musl-fixes-v1-2-d0958fffb1af@nixdorf.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809-musl-fixes-v1-2-d0958fffb1af@nixdorf.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

