Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E56A27FB12
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 07:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108280; cv=none; b=hzkvZEQlLJEdvqI8vBssH1q1IQALsyJrYUG+p1aARDr71Hi3QRCd8LQEVnZ3y83uXxeuv85utOE8K+ktZh8rNiXBRhgi8aKxhhWe6PV7WF6qlUK+fpOrN3wQYUqVPmgeHx+e47YzPN8038c7fw/6gijBsoaI0woYrQSwTFJmG0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108280; c=relaxed/simple;
	bh=HqzIipNZMewAMLp0aFKwRT1c48es5wM/vsJVSxdr/4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=imMxDoNHjVP6zm8uDpOO5FBJGo3G0R9S3xN4DL2/yXjawNdgCamcr9JndlPe7j1X3w+/gRR0mfd/Rqpn4J4Pn3HTxfdsxh7DgRBIqcwKg7Hgazyo++1wYbygmV9PASnzroKFrFd/x2XF/FggJTy2dGnkzB+8sGMsm9EJky/WRqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GM/4y67w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GM/4y67w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kw3ULxlR/nAAjZh0Pk7ykEuUgVOWXK1oZDa0wXm+mow=; b=GM/4y67w5W86Z0+XjClsNu1zaC
	DxziAaJNFUq9k0f9dP71Nx8rD23IT6oxAmRQnz61hc7oIp0fGsAxDcO61twPf61r6f6Sw4q7m3YSH
	v/3O01MADpKUIQoyJAsGshZmVCFPR5VOEGbkYePDLkPOqXsjKlNggQrxx9tRAzKxGNIjw875lV4rJ
	QP23ZPjctWpVouyrLQrV/UGvdpb7DYRJ9MrBDVTk1sXmvrWAh6P4bwePTR2NKXqHNF0JrVsOFOA7X
	XNIXWgZ0BoflEF4Me1HuuM8wjBjm4ZBhHBoVjw7EMVrqUeQB39RiDDFAf2ZCoYBzVQWini6QvbTpr
	cT7wX8HA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqRz2-00000007Dhj-1wyH;
	Mon, 25 Aug 2025 07:51:16 +0000
Date: Mon, 25 Aug 2025 00:51:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <aKwV9MPjoQpQfHeD@infradead.org>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
 <573177fd-202d-4853-b0d1-c7b7d9bbf2f2@sandeen.net>
 <aKSW1yC3yyR6anIM@infradead.org>
 <0d424258-e1ba-47c3-a0ae-60e241ca3c7c@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d424258-e1ba-47c3-a0ae-60e241ca3c7c@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 19, 2025 at 10:38:54AM -0500, Eric Sandeen wrote:
> Ok, this is getting a little more complex. The ENODATA problem is
> very specific, and has (oddly) been reported by users/customers twice
> in recent days.

That's probably when you started deploying a kernel to them that
contained a backport of

07120f1abdff80f3d1351f733661abe28d609535
Author: Allison Collins <allison.henderson@oracle.com>
Date:   Mon Jul 20 21:47:22 2020 -0700

    xfs: Add xfs_has_attr and subroutines

which added this check.  So anything fixing that should probably
add a Fixes tag, even if that commit only made the issue show up
and did not actually cause it.

