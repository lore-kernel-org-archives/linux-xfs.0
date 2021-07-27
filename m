Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9C2C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 22:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BC4E60EB2
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 22:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhG0WyB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 18:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhG0WyB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 18:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ECE360F90;
        Tue, 27 Jul 2021 22:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627426440;
        bh=iNwbfX8LhPcbkAU/CqKBRuH82rEug4uUsge7KALWDOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UEY2PfEh4ws1yFgJ8Tw39zDDEM3wdMxB19fTOcPOvDLfsV8/H2jCd2PIldv5QqTiD
         RJoabrWnQX1QXHu28uNEgMAIc+AEC8Jm+JeqrEYri838oU5UMuQoc2b2NY1482GuxH
         qaXdLo0ugq6dWu76+aEVtoye8Ntvdp0GEotfBREq4zgEDMjxD1xQ1BKXIwkKBmRIlG
         BMcyDr3iKXhnOs9zQ1V5utXFk+cHQt/xe1yl3qXzsLt0oXUaR57YGGUkl+2ktihG7g
         AXdv6nU0Ss0hhvXc5mqFLXRU9R6Cu4Hnj+JaNmHfzsS1cfD7+HA+4P65u293WNgz7v
         tj7rTTuDK4InA==
Date:   Tue, 27 Jul 2021 15:54:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 09/12] xfs: Rename XFS_IOC_BULKSTAT to
 XFS_IOC_BULKSTAT_V5
