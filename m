Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B1E3CB2E7
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 12:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475228; cv=none; b=qkEgWjxQ2jujf5GILdw+bC9jBLo3pSzA5Q5LXJ/O43IhqTeAwC/jRVPEMHXB4Y2Ug6CSFo93A2nvIVDYY1dfVNYd6lGXCsu7KvDejK85S+5MiD9REZhPIXrnZVIMfs5b9SWtGQX+FT/5i/l93Bgt/CmZVo11+xvZVKg5Rf43gL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475228; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3BK3lR30pQQYK0cQXvEKldtT7JuNgdX3Lgc786FQzem18PxImI+T36PVpcvUlc6fHba9OkycHFRrfyt6mbts2FSdVCGYPfd2Yl89yWzT1f898W5fF/WeDjUmCdAdtehqxJP6zBEbKcl59W+i2TeL2/Qf5e3Po4bhTAlySYad5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vGdlBVr6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vGdlBVr6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vGdlBVr6ZxG5KJBvwUkDqtEdd4
	QlmHKmTYF3Der3TmVp2GPXCbOBNllLhe+YDRiDjSVgROs7FjfkS0c5ffFT9xvzlz1xD2Ixk9oRoMW
	VFJxhCHTueuCKSjNo5eEzOdP7GXHNJBRZ1xlgQT+M3mZoTg3ZaqpnZj2KZv4csLkHH1mTRhp1aN9A
	BxnhCWLF6XUMvJ0AUM/ctDfKMn6uaBWHZg2jCmxEiV4X70lVCNLOQnW54mmA0RUNc/cQxqAMK26/r
	Ay4ZiRAz/AYHzUondguKBQrUlPcUjhBghV0ZrTALHtRBCVV4oXT5cKfkmJ9l8Y7+JqpqXTst2vbVg
	MVkkjlPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6SFe-00000006UWu-1jzN;
	Tue, 15 Sep 2026 12:27:06 +0000
Date: Tue, 15 Sep 2026 05:27:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] libfrog: add quotactl_fd support to xfsquotactl
Message-ID: <aqk5mu5os-yYL4Ag@infradead.org>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484899.2108717.17872277106848553305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178936484899.2108717.17872277106848553305.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
