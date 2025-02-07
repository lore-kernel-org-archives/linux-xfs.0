Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51395FC1D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738907684; cv=none; b=GLiXmEuYIU/kCPV2g/kMr1l6MyM4Wm+sq3nnlEWTcoVwjiry54UQuhhjVv3sPL8Ub/dzXQlyM/+AG9t4ZWI/3KqV6/5Qd4SMP8/QNeL7zGFfUPAL7JxTPljtT+oEv/KXtzQRc43Eta6XpX6+xxGiZ3xnsAeOkB0i+6XiY22rnFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738907684; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=baGao8/MuwmNUvIWkiw1SKueELwoEjnNlacmGCIJz8FYm8luQNXs4MiJ21JKuxhv4C7sknOeeZ3B6HAymETAk01IPFnddUweK21ex+bBNzZkQYQ8QSGOJV9Z64LJAPpvE2U0vACPni4vtEJDn+rP/uDiiabqrde40UQ9Kv4hp3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eHrEfGRP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eHrEfGRP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eHrEfGRPs+x1qjDTxtAiFvyHBa
	hlICKbTzusX1LSqq8UkiRUQf4y8+4hk026e7g1Cijmk3XlZQxOYFtfhSGoYa7emZuBsHg/woqMh8T
	3u4DYJ6uDSA8cpCcppJVw5mUc2TYhY2DO1WSTpEkUEltwSnpwzIQdskgdgTsso5QEbuIwq+uH5S+v
	DRs73KmDHOtxB3NrfS0Ol22aczlEvtzZlJnmMeBGVq6l3HqxvtF/9sQeOnkjgO05oyL64gls68PDf
	AHROzMIvaL4Oc07lu3wirceIPRcFxwMTd8zqvnl4Vc5/nVILk4byUZX15mr65p7uiYp8aIA1y6vC0
	nXg1FdTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgHK6-00000008Qo8-3vlI;
	Fri, 07 Feb 2025 05:54:42 +0000
Date: Thu, 6 Feb 2025 21:54:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/27] xfs_repair: rebuild the realtime rmap btree
Message-ID: <Z6WgIsKVvgNrM2rN@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088417.2741033.9023081378772193251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088417.2741033.9023081378772193251.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
