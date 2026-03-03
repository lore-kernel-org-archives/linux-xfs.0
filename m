Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E8D49252A
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552852; cv=none; b=o0tpYO79QWUCaP1zDbFqvCp0g1s2vuK++S4vdQfTJgF8OhWVUiUwa99OTl0Oi8Uyfdcg9NGtR+xpNKKKdpAkQJIbR+HqLFpQV4lnzLHI63xzBNxCMkuAv0mYGnE+Wg8h0dG5J2TvSeIH3NMWBoZKGjzlKNzZP0ahwIJXTXpan+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552852; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxywqX0SkazVU/I+CtsxMRNeEbVJ1tIG8Jpbr/dO+bIsY8hJ66VZub6Z5fN1dPuaF3OFu5wOpSmZ8HHwcUdYq1cxyfIft9rsgVtMRxRlTAOgMmCyb9YCrkJYcUGHhz+eGCCEufLFeRARUDDmYAE1kZgdextASuLqxP+KlC/B0hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EY1tIgq4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EY1tIgq4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EY1tIgq4jEvLnXlloa+TpoYOWy
	9fzTMnL1IFkzFuF81eZw6cWr/tFsjMBfbDgCO470GVgV3Vx9qQ03Ztxtl9yZH1K0Y996h/FAG9Q7D
	qLjl4EbbSP3nByt4g+DTowOLa6AQYWsGg4a5Qf4Wwdo0PcBa0sXY5SLxZN0GAk4Dh99gKs1iDw7Zn
	PxW297mgkmSCe5h4c+Rlbw2wLhTEl4fQ/+/uGDocyRZ24tbg3FtRuRcDbMivscGHAsv8S0u1NEo7Y
	R1gvlZ9MZDartHKbecbg+dPyji0B9LzEuGLI2bk0kU9Q9P+mVvio+lM3V/WC1k0irLDZNGyVFJe4k
	cil5lZqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRy6-0000000FSXF-3dWX;
	Tue, 03 Mar 2026 15:47:30 +0000
Date: Tue, 3 Mar 2026 07:47:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/26] xfs_healer: enable repairing filesystems
Message-ID: <aacCktYVattDFFh4@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783472.482027.18045832701670000143.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783472.482027.18045832701670000143.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

