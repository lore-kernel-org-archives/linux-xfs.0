Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51A915DBA8
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142048; cv=none; b=nBhSTXroyyyk6XR7iYvPVVC+leEuT/ZI1Z+lxmxVA+B0iWUMdFbBFtodJ/gjmNbsHttV0OFfwmfAU62nmgeOsiRL4LZ6obHZoxTUsUn3ybkzhi87lFvQsPbszWZ5gjZQPAGuL1Ewf6ddfmNgjvrWZi8rjO5A0B2poarkZmR3BMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142048; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6VF4yTciZ8LKWa2HcUSC4UVI/SeMQ1cD09bhlcLxIca4DKSkF6mJMu1zd7LL7UrDSaQt0k99Hwpg9aLJxj5N9YNnCHhRKumtxteXfrE0ymB23MeWhHhdeV7dhIzfIoUd+tosDrIXlEwA52TdDXavZLtR1L5Dcu2cDpPLvZKLXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x5a8jaLi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x5a8jaLi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=x5a8jaLiZI8Ho/3RQPqiSAbHRi
	Hu8jEWjS5UKDGnjjauz2bKTwu5jvKJAJVHrwi3XQYeOLs0htU6WcEMlx9+VPi0US3L0z8rjQyBSD2
	jjOOuFjNTTrtWiMLl4U+kk80gjoGhreIEdo9n7tpWmZUSkakcPqJpURUHmpbM/4BnCLHUH/ZNkAQq
	RxS0unb9RmDSyEJL8ZXJQ1yKBIJP0gcS6mOTqplmI/Uzu+NJLI6dK+6Hr5Eu4TdeCrImH6WPT8b9S
	O5pdJtpIwYAdEJz9XzZiPd+s39LUKpT9wReuwT9esw94e75eNC3wHs9c2Wvh+ZoUq2ttnhRWJzEzq
	/fzCsZcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNvC-0000000AKda-1gR1;
	Wed, 28 Feb 2024 17:40:46 +0000
Date: Wed, 28 Feb 2024 09:40:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs: check AGI unlinked inode buckets
Message-ID: <Zd9wHlcnZSak-pil@infradead.org>
References: <170900015625.939876.13962340231526041298.stgit@frogsfrogsfrogs>
 <170900015649.939876.11902030314177288352.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900015649.939876.11902030314177288352.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
