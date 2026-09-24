Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267B934E761;
	Thu, 24 Sep 2026 05:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229118; cv=none; b=QdTY/+rgveEgnJaX5X8BQwD6Juh7kOSiqYwDqIi7YCcbOjXixhAggTJhPXOlMdhcODzhAkQ8ao6hgLy3gyzF3Kd5mhXRby+r40FAodklbAGJZNDKvfp0U4k3+JNky900WquFb/Wj+SgstgOQO1s8kJD1ARXmrlShsXGWYpq42PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229118; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Izljb3A8HrjQ2vOxY48Zclex6Q3Vy/HqHtjBK72ivRlOB8kbcW4/UA6B+hY9H4cxT1m8o4+OoIOQ5LKtoFLGh2zEsxnDNiDYOe7xsJJtHYsCij/50STLwzWBY+Z50icN08XnGpv5YWZircbhhWRRWcgQinfef5y+UMmClBlkAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=snTIeCgF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="snTIeCgF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=snTIeCgFaOznTguhOWzNkBgB82
	0bM9Ce0WjFVnUoWpLQZ7zStYTBK7f6p9z2boMo9RA1c2cJtL0Ba2NmiYSs+my0vhmcvs+X2DynVz1
	JcERHpbC2buxkA6Cbrj/tdCCzf3w0nGghYXNlWQLlwB9kwtx7dqVnp1TsG9dNQqlu2kxN0vsQzjmD
	/frVArl+TMMnh6JuDhppi0j9/WEVQulG35VFAY4QnMZ904w0D7yA4LYkDNeU0UuoUaxsxWqSpRZsT
	gFcZtnavqGKf9YFGcwAr2IJEn/Z4q+FqlwVDtumjuOWFMLPhUQbOWCBioyBTQv8bmLXpotr06Zb8S
	qCOFnhcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cNA-0000000A5eC-2bWb;
	Thu, 24 Sep 2026 05:51:56 +0000
Date: Wed, 23 Sep 2026 22:51:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: actually report corrupt xattrs as XFAIL
 during cross-referencing
Message-ID: <arS6fGLG8AUwtgeU@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159713.1875436.4353102591557994166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159713.1875436.4353102591557994166.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
