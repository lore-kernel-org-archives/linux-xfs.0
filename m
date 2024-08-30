Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09032F2C;
	Fri, 30 Aug 2024 05:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997452; cv=none; b=XP5dz5DLuBpMWSfHQTHjS3xA2lDx9s3h3/jhIrltMIkvf/v1Itl7tJzYWl8LIpqQ9HIyokhK8CF8pTrbsR8e9QdyewKo2fuOum+myNSjOw+vcmu0Bqgm90VEzKjlROTRoVfmdKzOn9g2Alu3xsQnAvHokcm/LWdnHKdbDET15kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997452; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HO8T+e0ew7G5aFPNexFUIhri+1tyu/9a5ILAx3AeYgeLg8ow5wZXkHRtcbu1xF55bc4PQPC1DIu8vOKEizWUX8704x0fk9HeL8ZeFYMQadfmwIHHkGtVYaORCTOLGx7usp35QKVKZ6ky+PfToA0f99MkUY353w45GruAJaI4kbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z8Az2oj3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z8Az2oj3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=z8Az2oj3coNU+YiKzE2ba/BCn2
	ez4e2H4UCqxRU6cMC9ONIMkBX2C0iA7dC/6H3oh//zhFXZZFkWnfr3WMN+lvlpNWaQJqrtSqSWJmC
	/+C91qzBRJ6Umkqml86WXJoWT4IPI1jm4fRW020wRDMwq4CCl0p84qNwb8hbGo2Jce8AJRpXQOYbz
	j9K/hQV1WpFgE03P3faAinEm326pmh9VWhIGCMm/c/M/LZ9FzbiWlicP41nLjMdvVa29i0DfUH83V
	5KHL2LgCgtDazwjRGke26vTiAEkkWoZVhdSKpTlv6HxakBegzF5fPbYNqg7kJEW5+k1/Luou9leOp
	1KW8/yNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjudW-00000004sXZ-29Vw;
	Fri, 30 Aug 2024 05:57:30 +0000
Date: Thu, 29 Aug 2024 22:57:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] common/xfs: FITRIM now supports realtime volumes
Message-ID: <ZtFfSiLmq2fXOe8j@infradead.org>
References: <172478423382.2039664.3766932721854273834.stgit@frogsfrogsfrogs>
 <172478423415.2039664.6807634599087596331.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172478423415.2039664.6807634599087596331.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

