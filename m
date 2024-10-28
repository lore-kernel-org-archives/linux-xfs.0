Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66DA17CA1B
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104732; cv=none; b=fDeBzJJvBeHohufrvneJEoufsWxm8xGhIH6d5GQriffnHW+qIrptun+EID+p6eYliD3qQcCpCKKc1BOFaOWbkDlQuky4vR/N9oO6PicDSMXooAacCj272B7ZB1E5h474pNEvyTmRZP6k58qlnp2TjaxFwrmWENrsNy2NAKwVYGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104732; c=relaxed/simple;
	bh=0gPqJri44pcEO8nJSbUPYdO2wcFhcHDOGPbz2u9XfPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbZZ1f0vS5PHDpEPRoiDlgby8Uq/PRs/MSQL2r/052x7jaZ+bIjc5AMsPDwXWoanrZxyZMNMOHBsXCU2PuSxYGTGFbFdXrX/bjvj/z8NOCJGIHg+ijv8q7eSWs7LBfghutFQfgQ/qe7ux7NLRwSUjBTO/IkgbZR9IJpBYX07K68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zKf52VP8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zKf52VP8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G0Zts17cIHLc1b2Dt2XIYD5Ijz9+RrakwGftACwVH98=; b=zKf52VP87cJUqM0XH/bHrczg0o
	kzEreHrx0Qglwr61navj3s/+2GtVMBN0zflusxw9js9skxowRSz5511DDuXxJzXdecad2LA48K9Hl
	dXbusaBc+4GFPeaGxVx+Z5tI7lydEDDAuBA3Uq5R+2T3XX/L3hgzvdCLeb/Gqj+xrcyy1F45sx4LA
	EMesM0wQvFefQMdBr6NCaa0n6CgNiu14GwDmiOnFHHiLdjMjWXDUVj36gAIVsdrAIoRPFgmJqL05j
	YWRvjhghl1+ZbN0eAGAIea/SNfRMM81aWHefWYmXCmjpSQMyeHT+flxOdSEuYTlxwyv2+PAgJ0oJb
	CCd4coZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LH0-0000000A7Sq-1x5i;
	Mon, 28 Oct 2024 08:38:50 +0000
Date: Mon, 28 Oct 2024 01:38:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: access arbitrary realtime blocks and extents
Message-ID: <Zx9Nmhag3cYuzy3e@infradead.org>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773804.3041229.7516109047720839026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773804.3041229.7516109047720839026.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
> +	set_rt_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, rtbno), blkbb,
> +			DB_RING_ADD, NULL);

xfs_rtb_to_daddr?

> +		rtbno = XFS_BB_TO_FSB(mp, iocur_top->off >> BBSHIFT);

xfs_daddr_to_rtb?

