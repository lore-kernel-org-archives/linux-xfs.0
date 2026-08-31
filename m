Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B99503BFC
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183727; cv=none; b=nhTKme8HEzZHwoinHtKw83frUnaY/vZ+gV8hc7leijRzyR63TVs+4RE6AJ6/vrjR6lMYcOArg5SLvrylTpAUMiIFgQWt3zPgUlxqgxJ5X442UlVMdjYZG8re90jqjyERTfIP2QxhknRKYVY5l5oc8Yzbj0Cpy00liQej7AWbm/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183727; c=relaxed/simple;
	bh=C790TCu3viLK6B7oGt9/LmOIUePXLfFY1yzrpLwXnMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYcqQVv7jbMBth3JxcRY6Wpz9MT4M4wnScmayzhqMdjCCrm3BNv3mBpGVeSbaHsrAd93grIFQeyHlq2al+za0FN1dLIpucdtbb1DrL1hy69pmqXG7Tmuawem5bo0zqfxYdOCczquMrB+Qo0MPOm9ALkcjylv1bSkSMppXODksVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ztbG6EO6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ztbG6EO6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=II2CTQIRCGs1xlx1Ex2hg7mDdb6gno1A7jESAMIaPaE=; b=ztbG6EO6pCFNr8B2es4uvpjI/K
	8XtQ7nBMWxrV2H8dlhg87vdk/nUrPHuA6IEb9Hae2pR81o3EwgHl8y5avWyyFQbo7+P2SUgJz9qSI
	J1bz5Hab49uvzxWV21FJ/HrjRHNS3mJYnHKyhWYoPelEf1vZbLDI//9Jw4fCv5ULK0q6whkifqshL
	2MBD7GE9BlBBNjEgZvpaN4xwoN9v7kI+FqshyXjzDJEpiw/umjMgs09zI3CZgSXwrB1KL3WUcoZBY
	g/wRbtm7yfmqZc5UfXbNdWZNRbIVxNIKNbodhU3uymgLLhzcofw/70zxZa/ls5D04SjhgKbuDqFg9
	oJDWUaQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12Gz-00000009TzV-0F6x;
	Mon, 31 Aug 2026 13:42:05 +0000
Date: Mon, 31 Aug 2026 06:42:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] libxlog: rename xfs_log_recover.c to logscan.c
Message-ID: <apWErc_WRuW5DQSN@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <2515991ccb3bc1707f3e06137d5ec87298098ce3.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2515991ccb3bc1707f3e06137d5ec87298098ce3.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 26, 2026 at 10:08:46PM -0700, Chris Wedgwood wrote:
> This file is xfs_logprint's log scanner and the code repair uses to find
> and zero a log: xlog_get_bp(), xlog_bread(), xlog_find_tail() and
> friends.  It is userspace code with no kernel counterpart, and it does
> not perform recovery.
> 
> The kernel has its own fs/xfs/xfs_log_recover.c which does, and which a
> later patch brings into this directory.  Give the userspace scanner a
> name that says what it is, so the kernel file can keep the name it has
> upstream.

Some of the code is obviously copied from the kernel xfs_log_recover.c.
Did you write this commit log yourself?  Some of this reads rather
AI generated, although probably by something less insane than Claude..

