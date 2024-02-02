Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777CF17546
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855024; cv=none; b=gbsEOSb0zpvtLJsCYHR4uCe/L7+PowHr7ntfuLwsQauaHjmYB7rH/o8kthXilVnZzJpXxmB+C7zgKGnmMecNhkFq9AbPUnPzpycAkfLjAbOG+wBvWfF+8jcx/clDm+zWZgf5EtpxhTmVyVGLE4BdNvst6vOATbEwnwXxnYT7Kek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855024; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emHc2qYVrXBr/DlSFC64SFpJlNskPdSDSF7LnUwwxgtR1MA538k1gL0G0OesvZE/IRl4cIxsi3/1pEKwMZqxnPaeonxVn8fkdVYooaD3AM93/m2VwxU/i5qMRX2+ZUwv3gBTfISB987i0cafw1G6fJbihaW55scrWCAEeNP+um8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YDBPz8Ti; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YDBPz8Ti"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YDBPz8Tio8T4KufJ028x/LGMsD
	LqiW6JykUJcI9csWeHZfS6wUzkmXXjbvq+UAsWNNKHhms9a5gKgfuSPZ9IbD5LyTFEQ2HfYBzZgxd
	FSJQOb6lGSiN3JFy9bSj7357AKSkShT962mYz9/Fbgs5UcnO+oRCWXvU1PgwR01u7IZgyFi3Uz6Rh
	tcwo1ZtjbZofv3STujWxL6ayposKMvh3P09Hv9rSqYOYUFTIs3LO7WgiJMVQh4J3aFsHiOwx4d7Oi
	BDZUijEfmnHzwyZtDcIqm4O49kzm0HA2uHGHQPmYh1UA1sROs9LY84Ksqi+bJJHTsjWzZvf8SyklD
	tQvMl1jg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmxj-0000000APMR-0boM;
	Fri, 02 Feb 2024 06:23:43 +0000
Date: Thu, 1 Feb 2024 22:23:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/23] xfs: factor out a btree block owner check
Message-ID: <ZbyKbwAhhYXCY1WI@infradead.org>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681334249.1604831.389334053004368592.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681334249.1604831.389334053004368592.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
