Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF07BA2B
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 01:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381597; cv=none; b=LdbvBBBOtxkHSeH8ZBq0y9M5pWHnNsGtaMuzUSIQZ5nWS7xOFvI+zG5H4Xj2l+qAPAjiOfmRzV1WJCaXh0M/9PVduCC196ciUEVdMnFLYIwcX4uMHulWCZ20ukjOoWZ0KXUMDPwFD3i6+qwvpmgxhyX4ruSKelrw0X2J55fGph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381597; c=relaxed/simple;
	bh=3tmgq5NTx1i+ciJfc7Rco8bghI9TXj8pPF1BaFFrt0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToVoHJ4LNZA37s17KX66Rk8YIMvyfaen0p0FYrzykQm3ZF1TRMa8Nf/DVDH1H204SHiVXFzfMYuvjKTlZxdhB6ld7JNqZDph4I1D9X34NpfntSEl4yWpul7geK1IAi06OZfOK0BD2cciqIkn0bTmU08ph9e85c0QWIgnX39a/WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pBBO27KV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pBBO27KV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3tmgq5NTx1i+ciJfc7Rco8bghI9TXj8pPF1BaFFrt0A=; b=pBBO27KV1ST0IKeylF3tSVa1Up
	R7CZV6IzuTaB5b+VHEWXytdpReyoKQZRobUsc6rxwlw68RFcrt2ni+PYCux1DrPK12ADl1BSIX8+x
	JkL267frFhXUfYAdoUuDN22wLW8HP3E/bax0MpJN5/WrFedS5zZ53qQ9Gf3o8sgZod5qoMy5yP/Xz
	TFlewX2dU7KSqigOli+KWHUx8FdIjEJQbx7Oi8beyyCSxO2RokT/vrXTVqEs4WYhX1ORoJ0ypZxWE
	CfJkRvL45kNMHxgnMPZn2C85DA5LuUZoFNTuUQmKZlaTiupD+oT6zG525n2ginki+9q/M+bsGygSV
	BsLWZezg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaNu-0000000Cccm-31oS;
	Thu, 14 Mar 2024 01:59:54 +0000
Date: Wed, 13 Mar 2024 18:59:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: rebuild block mappings from rmapbt data
Message-ID: <ZfJaGhIgMvL2LBG6@infradead.org>
References: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
 <171029434369.2065697.1871117227419755749.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434369.2065697.1871117227419755749.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +#define min_t(type, x, y) ( ((type)(x)) > ((type)(y)) ? ((type)(y)) : ((type)(x)) )

Should this really be a hidden in a .c file in repair vs in a common
header where we can use it everywhere?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
