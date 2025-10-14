Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1972D46D8
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 22:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479698; cv=none; b=U06KhZUk2bnoUrF7RcHy+4GK7Hj9ptHHW+oT3dnjV6lptpo/4J4g7SEH7EELF4UU/wACVyCFO+jxGbojhjC/kxlxxxaLlSluZ0bbQ8EUHuCzx9T7nvK2kiQsIneWuGsE+aP/fSOzI6Ch76o9pHTQjR2nUKWK15I9o/YLK55qgjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479698; c=relaxed/simple;
	bh=XznnKQ5Z5zvVEbtuHCT9QeKiZHG/PjKtGgIF3ZjJm7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPkNkuI0Z5fRQsKDHS7LRVKxinMEZ28SJ6i2ag9wwB2wPS+ucPMhvaTZmv1Uj3hdtdfto6Dhmri8mRR3JT3ViI6Im/H6pNsoRHNsrQfe8l59+zkyVjLqhoexA00B+3HjsoxwIzfLFyC1BZvGiM0kyqSNO/922tLBhLyEVeZb9Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0JN7w8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0JN7w8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B09C4CEE7;
	Tue, 14 Oct 2025 22:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760479698;
	bh=XznnKQ5Z5zvVEbtuHCT9QeKiZHG/PjKtGgIF3ZjJm7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G0JN7w8g5rY5jn5Xxb5RHWRyD95uQGapPwZjQiEoxB+LACzobfvATVO1iE3ZqLqI/
	 LYyC1D9CX5T0o573+hcwao75wlUXYoO4NKj/BufQULFy1RIh3M85rWSkKWPk8/3hN1
	 fKVfLYWE/mQoiaISml5guySwi7wHIzn2pZXDcEgIuxp7KK1wHtiPkrgdm+uUJcbN4F
	 2BYxp6alX8Il7+e177BaxTzifk8AxRLGDpyosP9vI9nebI8tWVua8pYi32GsbD5OLl
	 UeEEfmbLoBu+CI4TN0hG0+8bFltIJB5xt64B9jxr0wek2A54gWJqAyFRH3yT+zYpuY
	 Evha0oQhi/cUA==
