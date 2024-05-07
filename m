Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386D32EB08
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 06:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715063835; cv=none; b=DWGYY3vA03YS7QqFvQe0MtyqsvTrQ4+ln63MDnKqCM899PwFnIkRYOOEpnblsfWMH2Sumld2Lg6S1UZmuWynw7V/WzZ4nGNkMfa9LmQS04gkMDBkndBlKsQ8Q+fwOabg+VN6SlsaGHMYkIfIYbm6OhlkldvZnBlwINN88n/v+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715063835; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxfrRboF38WXeFrUxQ4Y7EvCfBEZSPVyLsUq2jNW+lDjBkXo4VdX5pa7KXKjdMza36EOjqqG6wNyJQ8GVDFR1k8xYGtizFQkfa1uO5nd1SaJASomlofZNqfg967mtpNYZREkl5SZlQ2fB0/Qp/+WWmXd1cBUt8WddTjldHMbXiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 06A9F227A87; Tue,  7 May 2024 08:37:11 +0200 (CEST)
Date: Tue, 7 May 2024 08:37:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] xfs: Fix xfs_prepare_shift() range for RT
Message-ID: <20240507063710.GB2669@lst.de>
References: <20240503140337.3426159-1-john.g.garry@oracle.com> <20240503140337.3426159-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503140337.3426159-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

