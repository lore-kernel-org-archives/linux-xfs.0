Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00462FA3728
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5EBB218DE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:29:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h7BBbDAR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394194AbfJPS31 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:29:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54806 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390895AbfJPS31 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 14:29:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIIrfJ128639;
        Wed, 16 Oct 2019 18:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Vp7wPXCObQu3O6GaOw+FnLoCSd5E/0b4SbjrbqL8K1g=;
 b=h7BBbDAR+3k3gn1DoxBI+pEMPugrtT4dPyUvSkOeBiCG6oPT208LYHkmj9ZJF4DHr2Ms
 vJZbN3PmYdpFq88jTXcRvN50pN6iTkQNoqdKG+HPiP5l/ecA1mOwHpRPAUpwrEYlyzTB
 L0kjPieskUFlxc4E+YDbRWzDJMJJzXFS9jxLrq2A8U2GXaWQMkpHm0WGo4GL65xCQKgR
 5hPepYUB18ewc6jtxuaT8EeeRoAwGYwJRo/cexO6L0Cg+aKcXW4P6hDwWxjWjTd3l7eP
 ygJoDSiOaEMjND/Kp1Asna8FDXP7Uee83xH+u72CrtisUl47FzP288tkxH+Kq+XjN8iS 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vk6sqrypa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:29:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIJ7B0057205;
        Wed, 16 Oct 2019 18:29:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vp3bhqhkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:29:11 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9GITAXH007825;
        Wed, 16 Oct 2019 18:29:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Oct 2019 18:29:10 +0000
Date:   Wed, 16 Oct 2019 11:29:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v6 06/12] xfs: add xfs_remount_rw() helper
Message-ID: <20191016182909.GF13108@magnolia>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118647366.9678.14061368527967040009.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118647366.9678.14061368527967040009.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910160151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910160151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:13AM +0800, Ian Kent wrote:
> Factor the remount read write code into a helper to simplify the
> subsequent change from the super block method .remount_fs to the
> mount-api fs_context_operations method .reconfigure.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_super.c |  115 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 64 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f8770206b66e..cdc19c2af50f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1213,6 +1213,68 @@ xfs_test_remount_options(
>  	return error;
>  }
>  
> +static int
> +xfs_remount_rw(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_sb_t		*sbp = &mp->m_sb;
> +	int error;

Don't use typedefs (as hch said) and please indent all the variables,
not just some of them.

--D

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
> +	 * If this is the first remount to writeable state we
> +	 * might have some superblock changes to update.
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
> +	 * Fill out the reserve pool if it is empty. Use the stashed
> +	 * value if it is non-zero, otherwise go with the default.
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
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> @@ -1276,57 +1338,8 @@ xfs_fs_remount(
>  
>  	/* ro -> rw */
>  	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
> -		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> -			xfs_warn(mp,
> -		"ro->rw transition prohibited on norecovery mount");
> -			return -EINVAL;
> -		}
> -
> -		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		    xfs_sb_has_ro_compat_feature(sbp,
> -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> -			xfs_warn(mp,
> -"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> -				(sbp->sb_features_ro_compat &
> -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> -			return -EINVAL;
> -		}
> -
> -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> -
> -		/*
> -		 * If this is the first remount to writeable state we
> -		 * might have some superblock changes to update.
> -		 */
> -		if (mp->m_update_sb) {
> -			error = xfs_sync_sb(mp, false);
> -			if (error) {
> -				xfs_warn(mp, "failed to write sb changes");
> -				return error;
> -			}
> -			mp->m_update_sb = false;
> -		}
> -
> -		/*
> -		 * Fill out the reserve pool if it is empty. Use the stashed
> -		 * value if it is non-zero, otherwise go with the default.
> -		 */
> -		xfs_restore_resvblks(mp);
> -		xfs_log_work_queue(mp);
> -
> -		/* Recover any CoW blocks that never got remapped. */
> -		error = xfs_reflink_recover_cow(mp);
> -		if (error) {
> -			xfs_err(mp,
> -	"Error %d recovering leftover CoW allocations.", error);
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -			return error;
> -		}
> -		xfs_start_block_reaping(mp);
> -
> -		/* Create the per-AG metadata reservation pool .*/
> -		error = xfs_fs_reserve_ag_blocks(mp);
> -		if (error && error != -ENOSPC)
> +		error = xfs_remount_rw(mp);
> +		if (error)
>  			return error;
>  	}
>  
> 
