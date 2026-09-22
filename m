Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53303403E8
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 05:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054638; cv=none; b=gpRsLyl6O4J94nEm2kwtIttF6Lo1ENAEJTVmT4oIyoUxCwoFTjZvGAnwpqp9KdwY2dp8YRWhvrwNydrD2IWUmnq7MdeaX7jikBXSTE+7Dls58e2RI6W+nePyW8a/ogvJsR2SEj+KDNf+PBEqej1EIGv6sjA9F9TMA+/gCzQpDiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054638; c=relaxed/simple;
	bh=h5AmJhAbhvEEAfEzJpAV2RKDzIjKa5r31F2roiB6foI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pTigqBS0EEeen+f6qnxUn8lWdU+rqYmL9099cCyYtLAQVvfcEfLZ6IwAT35ALzlYskAJJg9IfO/RBshvPuIgK3zooIot8ZxAZv/mMVN+LIwUhwfmTYU2SnHtydvBdziuKQos5+NF4IyUaL/haCzirqVWSwloXzVJ6EHli2/zaVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oL1daQvg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oL1daQvg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ifTToNmp6uVYxrVfQKMKYzBjPTFcR4BnnVHqXEf89MU=; b=oL1daQvg4YipkIACa/c5UTcbcr
	dmHaXo4Y598OYnS35kx/5TsYrl4QjejU/oUR8cqT+WVjDWzEQF37Qxcpo8YpaaXkg0iZUKZpqRZBJ
	raiT3RQzwudQxSDg+oPFeu4jTlFEEGi0H3krXUiwc6Lzfn7MS8LMXBuepBYr5+ZK+RQ0LxY02IKdk
	dex/dJYh2A1XmTIRfx2Pnse07ZhaEjIuz1FHLS1UhYt+k8Twk06bEa5GO7D9RUwhzgI0usT+D+JG0
	9W7Pq10Fyux9NaO3RfwJbzKuVinl+R4g1Q0e8GdeAzGepmQbLD9V/EU8TReRuOCaUXwM7NFYutH4Z
	R9RoPShg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8syy-00000004EsR-0TJ3;
	Tue, 22 Sep 2026 05:23:56 +0000
Date: Mon, 21 Sep 2026 22:23:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfarray: don't allow users to unset in the middle
 of an array
Message-ID: <arIQ7BTzDz3NhdiF@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120785.181988.9998461891697022684.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120785.181988.9998461891697022684.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:17:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've merged online fsck, the only user of xfarray_unset is the
> free space btree repair code, and it only needs to be able to remove
> records from the end of the array.

I don't get the " Now that we've merged" part.  Without that we would
not have any user, right?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

