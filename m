Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56184 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753943AbeGFDk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:40:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w663cxsC165858
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:40:55 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2k0dnjr0yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:40:55 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w663esOO003963
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:40:55 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w663espK023670
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:40:54 GMT
Date: Thu, 5 Jul 2018 20:40:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 5/8] xfs: consider the local format inode in misc
 operations
Message-ID: <20180706034053.GP32415@magnolia>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-6-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-6-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:26AM +0800, Shan Hai wrote:
> The local format inode is a legal citizen from now on and consider
> it in misc operations.
> 
> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c      | 18 ++++++++++--------
>  fs/xfs/libxfs/xfs_inode_buf.c |  6 ------
>  fs/xfs/scrub/inode.c          |  2 +-
>  fs/xfs/xfs_bmap_util.c        | 11 +++++++++--
>  fs/xfs/xfs_inode.c            | 20 ++++++++++++++------
>  fs/xfs/xfs_inode_item.c       |  5 ++++-
>  fs/xfs/xfs_iomap.c            |  5 +++--
>  fs/xfs/xfs_log_recover.c      |  3 ++-
>  8 files changed, 43 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index bea6dc254a7d..6b151bd15da7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -830,11 +830,6 @@ xfs_bmap_local_to_extents(
>  	struct xfs_bmbt_irec rec;
>  	struct xfs_iext_cursor icur;
>  
> -	/*
> -	 * We don't want to deal with the case of keeping inode data inline yet.
> -	 * So sending the data fork of a regular inode is invalid.
> -	 */
> -	ASSERT(!(S_ISREG(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK));
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
>  
> @@ -3840,7 +3835,8 @@ xfs_bmapi_read(
>  
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> -	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
> +	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> +	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL),
>  	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT("xfs_bmapi_read", XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
> @@ -3863,7 +3859,7 @@ xfs_bmapi_read(
>  		return 0;
>  	}
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +	if (!(ifp->if_flags & (XFS_IFINLINE | XFS_IFEXTENTS))) {
>  		error = xfs_iread_extents(NULL, ip, whichfork);
>  		if (error)
>  			return error;
> @@ -4285,7 +4281,6 @@ xfs_bmapi_write(
>  	       (flags & (XFS_BMAPI_CONVERT | XFS_BMAPI_COWFORK)) ==
>  			(XFS_BMAPI_CONVERT | XFS_BMAPI_COWFORK));
>  	ASSERT(len > 0);
> -	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(!(flags & XFS_BMAPI_REMAP));
>  
> @@ -5244,11 +5239,18 @@ __xfs_bunmapi(
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if (unlikely(
>  	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> +	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL &&
>  	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
>  		XFS_ERROR_REPORT("xfs_bunmapi", XFS_ERRLEVEL_LOW,
>  				 ip->i_mount);
>  		return -EFSCORRUPTED;
>  	}
> +
> +	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
> +		*rlen = 0;
> +		return 0;
> +	}
> +
>  	mp = ip->i_mount;
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 33dc34655ac3..cb3c4b308137 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -157,7 +157,6 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
>  	.verify_write = xfs_inode_buf_write_verify,
>  };
>  
> -
>  /*
>   * This routine is called to map an inode to the buffer containing the on-disk
>   * version of the inode.  It returns a pointer to the buffer containing the
> @@ -384,12 +383,7 @@ xfs_dinode_verify_fork(
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
> -		/*
> -		 * no local regular files yet
> -		 */
>  		if (whichfork == XFS_DATA_FORK) {
> -			if (S_ISREG(be16_to_cpu(dip->di_mode)))
> -				return __this_address;
>  			if (be64_to_cpu(dip->di_size) >
>  					XFS_DFORK_SIZE(dip, mp, whichfork))
>  				return __this_address;
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 7a6208505980..1501983dd7aa 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -283,7 +283,7 @@ xfs_scrub_dinode(
>  			xfs_scrub_ino_set_corrupt(sc, ino);
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -		if (!S_ISDIR(mode) && !S_ISLNK(mode))
> +		if (!S_ISREG(mode) && !S_ISDIR(mode) && !S_ISLNK(mode))
>  			xfs_scrub_ino_set_corrupt(sc, ino);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 83b1e8c6c18f..46f718177fd7 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -760,7 +760,8 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
>  		return false;
>  
>  	/* If we haven't read in the extent list, then don't do it now. */
> -	if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
> +	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL &&
> +		!(ip->i_df.if_flags & XFS_IFEXTENTS))
>  		return false;
>  
>  	/*
> @@ -768,7 +769,8 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
>  	 * has delalloc blocks and we are forced to remove them.
>  	 */
>  	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
> -		if (!force || ip->i_delayed_blks == 0)
> +		if ((ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) &&
> +			(!force || ip->i_delayed_blks == 0))
>  			return false;
>  
>  	return true;
> @@ -792,6 +794,11 @@ xfs_free_eofblocks(
>  	struct xfs_bmbt_irec	imap;
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> +	if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
> +		ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {

Bleh, this indentation is confusing me.

if (foobarblahblabhlbahlabhlabh... &&
    bazcow...)
	dostuff();

or:

if (foobarblahblabhlabhalbhba.. &&
		bazcow...)
	dostuff();

> +		ip->i_delayed_blks = 0;
> +		return 0;
> +	}
>  	/*
>  	 * Figure out if there are any blocks beyond the end
>  	 * of the file.  If not, then there is nothing to do.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5df4de666cc1..78b9790a7cd4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1563,7 +1563,6 @@ xfs_itruncate_extents_flags(
>  	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
>  
>  	trace_xfs_itruncate_extents_start(ip, new_size);
> -
>  	flags |= xfs_bmapi_aflag(whichfork);
>  
>  	/*
> @@ -1745,9 +1744,15 @@ xfs_inactive_truncate(
>  	ip->i_d.di_size = 0;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
> -	if (error)
> -		goto error_trans_cancel;
> +	if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
> +		ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(ip->i_d.di_nextents == 0);
> +		ip->i_delayed_blks = 0;
> +	} else {
> +		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
> +		if (error)
> +			goto error_trans_cancel;
> +	}
>  
>  	ASSERT(ip->i_d.di_nextents == 0);
>  
> @@ -1879,6 +1884,7 @@ xfs_inactive(
>  	if (VFS_I(ip)->i_mode == 0) {
>  		ASSERT(ip->i_df.if_real_bytes == 0);
>  		ASSERT(ip->i_df.if_broot_bytes == 0);
> +		ASSERT(ip->i_delayed_blks == 0);

Why?

>  		return;
>  	}
>  
> @@ -1911,8 +1917,9 @@ xfs_inactive(
>  
>  	if (S_ISREG(VFS_I(ip)->i_mode) &&
>  	    (ip->i_d.di_size != 0 || XFS_ISIZE(ip) != 0 ||
> -	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
> +	     ip->i_d.di_nextents >= 0 || ip->i_delayed_blks >= 0)) {

Why does the test change from > to >= ?

>  		truncate = 1;
> +	}
>  
>  	error = xfs_qm_dqattach(ip);
>  	if (error)
> @@ -3554,7 +3561,8 @@ xfs_iflush_int(
>  	if (S_ISREG(VFS_I(ip)->i_mode)) {
>  		if (XFS_TEST_ERROR(
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
> -		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
> +		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
> +		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
>  		    mp, XFS_ERRTAG_IFLUSH_3)) {
>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  				"%s: Bad regular inode %Lu, ptr "PTR_FMT,
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 2389c34c172d..52b297987a75 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -139,6 +139,7 @@ xfs_inode_item_format_data_fork(
>  	struct xfs_log_iovec	**vecp)
>  {
>  	struct xfs_inode	*ip = iip->ili_inode;
> +	struct xfs_mount	*mp = ip->i_mount;
>  	size_t			data_bytes;
>  
>  	switch (ip->i_d.di_format) {
> @@ -197,7 +198,9 @@ xfs_inode_item_format_data_fork(
>  			ASSERT(ip->i_df.if_real_bytes == 0 ||
>  			       ip->i_df.if_real_bytes >= data_bytes);
>  			ASSERT(ip->i_df.if_u1.if_data != NULL);
> -			ASSERT(ip->i_d.di_size > 0);
> +			if (!xfs_sb_version_hasinlinedata(&mp->m_sb)) {
> +				ASSERT(ip->i_d.di_size > 0);

ASSERT(di_size > 0 || hasinlinedata); ??

> +			}
>  			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
>  					ip->i_df.if_u1.if_data, data_bytes);
>  			ilf->ilf_dsize = (unsigned)data_bytes;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 55876dd02f0c..aa72966081c5 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -532,7 +532,8 @@ xfs_file_iomap_begin_delay(
>  
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
> -	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
> +	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE &&
> +	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_LOCAL),
>  	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		error = -EFSCORRUPTED;
> @@ -541,7 +542,7 @@ xfs_file_iomap_begin_delay(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapw);
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +	if (!(ifp->if_flags & (XFS_IFINLINE |XFS_IFEXTENTS))) {
>  		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
>  		if (error)
>  			goto out_unlock;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b181b5f57a19..d8828f275d9a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3121,7 +3121,8 @@ xlog_recover_inode_pass2(
>  
>  	if (unlikely(S_ISREG(ldip->di_mode))) {
>  		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
> -		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
> +		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
> +		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
>  			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
>  					 XFS_ERRLEVEL_LOW, mp, ldip,
>  					 sizeof(*ldip));
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
