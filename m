Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F3517CA1B
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104900; cv=none; b=cVkSx+AqcjQFrkaEL2j57TR/iAJLP6TxABNOXa3Y0MXYv/D7+KFhBPHJ5EQIzBDIU1vzrjD7QJBRvAEDO6wAaaLJYBueBa2i0nsgWqkMsthpqSYWV0CKquk4JPJTNxPxqt0ds/Rm3MoAZJvYSxWVjCcq5brvUFLDt+6iptdOXJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104900; c=relaxed/simple;
	bh=cDqdBKuI/EaXZeqNY9oQB+xA3OyZYcYPmfuxC20EqF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KE3n3R9tHehxuaI2v1vNMm+Y13O2ohQ8fpgOWw8SF9wpXKeLgEl1qHxWjv4c1OFsNRLz5ZpxVgCnAg2tjmEweDI7UCX7KabqT+ZZ0crM1HhPhXD22nZRZA4DbitJqQ2pIKU9vO605xL8QwuI3UADn/wJf6gxETUj+MLNWomZeZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M/3bVUoT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M/3bVUoT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+gCtdLaOnR5CFbDvhdF2gmZmnG47s6SIbN4gij+P3kY=; b=M/3bVUoTJ6eZdwbVhez2xoHAVp
	4Gf7xn1ZefZA+0MJKVkixWX/U1iIDDnIJdeI0wAr7zZJSsi2/+W0uIyzsEnVA6JLSzkW8FyxqyllD
	ivg71ufo2pbkPhclByUIsRNBkD0KgdcEGmnGLBe7EcgkONHOVQBK/5exDRdOtXLs1ttlt9fTX3lfw
	VDJZ5vu96w7eR9nhEqGSVt/xJZ4lcbZ1dRevm06UVkLtNALmSrizxyviioEmn0/+pTpg1OiTKkqJ8
	nV4j1j+XXkNV93pQuZZ0GtrO1q5RtVGrqgQ4mKV7VFkM095DsPIjFFB88d7LJA0ZLdUK6b9fj0S+t
	Ji1f5tsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LJi-0000000A7m5-0T2E;
	Mon, 28 Oct 2024 08:41:38 +0000
Date: Mon, 28 Oct 2024 01:41:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs_db: enable conversion of rt space units
Message-ID: <Zx9OQo1uhTgy-UIP@infradead.org>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773819.3041229.79394639669103592.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773819.3041229.79394639669103592.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	[CT_AGBLOCK] = {
> +		.allowed = M(AGNUMBER)|M(BBOFF)|M(BLKOFF)|M(INOIDX)|M(INOOFF),

Can you space these out with whitespaces around the operators?

> +		.allowed = M(AGBLOCK)|M(AGINO)|M(BBOFF)|M(BLKOFF)|M(INOIDX)|M(INOOFF),

And break up the overly long lines?  In fact I wonder if just having
each M() on it's own line might be even nicer for readability.

> +static inline xfs_rtblock_t
> +xfs_daddr_to_rtb(
> +	struct xfs_mount	*mp,
> +	xfs_daddr_t		daddr)
> +{
> +	return daddr >> mp->m_blkbb_log;
> +}

We already have this in xfs_rtgroup.h in the latest tree, but
I guess that comes later?

>  Set current address to SB header in allocation group
>  .IR agno .
> 
> 
---end quoted text---
