Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAB12A1BF
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 15:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784041750; cv=none; b=j6whI2IHRp+yVbzVBkDOb537dwAXdFIBYk84XCiCMkzBE4Ng88K7NOnUDwf0KVnkjjDDnPr5FVpJPUl63Srzgfnw495k09Xu1l7FPf67z3sr54Bcc9KcfftYZwO7LydoROLKnPkj43zxPbGLHohyRsWniWZzRSN1SVxvP/ycLSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784041750; c=relaxed/simple;
	bh=brtSlaXWYjEvu1apUC9GnGvgR1Va3GgEBftzZynhgww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwsVIzh8LhXDCE1s0w5MZr7qvflUoZDOQNJ0wDO2h1rSjVQ+6NpTyT/amFMLwYX6f22flHyPCrWj5XgKnd9vmoY/jSuzfiLKOQcE8WxTY22NppL3QrmoA8mf6WVOBu9q4ZxGuVOJzQuN0uGp9RHsyThQI9h2mNcyWsYFHjCcHX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=csBP4o6d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="csBP4o6d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784041747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vHo8RNl2LI2DW1/5h4rnjcUhrGhhIuy5tIua1RWi8to=;
	b=csBP4o6dS3V8iDdSkrvrHGTmrllO+EdwtMjy+1raH8PwMP7fFtsukyvIHEe9w9eAapFipD
	piUYblo+fnQhS5M4QvmXilQano7K0AbGjQwwEFm+ItjSr/flLExhBp9M/JlGN2/vlw2Ezv
	lTr/nYFF4xWkYjvjV5rifnOBlpUE1aA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-rS3m6NEjOFSZpiuBHxUBcw-1; Tue,
 14 Jul 2026 11:09:03 -0400
X-MC-Unique: rS3m6NEjOFSZpiuBHxUBcw-1
X-Mimecast-MFC-AGG-ID: rS3m6NEjOFSZpiuBHxUBcw_1784041742
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBA6818011E6;
	Tue, 14 Jul 2026 15:09:01 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01EC63000232;
	Tue, 14 Jul 2026 15:09:00 +0000 (UTC)
