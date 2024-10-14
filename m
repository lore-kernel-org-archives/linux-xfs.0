Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4290142E77
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893387; cv=none; b=BDC4yI/AGlYXW56uRMtCHGFAanLaRzmj6JcpaxnvKmHHVjOOLP1nB9+kBsSgo5WkvjddX2u0jXZkFZPYMAVkZhAr6NFAl5rxXH7IFYgVFi0pzHJHIMlm2tzXLriOfuu9p3z/8fIUAJJAs9HC0WcWIyQ+jAAzvYG+zE2CVjDW7Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893387; c=relaxed/simple;
	bh=SRkbmhfJUSqbbOci1ilB5rEpZqwMbRfFkaSZKBYABM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVZvNvy4mXt16nD91Vubyfl5uGHCVjbZq67Njtwu7fYpnyZGdGurLUK9hjI2b8lJBGTArA2aZPtA3GzMk9dW5dp9p0dSXQxqnyfJshJgFWZnkJKgN1ry/6p0R+X4feMw1NEv4c3Iw5SXNqOs0hgwfJyBS8OZvl4l5ByHQ8oSgXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4Y2fq07b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4Y2fq07b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wF8OjOLjD9A5By1lar5EY7I4e9PCNrp4h274uMe+Lqs=; b=4Y2fq07bWLmSTURd5oyzaArxD9
	e00BLj/y6b3JnxIWBWLgbG3F++wqXfRuYBvHcOPBNXb5Yuhbo8K7KiozLM1wux0QoyxDrWH7MUoS/
	PuWybfRYgAfKsUa7WYIBWD1S6/9Sj098wwEtiZ1gzAr2FZBlCV9uq0KMREyINMfV9eYde1RzmOWVU
	/CPglSAgMMNsELDsHSV2IO+WpTkaNDsBusHELokqGxMNCR8f1usv48MPgyEwZN3bKdns8aNUCovqf
	N96nepv4B6Hi9k90x+Gt3nhzqdTIAaalQ2xMrX++vAVg7PwgsFJkpGt2sOQn7wwVybTbV+MqZ4Ih9
	8BJh8KdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0G9C-00000004CwI-1Mx8;
	Mon, 14 Oct 2024 08:09:46 +0000
Date: Mon, 14 Oct 2024 01:09:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/36] xfs: add a xfs_rtbno_is_group_start helper
Message-ID: <ZwzRyoWmBwxj1pN4@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644778.4178701.16054050216083032242.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644778.4178701.16054050216083032242.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 06:09:45PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Make the boundary condition flag more clear and implement it by
> a single masking operation.

I would have expected this to be squashed somewhere, e.g. the patch
addhing rt groups and thus all the surrounding functions in
xfs_rtgroup.h

