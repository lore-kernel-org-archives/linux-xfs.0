Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94C939FD8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390368; cv=none; b=MZDoJWvid3ywahc+h0kAzEL7M5yfS6KILHx/z0OSxHAlI7cp03GCV/zuPO75THaOHeyLDXzJj4v6FY13Jac96IMBVaIonl+g8NmUhIdgu4a1ETCJ7Tsd0Jxqmj9XmVWmvamDo3uaM3E35sdAJhWOgzLJNDZNiV3c+nvnupC10EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390368; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6TF0jqsvEjEvtKrwdd0WvdAU8+RqmhG4ALRPuFBD3xg76dQAE3/QDkkubuCS4MjQELGUgEElEh9lfYKYFpgw0zZqf3IiBbPMoa4g4mU4xBzed78FGzO6KL3Fv1tetUj8cyt4bcvb0pLBQs7sIdaezwQbuJtv+4+pOzYNT/CHLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=akTnV5yi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="akTnV5yi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=akTnV5yi/VyZGqvKsjBi45yTKf
	SN0SqcLs6zd65zcWSfPg8hr/x9l1v95n2Dauj5fCjEIImnyjRoy/chiN2m/seF++a4ubMXQE1qWiQ
	0ePsSzltE7o6Uv6280xfArifCcAawKXvOS6PH24Az9N2Kx91TgbPCb6oY0gu1896CVtkFYnsLtAy2
	IMxR7JnMNkASXdTRApI7FZcIZKL2hCIfB+Js0rvjaia9d+F8KlbcvcNnokC4IwbJk/bR9x2r/wo/I
	O4O7kwVAbRasjdKfLrJXOuBWB7QLhAsuEe4VeR4f3Wu2FtHHb/Agz68Z6uKI8hBdTr7iPwGX7GbPp
	bHJPDAGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMhr-0000000FHqD-0dSQ;
	Fri, 23 Aug 2024 05:19:27 +0000
Date: Thu, 22 Aug 2024 22:19:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs: scrub the realtime group superblock
Message-ID: <Zsgb34tuqzxAu25z@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088921.60592.15232505394298064283.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088921.60592.15232505394298064283.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

