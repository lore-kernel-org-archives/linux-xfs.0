Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E24D3F39C8;
	Wed, 29 Jul 2026 08:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785314051; cv=none; b=Vw7vKfplIUY4QJafYTQbwHj8SsjTI2tu9sTjHzKcMK3iqauGeWETms065cA1QU1GPDjXbt6+HzuNT1prJUIFdCauhSibJEN8IfiEdT3cb5KjtVFNbHr9xS8lvTmZRNvkqcdIijVneBEYzO07E8MpRvuwV7QWQZRFA9coDFa3r9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785314051; c=relaxed/simple;
	bh=IYRH8/T9khv2m04sp01b53brwpdEX1xXnb5NBQ1lU3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABTFZ8GefvthPqjYfhKPJt68IsbXw6Va/y7A/o01FTifCzBvhpJgIhpV052JKSZtOpZYH2SV1sRIAQAJQpwWd8Xn9mHNcFADR8i/p9Z0tyscy0foRhIjI8JfapAqCt1eqX0XE33FaMCRTICidO3q7m+VlQvVfS2Bk+uJS6Udvhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2meCy4u/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2meCy4u/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UYb97aoCpF3q0HnSJ9SsggpzE80BCFCEhyCGSyrAi+w=; b=2meCy4u/7QzeyObzXwfjaLv7/f
	+WgaWUyGj/CCwtPSGU7xxBsinNcWkBGg6MFShQJQRnABEHPAOYrEqe4S/fO+RObGePh3imRoyJpH+
	DlFnQ8RQGwkB+/Xb7ZF4rrC6hmzcMZqzFPjFoap4Xkj3SNly+Jreq6eu9IZUa9fz7CdBxMptkgQva
	7swePmlPXjiI8bdaMj+1s10ZzcBrM0sd3hu8hZcmXBYvcpqCrFvUo3cELPwRMNyohB5th/oEX/Rz0
	3nrdc6w1WiiEaYXsH5VEYTWasXq2JyHp+i+xQ6WU4cvrQWI2DF6lxbtg3fXDqjx7k6Gh2STShar91
	ux5twqCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wozjk-00000007EzL-0yZA;
	Wed, 29 Jul 2026 08:34:00 +0000
Date: Wed, 29 Jul 2026 01:34:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: cem@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix fallback data device flush for realtime inodes
Message-ID: <amm6-JkURolQqXDo@infradead.org>
References: <20260729073918.64505-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729073918.64505-1-zenghongling@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 29, 2026 at 03:39:18PM +0800, Hongling Zeng wrote:
> xfs_file_fsync() has a fallback flush for the case where the log force
> was a no-op, for example fdatasync/O_DSYNC overwrites of already
> allocated file data with no metadata updates.
> 
> The current fallback path is limited to non-realtime inodes and always
> flushes mp->m_ddev_targp. This misses realtime inodes whose data target
> is selected by the inode and may be mp->m_rtdev_targp.

No.  The rt device is flushed before the called to xfs_fsync_flush_log,
as we need to ensure that the data is flushed from the cache before
the log commit.  For the data device, the REQ_PREFLUSH case takes
care that.  After xfs_fsync_flush_log we only need to take care of
the data device if the file is on the data device and the cache
wasn't flushed as part of the log commit.

