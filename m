Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59A2EEB1
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 03:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724470488; cv=none; b=eN8inzR/8EClctvexZwXE+5zoXWKwSW1W/gnuEZG/hAo+tOhzADiHTn64QJhK7wXj/s0xv1iTrq2Mb8N83ClTpFgwPdw1NW/uOeEWz9MIwtXODA9I1b93D/iMIiqKAZurm3FtIGhm8UcT3RAtoZRAzw9nUhp3hnQeAuVOHa1/9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724470488; c=relaxed/simple;
	bh=e00kI/LJMYMyMSOQOnNuTEQIgiub2JaiGhAuBeiqYpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YiveQYwRhjC+e2Y5E2Ftggr3fdNMdqV6V7Euubm8Yx3/2Q/MJYbteBmFfj66CgIaY3xttZZ0WAoyvkhMzcSa9iF3XXWK6EYPJ4/rHM96ycBSqhhk4Pqr/DaRdTH0DAhfixsGgcR4Fi4YPs+uC/AOG6a/RpVBQ2LesmsXdOJ6rao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DOJzYSsQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DOJzYSsQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AVAfm/HdbQuT/XY9B4Qx3kvjPZ7Qs+gI3Zl6++AOPrI=; b=DOJzYSsQ5fpnvksOSUDLtgY8C3
	KF6jo1hAU2ONVjcQEl0xen8YxAISmtZoLPfs/45tTUtvl4eLVSDP/kZtixBur2Q9tgyzCwVtiEAej
	/INEzVqM0zGXKcd013fySK6WePJStGlLYj6ZZnSJMMMJG7GaY87iuBjnS6E8b5Vs/rtfbKzrnX8ci
	G1XRTS2KfH6AZWhsqIkryiZv/o4B65jbZKXC8aw4HGKhfCjhE1g+3YtJkkzj0jTRONSvMoie3SgCY
	eik/azwz9K71rVZlM6JEmGBXW1ZM9kT6IDJVm7x06tLb6Lb2oq877MGmooQ7Xkyl1zpp73ZSsfd6B
	gW3GHFtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shhY3-00000001LYj-1xMB;
	Sat, 24 Aug 2024 03:34:43 +0000
Date: Fri, 23 Aug 2024 20:34:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <ZslU0yvCX9pbJq8C@infradead.org>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823110439.1585041-4-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 23, 2024 at 07:04:37PM +0800, Long Li wrote:
> After pushing log items, the log item may have been freed, making it
> unsafe to access in tracepoints. This commit introduces XFS_ITEM_UNSAFE
> to indicate when an item might be freed during the item push operation.

So instead of this magic unsafe operation I think declaring a rule that
the lip must never be accessed after the return is the much saner
choice.

We'll then need to figure out how we can still keep useful tracing
without accessing the lip.  The only information the trace points need
from the lip itself are the type, flags, and lsn and those seem small
enough to save on the stack before calling into ->iop_push.

