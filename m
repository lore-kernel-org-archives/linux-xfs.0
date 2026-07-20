Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B122B407565;
	Mon, 20 Jul 2026 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784549055; cv=none; b=gUT7dPXKLkpqoMzpr0bTsk20LpwUfaawdivcffXnAC+S/zEBz6r915x2O6oC2Og5ewQ9fYoT2O9NAfusqoIa4O4vGvKFNPJ4fRL+vCVa0Acer8Hhbxl4dbwZk7fyXpBss9HdrKx7RFri14lTkuRvQZK5m8460KOpXIJKWjU7GI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784549055; c=relaxed/simple;
	bh=jwQI/Pf9NgcNp+DK3zQQGTyKt/dsw3MbYO0e3utNawk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cToprLpahXKo+/cpI8sLZTwYOTx7xC0LmwnFf2RXGYc9Mx2vxh4PW2TT4MGMMcCMnX+cYh/LkwlR2He8HMjG+IzJDDKe8DRRsBcjIi8QMHqPeXAE2mBXb7P2EZBOcHAoJDRABXIFAQMCYgs4PJM8ILXsTKaOQ7RE2qM3YRV77GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EImnMY0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EImnMY0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296D01F000E9;
	Mon, 20 Jul 2026 12:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784549053;
	bh=GrjyUrFA1NruvtisUz4gp+RpWRHZm15WecJhiwdx36M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EImnMY0U0L6e9FoTHcqYRk4KnGvjXq+2u9UK7ILXDVd8nPJ3kvm0k4BPVzHyLSAh/
	 qk4J+FUPLP9Wa7VfEZlcdVfbrJzRWL1dJGql6odNBDVrf/r1HaDEoBmsYcdZFgbKCE
	 hhAGosbgqqEZ8XCYLKdy7/K0OukRqy/gaRGBpmHlv/cOtMgCCXvWE0JMggWzSIUTMa
	 VqeP175mPSrKDwiD9Cg44xQxMY02HlbHaIDKaH6+tmnSpx9Mm2CUCqpE0o80BUGnP7
	 RpdXH2oqTF4k42FapqzISKscYDArm1VFcPUvvMpP8YG+zCqlQm7zOlN+il/P/eLcMR
	 mN8ZfdJp/qehg==
Date: Mon, 20 Jul 2026 14:04:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Ibrahim Hashimov <security@auditcode.ai>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, bfoster@redhat.com, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5] xfs: bounds-check buffer log item's dirty bitmap
Message-ID: <al4OdTezVWyhrKwe@nidhogg.toxiclabs.cc>
References: <20260714175532.74257-1-security@auditcode.ai>
 <20260715071723.81917-1-security@auditcode.ai>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715071723.81917-1-security@auditcode.ai>

On Wed, Jul 15, 2026 at 09:17:23AM +0200, Ibrahim Hashimov wrote:
> xlog_recover_do_reg_buffer() replays each dirty region described by a
> buffer log item's bitmap into the buffer read for that item:
> 
> 	memcpy(xfs_buf_offset(bp, (uint)bit << XFS_BLF_SHIFT),
> 		item->ri_buf[i].iov_base,
> 		nbits << XFS_BLF_SHIFT);
> 
> The destination offset (bit/nbits, from the logged dirty bitmap) and the
> buffer size (from the logged blf_len) are both attacker-controlled and
> otherwise unrelated, yet the only thing bounding the copy is an ASSERT(),
> which compiles away on production kernels. A crafted image logging a
> small blf_len together with a bitmap bit past the end of that buffer
> drives the memcpy() past the buffer's allocation, corrupting adjacent
> kernel heap during mount-time log recovery. This is reachable by anyone
> who can get a crafted image mounted -- the malicious-filesystem threat
> model XFS already guards against elsewhere.
> 
> Turn the ASSERT() into a real XFS_IS_CORRUPT() check that aborts recovery
> of the buffer with -EFSCORRUPTED, consistent with the validate-and-fail
> idiom already used in xlog_recover_do_inode_buffer() and
> xfs_dquot_item_recover.c. xlog_recover_do_reg_buffer() therefore becomes
> STATIC int and its three callers propagate the error.
> 
> Found and confirmed with KASAN on a CONFIG_XFS_DEBUG=n build: the crafted
> image trips a slab-out-of-bounds write before this change and fails
> recovery cleanly with -EFSCORRUPTED after it.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> Assisted-by: AuditCode-AI:2026.07

We are starting to get rid of Assisted-by tags mentioning specific
models or completely getting rid of them at all.

If you are ok with it I'll just remove this tag during commit time, or
if you prefer, please send a new version without the tag.

