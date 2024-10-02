Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD92E28F4
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 06:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727849022; cv=none; b=NQBzEBF7wacUAmjL8OnM74vsm+OYyS715u0AtEHZzqwyHCT855WCyzIuqNX8HPvosDcYMgsKI/vp8V7LdXbvh4k4Jne3lwSUU4Y2QNLBQPrT6ksLLTGkLpgVVbrHE2LCxReV9DXOFOZ6e6FFgfems6rM9C5Qx1fFYMLLgfHOSTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727849022; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvslZOzga3v2ioIpSjnS2dCj6pXIUrXtwc2n00oSiqvjAntAir6uRdU3Ys+ecfowvDBYkuuRUa/29yiA6VbjEi4KmZAbSoQniGPu05XmjjVhh3nevmCMAKzV4H3/aypNz52KJRMSg7LDljah857bpxmOcNz/AFuW62MXmBeYGVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fB+GFB/X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fB+GFB/X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fB+GFB/Xgi4libkVXUAJTRWqfw
	mhJGWK+wO+ayZOfpmc3XalCagEFsMbPV7aol+HmJz7LfAs8HcedNMJydVDxTCRzVMMejM9CXzrChm
	h0VdHxUC8RjOx7AWUGwITy+msu9PXhfHnQ7KpW5ul1oW2GniLLLho8/w2mrehXTTI4g10gNqLT+Q9
	wk/gHwON/zd/qYk/rrjaNsYsphQjDEHTPxwLcDlLXhmrDDBSfpc1ZAWP+CCkznaiOC+xo1PSx3qaD
	4GB7dKDG09Zq1Xf/Xsz+isR81rk3j1E4wGgU4+pVBhhVi/HD3UHbvv/gAERiVRfRAuup61mU7WC16
	ByejNoZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsSa-00000004tq8-2As8;
	Wed, 02 Oct 2024 06:03:40 +0000
Date: Tue, 1 Oct 2024 23:03:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: clean up the rtinit() function
Message-ID: <ZvziPD0oTVcZm0eZ@infradead.org>
References: <172783103720.4038865.18392358908456498224.stgit@frogsfrogsfrogs>
 <172783103735.4038865.17704760289119478.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103735.4038865.17704760289119478.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

