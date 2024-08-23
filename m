Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6717C3BBC2
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724386396; cv=none; b=pqqLdfOlAfus7/TFjOgUhcoFPsTt8tAOzjgdIYFuZK5L1mC/C38dQxtiwDfasMBEdDKkQmNsjLUId4SoW93ixjgytr7nKq1luSc/CJuGfTE24dQCmQ4/mXQNj3HXmR+PE4OKMu813r3ojmYT5z61dccTuR/MZHjeoAV2RvAq770=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724386396; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQeIUAG9UIXvEgepHDrtNVkVOBFsaRgCTpcCv7NYyhPL/12EFgmcvDKUSINxhyQ4fbr2InG50M007NbpDHlNtLN7aD6eD6g8zKyZhA3+u9NSgLKykt5hSwbfInnL9E1OHdCAyMWYeYpHz46sum0ZuWIW985TKEJpyeqe+Q06gc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4PqdPRsb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4PqdPRsb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4PqdPRsbVur8TbM/LWfC1BDSqq
	CbAo9VmCVMPIVMTm3sJalEpFxkAw+O7v6PtjNvnOGFHclArkoFP+KTGNa8/aXcRMmq3hLAh0WnW+/
	S251T03RcuE92w1ydQMCbd1E7+jfZ9PVAUimWuoW6jSGcSxcHkxc026V1YbCbGO/8cINRuIGkTjOG
	OXxbxZzckWypkAlTlKZz9VfTJlOBEfBoaPHVUUjBF0Se04tUkR38OxU2j4XNpMd2rYJH6Nk8ESu+k
	VFXg0U2CkuYaOZEGkZsUhqOem6xJhPKylIzCa2EavsKSvAIbpCdTEEpMRLBbte9I0BNApLlidbtzV
	jRZ5VEQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shLfn-0000000F9iA-09Jg;
	Fri, 23 Aug 2024 04:13:15 +0000
Date: Thu, 22 Aug 2024 21:13:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: pass the icreate args object to xfs_dialloc
Message-ID: <ZsgMW_yjlxRk9b85@infradead.org>
References: <172437084629.57308.17035804596151035899.stgit@frogsfrogsfrogs>
 <172437084690.57308.4842818086745573630.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437084690.57308.4842818086745573630.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

