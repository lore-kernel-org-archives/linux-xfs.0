Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547ED1411DE
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724819016; cv=none; b=LOlbkaX2hT0u7ibX/aF5nxZfCks+DG03rEQQf9O1GF0in7WB1yIsr9MBvD9c4DvJ7RGhLUC3+cQiG8P9dGep/kjj9ujy7dxIxEzRqCqlntJvwwx8swHgw6ckqXGojNmSZuFyqVGShULsfQFgAIuuyxV21laGUyZ22uJ8MdBkVMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724819016; c=relaxed/simple;
	bh=kdGmGjPNn4zlgle2mQX/j8oBi4zQlnye/gQKvpWjf0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYNWn+0N8yltL6qu7G7pjxO3zkzEO307sgiKSG4oiEXvTn3ndXTOUFGY47Uqzb0XvGkmXePnoxqdo/9kj19gzL8UwpUFkadwV1qc1xCqtDCYDYLWhetN9zeqRMbU4tnnTaOB9oM7T8V0EeOiHYayyOfjjOA6y8xkgcAGsvxfXqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gJ9vK3QD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gJ9vK3QD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sbj9Hz4/wmwqFrvKQJ4pNBRaphTQ0gZFr4WxpebdeNk=; b=gJ9vK3QD0TbMGTYjm66phpDy9w
	+WXw/vsj0ht7NlF0p91dBXx4lbMDJkAfPC7lBqB8l2WUSKtEThpQsrExTRSkX/yyPqeETjR/KrL1N
	LJjUYuT1xC/jjMOxuhyYFfc9IY+tGgD/O4IhynHVTi5pRiKMNdiZLqLHx2hATxg/KtgVR5lgB4k4A
	Ao6nziZ1Mh5XWSAsTnv/9ELvAUnTglnsv2CWri0DbC2VTAND++Mm2mqng7cjp0Xbm1tM+uVOUJnM8
	rsPcGKFLMOyd7ue8pS9Hv7OAPQOAW/A/8ncmDX3NM8eBS6OcWDv6nZMGynCP+JMo+DJ+6NyapoFpN
	hBQJL34A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjADV-0000000DmJ4-2iNS;
	Wed, 28 Aug 2024 04:23:33 +0000
Date: Tue, 27 Aug 2024 21:23:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Long Li <leo.lilong@huawei.com>,
	djwong@kernel.org, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <Zs6mRe5o_zndtwM_@infradead.org>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
 <ZslU0yvCX9pbJq8C@infradead.org>
 <Zs2jpYJHBtYqSMmD@dread.disaster.area>
 <Zs3G-ZrwPsOjuInE@infradead.org>
 <Zs5KsPEBZFkzG2Pb@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs5KsPEBZFkzG2Pb@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 28, 2024 at 07:52:48AM +1000, Dave Chinner wrote:
> I suspect that we'd do better to have explicit shutdown processing
> of log items in the AIL (i.e. a ->iop_shutdown method) that is
> called instead of ->iop_push when the AIL detects that the
> filesystem has shut down. We can then define the exact behaviour we
> want in this case and processing does not have to be non-blocking
> for performance and latency reasons.
> 
> If we go down that route, I think we'd want to add a
> XFS_ITEM_SHUTDOWN return value after the push code calls
> xfs_force_shutdown(). The push code does not error out the item or
> remove it from the AIL, just shuts down the fs and returns
> XFS_ITEM_SHUTDOWN.

Yes, that seems even better.  But it would probably be a fair amount
of work.