Date: Tue, 14 Jul 2026 11:08:58 -0400
From: Brian Foster <bfoster@redhat.com>
To: Ibrahim Hashimov <security@auditcode.ai>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: bounds-check buffer log item's dirty bitmap
Message-ID: <alZRCj6IIETEDjRM@bfoster>
References: <20260708225814.2568-1-security@auditcode.ai>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708225814.2568-1-security@auditcode.ai>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Jul 09, 2026 at 12:58:14AM +0200, Ibrahim Hashimov wrote:
> xlog_recover_do_reg_buffer() replays each dirty region a buffer log
> item's bitmap describes into the in-core buffer read for that log
> item:
> 
> 	memcpy(xfs_buf_offset(bp, (uint)bit << XFS_BLF_SHIFT),
> 		item->ri_buf[i].iov_base,
> 		nbits << XFS_BLF_SHIFT);
> 
> The only thing standing between that destination offset and the end
> of "bp" is:
> 
> 	ASSERT(BBTOB(bp->b_length) >=
> 	       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
> 
> "bp" is sized directly from the logged, attacker-controlled
> buf_f->blf_len (xlog_recover_buf_commit_pass2() ->
> xfs_buf_read(..., buf_f->blf_blkno, buf_f->blf_len, ...)), while
> "bit"/"nbits" come from the logged dirty bitmap (buf_f->blf_data_map),
> also attacker-controlled. Nothing else relates the two: the source
> side is trimmed against the log iovec length a few lines down
> (item->ri_buf[i].iov_len), but the destination side has no equivalent
> runtime check.
> 
> ASSERT() compiles to a no-op on production (non-DEBUG, non-XFS_WARN)
> kernels, which is exactly where this matters. A dirty log record
> whose buffer-log-format item logs a small blf_len (e.g. 1, a
> 512-byte buffer) together with a dirty bitmap bit that indexes past
> that buffer drives the memcpy() above straight past the end of the
> recovered buffer's backing allocation, corrupting adjacent kernel
> heap memory during mount-time log recovery of a crafted (or merely
> corrupt) XFS image. This is reachable by anyone who can get such an
> image mounted (CAP_SYS_ADMIN in the init namespace, or automount of
> removable/untrusted media) -- the standard malicious-filesystem
> threat model XFS's other verifiers guard against. Found with a
> KASAN-enabled kernel: a crafted image with a small blf_len and an
> out-of-range bitmap bit produces a slab-out-of-bounds write during
> log recovery.
> 
> Nearby recovery code already treats this class of "logged size
> doesn't match reality" problem as a real runtime condition rather
> than an invariant to assert on. In this very function, the dquot
> sanity check a few lines below does exactly that:
> 
> 	if (item->ri_buf[i].iov_len < size_disk_dquot) {
> 		xfs_alert(mp, "XFS: dquot too small (%zd) in %s.", ...);
> 		goto next;
> 	}
> 
> and its sibling xlog_recover_do_inode_buffer(), a little further down
> in this same file, converts the equivalent destination-bounds
> ASSERT() into a real XFS_IS_CORRUPT() check that aborts recovery of
> the item instead of trusting the log:
> 
> 	ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
> 	...
> 	if (XFS_IS_CORRUPT(mp, *logged_nextp == 0)) {
> 		xfs_alert(mp, "Bad inode buffer log record ...");
> 		return -EFSCORRUPTED;
> 	}
> 

In the spirit of the LLM guidelines thing Carlos had recently posted, I
feel like this commit log could probably be cut down without losing
useful information. I'm not sure we need all this detailed context and
code snippets from other functions, for example. It should be sufficient
to say something like we have runtime validation/detection in other
places like and this change is consistent.

In general, I think you should read this and think about how to cut it
down to minimally useful information. I'm not opposed to long commit
logs by any stretch, but usually these are reserved to explain
complicated problems and solutions. This is quite a lot of text for a
patch to convert a preexisting assert to a runtime check.

> Give xlog_recover_do_reg_buffer() the same treatment: turn the
> destination-bounds ASSERT() into a real XFS_IS_CORRUPT() check, log
> it with xfs_alert() (matching xlog_recover_do_inode_buffer() and the
> xfs_dquot_item_recover.c size checks), and fail recovery of this
> buffer with -EFSCORRUPTED instead of copying past its end. Since the
> function now needs to report failure, change it from "STATIC void"
> to "STATIC int" and propagate the new error out of all three
> callers:
> 
>   - xlog_recover_do_primary_sb_buffer(), which already returns int
>     and already checks other error conditions inline;
>   - xlog_recover_do_dquot_buffer(), which returns a "dirty" bool to
>     its one caller; it gains an "int *error" out-parameter so the
>     caller can distinguish "buffer intentionally skipped" from
>     "buffer recovery failed";
>   - the plain regular-buffer branch of
>     xlog_recover_buf_commit_pass2(), which already has an in-scope
>     "error" local used by the sibling branches right next to it.
> 
> This is a minimal, targeted fix: it does not change any successful
> recovery path (the new check only rejects logs that were already
> violating the invariant the ASSERT() was documenting), and it
> mirrors the exact validate-and-fail idiom already used a few lines
> away in the same file and in fs/xfs/xfs_dquot_item_recover.c.
> 
> Verified on a v6.19 KASAN-enabled kernel (CONFIG_XFS_DEBUG=n): mount
> of a crafted image whose buffer log item's dirty bitmap indexes past
> its logged blf_len trips a KASAN slab-out-of-bounds write in
> xlog_recover_do_reg_buffer() before this patch; with the patch
> applied, mounting the same image fails recovery with -EFSCORRUPTED
> and no KASAN report is produced.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> Assisted-by: AuditCode-AI:2026.07
> ---
> v2: no functional change; v1 was sent with an empty Subject line due to
>     a local git send-email glitch (leading blank line in the patch file).
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

Similarly.. not sure we need a paragraph on what we don't do here (use
an assert) and why.

Also I find the opposite logic a little more readable as a validation
check (i.e. bit/nbits too large for buffer), for whatever reason, but
others might disagree.

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

Hrm, that's kind of an ugly function signature...

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

... and the error = 0 assignment buried in the _do_dquot_buffer() call
is also kind of confusing, since these both reuse the same error path
out of the function.

I wonder if we should switch the semantics of the call to return error
and let 'dirty' be a parameter..? Another option could be to use a
special error code to reflect the !dirty case that we can check for and
reset here, but that might be too hacky as well (but if not, should
probably be a separate patch). Hm?

Brian

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

