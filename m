Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB5F53397
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537610; cv=none; b=ksv0Nrzzfq5m+bNrelh9j5IE7hnNx4EqZeYckHfpm7K97p7f3cw0/4hENEQLUhKXUQvQx01IcR9DdS9rRiUcgb/mDbAeleExLIfPV3jjvTn+OFcQj88Lwnc2LEPvR1R3QNmK/+oBnJ1GNLaFpPwfF9GTenI7YW2sZ2WYW5ZFW6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537610; c=relaxed/simple;
	bh=YEcauFgKI5MwQEVUwfJPMGxCDzO8U3Dedo+RRW+KnIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpUMf/ypI0kXgVpewrx6EzDXNqRipSMCQi3WCxO7V2TJVa9qzWTqBAd3/Qp1Y/nKfnlhYrixsjzqS1yLGdGC/4AWe3YkfSFZL8gRTbcg6LqPZMCDFbcaVDSRtDOB7V0LqEDuaL2J5jCz6rIGiu4brJaFxySND6rLOugXL4IlgBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wDK89eEc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wDK89eEc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mce0sJRqTOUDGiINQ7q3n/+pn3R7L27xod5aVWwnC5s=; b=wDK89eEcGZclZxsVW/1At9RkH0
	/kEiAq+zO3FcTTeL9ZTJy6qbkt9D8lOxjT+CSgACjcMUw7hDlu727ErSZO6T8tUp7aoK1woAe+284
	Sxto/pN4kD/EtrS2juQoY2K+SfxY8dQ3P2v8/xYl7HvDFMm7IThnB9zfwb26jZpSyv0AMtAKTgM/A
	LJjJtjRDx2S0UEbFKwP9337/mAuACs4eCt8TeQfUL2OVxQD0JM6o1BwzCfDuyGq5BSGkLfbIDYVTk
	UzlHzZ0z5nD1TEjPd+5rTeZHRvGW0zXG9P/ox5o2Go4ZjFP+KodjheF5Ikapln4aQ5/NLVBGCFUr8
	MfuFujAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR7I-00000008Xg4-30l4;
	Wed, 27 Mar 2024 11:06:48 +0000
Date: Wed, 27 Mar 2024 04:06:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: introduce new file range commit ioctls
Message-ID: <ZgP9yEGOO5XZt0_6@infradead.org>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
 <171150380898.3216674.17747658861040725823.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150380898.3216674.17747658861040725823.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 06:56:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This patch introduces two more new ioctls to manage atomic updates to
> file contents -- XFS_IOC_START_COMMIT and XFS_IOC_COMMIT_RANGE.  The
> commit mechanism here is exactly the same as what XFS_IOC_EXCHANGE_RANGE
> does, but with the additional requirement that file2 cannot have changed
> since some sampling point.  The start-commit ioctl performs the sampling
> of file attributes.

Unless we actually have a good use case for this right now I'd still
prefer to skip it.
