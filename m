Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED1D20DDB
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730174; cv=none; b=RgoCdKtdopSz2GVLhChJQ5YkEG7hByXEiqZdeczF/e+P+YYwSt0hb/H/Q8nkkw+1CmYna+K/7tyR5WPJ2J8MqBMYbYwDLcoynaUUT2my08I5PRZWMDSOAJnF1aID7He5SzVR9XO3UE8SwP46ex3HPBsShe3pf3kPpXJSNuCSXrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730174; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0MOBmw7dvtxEHiC/8HzYUf+iAJ0eSuDZomJffp952adifbZbgWDyy3zBljM/HFEB77FTQaQ2b4OfQfZQQR9WdU/+YdEn1r0kgGHnVjL3PjFDNB8bePh/hH4PQaXxo/aQNJ7jrWdKheK7xRuP+LoR0XvtAC14zshKHN6AbS0kQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FsZjrF3i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FsZjrF3i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FsZjrF3itU0a3Mx834eDDDm02t
	WJCRdzZWqq1tVpOKYXvJEEv0DB/xCYT57jlbazQSMiIUKc5O3LRcGBE6i78viep+l7ivFL20kUzVQ
	sn1lqQxDZ/BveDWnYM9B6xU3dSKegSnYr2Cv35Ogf2mQyAfcx0Yr9fI7q39ScKLnGbtXtBnZiFNvx
	2078ykTZXYaHr8eLd87uxb2ns+MACIcG+/9E11VgaMdn8Rc/yDO8nmdcm/3SfhUg8X4FYK3w5AIuO
	X/7in9ZuFTPpAqvncXP76/dZexurjM5yXX5brTOXifwM0SFWKkSFj7EK9aQjomrYbGmlCjlWZhosj
	O33qrCfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRMC-00000005Mrx-4362;
	Wed, 10 Apr 2024 06:22:52 +0000
Date: Tue, 9 Apr 2024 23:22:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/14] xfs: repair link count of nondirectories after
 rebuilding parent pointers
Message-ID: <ZhYwPNcOpAi63gjO@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971204.3632937.13387414768621786629.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971204.3632937.13387414768621786629.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

