Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2F3145FEF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 21:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722375812; cv=none; b=LWq+59BuEwflLbXxi1q3OaqE2Uv/tBJP6yhj5t2T5P/PhB7ya22TeKYGp3R3E5VtLc/DOnmJhfvHqo0qxeYKZTuWu3zwXALE+F7IrA/hr4v85CcCFCPsSeDHLb32GFT5JLuWMFzFAXssEDbIXXikZQTGl+DNXFZM3kN/yebKvKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722375812; c=relaxed/simple;
	bh=BEgdo+4Du9Ja2K+4UB6fZwUlgMAW7UL5AtSEDNpukwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XyT4iO8R6Nwb1+oT7sYenr1DTNeyGhjaI0bcbhYRiYtHnWxX7Zj1VVOckB0dSwy9Hg8Fowjh8Tnv9IZ/rHdVPtVUXXrhfxbk9VH1IDRda362MffAIF1jHHLFPbitfhYOZfX5pDsZCQ7is27mWreF70zlmZDK/EImXW+N21PJwUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TpqhD88n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TpqhD88n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ShsTUYO9nZFbglfGPjs2AMKsSRNTN2HSXAjSY3DM5vY=; b=TpqhD88nSBF6X9FYNfSyNgmjP/
	MlbkO5/XdOxoenVQvlxfCqReOBuRQStvt7OnVF2PhDkclnlaB3UskSuNRkuFmazznwl7BaSv837VG
	D3+jNUHDmi5IVdfr0yHIfPKU6wLNg+FyqHjYd5ySf+lJLyI7qMC1GoEN5y7xU6/c0PcjGWliwzjN7
	J+JTzBBuD5x+ZGbdI02yAo4O2hArgYhyXhJTaGUGHSmqapElHSEVsYY7aK6TzfZkF4K+2g18esUrw
	As+JpLexUbXuSirc6sp6tT7lMytJZ/Lo9sD0mFkPhfBSXOBVOKvw7zfOJRyWwhCpHjPCdEJTgNyQ7
	EyQeJC2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYud0-0000000GZMP-1NOQ;
	Tue, 30 Jul 2024 21:43:30 +0000
Date: Tue, 30 Jul 2024 14:43:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_property: add a new tool to administer fs
 properties
Message-ID: <ZqlegsIRSwlccyX8@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940678.1543753.11215656166264361855.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230940678.1543753.11215656166264361855.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 29, 2024 at 08:21:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a tool to list, get, set, and remove filesystem properties.

Ok, so this wraps spaceman.  Can we make the property manipulation only
available through this interface to cause less confusion?

