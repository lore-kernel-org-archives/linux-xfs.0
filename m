Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E68779FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810000; cv=none; b=MoeJWmQG8vBkfrOrNycmdNktjRDavn+fNBnweMr3FAnkHcwXYgtgg5RP5I+xDd8nYu3b6fdQ3zdE+pssvXriIFnxBkanOI7tvZ85DRDQXEDK6qr3usnpf+nnGMBvk1ihoO6MRVIeUCJ5G448O5bF2FrdH7/FEoqwKa0TtCtrdQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810000; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7XSl/1eVhTJllutEwomVkKGSEceoAuBfIVEjTOpmsFaR6JMfkUcFWbEdOxVLysy5Ag/IEH7u6Eq05dPgA3nVHpSi0CqYFtStyKwtW2VZxUDK0A32QdAYFVTm1xXazlj10K6VOivqcdBGRdqyVgsryhoy/xl691tIq92A8INtEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zPRBKiwn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zPRBKiwn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zPRBKiwnWLeOKToWOA6S8zaA+3
	n51K7zRrX58EUdkx5WUGm5m46mOPr440FsLJFREY3v3fYVviSpstLZTExoQMg4Tr4gRyQTOc8ATxw
	Dp8buM8xykmD+82/MMG0sAHZO+ECPKBaxGozUYyzbvDcqDFbH+O83dS7IzKP8F9ei2VbWtO1m4kIH
	lZLnWAqON4a0UfELeQ7Bma5/jngOVIJJhRgdvdp9Oc7mWvYlq6adIvlfkbG/24gvOqtV/18e0qvcy
	rrTrEgztmPLfl8bF2SYNxs90qhI1+7x+V/5q4V39E/3unS6/kbIT+6bfMwVSAwKaMTFQ9S5iEGoNU
	cA9fiIUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtBP-0000000AJfq-00pE;
	Tue, 10 Dec 2024 05:53:19 +0000
Date: Mon, 9 Dec 2024 21:53:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/50] xfs_io: support scrubbing rtgroup metadata
Message-ID: <Z1fXTrLyiUE2AtID@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752510.126362.13394045053539281164.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752510.126362.13394045053539281164.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

