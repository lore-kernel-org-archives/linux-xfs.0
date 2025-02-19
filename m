Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C1A8C0B;
	Wed, 19 Feb 2025 06:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945350; cv=none; b=gymmLbar/70uU4b4mzL5kFaCGXjMzvCmihqF7pWB//XgJMsoK2IoXcb/T+o9WZQiKxXLf5Bl64/LnIrgX4qU60C0dMLDsGVzEDGk82gcfHiSJZkee19tZwfjlulesDBLUUK7+Hde7lLt/oqmTiGrq1wjTEr5alITnL9MVaWHUuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945350; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fut+1/Th1IfRM2oTKxbUq0dLsqq4XWcKQABcR67/O+dF4s4FeLPbwGNUVQVZpDH500iyZXb16vdMln1bEPO4BqmqxOcOzHBhXUXWKkJycWPF/Aecs+9efSvyyaMLsKb5GdhFqiXJeJC4XWqDHNYheYinbh0csQjzR6Lj8OCzL5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1IZ3AR30; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1IZ3AR30"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1IZ3AR30G7tll3X6d8FSBxB7rp
	Xo01QbNBuaild0n5fHoYRlMuP8m4m/19ILa58dfcETc6tGbp9gPPWL7FqtjfTury+CLJCl/Q25WuG
	RnBXcXW5vM+TVicDRGCHEivc0qJmywmkFfER4mqFWSGc7XZEMM4TSE9EUGzv5yy4p5pOJ/l+R0J0S
	j5hXpIgaaI/Cf/y/cAdBvA2RQK610nVo8NbU77U9rjmJOV3NqYs68C3Q3djzqdlIixHT2XrcGJHhh
	vqFlclpKhDWr2G9UtoVtpojyxCSfhDl8QdDIdwZQsrZgNxY3yKRLK7w/GWh0Lp79XCbbkcsVTFTd/
	Jzx67lzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdGe-0000000B0FX-2kGz;
	Wed, 19 Feb 2025 06:09:08 +0000
Date: Tue, 18 Feb 2025 22:09:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs/019: test reserved file support
Message-ID: <Z7V1hGjqtSmL8JJd@infradead.org>
References: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
 <173992588687.4079248.1375034459997008677.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588687.4079248.1375034459997008677.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

