Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FD139446D
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776760156; cv=none; b=Vw9nh71p6asybDrjhOPFhSd6i2rI0RJDBqo/e/vFDX5/fqQQ6O/pkMdY1qaCWM+HLp7WYfAX7e6WVTJBst3q1opx9vVBppWlwAPYevPvbXkuztsk8+4M+kW6eQKAf1kvD78Ldt9VNeZmPxIeE7kk+f9pRQ0zat78FZ3KRM+2tzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776760156; c=relaxed/simple;
	bh=ChTKrz6LrULdtALF1E6BMtpVpreWFmmGCchyaZC/X0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iev/YMRuUUPbD9mvYN4ub9ig+aGZdAj4zMVRH6FnDWWYx9JpRQgCPi7Q/H8FKfmypvG06QC9IRyi4EajvJcXWarf5eBAs1Jyfict6LJmnvk9fAtJBtdrlfud6QoXItxutqfsWwvmiGZo91WPXYbmEedRGixPHTF29hyG3ivugLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5D0nU/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5D0nU/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3790C2BCB5;
	Tue, 21 Apr 2026 08:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776760155;
	bh=ChTKrz6LrULdtALF1E6BMtpVpreWFmmGCchyaZC/X0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J5D0nU/cYS6dFdG9JnHPZtzjBnZXD4Dm8Vv5jSuO1f60AOOC2UBsJ78iYuyc58PUu
	 IvhpD5bMrc5Duhxkb0N+vCYzrOnrUKfy9POSp3roMTbUesmlVH2OnEwAaIqprEFAYS
	 wb+3S6EHzEjpqFGWO7fNJBUT1wjIeJsYbTj346EbNNIrH9+Dfq/Yat+X579D7ue5P7
	 418eUA3tIrPgevYXBCnTfjBG440ajuWNeL+MR7wQGv0hmouJXCzn519vsNyVcBnugd
	 joRyTVWq2VgJIzPxoDBX46JpihtxVawxBHJ5J56vi7bZabPIXIM45v2tQYwSJVP9PC
	 DEBm+H1e/i0KA==
Date: Tue, 21 Apr 2026 10:29:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, 
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 0/3] xfs: handle ERR_PTR return from bio_split
Message-ID: <aec1GGrtAYLM20lM@nidhogg.toxiclabs.cc>
References: <20260418092715.375850-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418092715.375850-1-leo.lilong@huawei.com>

On Sat, Apr 18, 2026 at 05:27:12PM +0800, Long Li wrote:
> bio_split() now returns ERR_PTR() on failure rather than NULL. xfs code
> currently ignores the return value of bio_split() and dereferences it
> unconditionally, which will crash if bio_split() returns an error pointer.
> 
> Add an IS_ERR() check after bio_split(), and perform corresponding error
> handling.
> 
> Long Li (3):
>   xfs: handle ERR_PTR return from bio_split in xfs_buf_submit_bio
>   xfs: handle ERR_PTR return from bio_split in xlog_write_iclog
>   xfs: handle ERR_PTR return from bio_split in xfs_zone_gc_split_write

All those patches should be merged into a single patch. You don't need a single
patch for each function just to handle the same update.

> 
>  fs/xfs/xfs_buf.c     |  6 ++++++
>  fs/xfs/xfs_log.c     |  2 ++
>  fs/xfs/xfs_zone_gc.c | 10 +++++++++-
>  3 files changed, 17 insertions(+), 1 deletion(-)
> 
> -- 
> 2.39.2
> 
> 
