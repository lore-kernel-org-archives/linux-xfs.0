Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3536C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 22:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC2D23158
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 22:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbhAFWvN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 17:51:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51854 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbhAFWvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 17:51:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106MmqQV100695;
        Wed, 6 Jan 2021 22:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X9tPtzJpHxY2W+YzRkXFAZOY4U+veG/TJCXVzqmjpJk=;
 b=MkVYiiU+V9QCEus8MVAixLyYenI4y5S/vebJb53c3M8bFJj/oSj+b5uhnhq74xC5uWID
 4KhxPkRhC78JX2T2wlT7zVbT3Pt4nORcQ922Hk7BtFybMS6zgtgT3wKFd69m72DogJgc
 k2pMTq3m0NUvmHEs2N1q5l7BnVbyWRQKL42z+4TlZEL6js84yf3toWpXW+r2KRHdi48W
 CFKqrw/uFyu4Sd+DrCYW8kHO882lG1cGDIZg89nOO/ou4C78I43jww17dIeMtL/FAm9H
 AiG7XwMItNw8/iNMd6qCB2BPQ3QMF2klpG5s+hlX6xdNRQ76vP86DhwOQESbx9uPtbc2 Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35wcuxtk08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 22:50:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106MeppW021596;
        Wed, 6 Jan 2021 22:50:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35v1fadnad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 22:50:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106MoS9x029317;
        Wed, 6 Jan 2021 22:50:28 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 14:50:28 -0800
Subject: Re: [PATCH 1/9] xfs: sync lazy sb accounting on quiesce of read-only
 mounts
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-2-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <aaf14f99-1677-bd01-5627-eec0c86c53ee@oracle.com>
Date:   Wed, 6 Jan 2021 15:50:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210106174127.805660-2-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/6/21 10:41 AM, Brian Foster wrote:
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

Ok makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
>   fs/xfs/xfs_log.h   |  1 +
>   fs/xfs/xfs_mount.c |  3 +--
>   3 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa2d05e65ff1..b445e63cbc3c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -347,6 +347,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
>   	tic->t_res_num++;
>   }
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
>   /*
>    * Replenish the byte reservation required by moving the grant write head.
>    */
> @@ -886,15 +905,8 @@ xfs_log_unmount_write(
>   {
>   	struct xlog		*log = mp->m_log;
>   
> -	/*
> -	 * Don't write out unmount record on norecovery mounts or ro devices.
> -	 * Or, if we are doing a forced umount (typically because of IO errors).
> -	 */
> -	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
> -	    xfs_readonly_buftarg(log->l_targ)) {
> -		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> +	if (!xfs_log_writable(mp))
>   		return;
> -	}
>   
>   	xfs_log_force(mp, XFS_LOG_SYNC);
>   
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 58c3fcbec94a..98c913da7587 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -127,6 +127,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
>   int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
>   void      xfs_log_unmount(struct xfs_mount *mp);
>   int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
> +bool	xfs_log_writable(struct xfs_mount *mp);
>   
>   struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
>   void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7110507a2b6b..a62b8a574409 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1176,8 +1176,7 @@ xfs_fs_writable(
>   int
>   xfs_log_sbcount(xfs_mount_t *mp)
>   {
> -	/* allow this to proceed during the freeze sequence... */
> -	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
> +	if (!xfs_log_writable(mp))
>   		return 0;
>   
>   	/*
> 