Cheers.

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
> v5: add the "/* write dirty buffer */" comment Darrick and Brian asked
>     for above the error reset; no functional change. Carry their
>     Reviewed-by tags.
> v4: fold xlog_recover_do_dquot_buffer()'s bool return and error
>     out-parameter into a single int return (1 if dirty, 0 if clean, or a
>     negative errno on failure), per Darrick's review.
> v3: trim the changelog per Brian Foster's review. Add a Fixes: tag --
>     the destination-bounds check has been an ASSERT since the initial git
>     import (2.6.12-rc2), so it predates the git era.
> v2: resend; v1 went out with an empty Subject line due to a local
>     git send-email glitch (leading blank line in the patch file).
> 
>  fs/xfs/xfs_buf_item_recover.c | 57 +++++++++++++++++++++++++++++--------------
>  1 file changed, 41 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 02b95b89d1b5..240deb3f7827 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -461,7 +461,7 @@ xlog_recover_validate_buf_type(
>   * given buffer.  The bitmap in the buf log format structure indicates
>   * where to place the logged data.
>   */
> -STATIC void
> +STATIC int
>  xlog_recover_do_reg_buffer(
>  	struct xfs_mount		*mp,
>  	struct xlog_recover_item	*item,
> @@ -489,8 +489,24 @@ xlog_recover_do_reg_buffer(
>  		ASSERT(nbits > 0);
>  		ASSERT(item->ri_buf[i].iov_base != NULL);
>  		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
> -		ASSERT(BBTOB(bp->b_length) >=
> -		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
> +		/*
> +		 * The bitmap is only trustworthy to the extent that it
> +		 * describes a region that actually fits inside the buffer we
> +		 * read in based on the (attacker-controlled) blf_len.  Do not
> +		 * rely on an ASSERT() for this -- it compiles away entirely on
> +		 * non-DEBUG kernels, which is exactly where this matters, so
> +		 * validate it for real and abort recovery of this buffer rather
> +		 * than copying past the end of it.
> +		 */
> +		if (XFS_IS_CORRUPT(mp, BBTOB(bp->b_length) <
> +				((uint)bit << XFS_BLF_SHIFT) +
> +				(nbits << XFS_BLF_SHIFT))) {
> +			xfs_alert(mp,
> +	"Bad buffer log item dirty bitmap (bit %d, nbits %d) for %d-byte buffer at daddr 0x%llx.",
> +				bit, nbits, BBTOB(bp->b_length),
> +				xfs_buf_daddr(bp));
> +			return -EFSCORRUPTED;
> +		}
>  
>  		/*
>  		 * The dirty regions logged in the buffer, even though
> @@ -544,6 +560,7 @@ xlog_recover_do_reg_buffer(
>  	ASSERT(i == item->ri_total);
>  
>  	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
> +	return 0;
>  }
>  
>  /*
> @@ -552,10 +569,10 @@ xlog_recover_do_reg_buffer(
>   * (ie. USR or GRP), then just toss this buffer away; don't recover it.
>   * Else, treat it as a regular buffer and do recovery.
>   *
> - * Return false if the buffer was tossed and true if we recovered the buffer to
> - * indicate to the caller if the buffer needs writing.
> + * Return 0 if the buffer was not recovered (tossed), 1 if it was recovered and
> + * needs writing, or a negative errno if recovery of the buffer failed.
>   */
> -STATIC bool
> +STATIC int
>  xlog_recover_do_dquot_buffer(
>  	struct xfs_mount		*mp,
>  	struct xlog			*log,
> @@ -564,6 +581,7 @@ xlog_recover_do_dquot_buffer(
>  	struct xfs_buf_log_format	*buf_f)
>  {
>  	uint			type;
> +	int			error;
>  
>  	trace_xfs_log_recover_buf_dquot_buf(log, buf_f);
>  
> @@ -571,7 +589,7 @@ xlog_recover_do_dquot_buffer(
>  	 * Filesystems are required to send in quota flags at mount time.
>  	 */
>  	if (!mp->m_qflags)
> -		return false;
> +		return 0;
>  
>  	type = 0;
>  	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
> @@ -584,10 +602,12 @@ xlog_recover_do_dquot_buffer(
>  	 * This type of quotas was turned off, so ignore this buffer
>  	 */
>  	if (log->l_quotaoffs_flag & type)
> -		return false;
> +		return 0;
>  
> -	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
> -	return true;
> +	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
> +	if (error)
> +		return error;
> +	return 1;
>  }
>  
>  /*
> @@ -724,7 +744,9 @@ xlog_recover_do_primary_sb_buffer(
>  	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
>  	int				error;
>  
> -	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +	if (error)
> +		return error;
>  
>  	if (orig_agcount == 0) {
>  		xfs_alert(mp, "Trying to grow file system without AGs");
> @@ -1081,11 +1103,11 @@ xlog_recover_buf_commit_pass2(
>  			goto out_release;
>  	} else if (buf_f->blf_flags &
>  		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
> -		bool	dirty;
> -
> -		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
> -		if (!dirty)
> +		error = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
> +		if (error <= 0)
>  			goto out_release;
> +		/* write dirty buffer */
> +		error = 0;
>  	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
>  			xfs_buf_daddr(bp) == 0) {
>  		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
> @@ -1105,7 +1127,10 @@ xlog_recover_buf_commit_pass2(
>  			xfs_buf_relse(rtsb_bp);
>  		}
>  	} else {
> -		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> +						   current_lsn);
> +		if (error)
> +			goto out_release;
>  	}
>  
>  	/*
> -- 
> 2.50.1 (Apple Git-155)
> 
