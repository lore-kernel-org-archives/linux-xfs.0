Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0344C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 03:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiD0DSA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiD0DR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 23:17:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1825B13CE1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 20:14:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB127B81FE0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 03:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81897C385A4;
        Wed, 27 Apr 2022 03:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651029285;
        bh=NYvDCBEFUyaC87ooE3XfQ1C1xbfNDEOy3nAvjfixAzA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9LSj2IRLmPBi/N8IlDFj/iHjilrlwHzB4xL67D5o2bn/C2bux8vPRGX8XG8DAZLq
         6817BoMlzAYf0Il+EYtwjmqM6EQnQgr//mFQYcMN9i+PU/0lf3LxLHYe5zSL7a0iVe
         pGQadjg6zXv0FxviayelUqoSmUCtY9wEp/Be0Kjuqc5bar4HgHufNmp3sOhFMAkpDt
         v/M57u0Wn668UsXaocH7bVlHPv+wjB1aOM34CAeEGa7x6KNmfbJLo659AjT4/6OVp8
         CPV7iUC4TSwd3/W6ZkE4L4jura2ztfZdm1CByI+k6tPKzJAna2Xk1mK3j4PwmL0Tqx
         ZUxZYUZiwN6xA==
Date:   Tue, 26 Apr 2022 20:14:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: hide log iovec alignment constraints
Message-ID: <20220427031445.GD17025@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Callers currently have to round out the size of buffers to match the
> aligment constraints of log iovecs and xlog_write(). They should not
> need to know this detail, so introduce a new function to calculate
> the iovec length (for use in ->iop_size implementations). Also
> modify xlog_finish_iovec() to round up the length to the correct
> alignment so the callers don't need to do this, either.
> 
> Convert the only user - inode forks - of this alignment rounding to
> use the new interface.

Hmm.  So currently, we require that the inode fork buffer be rounded up
to the next 4 bytes, and then I guess the log will copy that into the
log iovec?  IOWs, if we have a 37-byte data fork, we'll allocate a 40
byte buffer for the xfs_ifork, and the log will copy all 40 bytes into a
40 byte iovec.

Now it looks like we'd allocate a 37-byte buffer for the xfs_ifork, but
the log iovec will still be 40 bytes.  So ... do we copy 37 bytes out of
the ifork buffer and zero the last 3 bytes in the iovec?  Does we leak
kernel memory in those last 3 bytes?  Or do we copy 40 bytes and
overrun?

It sorta looks like (at least for the local format case) xlog_copy_iovec
will copy 37 bytes and leave the last 3 bytes of the iovec in whatever
state it was in previously.  Is that zeroed?  Because it then looks like
xlog_finish_iovec will round that 37 up to 40.

