Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563463FBB0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142164; cv=none; b=jvthPKwvbPTCGRV+tGjqh5Bqz6WMP9KiiHudGEly0ZC5gFiQmQJLp3zqb0B9os888uurxZXvj+vonNG66qy0n54SyOAWL429cwCSJ7XltEPQIGcWZPt/rlwGQbOhghAszo6rzSIeCI5OVB/hDpNeiqmgJVNqccSn5pyt2gUUm1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142164; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3AilUTaP1h87nv3HUYmlDCWJpVZSxDQl/uvPcgXmXwtWgq/BaYAx/Ngqn5PEUvF9aqRcCtU1x+SMBSYaiisapghF0q7uKg8iGSBIZwBAGjGtJ/VMC3+KeSuH/G+55N7kGPyqQ2Agryqt0d9tdkNVkjEtx/nYwdbnjpPfd6k83k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kgsMQ7DY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kgsMQ7DY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kgsMQ7DYkRYAkgjZtM+6O8chap
	yHUhyYuoM6QLpun3CK+KfWGw5QXx0rpf5CeMK8JTEKOVhtJMaAoYVgTY95BJ6hMV/m/SyGwP+axT9
	SaJUENAH70wmmd2A5s7TvmCgpdivA6TDJ7pqpXlyCDvip/EzSW1nwtgI9ff0DCfl2+sjK9blI9T0j
	2Md7qfnzsjWfR/thoh63a6uvTyVyeWpLcohi0PanA1BlnJjfLO0OTEeHnCplen4I+8Hju2IB8yMqC
	dHx68NwHo/tzBVRTBKRCxTEDA8kzW4Zj8HpRDFlq26y6LhGnhsrv1wdqaGme+h7cSxiD3oyt0sCjO
	WiD9h1Fw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNx4-0000000AKtq-3M0D;
	Wed, 28 Feb 2024 17:42:42 +0000
Date: Wed, 28 Feb 2024 09:42:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] xfs: check unused nlink fields in the ondisk inode
Message-ID: <Zd9wkjimfevyMcoU@infradead.org>
References: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
 <170900016059.940004.4268890665789625903.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900016059.940004.4268890665789625903.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
