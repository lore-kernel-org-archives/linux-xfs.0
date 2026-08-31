Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117EB4DB567
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183564; cv=none; b=SnrLbapiPDvEwNly1QtBExW4H7ehmGyU6HFc5GsnwkoN0UAq4PPpv6D+Hc4Ym0Mcwm9zw8fKw59J6Ni+C6+0Lr/A7OGza0yFsmM9VxUfN/d4HRWSpU8PpS3nu1CPJz767CLBk8OaY0Ww2eC/eIDw/uSv4f2isGTSsReo8VunF+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183564; c=relaxed/simple;
	bh=KOkzG48qZWiKIT5OMoDrRX9135MtvEH6MKbh9iEcMFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGYbffoKG1XgrD0Gw2QRVb/6nOeIoWB/K2p36NG/0fyydfhkBNJjqQzSbBMPaAoOyoDc4mBV1lXl1laB+dSRCYJ8LLm/oDqZrVdOjVhTr6IHcC78KCeGueBEYecP5QVgjYduJ0Iri1A1yNgRs1zJht8+7nAezpAty6u5Z+oRM94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aOQpYhtE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aOQpYhtE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G+aOBVnY6z8uWF2pcgiL/Y+e+8uvicHnalN6WbBgORk=; b=aOQpYhtEN9xE/gwPCm21AcKS1K
	9dCsEAK1L2TEt4jMwLhXZChrTUtltoF0yDr0qbDYFvLfLCvs+0Tzy8H8EvswSAXXz13FmhRQt+XBz
	TRVeCwvMj6l+eHWEY937cL3JFu/nsHzl5If1MU0O6S3xdc5IgCOwnWEQyGhXb2IL9wjv9rhH4gzuv
	1DDnahkaMuWqWU33lLw96lAnPMYq9WGY/mmFJQebDlcmG+3KoULrXA/Z+e9SjRiLQiKpsu454j2hJ
	/0GvPkq/Tm3AcVPulmGvD+g0slsdmcE+w+qzD93PLoij/YkjGz7+8wW0TYQnNvUTJMFYqoliUg85u
	kE6PpLCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12EL-00000009S6E-27Sm;
	Mon, 31 Aug 2026 13:39:21 +0000
Date: Mon, 31 Aug 2026 06:39:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] libxfs: record a failed buffer write when it fails
Message-ID: <apWECUHmTpoyt9PK@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <19b14aff5aa38738f92c7fef2babefb7f773655b.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19b14aff5aa38738f92c7fef2babefb7f773655b.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 20, 2026 at 10:42:15PM -0700, Chris Wedgwood wrote:
> libxfs_flush_mount() decides whether metadata reached the disk by
> looking at XFS_BUFTARG_LOST_WRITE and XFS_BUFTARG_CORRUPT_WRITE, and its
> comment says a buffer that cannot be written sets them.  It does not.
> The flags are only set from libxfs_buf_prepare_mru(), that is, when a
> still-dirty buffer is later released to the free list.  A write that
> fails during a cache flush leaves the buffer dirty and errored in the
> cache, and cache_flush() discards what libxfs_bflush() returns, so
> nothing records the failure and libxfs_flush_mount() returns success.
> 
> No existing caller can tell: mkfs.xfs and xfs_repair both detect a
> failing write through their own error paths first, so today this is a
> latent contract violation rather than a visible bug.
> 
> It stops being latent with log replay.  Replay flushes the metadata it
> has applied and then retires the log, and the flush result is what says
> the retirement is safe.  Believing a flush that did not happen destroys
> the only remaining copy of that metadata.
> 
> Set the flags where the failure is detected.  Both failure exits, the
> I/O error and the write verifier, go through one helper so the promise
> holds however the write failed.  The stale-buffer exit is left alone: it
> reports a caller bug rather than lost data, and has always done so.
> 
> Measured with an LD_PRELOAD shim that fails pwrite() after a chosen
> number of calls, replaying a log whose recovery needs 558 writes.
> Failing from write 181, which lands in the flush after replay:

Can you wrire this up in xfstests?  Maybe using an environment
variable instead of LD_PRELOAD like some of the other error injection
we do in userspace if that is easier to maintain.
