Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D7122ACF7
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810777; cv=none; b=em2nn3lcfQ90jYTURxtodHsj4Pt+c9YuiFqsBPMUi7OYRr37YYYHNy51mSisRrN9bu5wkMp1yHgkeqojbQkUNxrWfOdAW7rlQneiQHU+bXJ7qtf5S8VKNxdZAkfH+myZHfJBKWOAoyZNEkzZdPkboIosLULMBPf/1kCKgnG6GbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810777; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soOZSKJWKIjRmgUww3yxQXfDlLccbeoZGV6a0Tfpjog/nPMvZllvgwvB4Mvexx7p77bsA0c0jou3nA3/zSf5K42aHLuqlCV5dKeAZsEeoR2cX2wuQiosf1qRzx0iwUw2JRVi/llFQRKDSikO8kqLldUyPAnKhEi0VT0gAajddco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ojE86CzL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ojE86CzL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ojE86CzLkeEI9pZADlqX73XkOR
	uq3wmunS5z1NmY677J2NNGYXt+LhpYwtCoGTv+zs3vz28QE/+lrnE5z4vMxTAfVZmo8QHxcfDvhXJ
	Az4L+EPkzeyXrCsS9yhruAWtbsBklBU5dpBkMRsBthYWyreO3BB3a22NAkdc2mZAIDqfWUszW7xVV
	TIAqRSf4v7PBcKJChhkPoDX8e+cYg65SjcPOieLQ27th1F5LJKXjXS1a5lsVeae+mVzNrKggKDy5Q
	tQ9vSIqaAgyHxIVjbnoKCdypdhJsH6NRZARgH12Kbh+pM3O2zW+V7RRbOxwT9mIIqp07R9kJaIbq+
	kSKegKLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtNw-0000000AMsj-11lv;
	Tue, 10 Dec 2024 06:06:16 +0000
Date: Mon, 9 Dec 2024 22:06:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 50/50] mkfs: format realtime groups
Message-ID: <Z1faWF92xIt18unO@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752710.126362.4060220545378050721.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752710.126362.4060220545378050721.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

