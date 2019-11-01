Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61836CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A6EE217D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W18zm+Oa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfKAThq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 15:37:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49938 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfKAThq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 15:37:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JYWfR022923;
        Fri, 1 Nov 2019 19:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0cEGUVB+3w+Cur62FhPEUGQCzCnSwNpTb9Nnw0kaIYg=;
 b=W18zm+Oa5oPBngpTx5XPi/gcaixyq6WLybOw5vES8MdPmC8lYCwcDzep/erLD6bzNPs+
 mD1QlIijzKZOf/EszayMw03SOxH6Mz9NlDwGm/fqpcq/33CC56NGT4vL2udxFvxkyUQ/
 Nq5hcDzPnfCbaAWT6kZhVN6DMZwd3pczTbXGOMpfoDN6Fm8fJi3Z2aNvRLnX52dAFQJE
 uNosE3ORD+A9zt3L7IiGJWy4JFDCnhTTabtHNTN3np31SELf+ThiI2nQeqKvTm4nSn8k
 YlcfSe3TWnN4G64xooU01OOnnBoPKJgdrzSJOI1SjEGjIIVL/JxNGs2maOtiSTDCvBPK vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vxwhg3qrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:37:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JXJs5031672;
        Fri, 1 Nov 2019 19:35:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w0qdwv9b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:35:21 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1JZI0Q024041;
        Fri, 1 Nov 2019 19:35:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 19:35:18 +0000
Date:   Fri, 1 Nov 2019 12:35:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 06/16] xfs: add xfs_remount_rw() helper
Message-ID: <20191101193517.GD15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259463427.28278.4872547152408994149.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259463427.28278.4872547152408994149.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:50:34PM +0800, Ian Kent wrote:
> Factor the remount read write code into a helper to simplify the
> subsequent change from the super block method .remount_fs to the
> mount-api fs_context_operations method .reconfigure.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |  115 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 64 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6d908b76aa9e..6eaa1b05897a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1184,6 +1184,68 @@ xfs_test_remount_options(
>  	return error;
>  }
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
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> @@ -1247,57 +1309,8 @@ xfs_fs_remount(
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