(FWIW I'm just checking for kernel memory exposure vectors here.)

--D

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.c  | 12 +++---------
>  fs/xfs/xfs_inode_item.c         | 25 +++++++------------------
>  fs/xfs/xfs_inode_item_recover.c |  4 ++--
>  fs/xfs/xfs_log.h                | 23 +++++++++++++++++++++++
>  4 files changed, 35 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 9aee4a1e2fe9..1a4cdf550f6d 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -36,7 +36,7 @@ xfs_init_local_fork(
>  	int64_t			size)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> -	int			mem_size = size, real_size = 0;
> +	int			mem_size = size;
>  	bool			zero_terminate;
>  
>  	/*
> @@ -50,8 +50,7 @@ xfs_init_local_fork(
>  		mem_size++;
>  
>  	if (size) {
> -		real_size = roundup(mem_size, 4);
> -		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
> +		ifp->if_u1.if_data = kmem_alloc(mem_size, KM_NOFS);
>  		memcpy(ifp->if_u1.if_data, data, size);
>  		if (zero_terminate)
>  			ifp->if_u1.if_data[size] = '\0';
> @@ -497,12 +496,7 @@ xfs_idata_realloc(
>  		return;
>  	}
>  
> -	/*
> -	 * For inline data, the underlying buffer must be a multiple of 4 bytes
> -	 * in size so that it can be logged and stay on word boundaries.
> -	 * We enforce that here.
> -	 */
> -	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
> +	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, new_size,
>  				      GFP_NOFS | __GFP_NOFAIL);
>  	ifp->if_bytes = new_size;
>  }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 00733a18ccdc..721def0639fd 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -71,7 +71,7 @@ xfs_inode_item_data_fork_size(
>  	case XFS_DINODE_FMT_LOCAL:
>  		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
>  		    ip->i_df.if_bytes > 0) {
> -			*nbytes += roundup(ip->i_df.if_bytes, 4);
> +			*nbytes += xlog_calc_iovec_len(ip->i_df.if_bytes);
>  			*nvecs += 1;
>  		}
>  		break;
> @@ -112,7 +112,7 @@ xfs_inode_item_attr_fork_size(
>  	case XFS_DINODE_FMT_LOCAL:
>  		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
>  		    ip->i_afp->if_bytes > 0) {
> -			*nbytes += roundup(ip->i_afp->if_bytes, 4);
> +			*nbytes += xlog_calc_iovec_len(ip->i_afp->if_bytes);
>  			*nvecs += 1;
>  		}
>  		break;
> @@ -204,17 +204,12 @@ xfs_inode_item_format_data_fork(
>  			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
>  		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
>  		    ip->i_df.if_bytes > 0) {
> -			/*
> -			 * Round i_bytes up to a word boundary.
> -			 * The underlying memory is guaranteed
> -			 * to be there by xfs_idata_realloc().
> -			 */
> -			data_bytes = roundup(ip->i_df.if_bytes, 4);
>  			ASSERT(ip->i_df.if_u1.if_data != NULL);
>  			ASSERT(ip->i_disk_size > 0);
>  			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
> -					ip->i_df.if_u1.if_data, data_bytes);
> -			ilf->ilf_dsize = (unsigned)data_bytes;
> +					ip->i_df.if_u1.if_data,
> +					ip->i_df.if_bytes);
> +			ilf->ilf_dsize = (unsigned)ip->i_df.if_bytes;
>  			ilf->ilf_size++;
>  		} else {
>  			iip->ili_fields &= ~XFS_ILOG_DDATA;
> @@ -288,17 +283,11 @@ xfs_inode_item_format_attr_fork(
>  
>  		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
>  		    ip->i_afp->if_bytes > 0) {
> -			/*
> -			 * Round i_bytes up to a word boundary.
> -			 * The underlying memory is guaranteed
> -			 * to be there by xfs_idata_realloc().
> -			 */
> -			data_bytes = roundup(ip->i_afp->if_bytes, 4);
>  			ASSERT(ip->i_afp->if_u1.if_data != NULL);
>  			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
>  					ip->i_afp->if_u1.if_data,
> -					data_bytes);
> -			ilf->ilf_asize = (unsigned)data_bytes;
> +					ip->i_afp->if_bytes);
> +			ilf->ilf_asize = (unsigned)ip->i_afp->if_bytes;
>  			ilf->ilf_size++;
>  		} else {
>  			iip->ili_fields &= ~XFS_ILOG_ADATA;
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 6d44f5fd6d7e..d28ffaebd067 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -462,7 +462,7 @@ xlog_recover_inode_commit_pass2(
>  	ASSERT(in_f->ilf_size <= 4);
>  	ASSERT((in_f->ilf_size == 3) || (fields & XFS_ILOG_AFORK));
>  	ASSERT(!(fields & XFS_ILOG_DFORK) ||
> -	       (len == in_f->ilf_dsize));
> +	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
>  
>  	switch (fields & XFS_ILOG_DFORK) {
>  	case XFS_ILOG_DDATA:
> @@ -497,7 +497,7 @@ xlog_recover_inode_commit_pass2(
>  		}
>  		len = item->ri_buf[attr_index].i_len;
>  		src = item->ri_buf[attr_index].i_addr;
> -		ASSERT(len == in_f->ilf_asize);
> +		ASSERT(len == xlog_calc_iovec_len(in_f->ilf_asize));
>  
>  		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
>  		case XFS_ILOG_ADATA:
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 8dafe8f771c7..d9aebca3f971 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -21,6 +21,17 @@ struct xfs_log_vec {
>  
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
> +/*
> + * Calculate the log iovec length for a given user buffer length. Intended to be
> + * used by ->iop_size implementations when sizing buffers of arbitrary
> + * alignments.
> + */
> +static inline int
> +xlog_calc_iovec_len(int len)
> +{
> +	return roundup(len, 4);
> +}
> +
>  void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		uint type);
>  
> @@ -29,6 +40,12 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
>  {
>  	struct xlog_op_header	*oph = vec->i_addr;
>  
> +	/*
> +	 * Always round up the length to the correct alignment so callers don't
> +	 * need to know anything about this log vec layout requirement.
> +	 */
> +	len = xlog_calc_iovec_len(len);
> +
>  	/* opheader tracks payload length, logvec tracks region length */
>  	oph->oh_len = cpu_to_be32(len);
>  
> @@ -36,8 +53,14 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
>  	lv->lv_buf_len += len;
>  	lv->lv_bytes += len;
>  	vec->i_len = len;
> +
> +	/* Catch buffer overruns */
> +	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
>  }
>  
> +/*
> + * Copy the amount of data requested by the caller into a new log iovec.
> + */
>  static inline void *
>  xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		uint type, void *data, int len)
> -- 
> 2.35.1
> 
