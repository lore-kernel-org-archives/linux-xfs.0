Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44K0ehg081735 for <xfs@oss.sgi.com>; Fri, 4 May 2012 15:00:40 -0500
Date: Fri, 4 May 2012 15:04:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v5 PATCH 2/4] xfs: Add pquota fields where gquota is used.
Message-ID: <20120504200403.GW16881@sgi.com>
References: <20120314202623.17044.90045.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120314202636.17044.11836.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120314202636.17044.11836.sendpatchset@chandra-lucid.austin.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 14, 2012 at 03:26:36PM -0500, Chandra Seetharaman wrote:
> @@ -1517,7 +1521,7 @@ xfs_symlink(
>  	int			n;
>  	xfs_buf_t		*bp;
>  	prid_t			prid;
> -	struct xfs_dquot	*udqp, *gdqp;
> +	struct xfs_dquot	*udqp, *gdqp, *pdqp;
>  	uint			resblks;
>  
>  	*ipp = NULL;
> @@ -1547,7 +1551,7 @@ xfs_symlink(
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
>  	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> -			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
> +		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
>  	if (error)
>  		goto std_return;
>  
> @@ -1588,7 +1592,8 @@ xfs_symlink(
>  	/*
>  	 * Reserve disk quota : blocks and inode.
>  	 */
> -	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
> +	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
> +						pdqp, resblks, 1, 0);
>  	if (error)
>  		goto error_return;
>  
> @@ -1626,7 +1631,7 @@ xfs_symlink(
>  	/*
>  	 * Also attach the dquot(s) to it, if applicable.
>  	 */
> -	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
> +	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
>  	if (resblks)
>  		resblks -= XFS_IALLOC_SPACE_RES(mp);
> @@ -1710,6 +1715,7 @@ xfs_symlink(
>  	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
>  	return 0;
> @@ -1723,6 +1729,7 @@ xfs_symlink(
>  	xfs_trans_cancel(tp, cancel_flags);
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
		      ^^^^

Crashing here consistently on test 005, null ptr deref.

pdqp needs to be initialized in this function:

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c
+++ xfs/fs/xfs/xfs_vnodeops.c
@@ -1525,7 +1525,7 @@ xfs_symlink(
        if (pathlen >= MAXPATHLEN)      /* total string too long */
                return XFS_ERROR(ENAMETOOLONG);
 
-       udqp = gdqp = NULL;
+       udqp = gdqp = pdqp = NULL;
        if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
                prid = xfs_get_projid(dp);
        else


-Ben

>  
>  	if (unlock_dp_on_error)
>  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> @@ -2189,7 +2196,7 @@ xfs_free_file_space(
>  		}
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		error = xfs_trans_reserve_quota(tp, mp,
> -				ip->i_udquot, ip->i_gdquot,
> +				ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
>  				resblks, 0, XFS_QMOPT_RES_REGBLKS);
>  		if (error)
>  			goto error1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