Message-ID: <20210727225400.GS559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-10-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-10-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:38PM +0530, Chandan Babu R wrote:
> This commit renames XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5 to allow a future
> commit to extend bulkstat facility to support 64-bit extent counters. To this
> end, this commit also renames xfs_bulkstat->bs_extents field to
> xfs_bulkstat->bs_extents32.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h |  4 ++--
>  fs/xfs/xfs_ioctl.c     | 27 ++++++++++++++++++++++-----
>  fs/xfs/xfs_ioctl32.c   |  7 +++++++
>  fs/xfs/xfs_itable.c    |  4 ++--
>  fs/xfs/xfs_itable.h    |  1 +
>  5 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2594fb647384..d760a969599e 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -394,7 +394,7 @@ struct xfs_bulkstat {
>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>  
>  	uint32_t	bs_nlink;	/* number of links		*/
> -	uint32_t	bs_extents;	/* number of extents		*/
> +	uint32_t	bs_extents32;	/* number of extents		*/

I wish I'd thought of this when we introduced bulkstat v5 so you
wouldn't have had to do this.

(I might have more to say in the bulkstat v6 patch review.)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>  	uint16_t	bs_version;	/* structure version		*/
>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
> @@ -853,7 +853,7 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)
>  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
>  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
> -#define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
> +#define XFS_IOC_BULKSTAT_V5	     _IOR ('X', 127, struct xfs_bulkstat_req)
>  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
>  /*	FIEXCHANGE_RANGE ----------- hoisted 129	 */
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2da90f81e6e3..85f45340cb16 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -715,6 +715,8 @@ xfs_fsbulkstat_one_fmt(
>  {
>  	struct xfs_bstat		bs1;
>  
> +	ASSERT(breq->version == XFS_BULKSTAT_VERSION_V1);
> +
>  	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
>  	if (copy_to_user(breq->ubuffer, &bs1, sizeof(bs1)))
>  		return -EFAULT;
> @@ -728,6 +730,8 @@ xfs_fsinumbers_fmt(
>  {
>  	struct xfs_inogrp		ig1;
>  
> +	ASSERT(breq->version == XFS_INUMBERS_VERSION_V1);
> +
>  	xfs_inumbers_to_inogrp(&ig1, igrp);
>  	if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
>  		return -EFAULT;
> @@ -787,14 +791,17 @@ xfs_ioc_fsbulkstat(
>  	 */
>  	if (cmd == XFS_IOC_FSINUMBERS) {
>  		breq.startino = lastino ? lastino + 1 : 0;
> +		breq.version = XFS_INUMBERS_VERSION_V1;
>  		error = xfs_inumbers(&breq, xfs_fsinumbers_fmt);
>  		lastino = breq.startino - 1;
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
>  		breq.startino = lastino;
>  		breq.icount = 1;
> +		breq.version = XFS_BULKSTAT_VERSION_V1;
>  		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
>  	} else {	/* XFS_IOC_FSBULKSTAT */
>  		breq.startino = lastino ? lastino + 1 : 0;
> +		breq.version = XFS_BULKSTAT_VERSION_V1;
>  		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
>  		lastino = breq.startino - 1;
>  	}
> @@ -819,6 +826,8 @@ xfs_bulkstat_fmt(
>  	struct xfs_ibulk		*breq,
>  	const struct xfs_bulkstat	*bstat)
>  {
> +	ASSERT(breq->version == XFS_BULKSTAT_VERSION_V5);
> +
>  	if (copy_to_user(breq->ubuffer, bstat, sizeof(struct xfs_bulkstat)))
>  		return -EFAULT;
>  	return xfs_ibulk_advance(breq, sizeof(struct xfs_bulkstat));
> @@ -918,13 +927,15 @@ STATIC int
>  xfs_ioc_bulkstat(
>  	struct file			*file,
>  	unsigned int			cmd,
> -	struct xfs_bulkstat_req __user	*arg)
> +	struct xfs_bulkstat_req __user	*arg,
> +	int				version)
>  {
>  	struct xfs_mount		*mp = XFS_I(file_inode(file))->i_mount;
>  	struct xfs_bulk_ireq		hdr;
>  	struct xfs_ibulk		breq = {
>  		.mp			= mp,
>  		.mnt_userns		= file_mnt_user_ns(file),
> +		.version		= version,
>  	};
>  	int				error;
>  
> @@ -960,6 +971,8 @@ xfs_inumbers_fmt(
>  	struct xfs_ibulk		*breq,
>  	const struct xfs_inumbers	*igrp)
>  {
> +	ASSERT(breq->version == XFS_INUMBERS_VERSION_V5);
> +
>  	if (copy_to_user(breq->ubuffer, igrp, sizeof(struct xfs_inumbers)))
>  		return -EFAULT;
>  	return xfs_ibulk_advance(breq, sizeof(struct xfs_inumbers));
> @@ -970,11 +983,13 @@ STATIC int
>  xfs_ioc_inumbers(
>  	struct xfs_mount		*mp,
>  	unsigned int			cmd,
> -	struct xfs_inumbers_req __user	*arg)
> +	struct xfs_inumbers_req __user	*arg,
> +	int				version)
>  {
>  	struct xfs_bulk_ireq		hdr;
>  	struct xfs_ibulk		breq = {
>  		.mp			= mp,
> +		.version		= version,
>  	};
>  	int				error;
>  
> @@ -1882,10 +1897,12 @@ xfs_file_ioctl(
>  	case XFS_IOC_FSINUMBERS:
>  		return xfs_ioc_fsbulkstat(filp, cmd, arg);
>  
> -	case XFS_IOC_BULKSTAT:
> -		return xfs_ioc_bulkstat(filp, cmd, arg);
> +	case XFS_IOC_BULKSTAT_V5:
> +		return xfs_ioc_bulkstat(filp, cmd, arg,
> +				XFS_BULKSTAT_VERSION_V5);
>  	case XFS_IOC_INUMBERS:
> -		return xfs_ioc_inumbers(mp, cmd, arg);
> +		return xfs_ioc_inumbers(mp, cmd, arg,
> +				XFS_INUMBERS_VERSION_V5);
>  
>  	case XFS_IOC_FSGEOMETRY_V1:
>  		return xfs_ioc_fsgeometry(mp, arg, 3);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index bef19060f4aa..d9a7abc209b5 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -88,6 +88,8 @@ xfs_fsinumbers_fmt_compat(
>  	struct xfs_inogrp		ig1;
>  	struct xfs_inogrp		*igrp = &ig1;
>  
> +	ASSERT(breq->version == XFS_INUMBERS_VERSION_V1);
> +
>  	xfs_inumbers_to_inogrp(&ig1, ig);
>  
>  	if (put_user(igrp->xi_startino,   &p32->xi_startino) ||
> @@ -177,6 +179,8 @@ xfs_fsbulkstat_one_fmt_compat(
>  	struct xfs_bstat		bs1;
>  	struct xfs_bstat		*buffer = &bs1;
>  
> +	ASSERT(breq->version == XFS_BULKSTAT_VERSION_V1);
> +
>  	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
>  
>  	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
> @@ -293,15 +297,18 @@ xfs_compat_ioc_fsbulkstat(
>  	 */
>  	if (cmd == XFS_IOC_FSINUMBERS_32) {
>  		breq.startino = lastino ? lastino + 1 : 0;
> +		breq.version = XFS_INUMBERS_VERSION_V1;
>  		error = xfs_inumbers(&breq, inumbers_func);
>  		lastino = breq.startino - 1;
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
>  		breq.startino = lastino;
>  		breq.icount = 1;
> +		breq.version = XFS_BULKSTAT_VERSION_V1;
>  		error = xfs_bulkstat_one(&breq, bs_one_func);
>  		lastino = breq.startino;
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
>  		breq.startino = lastino ? lastino + 1 : 0;
> +		breq.version = XFS_BULKSTAT_VERSION_V1;
>  		error = xfs_bulkstat(&breq, bs_one_func);
>  		lastino = breq.startino - 1;
>  	} else {
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 65c194cdea79..f0daa65e61ff 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -134,7 +134,7 @@ xfs_bulkstat_one_int(
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
>  	buf->bs_extsize_blks = ip->i_extsize;
> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
> +	buf->bs_extents32 = xfs_ifork_nextents(&ip->i_df);
>  	xfs_bulkstat_health(ip, buf);
>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
> @@ -356,7 +356,7 @@ xfs_bulkstat_to_bstat(
>  	bs1->bs_blocks = bstat->bs_blocks;
>  	bs1->bs_xflags = bstat->bs_xflags;
>  	bs1->bs_extsize = XFS_FSB_TO_B(mp, bstat->bs_extsize_blks);
> -	bs1->bs_extents = bstat->bs_extents;
> +	bs1->bs_extents = bstat->bs_extents32;
>  	bs1->bs_gen = bstat->bs_gen;
>  	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
>  	bs1->bs_forkoff = bstat->bs_forkoff;
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index f5a13f69883a..ee4d8d0461ca 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -14,6 +14,7 @@ struct xfs_ibulk {
>  	unsigned int		icount;   /* number of elements in ubuffer */
>  	unsigned int		ocount;   /* number of records returned */
>  	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
> +	int			version;  /* structure version to be returned */
>  };
>  
>  /* Only iterate within the same AG as startino */
> -- 
> 2.30.2
> 
