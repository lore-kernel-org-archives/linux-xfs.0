Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB554A21
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070010; cv=none; b=Zo4ti5cNi07IO2i7G8+2TPMSfiiwTK5uP5MecH7XhljRVzDPeQuyAZ5618uyp/8iMhTvW4I4on65EjtrllYnsO2Yd1KbXFX1XwUPpiQ2lXHwUIkjAgk547HQ836UHtJwhvEb/WRlKtgGzwz61NbpYPXta/HMAVSuJAE2eK1z0vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070010; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubYDwvcogG4gqfrNVUpqfU0ZUja8X1tRHli1VqH86u7KXHzhh80ij9OYfmJhu/glZ8H5ktULp/FCGJbSXgiHsbwCdcDinHmIFj8vLITK2Xly7IVLQEx4Ia0dC8kmuAVtdLkl589HLvEMqmwQ6jaYmn9zkos5HsgbhmHgsEPL8ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BHQi3mDr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BHQi3mDr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BHQi3mDrm0oxNai5ZhOy8cnlMg
	64/keKSkk1cTIAxyx9Z+O2hoMXTEfuDzXGJmfV9BJsnxCFgjeYuY1AP9IACesLxV+454MYiIhxo31
	vW/ZMUpNrQEoN4oNlW5aHEO2f/zA2QyGNtwXcHxAPHKFVeyFngtqkXvyeFt8764MtX/2Y7JiZ+DN9
	5qm1lpC33kqJFWoAFLwBvnCeerimxBlEr5yvVS3xqssySxfdw1MlkIVKpINDYoRDjnEJusUygqMG0
	/hAJFHroq6oqtpzuwLQklTV/CiyDbK9mgX43tSknj1cB91wQ/1O/k5X17HwtSGS8GAiAc4kQr8tmC
	a2JeuxJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLyp7-00000002pj0-0GZY;
	Fri, 13 Dec 2024 06:06:49 +0000
Date: Thu, 12 Dec 2024 22:06:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: make xfs_iroot_realloc take the new numrecs
 instead of deltas
Message-ID: <Z1vO-dqFibjMzTh5@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122210.1180922.1051140780688294093.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122210.1180922.1051140780688294093.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

