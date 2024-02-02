Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6FA17564
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706854708; cv=none; b=RlwKH65goU0E7L87LfgakNPI0AmkXv2VL8ttMe8MhKBQAwUvke1cLrto0n2/qh3UtydwxI1y4fHx0MP6QqMP3y89u4mQX77X2woU6NTCPXHIlIcC79NX2OkJG1laGYT+7Z2eNZN9IcXv0/PDm47yjAl8XjTdqiHQ7Nwi+3OUjRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706854708; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XjlJm73u7Ch0QXYn0WeVjCOwkmCbWegNOvp4RMEE7hdZfXO8jDTeK25QutBdb5Klf1Muq1K0Kd3YyENCoLD9qO3OZOG9I0MclfJYPK/hGy0ehUBMN0Jp0Yrv4NbfWaL6JPJU2adg+cJYJWhaeZz2FqlYD2/U4MBjctqq14Kwqa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cehZn8ZH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cehZn8ZH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cehZn8ZHhwfWvrEiTwCkdr/FeB
	zaDydrfmT86yVW5kCEMjfGnBq9uH4YhTTb2AMd625itScFNtWLwefJ/Q9s1YwDd7m9MxY2VFt+pXu
	KNhJHBqFwoSXhwDdb7+rD93N6dVwwJke88C9OLV/VuD7A+l74dLhAKZgf/SKQpbwxoXwvb25YvsQ/
	noNlNNJH/QyD+wY9gAtXmUle6foDQPBfsoXKi0/fVHa5xcyMEcZVZpIq4lMcbno4+AjfsxVMUVhbh
	I5ZBf5m8hkPci4eMAxUq2vB2n9AFvU59qgy379ZY76ohuMidxyqx7HWfiGL36ulD6cEYFQaWFH9Dh
	+5r/iwnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmsd-0000000AOHU-16oK;
	Fri, 02 Feb 2024 06:18:27 +0000
Date: Thu, 1 Feb 2024 22:18:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/23] xfs: consolidate btree block allocation tracepoints
Message-ID: <ZbyJM6GEE7LpfRUx@infradead.org>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681333967.1604831.8930919341410005794.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681333967.1604831.8930919341410005794.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