Date: Tue, 14 Oct 2025 15:08:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: remove the xlog_rec_header_t typedef
Message-ID: <20251014220817.GM6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-8-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:11AM +0900, Christoph Hellwig wrote:
> There are almost no users of the typedef left, kill it and switch the
> remaining users to use the underlying struct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Woot.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h |  4 ++--
>  fs/xfs/xfs_log.c               |  6 +++---
>  fs/xfs/xfs_log_recover.c       | 28 ++++++++++++++--------------
>  3 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 4cb69bd285ca..908e7060428c 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -136,7 +136,7 @@ struct xlog_rec_ext_header {
>  #define XLOG_REC_EXT_SIZE \
>  	offsetofend(struct xlog_rec_ext_header, xh_cycle_data)
>  
> -typedef struct xlog_rec_header {
> +struct xlog_rec_header {
>  	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
>  	__be32	  h_cycle;	/* write cycle of log			:  4 */
>  	__be32	  h_version;	/* LR version				:  4 */
> @@ -174,7 +174,7 @@ typedef struct xlog_rec_header {
>  
>  	__u8	  h_reserved[184];
>  	struct xlog_rec_ext_header h_ext[];
> -} xlog_rec_header_t;
> +};
>  
>  #ifdef __i386__
>  #define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_size)
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1fe3abbd3d36..8b3b79699596 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2578,9 +2578,9 @@ xlog_state_get_iclog_space(
>  	struct xlog_ticket	*ticket,
>  	int			*logoffsetp)
>  {
> -	int		  log_offset;
> -	xlog_rec_header_t *head;
> -	xlog_in_core_t	  *iclog;
> +	int			log_offset;
> +	struct xlog_rec_header	*head;
> +	struct xlog_in_core	*iclog;
>  
>  restart:
>  	spin_lock(&log->l_icloglock);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ef0f6efc4381..03e42c7dab56 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -190,8 +190,8 @@ xlog_bwrite(
>   */
>  STATIC void
>  xlog_header_check_dump(
> -	xfs_mount_t		*mp,
> -	xlog_rec_header_t	*head)
> +	struct xfs_mount		*mp,
> +	struct xlog_rec_header		*head)
>  {
>  	xfs_debug(mp, "%s:  SB : uuid = %pU, fmt = %d",
>  		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
> @@ -207,8 +207,8 @@ xlog_header_check_dump(
>   */
>  STATIC int
>  xlog_header_check_recover(
> -	xfs_mount_t		*mp,
> -	xlog_rec_header_t	*head)
> +	struct xfs_mount	*mp,
> +	struct xlog_rec_header	*head)
>  {
>  	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
>  
> @@ -238,8 +238,8 @@ xlog_header_check_recover(
>   */
>  STATIC int
>  xlog_header_check_mount(
> -	xfs_mount_t		*mp,
> -	xlog_rec_header_t	*head)
> +	struct xfs_mount	*mp,
> +	struct xlog_rec_header	*head)
>  {
>  	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
>  
> @@ -400,7 +400,7 @@ xlog_find_verify_log_record(
>  	xfs_daddr_t		i;
>  	char			*buffer;
>  	char			*offset = NULL;
> -	xlog_rec_header_t	*head = NULL;
> +	struct xlog_rec_header	*head = NULL;
>  	int			error = 0;
>  	int			smallmem = 0;
>  	int			num_blks = *last_blk - start_blk;
> @@ -437,7 +437,7 @@ xlog_find_verify_log_record(
>  				goto out;
>  		}
>  
> -		head = (xlog_rec_header_t *)offset;
> +		head = (struct xlog_rec_header *)offset;
>  
>  		if (head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
>  			break;
> @@ -1237,7 +1237,7 @@ xlog_find_tail(
>  	xfs_daddr_t		*head_blk,
>  	xfs_daddr_t		*tail_blk)
>  {
> -	xlog_rec_header_t	*rhead;
> +	struct xlog_rec_header	*rhead;
>  	char			*offset = NULL;
>  	char			*buffer;
>  	int			error;
> @@ -1487,7 +1487,7 @@ xlog_add_record(
>  	int			tail_cycle,
>  	int			tail_block)
>  {
> -	xlog_rec_header_t	*recp = (xlog_rec_header_t *)buf;
> +	struct xlog_rec_header	*recp = (struct xlog_rec_header *)buf;
>  
>  	memset(buf, 0, BBSIZE);
>  	recp->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
> @@ -2997,7 +2997,7 @@ xlog_do_recovery_pass(
>  	int			pass,
>  	xfs_daddr_t		*first_bad)	/* out: first bad log rec */
>  {
> -	xlog_rec_header_t	*rhead;
> +	struct xlog_rec_header	*rhead;
>  	xfs_daddr_t		blk_no, rblk_no;
>  	xfs_daddr_t		rhead_blk;
>  	char			*offset;
> @@ -3034,7 +3034,7 @@ xlog_do_recovery_pass(
>  		if (error)
>  			goto bread_err1;
>  
> -		rhead = (xlog_rec_header_t *)offset;
> +		rhead = (struct xlog_rec_header *)offset;
>  
>  		/*
>  		 * xfsprogs has a bug where record length is based on lsunit but
> @@ -3141,7 +3141,7 @@ xlog_do_recovery_pass(
>  				if (error)
>  					goto bread_err2;
>  			}
> -			rhead = (xlog_rec_header_t *)offset;
> +			rhead = (struct xlog_rec_header *)offset;
>  			error = xlog_valid_rec_header(log, rhead,
>  					split_hblks ? blk_no : 0, h_size);
>  			if (error)
> @@ -3223,7 +3223,7 @@ xlog_do_recovery_pass(
>  		if (error)
>  			goto bread_err2;
>  
> -		rhead = (xlog_rec_header_t *)offset;
> +		rhead = (struct xlog_rec_header *)offset;
>  		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
>  		if (error)
>  			goto bread_err2;
> -- 
> 2.47.3
> 
> 
