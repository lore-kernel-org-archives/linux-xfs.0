Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D2F145FEF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 21:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722375508; cv=none; b=qcf0t02EhpInWJ7G7eyOrG/FfZGEy8TsAaczNJGHyi9P7MUuNjEB1aapsVJOEX2lDNJ7SgTPZftNi5ldRaMxwFdq1MBYYTR7GOCzA06+NBUwEWzfeJ7e6IOZzQ73yCh7Xo7L9qHGfkiXRUKhtRDruYxq3GOpgrcBMshenKelDO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722375508; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMziPo2HSYyqh8BH4kb/k6qpbm6LNfREBMdzmvDVWyow39SgnMcjAIg4jT3cNilRUCzKKKjvKL/5u6QAkrcd7p/o3lX+5hm+Xxz3Ahx5Ks5bVafbZtVIpYycQqn1b+m/O1rS0NTvyd9HfWjv26m+SVjT343JO5XTeu+NW8U4/+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B5100yve; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B5100yve"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=B5100yve9Ln9/5Fe7VWkFWpHFB
	TPLsb12JpuACczumOg5rWhPBaV5lRAQUImqBPzoje2ydr81nLH9dvJfjywwm+c4pPVZkjq32MQ0Mh
	HSABspVp/t7bu8ilm5GIbd9ldv9AMs25HAYi3yug9pvHBcyV6jKaQU4aw64UyfWbzy2L690d78MR/
	NTTt2C7QfxXNPGvjErXeu45Ttj5iYVf44iEg2ByUHJvNXpfcVrwWl3HU5P8DNGr5hvsyM2/wYDha0
	g3xB/hwcwjwFdhXcEwEYuBG1jmWYxdOTobyd5rIK+68wvKF30em9A3GKonTRXB3V4Ir4LI0t0xsWj
	kSvrQzfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYuY7-0000000GYyD-0yvf;
	Tue, 30 Jul 2024 21:38:27 +0000
Date: Tue, 30 Jul 2024 14:38:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] libxfs: pass a transaction context through listxattr
Message-ID: <ZqldUxv2XzTd7s3J@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940647.1543753.663518227766891037.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230940647.1543753.663518227766891037.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

