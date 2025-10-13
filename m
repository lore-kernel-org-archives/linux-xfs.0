Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E698D1ACEAF
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 03:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760325600; cv=none; b=jDhFpVSSMDlNeh0aModM43TF0hcMHENDrFGWoGR4LseTnY7DbqEQzWLfcQeXGx3uNssSg8kXPbj69LA4MhejqETAXCDEhclJRN81d34d5qOx07VLXV7t5zIqNHvCPtT5UB0j2+ibUcvHF/CbYiUypkZstguqmDYoUmjoqDG2zKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760325600; c=relaxed/simple;
	bh=M0DbMuPNHY+FiAZYTR2YMhpUjxv5/GKz7lFjTd63hLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ReKsaRm8XJHVsZP940/4EVb1bMAHrXzU8idDxyIVJHp3gltk1BWTxIxVshgBvgGZFy/lvP50HSRIfrCUAGgyWfOSX0aWqMww54ZRGoA3DEzoKipcuJ0bLUo+1DBAvXxHMcCcQa6H19Jr76Kuq1d6spo/NdxrhVDLcpsxevSUJkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UD+eZ1Mt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UD+eZ1Mt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TPU0dMih9kjq74FvN1ll2OiNppsqC/EgCp1eJxb3B9I=; b=UD+eZ1Mtv+gmrJHI+BO0Ioelf7
	GQ8ImY4KjRAokTk0i6CDl9aJce6wqcxmgj2hM+qDqcsZy3gpkQUOQn2shmw/4bnkiOIHt+Zvjjwbv
	LaTr6DF7tlqLoJ//1GcADc7T2BCGMA/L+Z/8rlmYo66bQ7TXjNI6Qav/K5dqXzfRBt7/Fz7tSnvFd
	hjoQooBbol/WJSZU/O6kry25Mlq8uEoidOUMeH7VC8CWLwQmhmYIReMtFCUp6jeehoEX5X+A5eNgE
	FihBzoBjaLnigbNF9KXN0IcQowT7YeQiHCHHCVUeH6NAkLDlPoKQgSQZkcaSePu7QNd/43mQKCJ8t
	G3VWgq1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v896M-0000000C9rP-1ae9;
	Mon, 13 Oct 2025 03:19:58 +0000
Date: Sun, 12 Oct 2025 20:19:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: fix copy-paste error in calculate_rtgroup_geometry
Message-ID: <aOxv3k0AgS1qLBD9@infradead.org>
References: <20251011183404.GG6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011183404.GG6188@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Oct 11, 2025 at 11:34:04AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this copy-paste error -- we should calculate the rt volume
> concurrency either if the user gave us an explicit option, or if they
> didn't but the rt volume is an SSD.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

