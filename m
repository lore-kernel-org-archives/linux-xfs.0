Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645E68C0B;
	Wed, 19 Feb 2025 07:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949470; cv=none; b=jc8rMXisBQ5ZPJUm37wdXYvwyhB5uHHco/yJ916E4AKw0BjaoaAA0muSF3QWqjH7fhdlJ86zVV7noNDUBMegSU78GAmoIhmwJZ964fzkOIMiJPP18ZkfB7G7mdP7TnnMYQOf8Bm+rMpNtmIEk6P1OPqP1RfuLZBWfZaTfPKqI1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949470; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RqCtI6FnwKYLhrM5cmnk0mbpRQA1X3HmcpQYcsTkVRfKdL9FZf0YhqfZ7aWcfmHZLyxr17TefEKKqf4jxfDT0VVAQxu5AREJogf+y94eUvueNTAHTlJg9cMODQNpdxJRRfjXG8OIryGZxTpPNhqDMopqPHuhnhLTn7eRP/Alx4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3y42r86g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3y42r86g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3y42r86gwJeViWafjAUE/6SE87
	Rx1dTWlnaOAOQO3U6cmZOqAWKFgktbBW861fMmWqPLtADoJV1N03d2GoXB8lrzhM6BIIZ69H5I0ma
	19FNuu559CKf8rYRaQf1EY3ygjramRILj4vluQLh8CSzvdsl0i1a93pKCTQsWmvcJBfI3lDt/VWB0
	5u6Mqxzo7DPlIMluK0TTZpGLwlZugzWqikomo5cuO6thG3Rg+sVmnLIvPeaY8VlAbQ6jhHqPL37GX
	RaaNml8k2qtvz2TTtjzxNsaT3aKlnqMOlyTJsqHI+TvLAJ36xLlXluMdOc1Z27ADj7xiYaAs5eo+n
	Yi7wUnJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeL7-0000000BCVp-0FgE;
	Wed, 19 Feb 2025 07:17:49 +0000
Date: Tue, 18 Feb 2025 23:17:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 14/15] common/fuzzy: adapt the scrub stress tests to
 support rtgroups
Message-ID: <Z7WFnaYJrXWEcUPD@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589437.4079457.14723541149706284576.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589437.4079457.14723541149706284576.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

