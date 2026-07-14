Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51890417BE0;
	Tue, 14 Jul 2026 17:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784050996; cv=none; b=i1y+sh+Z65o+u7md8AAU18d+ppFR0Zq2UsnIFJD7JIAXflBPsS6SyoIsYRAY2vM1/QrS10FqqinOpcvWm44SE4gkegk56oagNKZXOa7fv8MIgzX4W81Ng8YUCy+g5xhbKrvrFZPTrPae+wNgmob+Iv1HjAKXklcjEM0NhB6+aOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784050996; c=relaxed/simple;
	bh=5WiDCyRVPgHRCvGJATrrMG40A+oR9ekLRX4yiJTQ7E0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doq56x/oifEFf6WHM9qqhAnyxOD2klHyhgIgmuGYf8Q9krYvKrfYf/RGCoCNmV2DLTE8AgxR8rCGGX93ZPicdA7mHNzufWZ+h89n6OIPMoJ4/K1bC3z4dyedZkL3mLjp0kb0VpUmLQQy5cRLUYEqysO5o/JwurHEewZCVmCPhIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyMyvqet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyMyvqet"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 02FBF1F000E9;
	Tue, 14 Jul 2026 17:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784050988;
	bh=KcEgfzomHAugZM1nIzI/5XdcPmhJJaHE/IScPEaJG+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DyMyvqetJTTR+63fDDCOyuqc0t01wLf0lmHP5Y5IxBrPTdamxT9hZru9odg7ye5iB
	 NurJ4aK9Z1NV0X94118DQw93X+paYqEaE+AK5IPEsJUfPuE4mNbmb+RWHxYBWZWY/x
	 +z5a6RI+V+CtaRPgAh6s1NmKLoWG+zwCfLNeJwweLA00BZrfP2EVkXjFnDGThULPGa
	 riCz3LMW4JapXUA6il3o3QcLJRvqGaBHE7OFx4zGFlHFDUCQKlb16P9v5krCaN3NDD
	 3uzOjRtiulcFRhXv9iufiL23Mab1+TMWZHZxg+I4vvs1EJMIfSxU/qSr7rY1hQfh2x
	 gzgGAaFgAhJXQ==
Date: Tue, 14 Jul 2026 10:43:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ibrahim Hashimov <security@auditcode.ai>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, bfoster@redhat.com,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] xfs: bounds-check buffer log item's dirty bitmap
Message-ID: <20260714174307.GE7380@frogsfrogsfrogs>
References: <20260708225814.2568-1-security@auditcode.ai>
 <20260714172730.73160-1-security@auditcode.ai>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714172730.73160-1-security@auditcode.ai>

On Tue, Jul 14, 2026 at 07:27:30PM +0200, Ibrahim Hashimov wrote:
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
> ---
> v3: trim the changelog per Brian Foster's review; no code change. Add a
>     Fixes: tag -- the destination-bounds check has been an ASSERT since
>     the initial git import (2.6.12-rc2), so it predates the git era.
> v2: resend; v1 went out with an empty Subject line due to a local
>     git send-email glitch (leading blank line in the patch file).
> 
>  fs/xfs/xfs_buf_item_recover.c | 48 ++++++++++++++++++++++++++++-------
>  1 file changed, 39 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 02b95b89d1b5..521e5f544caf 100644
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
> @@ -489,8 +489,25 @@ xlog_recover_do_reg_buffer(
>  		ASSERT(nbits > 0);
>  		ASSERT(item->ri_buf[i].iov_base != NULL);
>  		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
> -		ASSERT(BBTOB(bp->b_length) >=
> -		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
> +
> +		/*
> +		 * The bitmap is only trustworthy to the extent that it
> +		 * describes a region that actually fits inside the buffer we
> +		 * read in based on the (attacker-controlled) blf_len.  Do not
> +		 * rely on an ASSERT() for this -- it compiles away entirely
> +		 * on non-DEBUG kernels, which is exactly where this matters,
> +		 * so validate it for real and abort recovery of this buffer
> +		 * rather than copying past the end of it.
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
> @@ -544,6 +561,7 @@ xlog_recover_do_reg_buffer(
>  	ASSERT(i == item->ri_total);
>  
>  	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
> +	return 0;
>  }
>  
>  /*
> @@ -553,7 +571,9 @@ xlog_recover_do_reg_buffer(
>   * Else, treat it as a regular buffer and do recovery.
>   *
>   * Return false if the buffer was tossed and true if we recovered the buffer to
> - * indicate to the caller if the buffer needs writing.
> + * indicate to the caller if the buffer needs writing.  *error is set if
> + * recovery of the buffer failed and the caller must abort replay of this
> + * buffer.

This is still a rather ugly function signature.  You could compress the
return value into "1 if dirty, 0 if clean, or a negative errno on
failure" and then the callsite becomes:

	error = xlog_recover_do_dquot_buffer(...):
	if (error <= 0)
		goto out_release;

	/* write dirty buffer */
	error = 0;

--D

>   */
>  STATIC bool
>  xlog_recover_do_dquot_buffer(
> @@ -561,10 +581,12 @@ xlog_recover_do_dquot_buffer(
>  	struct xlog			*log,
>  	struct xlog_recover_item	*item,
>  	struct xfs_buf			*bp,
> -	struct xfs_buf_log_format	*buf_f)
> +	struct xfs_buf_log_format	*buf_f,
> +	int				*error)
>  {
>  	uint			type;
>  
> +	*error = 0;
>  	trace_xfs_log_recover_buf_dquot_buf(log, buf_f);
>  
>  	/*
> @@ -586,7 +608,7 @@ xlog_recover_do_dquot_buffer(
>  	if (log->l_quotaoffs_flag & type)
>  		return false;
>  
> -	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
> +	*error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
>  	return true;
>  }
>  
> @@ -724,7 +746,9 @@ xlog_recover_do_primary_sb_buffer(
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
> @@ -1083,7 +1107,10 @@ xlog_recover_buf_commit_pass2(
>  		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
>  		bool	dirty;
>  
> -		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
> +		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f,
> +						     &error);
> +		if (error)
> +			goto out_release;
>  		if (!dirty)
>  			goto out_release;
>  	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
> @@ -1105,7 +1132,10 @@ xlog_recover_buf_commit_pass2(
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
> 
