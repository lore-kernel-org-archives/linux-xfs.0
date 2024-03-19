Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2536B3BB38
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 20:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710880822; cv=none; b=iCXd/vh0EUky/F9PqbtLCMlDuTgcW7lEmNKU0hIyalsuNHiUG4d+w1nQyMwWl61ndGXlzHFEBVx1SY/KRkOtEixgKibVvPAD2URWH8m5GzuymohHseSpFXjQhJZ4wreY1rG2pyaJ5AC14avZ0IZn76514G96WIb2wBqc1RJokjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710880822; c=relaxed/simple;
	bh=uSOBVAJtCRO9CPosgJAx9Q2dVBm3UG3FwOtVyXp+9VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QsxPDNKUVQggCsaAqAylT9mPlE0xhuqrLk4dBa2viOUS0vKSWpER6cPhOgqRc+hF7wzzyc16cbV57z+9pYIXjSivNa/0YRIdWWI+ShXw4tLpWQ94GkCNpV6t+je3dU+ExfCI+g+QuT5Qa8B4FL0YTYD47Db6r8c1GT2ozvSTaxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpaiAx18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpaiAx18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6EDC433C7;
	Tue, 19 Mar 2024 20:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710880821;
	bh=uSOBVAJtCRO9CPosgJAx9Q2dVBm3UG3FwOtVyXp+9VA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BpaiAx18r9vs4xmg8HXYk2GNss+HkG+YBbWP+w2K/JzlKRl5bbswM60EkZFhtF76S
	 uwNKdVUfPNcZuVbvyOyFNEoKAoKQ68ADAHWxN+SaQ02TqkUoZnjj2uIwg57qOur/mY
	 ky4IEk1lvpOWX85NjHuN+6j8FAyO0Uf0au3pKCgDYEGXzB+r+g2O4Bj2MB11ykMula
	 SKvN0Vk13IK27z7ce+YOfQtEgCy2bRqNAYW+ouetVOWkyb47PYbGlDiFl4gANXwBwc
	 W2JmOeXL4ckmFwbDXd02DcrpwH/WLgb2ATUT5jEgrgFG4lQgaz7fLLZRyn4zToWDr1
	 dVeWzIGBEs9ug==
Date: Tue, 19 Mar 2024 13:40:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: consistently use struct xlog in buffer item
 recovery
Message-ID: <20240319204021.GF1927156@frogsfrogsfrogs>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-6-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-6-david@fromorbit.com>

