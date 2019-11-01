Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E89DCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 20:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A9D52086D
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 20:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F5YKRlrP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfKAURA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 16:17:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfKAURA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 16:17:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1KDU6m053240;
        Fri, 1 Nov 2019 20:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lCZ6S+kx8tMIlQ8LloQ7m8mCx02Zegjj860DQAVMwlo=;
 b=F5YKRlrPwI5c4Pqnmf55+V04COSuNhnO/gEIaevgFTJwmBduTKoRLDyHgjZpNMJw7311
 UNudL5UHHyd2DH+Ai1Xcqo7hPoKWpYopqCV2v0+RHxxYR1TsG5qYyrwQ8/ik2rzsfZl6
 D0WdXXUrlVZDlOmtEqv5RYDefGut7K1tGfoHoReurpDGkYXzxMXvhfQth5CrxxpR6q2q
 SdkDXnfSltyVmtoOkQoERykqL5i58G4acjND5OjaPgyMxuS7ukZRHleFZeIIw5q2dPRn
 mloqX/y8/lXQMgR5RyjtpcApcJ42y+QBYqshOXhFStpM6ZCZnZkE9jzhbu8y0XwWVZVc /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vxwhg3w7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 20:16:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1KFJ73128260;
        Fri, 1 Nov 2019 20:16:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w0qdwx6y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 20:16:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1KGbaQ030483;
        Fri, 1 Nov 2019 20:16:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 13:16:37 -0700
Date:   Fri, 1 Nov 2019 13:16:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 14/16] xfs: move xfs_fc_reconfigure() above
 xfs_fc_free()
Message-ID: <20191101201635.GH15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259467671.28278.14729127257650613602.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259467671.28278.14729127257650613602.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:51:16PM +0800, Ian Kent wrote:
> Grouping the options parsing and mount handling functions above the
> struct fs_context_operations but below the struct super_operations
> should improve (some) the grouping of the super operations while also
> improving the grouping of the options parsing and mount handling code.
> 
> Start by moving xfs_fc_reconfigure() and friends.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

