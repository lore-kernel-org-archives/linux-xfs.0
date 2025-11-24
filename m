Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEA62BE035;
	Mon, 24 Nov 2025 18:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010327; cv=none; b=hoKzowTrquEOoWZnPkMzKcqn1cebMTbINJ9zJmurKWqCjVodatXt/IEM58HQ2KKKGr8GewZZ6bB26lRcsmOZohcGZfP6zjHfy4Q8wzpWefGlQu8E4zIunEvXLNukg0jxuOapleKmQHOpNpGB+Jxzm/i2bFyOfN6uxZku6ycPRJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010327; c=relaxed/simple;
	bh=tyvhxyqDLgZlRxDUys0BlVrPjkRUoqDzcc9MtEED+MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2EVCXnW94YK/XTPul96VAedT38gDGLBxf7CH2wBXQX8+tJWrFdeG3wVe/DhH8pUu1niQ2kI50kEibA9u9d77B1ZrCsdIbd4Pgc1coyflF7Gk92XyzRZWv/oSTXbkHNZnWXKJ/aG9TLG27UMiv6meMNPp+w9UqdKgDvZIMSSG9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IatQnPZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IatQnPZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A54C4CEF1;
	Mon, 24 Nov 2025 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010324;
	bh=tyvhxyqDLgZlRxDUys0BlVrPjkRUoqDzcc9MtEED+MQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IatQnPZorzv04TdayMmKyYQmSAUmEx0GR8Se0LU0+BomvRK8ykgE+CCXoHyEB9gEe
	 6VfLwfg++9jmJfx623Xa8QgI3ipqFLcOmckpw0DuUvhxP2RYNvBbPDukGzKCf0ltzu
	 GkpSRULM+2ZG2YeQW0G89hTxE/z2bzmYPF5eNfZjc9llcJdF3w5B30wDJOPqs4f7uO
	 /W7BNdEt+ZESt6qYTZ0LTIlMIE4PVgcJC+99t2vp+LEMVwATTIFPi+sThdx7SllavB
	 1u9pu8nLJ9RLi/q4PxG83NkOIsQ03fCU9u0UkVo93frrzWee/bOctZCizRBcLiOllV
	 l7N+ydSonOgrA==
Date: Mon, 24 Nov 2025 10:52:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: cem@kernel.org, chandanbabu@kernel.org, bfoster@redhat.com,
	david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] xfs: validate log record version against superblock
 log version
Message-ID: <20251124185203.GA6076@frogsfrogsfrogs>
References: <aR67xfAFjuVdbgqq@infradead.org>
 <20251124174658.59275-3-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124174658.59275-3-rpthibeault@gmail.com>

On Mon, Nov 24, 2025 at 12:47:00PM -0500, Raphael Pinsonneault-Thibeault wrote:
> Syzbot creates a fuzzed record where xfs_has_logv2() but the
> xlog_rec_header h_version != XLOG_VERSION_2. This causes a
> KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().
> 
> Fix by adding a check to xlog_valid_rec_header() to abort journal
> recovery if the xlog_rec_header h_version does not match the super
> block log version.
> 
> A file system with a version 2 log will only ever set
> XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
> there is any mismatch, either the journal or the superblock has been
> corrupted and therefore we abort processing with a -EFSCORRUPTED error
> immediately.
> 
> Also, refactor the structure of the validity checks for better
> readability. At the default error level (LOW), XFS_IS_CORRUPT() emits
> the condition that failed, the file and line number it is
> located at, then dumps the stack. This gives us everything we need
> to know about the failure if we do a single validity check per
> XFS_IS_CORRUPT().
> 
> Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
> Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
> Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
> ---
> Changelog
> v1 -> v2: 
> - reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
> v2 -> v3: 
> - abort journal recovery if the xlog_rec_header h_version does not 
> match the super block log version
> v3 -> v4: 
> - refactor for readability
> v4 -> v5:
> - stop pretending h_version is a bitmap, remove check using
> XLOG_VERSION_OKBITS

Hrmm maybe we ought to reserve XLOG_VERSION==0x3 so that whenever we do
log v3 we don't accidentally write logs with bits that won't be
validated quite right on old kernels?

Though I suppose logv3 would have a separate superblock bit an old
kernel just plain wouldn't mount a logv3 filesystem, let alone look at
its log.

>  fs/xfs/xfs_log_recover.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e6ed9e09c027..2ed94be010d0 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2950,18 +2950,23 @@ xlog_valid_rec_header(
>  	xfs_daddr_t		blkno,
>  	int			bufsize)
>  {
> +	struct xfs_mount	*mp = log->l_mp;
> +	u32			h_version = be32_to_cpu(rhead->h_version);
>  	int			hlen;
>  
> -	if (XFS_IS_CORRUPT(log->l_mp,
> +	if (XFS_IS_CORRUPT(mp,
>  			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
>  		return -EFSCORRUPTED;
> -	if (XFS_IS_CORRUPT(log->l_mp,
> -			   (!rhead->h_version ||
> -			   (be32_to_cpu(rhead->h_version) &
> -			    (~XLOG_VERSION_OKBITS))))) {
> -		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
> -			__func__, be32_to_cpu(rhead->h_version));
> -		return -EFSCORRUPTED;
> +
> +	/*
> +	 * The log version must match the superblock
> +	 */
> +	if (xfs_has_logv2(mp)) {
> +		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_2))

Being pedantic here, but the kernel cpu_to_be32 wrappers are magic in
that they compile to byteswapped constants so you can avoid the runtime
overhead of byteswapping rhead->h_version by doing:

	if (XFS_IS_CORRUPT(mp,
	    rhead->h_version != cpu_to_be32(XLOG_VERSION_2)))
		return -EFSCORRUPTED;

But seeing as this is log validation for recovery, I think the
performance implications are vanishingly small.

I suppose if we /really/ want to be pedantic then the change of bitmask
test to direct comparison ought to be a separate patch in case someone
some day ends up bisecting a log recovery problem to this patch.

Either way,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> +			return -EFSCORRUPTED;
> +	} else {
> +		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_1))
> +			return -EFSCORRUPTED;
>  	}
>  
>  	/*
> @@ -2969,12 +2974,12 @@ xlog_valid_rec_header(
>  	 * and h_len must not be greater than LR buffer size.
>  	 */
>  	hlen = be32_to_cpu(rhead->h_len);
> -	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
> +	if (XFS_IS_CORRUPT(mp, hlen <= 0 || hlen > bufsize))
>  		return -EFSCORRUPTED;
>  
> -	if (XFS_IS_CORRUPT(log->l_mp,
> -			   blkno > log->l_logBBsize || blkno > INT_MAX))
> +	if (XFS_IS_CORRUPT(mp, blkno > log->l_logBBsize || blkno > INT_MAX))
>  		return -EFSCORRUPTED;
> +
>  	return 0;
>  }
>  
> -- 
> 2.43.0
> 
