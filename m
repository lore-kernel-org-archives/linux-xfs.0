Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E0313CF82;
	Mon,  5 Oct 2026 12:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205058; cv=none; b=HLe/Lrv2Azb687YNZE5Np7eKiJkKHw43q129zsE+ktuMHVyxKTyXBIys+g2hf535hh2cuNJdxE/psQnkngAvKb5JWdmnTDz+TbB+wEEPTGcMed+afIq2+O6HPWxVNhSCAgyEWHgeGZ7YR+X1fzmP2khGFUOcmkGSOsvm+WFpn1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205058; c=relaxed/simple;
	bh=BoUC1g65M3UpkFfH+TZsc4FWW3SoIsOKe6DMC4178KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+/k4m5aDmrsylywhZQha8CieV5WcGh833pwzirdiv8EJb0HqViXruTSlrLE1LmScrxGrA+uhHRAclKQHBgXh8MjAZZzvMbW1Lqt9wCJz6/XA/VbG+yUOIwTRPHtY8KF/uXd1y0PXduBsqROH/JcN3YBFruFaIwXCCCYXEMFSwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nc80p8HZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nc80p8HZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YmN27a85tClVMxg8X5li5R2z+HfVvXXfMbjJB0fDgsk=; b=Nc80p8HZxpT3Epyih6144+3JQD
	vZDSPMBNvIp8ngPJqDA2WSPtrx1KqPBgGSngfPRgcBC2On1kk/PyY3ZILvdgCE9jpKwpHFF/dmnL2
	LAyjFGCX/8NM5gcNiEIam0oc2t2CrYbUHSWL/XOccCBZv/ZeIK3VfuMYv2jvOPcO6m/yWMZaFYmxQ
	PDspz1AOP/XNx8MZdHiJBpOquRYNICfR8TSytUid3+J1DXYKsWTcnL6hRHTtYJpTtFi8HujD889pO
	Xlu3Ec0zB5H3x1QWVkoUnBJd9PMdnOqY++cQWJfqlBXTKx/JKPZyrcsh3QGdc7HjE+yUtXJtQwscu
	Taad3ntA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiG8-0000000GRCQ-0uXq;
	Mon, 05 Oct 2026 12:57:36 +0000
Date: Mon, 5 Oct 2026 05:57:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: basic functional testing of media verification
 command
Message-ID: <asOewOC7zcaNVU_X@infradead.org>
References: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
 <179060965824.790984.9346083899208929049.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179060965824.790984.9346083899208929049.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 28, 2026 at 08:36:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Implement a simple testcase to check that media verification works on
> however the scratch filesystem is configured.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

