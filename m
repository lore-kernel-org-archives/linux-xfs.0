Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5C01A683D
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979309; cv=none; b=AxVpjVlCK3roGAyI8xx+HrsJpkrXI+2NlVuGFQMHX/PUxLprH1+vVbBhbcM9RHQRYZR1D4tb2Sh7eaw1ESKgDEQffRTqcK2EnriZi6pep4TU0VxO2NzuJFFngNK3RCeiScGLjwGBwiUOUNvQGWM8voS03CPnnLHTMjV4PjJUGno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979309; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pN3yAtNgKW2N/xS9Y4j8s9fbGHdWkTV0wcZJRBnEIEHiNt7IUEMJtJds7QpO8ZzGGcVARPMS1VC4D+ZjRiz92MDyhkmK0Q0Z+B+LPLEZbjrjH/wg0Bt42m0Odrjy2pZh48hdX6HfhM5G9ULi3qnoalCpjFhtkzPwf1qhfwSc2ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F76D9vOn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F76D9vOn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=F76D9vOnALAY7iL1ecpw0CbMAS
	TN8loG1D/+DoScPj/9r0ItSeOkD155Cd90ViljF1KmjV9CMNns38nJWROoOvjlGHTcMIFp4KNc8ya
	EiY18DCmR7oxeeQ9AU4VcW+KKaij72YDz7INFwkwFKdFhDRvizwdg6pri5kpKhrnpcNvCD9rDElzU
	9QGN22H+ybhK7FX8kbXWMaeOPQSMgZDL1iP7diihVTOrK7E9geVbNxjRladDwG/vbyQlMorn/kCAP
	apKjPbDNYkDROFcTcqNw72JXFE5j/d7pcDuARXuqtXyqeX6Wuz1vS2klNHHTMYHO90x0wPpO30sJf
	kDO7bLiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8ZNy-00000001LMA-28Zd;
	Mon, 21 Sep 2026 08:28:26 +0000
Date: Mon, 21 Sep 2026 01:28:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] mkfs: allow disabling quota flags
Message-ID: <arDqqsIkJCyixEHe@infradead.org>
References: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
 <178996057675.169604.16144457816697173954.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996057675.169604.16144457816697173954.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

