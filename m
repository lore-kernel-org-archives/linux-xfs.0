Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23D1C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A135B23444
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbhAGTkB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:40:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44718 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbhAGTkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:40:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JYxmt114833;
        Thu, 7 Jan 2021 19:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qn9Z+IbWEhKkdgZn/V2fh4nmEvyDWuTPUDH6rkAzjko=;
 b=CkYWZPB8mlKGCSxjkZi25hixiRE9dRuVGxg89qf715Gqi/WPF+1W+kzOZmN7rMS4lv+M
 V478Smy3yRZlS7gOMOunGVc9H38sqI0TWYLkN5a7Wger9eRuWG0kGKiaMuqkT3nzRzQS
 IwXWnBIS3sM3OyXsE6NsJqxReMRsY1p+QGfh0fMp06r9zA/Ro1Frnp4KIdkIWzVpP1LV
 O89ybiZopoq0yhVvK2HY1dDE/gxWXrFVrmwzOV0DkIIUSWkYJT4yUsP4V8/FJy5WbLnX
 JiWTb2ZExF6s50eDK4U0mlSsAY35UCwPTVRaTAa9t8kM+8Rm6A7XlTqlX3CzkAygKeWN 6A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35wcuxxcp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 19:39:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JaWie024079;
        Thu, 7 Jan 2021 19:39:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35v4redqyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 19:39:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107JdIxb007380;
        Thu, 7 Jan 2021 19:39:18 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 19:39:17 +0000
Date:   Thu, 7 Jan 2021 11:39:16 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: remove xfs_quiesce_attr()
Message-ID: <20210107193916.GK6918@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-9-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:26PM -0500, Brian Foster wrote:
> xfs_quiesce_attr() is now a wrapper for xfs_log_clean(). Remove it
> and call xfs_log_clean() directly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Yay, I always found "quiesce attr" confusing...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.c |  2 +-
>  fs/xfs/xfs_super.c | 24 ++----------------------
>  2 files changed, 3 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index f97b82d0e30f..4a26b48b18e4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -946,7 +946,7 @@ xfs_mountfs(
>  	 */
>  	if ((mp->m_flags & (XFS_MOUNT_RDONLY|XFS_MOUNT_NORECOVERY)) ==
>  							XFS_MOUNT_RDONLY) {
> -		xfs_quiesce_attr(mp);
> +		xfs_log_clean(mp);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8fc9044131fc..aedf622d221b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -867,26 +867,6 @@ xfs_restore_resvblks(struct xfs_mount *mp)
>  	xfs_reserve_blocks(mp, &resblks, NULL);
>  }
>  
> -/*
> - * Trigger writeback of all the dirty metadata in the file system.
> - *
> - * This ensures that the metadata is written to their location on disk rather
> - * than just existing in transactions in the log. This means after a quiesce
> - * there is no log replay required to write the inodes to disk - this is the
> - * primary difference between a sync and a quiesce.
> - *
> - * We cancel log work early here to ensure all transactions the log worker may
> - * run have finished before we clean up and log the superblock and write an
> - * unmount record. The unfreeze process is responsible for restarting the log
> - * worker correctly.
> - */
> -void
> -xfs_quiesce_attr(
> -	struct xfs_mount	*mp)
> -{
> -	xfs_log_clean(mp);
> -}
> -
>  /*
>   * Second stage of a freeze. The data is already frozen so we only
>   * need to take care of the metadata. Once that's done sync the superblock
> @@ -909,7 +889,7 @@ xfs_fs_freeze(
>  	flags = memalloc_nofs_save();
>  	xfs_stop_block_reaping(mp);
>  	xfs_save_resvblks(mp);
> -	xfs_quiesce_attr(mp);
> +	xfs_log_clean(mp);
>  	ret = xfs_sync_sb(mp, true);
>  	memalloc_nofs_restore(flags);
>  	return ret;
> @@ -1752,7 +1732,7 @@ xfs_remount_ro(
>  	 */
>  	xfs_save_resvblks(mp);
>  
> -	xfs_quiesce_attr(mp);
> +	xfs_log_clean(mp);
>  	mp->m_flags |= XFS_MOUNT_RDONLY;
>  
>  	return 0;
> -- 
> 2.26.2
> 
