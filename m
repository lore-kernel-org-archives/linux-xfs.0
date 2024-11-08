Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CC31D0400
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 14:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731077726; cv=none; b=IsvUk797RpY8fYAFu0EemnK4BF5IH0snBsZ94YjmaYj0tF9V47yU4HQvIaHTt5YK6pAIjfzCoaWb9YFnBh7ffvILx4BJ9krZGfR+6LgzmGBOuf54JeTry9+F1OiJyW9PZm+s8t99NAwi4s6ynBnczPJIWOVJ9TSz7D8hHBKAHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731077726; c=relaxed/simple;
	bh=GC9UpQ9ClsTmqfiJFclOzG3lLPjhVM6sKsUoYAwgdTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvvMDCgF25eyx93Ca4Q29bhvhNIgeG/Zv280aMUUBY29WrAU/VGOq07IK8fJiZiXMffZijucrl+iTowB1oPJ8G/3WYnrEOLi/Sk2Fo7SAh9l3xQnR3CkLGsYfMoPUuqp4sUoWx8XegnWXiBrDVULcUoFF6/V9l2GNt/OG2jR2+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=chygU1Z4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="chygU1Z4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YKXlBvNVWNK4peo4ykJgFXl0VKmYwjj0iMBJWNNEb1Q=; b=chygU1Z4MuDFgwLbTyh63nI1ML
	brbEWgnOhQWFvqAYOVfVUt/QCG7O2oumVEshgbKhSMyd5cRCt0WZlP3r29JhmkqmCdrIdR69AUyKD
	biUhElRDqFBQ3/SS4YxfnvR+pNNJDtTrwVnGb56fK3KPiqAurJj6/9vSgy9dN0JNVtrziksm+5gMV
	OogdO1sDaV/PU1QbaskplxZlpWPHNY+T1e6vC62mdcGiN2dhgr08s96ymfmgWqQw4fgn3pOrM+P/L
	vp9VmcsknPA92EJzGFFubEkLGpLr7uGWkDqh0ojcAS+b3g4G9AIYj0C5IXai/NtnEIwW8ttuWyl2/
	mxG9ZMpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t9QOR-0000000AvNV-29IK;
	Fri, 08 Nov 2024 14:55:23 +0000
Date: Fri, 8 Nov 2024 06:55:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, brauner@kernel.org,
	linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH] iomap: fix zero padding data issue in concurrent append
 writes
Message-ID: <Zy4mW6r3rjMEsNir@infradead.org>
References: <20241108122738.2617669-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108122738.2617669-1-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 08, 2024 at 08:27:38PM +0800, Long Li wrote:
> After reboot, file has zero padding in range [A+B, A+B+C]:
> 
>   |<         Block Size (BS)      >|
>   |DDDDDDDDDDDDDDDD0000000000000000|
>   ^               ^        ^
>   A              A+B      A+B+C (EOF)
> 
>   D = Valid Data
>   0 = Zero Padding
> 
> The issue stems from disk size being set to min(io_offset + io_size,
> inode->i_size) at I/O completion. Since io_offset+io_size is block
> size granularity, it may exceed the actual valid file data size. In
> the case of concurrent append writes, inode->i_size may be larger
> than the actual range of valid file data written to disk, leading to
> inaccurate disk size updates.

Oh, interesting one.  Do you have a reproducer we could wire up
to xfstests?

> This patch introduce ioend->io_end to trace the end position of the
> valid data in ioend, rather than solely relying on ioend->io_size.
> It ensures more precise disk size updates and avoids the zero padding
> issue. Another benefit is that it makes the xfs_ioend_is_append()
> check more accurate, which can reduce unnecessary end bio callbacks
> of xfs_end_bio() in certain scenarios, such as repeated writes at the
> file tail without extending the file size.

Hmm.  Can we do away with two members for the size by just rounding
up the block size for the block based operations?

