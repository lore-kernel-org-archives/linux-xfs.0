Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D4AC433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86AE823442
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbhAGTHC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:07:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbhAGTHB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:07:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107IxVbt064223;
        Thu, 7 Jan 2021 19:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=d6SVUwDBiOuaI/GSw/Y02E946txETZN/xS3nl13hjOw=;
 b=Oxm8k3h/0kWK2Yvq2Y+drZ3EViETLTKFuHYRPyWqaMF4LJtV1GRUxFeXK42JPBjGVSep
 1rV9yakFTkMhEB3tZEI9FfHcOI6r5GKhWhi1MR2A7aJXkpNRbkkqMnnHC0rMYgFX4N72
 eATNDBBuDOO+cpRiUDQ0J/YNDQF+Y4G0xsSqHFWKXy5RdCzPPX9M8onRvf4OhoJej3W/
 CXUUkgM7XEdXt2Tp6u7Cv2DzH1faEaxXbDBEA4cbxWHx2lf9EViOX0U3rmbfU05ZcWYG
 RLCQ1ChOt6Kq0lzAPyRf+1jQpoyowJ3kFBW0HPW1GK4mLPFfpofXFtosAw/wZDRhuQGe kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35wftxdfew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 19:06:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107J0sDe092906;
        Thu, 7 Jan 2021 19:06:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35v1fbkw0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 19:06:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 107J6G6A027383;
        Thu, 7 Jan 2021 19:06:17 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 19:06:16 +0000
Date:   Thu, 7 Jan 2021 11:06:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: sync lazy sb accounting on quiesce of read-only
 mounts
Message-ID: <20210107190615.GE6918@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-2-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:19PM -0500, Brian Foster wrote:
> xfs_log_sbcount() syncs the superblock specifically to accumulate
> the in-core percpu superblock counters and commit them to disk. This
> is required to maintain filesystem consistency across quiesce
> (freeze, read-only mount/remount) or unmount when lazy superblock
> accounting is enabled because individual transactions do not update
> the superblock directly.
> 
> This mechanism works as expected for writable mounts, but
> xfs_log_sbcount() skips the update for read-only mounts. Read-only
> mounts otherwise still allow log recovery and write out an unmount
> record during log quiesce. If a read-only mount performs log
> recovery, it can modify the in-core superblock counters and write an
> unmount record when the filesystem unmounts without ever syncing the
> in-core counters. This leaves the filesystem with a clean log but in
> an inconsistent state with regard to lazy sb counters.
> 
> Update xfs_log_sbcount() to use the same logic
> xfs_log_unmount_write() uses to determine when to write an unmount
> record. We can drop the freeze state check because the update is
> already allowed during the freezing process and no context calls
> this function on an already frozen fs. This ensures that lazy
> accounting is always synced before the log is cleaned. Refactor this
> logic into a new helper to distinguish between a writable filesystem
> and a writable log. Specifically, the log is writable unless the
> filesystem is mounted with the norecovery mount option, the
> underlying log device is read-only, or the filesystem is shutdown.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
>  fs/xfs/xfs_log.h   |  1 +
>  fs/xfs/xfs_mount.c |  3 +--
>  3 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa2d05e65ff1..b445e63cbc3c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -347,6 +347,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
>  	tic->t_res_num++;
>  }
>  
> +bool
> +xfs_log_writable(
> +	struct xfs_mount	*mp)
> +{
> +	/*
> +	 * Never write to the log on norecovery mounts, if the block device is
> +	 * read-only, or if the filesystem is shutdown. Read-only mounts still
> +	 * allow internal writes for log recovery and unmount purposes, so don't
> +	 * restrict that case here.
> +	 */
> +	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
> +		return false;
> +	if (xfs_readonly_buftarg(mp->m_log->l_targ))
> +		return false;
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return false;
> +	return true;
> +}
> +
>  /*
>   * Replenish the byte reservation required by moving the grant write head.
>   */
> @@ -886,15 +905,8 @@ xfs_log_unmount_write(
>  {
>  	struct xlog		*log = mp->m_log;
>  
> -	/*
> -	 * Don't write out unmount record on norecovery mounts or ro devices.
> -	 * Or, if we are doing a forced umount (typically because of IO errors).
> -	 */
> -	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
> -	    xfs_readonly_buftarg(log->l_targ)) {
> -		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> +	if (!xfs_log_writable(mp))
>  		return;
> -	}
>  
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 58c3fcbec94a..98c913da7587 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -127,6 +127,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
>  int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
>  void      xfs_log_unmount(struct xfs_mount *mp);
>  int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
> +bool	xfs_log_writable(struct xfs_mount *mp);
>  
>  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
>  void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7110507a2b6b..a62b8a574409 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1176,8 +1176,7 @@ xfs_fs_writable(
>  int
>  xfs_log_sbcount(xfs_mount_t *mp)
>  {
> -	/* allow this to proceed during the freeze sequence... */
> -	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
> +	if (!xfs_log_writable(mp))
>  		return 0;
>  
>  	/*
> -- 
> 2.26.2
> 