No functional changes, right?  I didn't see any...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |  324 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 162 insertions(+), 162 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bed914bc087b..9c5ea74dbfd5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1139,168 +1139,6 @@ xfs_quiesce_attr(
>  	xfs_log_quiesce(mp);
>  }
>  
> -static int
> -xfs_remount_rw(
> -	struct xfs_mount	*mp)
> -{
> -	struct xfs_sb		*sbp = &mp->m_sb;
> -	int error;
> -
> -	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> -		xfs_warn(mp,
> -			"ro->rw transition prohibited on norecovery mount");
> -		return -EINVAL;
> -	}
> -
> -	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> -		xfs_warn(mp,
> -	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> -			(sbp->sb_features_ro_compat &
> -				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> -		return -EINVAL;
> -	}
> -
> -	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> -
> -	/*
> -	 * If this is the first remount to writeable state we might have some
> -	 * superblock changes to update.
> -	 */
> -	if (mp->m_update_sb) {
> -		error = xfs_sync_sb(mp, false);
> -		if (error) {
> -			xfs_warn(mp, "failed to write sb changes");
> -			return error;
> -		}
> -		mp->m_update_sb = false;
> -	}
> -
> -	/*
> -	 * Fill out the reserve pool if it is empty. Use the stashed value if
> -	 * it is non-zero, otherwise go with the default.
> -	 */
> -	xfs_restore_resvblks(mp);
> -	xfs_log_work_queue(mp);
> -
> -	/* Recover any CoW blocks that never got remapped. */
> -	error = xfs_reflink_recover_cow(mp);
> -	if (error) {
> -		xfs_err(mp,
> -			"Error %d recovering leftover CoW allocations.", error);
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		return error;
> -	}
> -	xfs_start_block_reaping(mp);
> -
> -	/* Create the per-AG metadata reservation pool .*/
> -	error = xfs_fs_reserve_ag_blocks(mp);
> -	if (error && error != -ENOSPC)
> -		return error;
> -
> -	return 0;
> -}
> -
> -static int
> -xfs_remount_ro(
> -	struct xfs_mount	*mp)
> -{
> -	int error;
> -
> -	/*
> -	 * Cancel background eofb scanning so it cannot race with the final
> -	 * log force+buftarg wait and deadlock the remount.
> -	 */
> -	xfs_stop_block_reaping(mp);
> -
> -	/* Get rid of any leftover CoW reservations... */
> -	error = xfs_icache_free_cowblocks(mp, NULL);
> -	if (error) {
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		return error;
> -	}
> -
> -	/* Free the per-AG metadata reservation pool. */
> -	error = xfs_fs_unreserve_ag_blocks(mp);
> -	if (error) {
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		return error;
> -	}
> -
> -	/*
> -	 * Before we sync the metadata, we need to free up the reserve block
> -	 * pool so that the used block count in the superblock on disk is
> -	 * correct at the end of the remount. Stash the current* reserve pool
> -	 * size so that if we get remounted rw, we can return it to the same
> -	 * size.
> -	 */
> -	xfs_save_resvblks(mp);
> -
> -	xfs_quiesce_attr(mp);
> -	mp->m_flags |= XFS_MOUNT_RDONLY;
> -
> -	return 0;
> -}
> -
> -/*
> - * Logically we would return an error here to prevent users from believing
> - * they might have changed mount options using remount which can't be changed.
> - *
> - * But unfortunately mount(8) adds all options from mtab and fstab to the mount
> - * arguments in some cases so we can't blindly reject options, but have to
> - * check for each specified option if it actually differs from the currently
> - * set option and only reject it if that's the case.
> - *
> - * Until that is implemented we return success for every remount request, and
> - * silently ignore all options that we can't actually change.
> - */
> -static int
> -xfs_fc_reconfigure(
> -	struct fs_context *fc)
> -{
> -	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> -	struct xfs_mount        *new_mp = fc->s_fs_info;
> -	xfs_sb_t		*sbp = &mp->m_sb;
> -	int			flags = fc->sb_flags;
> -	int			error;
> -
> -	sync_filesystem(mp->m_super);
> -
> -	error = xfs_fc_validate_params(new_mp);
> -	if (error)
> -		return error;
> -
> -	/* inode32 -> inode64 */
> -	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> -	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> -		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> -		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> -	}
> -
> -	/* inode64 -> inode32 */
> -	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> -	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> -		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> -		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> -	}
> -
> -	/* ro -> rw */
> -	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> -		error = xfs_remount_rw(mp);
> -		if (error)
> -			return error;
> -	}
> -
> -	/* rw -> ro */
> -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> -		error = xfs_remount_ro(mp);
> -		if (error)
> -			return error;
> -	}
> -
> -	return 0;
> -}
> -
>  /*
>   * Second stage of a freeze. The data is already frozen so we only
>   * need to take care of the metadata. Once that's done sync the superblock
> @@ -1735,6 +1573,168 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static int
> +xfs_remount_rw(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	int error;
> +
> +	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited on norecovery mount");
> +		return -EINVAL;
> +	}
> +
> +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> +		xfs_warn(mp,
> +	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> +			(sbp->sb_features_ro_compat &
> +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> +		return -EINVAL;
> +	}
> +
> +	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> +
> +	/*
> +	 * If this is the first remount to writeable state we might have some
> +	 * superblock changes to update.
> +	 */
> +	if (mp->m_update_sb) {
> +		error = xfs_sync_sb(mp, false);
> +		if (error) {
> +			xfs_warn(mp, "failed to write sb changes");
> +			return error;
> +		}
> +		mp->m_update_sb = false;
> +	}
> +
> +	/*
> +	 * Fill out the reserve pool if it is empty. Use the stashed value if
> +	 * it is non-zero, otherwise go with the default.
> +	 */
> +	xfs_restore_resvblks(mp);
> +	xfs_log_work_queue(mp);
> +
> +	/* Recover any CoW blocks that never got remapped. */
> +	error = xfs_reflink_recover_cow(mp);
> +	if (error) {
> +		xfs_err(mp,
> +			"Error %d recovering leftover CoW allocations.", error);
> +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +	xfs_start_block_reaping(mp);
> +
> +	/* Create the per-AG metadata reservation pool .*/
> +	error = xfs_fs_reserve_ag_blocks(mp);
> +	if (error && error != -ENOSPC)
> +		return error;
> +
> +	return 0;
> +}
> +
> +static int
> +xfs_remount_ro(
> +	struct xfs_mount	*mp)
> +{
> +	int error;
> +
> +	/*
> +	 * Cancel background eofb scanning so it cannot race with the final
> +	 * log force+buftarg wait and deadlock the remount.
> +	 */
> +	xfs_stop_block_reaping(mp);
> +
> +	/* Get rid of any leftover CoW reservations... */
> +	error = xfs_icache_free_cowblocks(mp, NULL);
> +	if (error) {
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +
> +	/* Free the per-AG metadata reservation pool. */
> +	error = xfs_fs_unreserve_ag_blocks(mp);
> +	if (error) {
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +
> +	/*
> +	 * Before we sync the metadata, we need to free up the reserve block
> +	 * pool so that the used block count in the superblock on disk is
> +	 * correct at the end of the remount. Stash the current* reserve pool
> +	 * size so that if we get remounted rw, we can return it to the same
> +	 * size.
> +	 */
> +	xfs_save_resvblks(mp);
> +
> +	xfs_quiesce_attr(mp);
> +	mp->m_flags |= XFS_MOUNT_RDONLY;
> +
> +	return 0;
> +}
> +
> +/*
> + * Logically we would return an error here to prevent users from believing
> + * they might have changed mount options using remount which can't be changed.
> + *
> + * But unfortunately mount(8) adds all options from mtab and fstab to the mount
> + * arguments in some cases so we can't blindly reject options, but have to
> + * check for each specified option if it actually differs from the currently
> + * set option and only reject it if that's the case.
> + *
> + * Until that is implemented we return success for every remount request, and
> + * silently ignore all options that we can't actually change.
> + */
> +static int
> +xfs_fc_reconfigure(
> +	struct fs_context *fc)
> +{
> +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> +	struct xfs_mount        *new_mp = fc->s_fs_info;
> +	xfs_sb_t		*sbp = &mp->m_sb;
> +	int			flags = fc->sb_flags;
> +	int			error;
> +
> +	sync_filesystem(mp->m_super);
> +
> +	error = xfs_fc_validate_params(new_mp);
> +	if (error)
> +		return error;
> +
> +	/* inode32 -> inode64 */
> +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> +	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> +	}
> +
> +	/* inode64 -> inode32 */
> +	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> +	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> +	}
> +
> +	/* ro -> rw */
> +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> +		error = xfs_remount_rw(mp);
> +		if (error)
> +			return error;
> +	}
> +
> +	/* rw -> ro */
> +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> +		error = xfs_remount_ro(mp);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
>  static void xfs_fc_free(struct fs_context *fc)
>  {
>  	struct xfs_mount	*mp = fc->s_fs_info;
> 