On Tue, Mar 19, 2024 at 01:15:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than passing a mix of xfs_mount and xlog (and sometimes both)
> through the call chain of buffer log item recovery, just pass
> the struct xlog and pull the xfs_mount from that only at the leaf
> functions where it is needed. This makes it all just a little
> cleaner.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item_recover.c | 94 +++++++++++++++++------------------
>  1 file changed, 47 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 9225baa62755..edd03b08c969 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -209,7 +209,7 @@ xlog_recover_buf_commit_pass1(
>   */
>  static int
>  xlog_recover_validate_buf_type(
> -	struct xfs_mount		*mp,
> +	struct xlog			*log,
>  	struct xfs_buf			*bp,
>  	struct xfs_buf_log_format	*buf_f,
>  	xfs_lsn_t			current_lsn)
> @@ -228,7 +228,7 @@ xlog_recover_validate_buf_type(
>  	 * inconsistent state resulting in verification failures. Hence for now
>  	 * just avoid the verification stage for non-crc filesystems
>  	 */
> -	if (!xfs_has_crc(mp))
> +	if (!xfs_has_crc(log->l_mp))
>  		return 0;
>  
>  	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
> @@ -396,7 +396,7 @@ xlog_recover_validate_buf_type(
>  		break;
>  #endif /* CONFIG_XFS_RT */
>  	default:
> -		xfs_warn(mp, "Unknown buffer type %d!",
> +		xfs_warn(log->l_mp, "Unknown buffer type %d!",
>  			 xfs_blft_from_flags(buf_f));
>  		break;
>  	}
> @@ -410,7 +410,7 @@ xlog_recover_validate_buf_type(
>  		return 0;
>  
>  	if (warnmsg) {
> -		xfs_warn(mp, warnmsg);
> +		xfs_warn(log->l_mp, warnmsg);
>  		xfs_buf_corruption_error(bp, __this_address);
>  		return -EFSCORRUPTED;
>  	}
> @@ -428,7 +428,7 @@ xlog_recover_validate_buf_type(
>  	 */
>  	ASSERT(bp->b_ops);
>  	bp->b_flags |= _XBF_LOGRECOVERY;
> -	xfs_buf_item_init(bp, mp);
> +	xfs_buf_item_init(bp, log->l_mp);
>  	bp->b_log_item->bli_item.li_lsn = current_lsn;
>  	return 0;
>  }
> @@ -441,7 +441,7 @@ xlog_recover_validate_buf_type(
>   */
>  static void
>  xlog_recover_buffer(
> -	struct xfs_mount		*mp,
> +	struct xlog			*log,
>  	struct xlog_recover_item	*item,
>  	struct xfs_buf			*bp,
>  	struct xfs_buf_log_format	*buf_f)
> @@ -450,7 +450,7 @@ xlog_recover_buffer(
>  	int			bit;
>  	int			nbits;
>  
> -	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
> +	trace_xfs_log_recover_buf_reg_buf(log, buf_f);
>  
>  	bit = 0;
>  	i = 1;  /* 0 is the buf format structure */
> @@ -492,14 +492,14 @@ xlog_recover_buffer(
>  
>  static int
>  xlog_recover_do_reg_buffer(
> -	struct xfs_mount		*mp,
> +	struct xlog			*log,
>  	struct xlog_recover_item	*item,
>  	struct xfs_buf			*bp,
>  	struct xfs_buf_log_format	*buf_f,
>  	xfs_lsn_t			current_lsn)
>  {
> -	xlog_recover_buffer(mp, item, bp, buf_f);
> -	return xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
> +	xlog_recover_buffer(log, item, bp, buf_f);
> +	return xlog_recover_validate_buf_type(log, bp, buf_f, current_lsn);
>  }
>  
>  /*
> @@ -513,7 +513,6 @@ xlog_recover_do_reg_buffer(
>   */
>  static bool
>  xlog_recover_this_dquot_buffer(
> -	struct xfs_mount		*mp,
>  	struct xlog			*log,
>  	struct xlog_recover_item	*item,
>  	struct xfs_buf			*bp,
> @@ -526,7 +525,7 @@ xlog_recover_this_dquot_buffer(
>  	/*
>  	 * Filesystems are required to send in quota flags at mount time.
>  	 */
> -	if (!mp->m_qflags)
> +	if (!log->l_mp->m_qflags)
>  		return false;
>  
>  	type = 0;
> @@ -550,7 +549,7 @@ xlog_recover_this_dquot_buffer(
>   */
>  static int
>  xlog_recover_verify_dquot_buf_item(
> -	struct xfs_mount		*mp,
> +	struct xlog			*log,
>  	struct xlog_recover_item	*item,
>  	struct xfs_buf			*bp,
>  	struct xfs_buf_log_format	*buf_f)
> @@ -564,7 +563,7 @@ xlog_recover_verify_dquot_buf_item(
>  	case XFS_BLFT_GDQUOT_BUF:
>  		break;
>  	default:
> -		xfs_alert(mp,
> +		xfs_alert(log->l_mp,
>  			"XFS: dquot buffer log format type mismatch in %s.",
>  			__func__);
>  		xfs_buf_corruption_error(bp, __this_address);
> @@ -573,19 +572,19 @@ xlog_recover_verify_dquot_buf_item(
>  
>  	for (i = 1; i < item->ri_total; i++) {
>  		if (item->ri_buf[i].i_addr == NULL) {
> -			xfs_alert(mp,
> +			xfs_alert(log->l_mp,
>  				"XFS: NULL dquot in %s.", __func__);
>  			return -EFSCORRUPTED;
>  		}
>  		if (item->ri_buf[i].i_len < sizeof(struct xfs_disk_dquot)) {
> -			xfs_alert(mp,
> +			xfs_alert(log->l_mp,
>  				"XFS: dquot too small (%d) in %s.",
>  				item->ri_buf[i].i_len, __func__);
>  			return -EFSCORRUPTED;
>  		}
> -		fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
> +		fa = xfs_dquot_verify(log->l_mp, item->ri_buf[i].i_addr, -1);
>  		if (fa) {
> -			xfs_alert(mp,
> +			xfs_alert(log->l_mp,
>  "dquot corrupt at %pS trying to replay into block 0x%llx",
>  				fa, xfs_buf_daddr(bp));
>  			return -EFSCORRUPTED;
> @@ -612,11 +611,12 @@ xlog_recover_verify_dquot_buf_item(
>   */
>  static int
>  xlog_recover_do_inode_buffer(
> -	struct xfs_mount		*mp,
> +	struct xlog			*log,
>  	struct xlog_recover_item	*item,
>  	struct xfs_buf			*bp,
>  	struct xfs_buf_log_format	*buf_f)
>  {
> +	struct xfs_sb			*sbp = &log->l_mp->m_sb;
>  	int				i;
>  	int				item_index = 0;
>  	int				bit = 0;
> @@ -628,7 +628,7 @@ xlog_recover_do_inode_buffer(
>  	xfs_agino_t			*logged_nextp;
>  	xfs_agino_t			*buffer_nextp;
>  
> -	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
> +	trace_xfs_log_recover_buf_inode_buf(log, buf_f);
>  
>  	/*
>  	 * If the magic number doesn't match, something has gone wrong. Don't
> @@ -641,12 +641,12 @@ xlog_recover_do_inode_buffer(
>  	 * Post recovery validation only works properly on CRC enabled
>  	 * filesystems.
>  	 */
> -	if (xfs_has_crc(mp))
> +	if (xfs_has_crc(log->l_mp))
>  		bp->b_ops = &xfs_inode_buf_ops;
>  
> -	inodes_per_buf = BBTOB(bp->b_length) >> mp->m_sb.sb_inodelog;
> +	inodes_per_buf = BBTOB(bp->b_length) >> sbp->sb_inodelog;
>  	for (i = 0; i < inodes_per_buf; i++) {
> -		next_unlinked_offset = (i * mp->m_sb.sb_inodesize) +
> +		next_unlinked_offset = (i * sbp->sb_inodesize) +
>  			offsetof(struct xfs_dinode, di_next_unlinked);
>  
>  		while (next_unlinked_offset >=
> @@ -695,8 +695,8 @@ xlog_recover_do_inode_buffer(
>  		 */
>  		logged_nextp = item->ri_buf[item_index].i_addr +
>  				next_unlinked_offset - reg_buf_offset;
> -		if (XFS_IS_CORRUPT(mp, *logged_nextp == 0)) {
> -			xfs_alert(mp,
> +		if (XFS_IS_CORRUPT(log->l_mp, *logged_nextp == 0)) {
> +			xfs_alert(log->l_mp,
>  		"Bad inode buffer log record (ptr = "PTR_FMT", bp = "PTR_FMT"). "
>  		"Trying to replay bad (0) inode di_next_unlinked field.",
>  				item, bp);
> @@ -711,8 +711,8 @@ xlog_recover_do_inode_buffer(
>  		 * have to leave the inode in a consistent state for whoever
>  		 * reads it next....
>  		 */
> -		xfs_dinode_calc_crc(mp,
> -				xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize));
> +		xfs_dinode_calc_crc(log->l_mp,
> +				xfs_buf_offset(bp, i * sbp->sb_inodesize));
>  
>  	}
>  
> @@ -734,7 +734,7 @@ xlog_recover_do_inode_buffer(
>  	 * it stale so that it won't be found on overlapping buffer lookups and
>  	 * caller knows not to queue it for delayed write.
>  	 */
> -	if (BBTOB(bp->b_length) != M_IGEO(mp)->inode_cluster_size) {
> +	if (BBTOB(bp->b_length) != M_IGEO(log->l_mp)->inode_cluster_size) {
>  		int error;
>  
>  		error = xfs_bwrite(bp);
> @@ -792,7 +792,7 @@ xlog_recovery_is_dir_buf(
>   */
>  static void
>  xlog_recover_do_partial_dabuf(
> -	struct xfs_mount		*mp,
> +	struct xlog			*log,
>  	struct xlog_recover_item	*item,
>  	struct xfs_buf			*bp,
>  	struct xfs_buf_log_format	*buf_f)
> @@ -802,7 +802,7 @@ xlog_recover_do_partial_dabuf(
>  	 * and rely on post pass2 recovery cache purge to clean these out of
>  	 * memory.
>  	 */
> -	xlog_recover_buffer(mp, item, bp, buf_f);
> +	xlog_recover_buffer(log, item, bp, buf_f);
>  }
>  
>  /*
> @@ -827,7 +827,7 @@ xlog_recover_do_partial_dabuf(
>   */
>  static xfs_lsn_t
>  xlog_recover_get_buf_lsn(
> -	struct xfs_mount	*mp,
> +	struct xlog		*log,
>  	struct xfs_buf		*bp,
>  	struct xfs_buf_log_format *buf_f)
>  {
> @@ -839,7 +839,7 @@ xlog_recover_get_buf_lsn(
>  	uint16_t		blft;
>  
>  	/* v4 filesystems always recover immediately */
> -	if (!xfs_has_crc(mp))
> +	if (!xfs_has_crc(log->l_mp))
>  		goto recover_immediately;
>  
>  	/*
> @@ -916,7 +916,7 @@ xlog_recover_get_buf_lsn(
>  		 * the relevant UUID in the superblock.
>  		 */
>  		lsn = be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
> -		if (xfs_has_metauuid(mp))
> +		if (xfs_has_metauuid(log->l_mp))
>  			uuid = &((struct xfs_dsb *)blk)->sb_meta_uuid;
>  		else
>  			uuid = &((struct xfs_dsb *)blk)->sb_uuid;
> @@ -926,7 +926,7 @@ xlog_recover_get_buf_lsn(
>  	}
>  
>  	if (lsn != (xfs_lsn_t)-1) {
> -		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
> +		if (!uuid_equal(&log->l_mp->m_sb.sb_meta_uuid, uuid))
>  			goto recover_immediately;
>  		return lsn;
>  	}
> @@ -945,7 +945,7 @@ xlog_recover_get_buf_lsn(
>  	}
>  
>  	if (lsn != (xfs_lsn_t)-1) {
> -		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
> +		if (!uuid_equal(&log->l_mp->m_sb.sb_meta_uuid, uuid))
>  			goto recover_immediately;
>  		return lsn;
>  	}
> @@ -977,14 +977,14 @@ xlog_recover_get_buf_lsn(
>   */
>  static bool
>  xlog_recover_this_buffer(
> -	struct xfs_mount		*mp,
> +	struct xlog			*log,
>  	struct xfs_buf			*bp,
>  	struct xfs_buf_log_format	*buf_f,
>  	xfs_lsn_t			current_lsn)
>  {
>  	xfs_lsn_t			lsn;
>  
> -	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
> +	lsn = xlog_recover_get_buf_lsn(log, bp, buf_f);
>  	if (!lsn)
>  		return true;
>  	if (lsn == -1)
> @@ -992,8 +992,8 @@ xlog_recover_this_buffer(
>  	if (XFS_LSN_CMP(lsn, current_lsn) < 0)
>  		return true;
>  
> -	trace_xfs_log_recover_buf_skip(mp->m_log, buf_f);
> -	xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
> +	trace_xfs_log_recover_buf_skip(log, buf_f);
> +	xlog_recover_validate_buf_type(log, bp, buf_f, NULLCOMMITLSN);
>  
>  	/*
>  	 * We're skipping replay of this buffer log item due to the log
> @@ -1065,22 +1065,22 @@ xlog_recover_buf_commit_pass2(
>  	 * to simplify the rest of the code.
>  	 */
>  	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
> -		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
> +		error = xlog_recover_do_inode_buffer(log, item, bp, buf_f);
>  		if (error || (bp->b_flags & XBF_STALE))
>  			goto out_release;
>  		goto out_write;
>  	}
>  
>  	if (buf_f->blf_flags & XFS_BLF_DQUOT_BUF) {
> -		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
> +		if (!xlog_recover_this_dquot_buffer(log, item, bp, buf_f))
>  			goto out_release;
>  
> -		error = xlog_recover_verify_dquot_buf_item(mp, item, bp, buf_f);
> +		error = xlog_recover_verify_dquot_buf_item(log, item, bp, buf_f);
>  		if (error)
>  			goto out_release;
>  
> -		xlog_recover_buffer(mp, item, bp, buf_f);
> -		error = xlog_recover_validate_buf_type(mp, bp, buf_f,
> +		xlog_recover_buffer(log, item, bp, buf_f);
> +		error = xlog_recover_validate_buf_type(log, bp, buf_f,
>  				NULLCOMMITLSN);
>  		if (error)
>  			goto out_release;
> @@ -1095,14 +1095,14 @@ xlog_recover_buf_commit_pass2(
>  	 */
>  	if (xlog_recovery_is_dir_buf(buf_f) &&
>  	    mp->m_dir_geo->blksize != BBTOB(buf_f->blf_len)) {
> -		xlog_recover_do_partial_dabuf(mp, item, bp, buf_f);
> +		xlog_recover_do_partial_dabuf(log, item, bp, buf_f);
>  		goto out_write;
>  	}
>  
>  	/*
>  	 * Whole buffer recovery, dependent on the LSN in the on-disk structure.
>  	 */
> -	if (!xlog_recover_this_buffer(mp, bp, buf_f, current_lsn)) {
> +	if (!xlog_recover_this_buffer(log, bp, buf_f, current_lsn)) {
>  		/*
>  		 * We may have verified this buffer even though we aren't
>  		 * recovering it. Return the verifier error for early detection
> @@ -1113,7 +1113,7 @@ xlog_recover_buf_commit_pass2(
>  	}
>  
>  
> -	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +	error = xlog_recover_do_reg_buffer(log, item, bp, buf_f, current_lsn);
>  	if (error)
>  		goto out_release;
>  
> -- 
> 2.43.0
> 
> 
