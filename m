Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76C11DE3DB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 06:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246517; cv=none; b=bh0gE1mlMCUsRrc0rnLU6rXNqa8PZwwqIjU2vXWDpENGaS+pkxYeATkkqbiO7jzqf/LQt9/smBhMH9NcIxRn/uj1BjTVKuhaRpWiMaNUdaUPzBoOq0cktoaGElrgvuDTSn39/yGk+xSoRibfuTREGnhmIFyn8BN8YnPq8YaMzPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246517; c=relaxed/simple;
	bh=aaa24zVP4Cufp0czV8S3NFS5UeEYtUh/c8yE4oUNRnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tAqaO9bjVFkckSGreRMlPgjpK9JSb8akBcWy4SNtQOOmdMMlIkQGBXA0CZlLg58OXiR/Sw2uLNDCJQMsMoOKULDjSZxLSm1iJfb8g8vcFf+oDXnMZLf4Hs1OTemeQ7ECTWVWpG0qov9x3eRtHa662uBGOVvjyB9m0z5CswFa1KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pBwOMatH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pBwOMatH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aaa24zVP4Cufp0czV8S3NFS5UeEYtUh/c8yE4oUNRnk=; b=pBwOMatHR6u9mXAWe8xzwGiRPj
	+9+fZ6Tg20lAWAeAl1+J5butdp1JPI87paCkC+xKDzexHE7BwgR6USrZK/EKgji9/dBNKkrDZMTFB
	tPcnY9SpTXUu20VcbZ3YmHW6ds7hTNcO7C8ehMU6+74hmn2btASZI0ZKi5wOowcvZCyjyFg7deH+P
	YieZWAMF0OlRjXTn8hawypKzBFm+l2CNJCnfr1zaAZ8oiUEOsfSHWOZbVeDt4pwleVMRe9BD55kM5
	4XofiUKyloTx+wZtw3qLJkzI/rTR1nGOBvivOWJFlXZOa6h4vNNU5/ZN2crTWREIKjYj64oKXz/xu
	EynMySAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4YZI-0000000G7Mx-1ELH;
	Mon, 23 Mar 2026 06:15:16 +0000
Date: Sun, 22 Mar 2026 23:15:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH v3 2/2] xfs: remove redundant validation in
 xlog_recover_attri_commit_pass2
Message-ID: <acDadB4tpuGhcIfw@infradead.org>
References: <20260320021130.2936657-1-leo.lilong@huawei.com>
 <20260320021130.2936657-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320021130.2936657-3-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 10:11:30AM +0800, Long Li wrote:
> Remove the redundant post-parse validation switch. By the time that
> block is reached, xfs_attri_validate() has already guaranteed all name
> lengths are non-zero via xfs_attri_validate_namelen(), and
> xfs_attri_validate_name_iovec() has already returned -EFSCORRUPTED for
> NULL names. For the REMOVE case, attr_value and value_len are
> structurally guaranteed to be NULL/zero because the parsing loop only
> populates them when value_len != 0. All checks in that switch are
> therefore dead code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

