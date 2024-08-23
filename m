Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D743BB25
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390280; cv=none; b=SUzCsFNCrMigpi1GogEqwEUrTFEYmWGBH7kC+TRPxQok4FvcVdpA1imutPTAQAr3uYmFkQ17WV+ROBZ1anU3k5l4mlHxx8EhQMOYbJ3B9OGTwIUAeJGhNdjG5W+mJacmrIYz0QYBLoF9xMyf3KLY8zxEoXR0JqEXeNUJcE1rswk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390280; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6OzvjYfT/KKjTNZO1ONvyAMjEtwpmZ4VfDcLDYVNrYArzMDR0v1IpKfGJZ6J5BORb1faFnY+kpqoZsGpBDM1uh1sVurW+lGGEaJY9iZRJsXZ1O/W6tMgCInE8dyjbCxFsEWtaHIjTZkPbRRzC4xlLaDKZ3IafIW3PMF5c2Cbsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SjSYeiY1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SjSYeiY1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SjSYeiY1gCBOfvXAydqPWEiTEU
	HozCWfAuerDjcDG1bIGkhFG6BZHICMMGDOMj3mwrGkPpMWAU+FogVprD3IUhMOp0VQTqH2uqKN/m5
	JNyfXdHbldwW35GKw/vE6QvTwBp4ipe7Yd10ajYwVV/QQ8fAwYdJ4EOcDZIzrVgS3qhVZ54m2Bdxt
	J/JJT0KKIPZ+dI3S9Lg+ZZrCSx3O9gKFf+f73PuYqCQAgOqM2DH7p6ROxy0ifOAm1jJeg8uwnJCUU
	/u6NIcJzEMHC+dKh0K2oqrsPIiHYPrMPnRSrCOwmFTUD25zZfS0HfdFN82N76C1+RyO7OK0FhCKIU
	wZ7eRVqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMgQ-0000000FHkK-1J1v;
	Fri, 23 Aug 2024 05:17:58 +0000
Date: Thu, 22 Aug 2024 22:17:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs: support logging EFIs for realtime extents
Message-ID: <ZsgbhnFbyI_0mJ6F@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088816.60592.12361252562494894102.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088816.60592.12361252562494894102.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

