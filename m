Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23837286D70
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 02:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781143988; cv=none; b=mRXCsL62XnJLAr8aJCOB4PsKyIxjep/0E2fDT0Ii5fmKX1S93YnlVqFvOb1BVkJGIo0GkQE1aETXn/sgkoX4u56lkEibxkmniGjmd82LozR4kEuyGyFW2KxUWFwDahe3fNZmQce/X+rkABa+9+qMghJMqxqGtqkx+TKSzS9FYWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781143988; c=relaxed/simple;
	bh=VuX1D/TgNya1zzU6Y74+Apek9EaJ9J6cKFhl2szNpTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqenZw7ecGs3HZ+F8bIYqG0G0G+6o5uI8SF74+SGkVDQPByGa8prJMmdo+B8Au0zoM4eHnLHDkGtu4Iz1vuunetvyouW1IgLsmOmQDTpCrA7oacdEYZKWZBV8aN7S72mNTaxhiYqT/GFG+RprufYUgXUXP2Bem3saGLMtcgUsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZObN5DOd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZObN5DOd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 826681F00899;
	Thu, 11 Jun 2026 02:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781143984;
	bh=EKZCyx0FInygfaesRMmJR1LHuHRvYkOLGWXn2aggU+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZObN5DOd1xszpyU3NqbHpcwOGdwefhfLp5qHKfXL8Bg0oOW2Cd/hJED7j8o9iXahq
	 6kssbULsD2JNwaryE9MXLx/pwajb+hI8Z22wPKH9r8NFSGtzbo6R8jlRqtlXakVQf0
	 7//wSs5mZoHuH49eWkL3JxWfYWn4J6vrwsmOBzpt2V9gCrfB7+0L2sTrnRstTG7jrt
	 q3Quslnubj2JMPnPgRnOop/CgFWX37chOatqkg8jXhY5QdX/rurSvmFHAS3sC4W64U
	 74dTCh6TJTwuRWvKRyOii4Vl40Xs3ffUcFmpRA2OHq00Ca6diZSyhTRpRI8hkAMqAF
	 UX5udKEUgSgfw==
Date: Wed, 10 Jun 2026 19:13:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yao Sang <sangyao@kylinos.cn>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: shut down zoned file systems on writeback errors
Message-ID: <20260611021303.GH6078@frogsfrogsfrogs>
References: <20260611015305.1583003-1-sangyao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611015305.1583003-1-sangyao@kylinos.cn>

On Thu, Jun 11, 2026 at 09:53:05AM +0800, Yao Sang wrote:
> Zoned writeback allocates space from an open zone and advances the
> in-memory allocation state before submitting the bio.  The completion
> path only records the written blocks and updates the mapping on success.
> If the write fails, XFS cannot tell how far the device write pointer
> advanced and cannot safely roll the open zone accounting back.
> 
> This was observed while investigating xfs/643 and xfs/646 on an external
> ZNS realtime device. A writeback error after consuming space from an
> open zone left later writers waiting for open-zone or GC progress that
> could not happen. xfs/643 exposed this through the GC defragmentation
> path, while xfs/646 exposed the same failure mode through the
> truncate/EOF-zeroing space wait path.
> 
> There is no local recovery path in ioend completion that can restore a
> consistent zoned allocation state after the device has rejected the
> write. Treat writeback errors for zoned inodes as fatal and force a
> file system shutdown from the ioend completion path. The existing
> shutdown path wakes zoned allocation waiters and makes future space
> waits return -EIO instead of leaving tasks stuck waiting for progress.

File writeback errors taking down the entire filesystem?  That's pretty
drastic. :(

If writes to a zone fail, do subsequent writes to that zone also fail?

Is it possible either to requeue the failed writes to another zone?  Or
at least offline the zone and wake up the writers to convey the EIO?

(hch might have better ideas...)

--D

> Signed-off-by: Yao Sang <sangyao@kylinos.cn>
> ---
> Zoned writeback allocates space from an open zone before submitting the
> bio.  If the device later rejects the write, XFS cannot reliably recover
> the in-core open-zone allocation state from ioend completion, because it
> cannot know whether or how far the device write pointer advanced.
> 
> The issue was investigated with xfs/643 and xfs/646 on an external ZNS
> realtime device.  Both tests can expose the same failure mode once a
> writeback error happens after consuming open-zone space:
> 
> - xfs/643 exposes it through the GC defragmentation path.
> - xfs/646 exposes it through the truncate/EOF-zeroing space wait path.
> 
> Without forcing shutdown, later writers can wait for open-zone or GC
> progress that will never arrive. Forcing shutdown wakes the existing
> zoned allocation waiters and turns later waits into -EIO.
> 
> Tested with:
> - xfstests: xfs/642, xfs/643, xfs/644,
>   xfs/646, xfs/647 
> 
>  fs/xfs/xfs_aops.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 1a82cf625a08..4bcb47da5989 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -139,6 +139,16 @@ xfs_end_ioend_write(
>  	 */
>  	error = blk_status_to_errno(ioend->io_bio.bi_status);
>  	if (unlikely(error)) {
> +		/*
> +		 * Zoned writes update the in-core open zone accounting before
> +		 * I/O submission.  A failed write leaves that state inconsistent,
> +		 * so shut down the filesystem instead of letting later writers
> +		 * wait forever for open zone space to become available.
> +		 */
> +		if (is_zoned) {
> +			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +			goto done;
> +		}
>  		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
>  			ASSERT(!is_zoned);
>  			xfs_reflink_cancel_cow_range(ip, offset, size, true);
> -- 
> 2.25.1
> 
> 
