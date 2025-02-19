Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E2E1BBBDD;
	Wed, 19 Feb 2025 06:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945101; cv=none; b=Yijy8ygqwiWEbaF8C2nqpTqeUcBGFp9+UCJ9LklXLicFm3EUW6m9wgEIoB0Vd2AggsM1s9N36yFM9PeDcYM5mXqoW2eea1hz+1fOVLBJMDoeJPoR3G49JUFKWoeWiMXtJRGZnPXNdF2qkOwaOR1cNTrsQCgdgPAYzSYLRDuhgLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945101; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMbUEPnGESZtuMUl8oCPeneGh1JBxtpl9WbsCs06MX6woouYHsuRLvAtFrbYqQ05pxHPoghSxwx6d+OX7CGY6TkIMAgeMtN3gM0d9Ta0u7LDvPstbuvXc2be+bouGuGzl/D7i/ueLo+j/VBamZUleBLsJO7QuBeY952DBDj3dqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yY8eIQem; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yY8eIQem"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yY8eIQemepAMs+EVzq3h8dPmGg
	weWEEMx1f8aY8MJ/pjiq4d1e3up+rDGOxeusEHcUCfIWbKvtAzCInkCn+M9lqlKGPELQOYH4NcQR0
	0vmpHgGsSBGN9W0IVhqJOuBSnSf5tQBkP+9ItsvFB71tAlpeKmRhFWcvpmi1GIEcK1hgy56vTCdei
	O2xm1VRJDI3xT5Y2gb7KogKYdWpbzcij8yDPhNeegXKpVgnK6p5HyqvndszkYySuQ9EN38rWODPz9
	3zGDScoHH9D/rjR5Po5pD/phP9j/j6nczvmKNZXVOG/xcBx/nQ/SJxR7H57SG9MpuR4tWJMkwlQol
	BErPa9eA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdCd-0000000AzWz-42GE;
	Wed, 19 Feb 2025 06:04:59 +0000
Date: Tue, 18 Feb 2025 22:04:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs/{050,144,153,299,330}: update quota reports to
 handle metadir trees
Message-ID: <Z7V0iy_9s2jBXl01@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588153.4078751.7769762708703860765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588153.4078751.7769762708703860765.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

