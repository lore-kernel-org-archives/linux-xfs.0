Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E750CFA372A
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4CE9218DE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WYbXAKtl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732524AbfJPS1i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:27:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40596 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfJPS1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 14:27:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIIntI146282;
        Wed, 16 Oct 2019 18:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iEuGN0URjJyiwgJmIrA61Pk32PWr/0y/ptBZLS4rYOM=;
 b=WYbXAKtlHJ3/0bsvgw7JOLFE7fdB2qzlFMEUJCrIm3e1dZN9r9tAS4PE3pDAhcVnyXbA
 gtcZoDnWzhr7AD11xqdhLsXLANsritJETxdnOZE8I41BdZuqytz3k+ff522laMsaJ+er
 vDs7C4B3+1VldmZNyEcYamyvvdFWWJAx0UN5PjxnzPI9hQJl310DOnl01Zlth8JfYFOC
 iVdWRXTdMUWwSt7BFarACdZGp7E58sxHUvwFCn6olmPSi/wKL1WTTd8GOjPYiJZyWFkr
 OBEBYpkENxP61hT5/P6yV3BYJgg45KdxzPX0bh7M4v1aLprCbCZ47gtM6FYHnOdar5iN cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vk68urxw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:27:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GII9ox121593;
        Wed, 16 Oct 2019 18:27:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vnxva8jhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:27:15 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9GIREC7027328;
        Wed, 16 Oct 2019 18:27:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Oct 2019 18:27:14 +0000
Date:   Wed, 16 Oct 2019 11:27:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v6 04/12] xfs: use super s_id instead of mount info
 m_fsname
Message-ID: <20191016182713.GD13108@magnolia>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118646315.9678.439818770752389112.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118646315.9678.439818770752389112.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910160151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910160151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:03AM +0800, Ian Kent wrote:
> Eliminate mount info field m_fsname by using the super block s_id
> field directly.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_error.c     |    2 +-
>  fs/xfs/xfs_log.c       |    2 +-
>  fs/xfs/xfs_message.c   |    4 ++--
>  fs/xfs/xfs_mount.c     |    5 +++--
>  fs/xfs/xfs_mount.h     |    1 -
>  fs/xfs/xfs_pnfs.c      |    2 +-
>  fs/xfs/xfs_super.c     |   35 +++++++++++++----------------------
>  fs/xfs/xfs_trans_ail.c |    2 +-
>  8 files changed, 22 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 849fd4476950..3ff3fc202522 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -257,7 +257,7 @@ xfs_errortag_test(
>  
>  	xfs_warn_ratelimited(mp,
>  "Injecting error (%s) at file %s, line %d, on filesystem \"%s\"",
> -			expression, file, line, mp->m_fsname);
> +			expression, file, line, mp->m_super->s_id);
>  	return true;
>  }
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a2beee9f74da..ed99f4f063c3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1479,7 +1479,7 @@ xlog_alloc_log(
>  
>  	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
>  			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
> -			mp->m_fsname);
> +			mp->m_super->s_id);
>  	if (!log->l_ioend_workqueue)
>  		goto out_free_iclog;
>  
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 9804efe525a9..aaea6faf5acc 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -20,8 +20,8 @@ __xfs_printk(
>  	const struct xfs_mount	*mp,
>  	struct va_format	*vaf)
>  {
> -	if (mp && mp->m_fsname) {
> -		printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
> +	if (mp && mp->m_super && mp->m_super->s_id) {
> +		printk("%sXFS (%s): %pV\n", level, mp->m_super->s_id, vaf);
>  		return;
>  	}
>  	printk("%sXFS: %pV\n", level, vaf);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index ba5b6f3b2b88..b6145a70a593 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -706,7 +706,8 @@ xfs_mountfs(
>  	/* enable fail_at_unmount as default */
>  	mp->m_fail_unmount = true;
>  
> -	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
> +	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype,
> +			       NULL, mp->m_super->s_id);
>  	if (error)
>  		goto out;
>  
> @@ -1277,7 +1278,7 @@ xfs_mod_fdblocks(
>  	printk_once(KERN_WARNING
>  		"Filesystem \"%s\": reserve blocks depleted! "
>  		"Consider increasing reserve pool size.",
> -		mp->m_fsname);
> +		mp->m_super->s_id);
>  fdblocks_enospc:
>  	spin_unlock(&mp->m_sb_lock);
>  	return -ENOSPC;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b3230f7ca2bf..f2a9f316fa6c 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -89,7 +89,6 @@ typedef struct xfs_mount {
>  	struct percpu_counter	m_delalloc_blks;
>  
>  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
> -	char			*m_fsname;	/* filesystem name */
>  	char			*m_rtname;	/* realtime device name */
>  	char			*m_logname;	/* external log device name */
>  	int			m_bsize;	/* fs logical block size */
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index a339bd5fa260..81df10f69ade 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -59,7 +59,7 @@ xfs_fs_get_uuid(
>  
>  	printk_once(KERN_NOTICE
>  "XFS (%s): using experimental pNFS feature, use at your own risk!\n",
> -		mp->m_fsname);
> +		mp->m_super->s_id);
>  
>  	if (*len < sizeof(uuid_t))
>  		return -EINVAL;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index cfa306f62bec..5876c2b551b5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -165,14 +165,6 @@ xfs_parseargs(
>  	int			iosize = 0;
>  	uint8_t			iosizelog = 0;
>  
> -	/*
> -	 * set up the mount name first so all the errors will refer to the
> -	 * correct device.
> -	 */
> -	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> -	if (!mp->m_fsname)
> -		return -ENOMEM;
> -
>  	/*
>  	 * Copy binary VFS mount flags we are interested in.
>  	 */
> @@ -805,33 +797,33 @@ xfs_init_mount_workqueues(
>  	struct xfs_mount	*mp)
>  {
>  	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_fsname);
> +			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_super->s_id);
>  	if (!mp->m_buf_workqueue)
>  		goto out;
>  
>  	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
> +			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
>  	if (!mp->m_unwritten_workqueue)
>  		goto out_destroy_buf;
>  
>  	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
>  			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
> -			0, mp->m_fsname);
> +			0, mp->m_super->s_id);
>  	if (!mp->m_cil_workqueue)
>  		goto out_destroy_unwritten;
>  
>  	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
> +			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
>  	if (!mp->m_reclaim_workqueue)
>  		goto out_destroy_cil;
>  
>  	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
> +			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
>  	if (!mp->m_eofblocks_workqueue)
>  		goto out_destroy_reclaim;
>  
>  	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
> -					       mp->m_fsname);
> +					       mp->m_super->s_id);
>  	if (!mp->m_sync_workqueue)
>  		goto out_destroy_eofb;
>  
> @@ -1036,10 +1028,9 @@ xfs_fs_drop_inode(
>  }
>  
>  STATIC void
> -xfs_free_fsname(
> +xfs_free_names(
>  	struct xfs_mount	*mp)
>  {
> -	kfree(mp->m_fsname);
>  	kfree(mp->m_rtname);
>  	kfree(mp->m_logname);
>  }
> @@ -1216,7 +1207,7 @@ xfs_test_remount_options(
>  
>  	tmp_mp->m_super = sb;
>  	error = xfs_parseargs(tmp_mp, options);
> -	xfs_free_fsname(tmp_mp);
> +	xfs_free_names(tmp_mp);
>  	kmem_free(tmp_mp);
>  
>  	return error;
> @@ -1591,7 +1582,7 @@ xfs_fs_fill_super(
>  
>  	error = xfs_parseargs(mp, (char *)data);
>  	if (error)
> -		goto out_free_fsname;
> +		goto out_free_names;
>  
>  	sb_min_blocksize(sb, BBSIZE);
>  	sb->s_xattr = xfs_xattr_handlers;
> @@ -1618,7 +1609,7 @@ xfs_fs_fill_super(
>  
>  	error = xfs_open_devices(mp);
>  	if (error)
> -		goto out_free_fsname;
> +		goto out_free_names;
>  
>  	error = xfs_init_mount_workqueues(mp);
>  	if (error)
> @@ -1755,9 +1746,9 @@ xfs_fs_fill_super(
>  	xfs_destroy_mount_workqueues(mp);
>   out_close_devices:
>  	xfs_close_devices(mp);
> - out_free_fsname:
> + out_free_names:
>  	sb->s_fs_info = NULL;
> -	xfs_free_fsname(mp);
> +	xfs_free_names(mp);
>  	kfree(mp);
>   out:
>  	return error;
> @@ -1789,7 +1780,7 @@ xfs_fs_put_super(
>  	xfs_close_devices(mp);
>  
>  	sb->s_fs_info = NULL;
> -	xfs_free_fsname(mp);
> +	xfs_free_names(mp);
>  	kfree(mp);
>  }
>  
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 6ccfd75d3c24..aea71ee189f5 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -836,7 +836,7 @@ xfs_trans_ail_init(
>  	init_waitqueue_head(&ailp->ail_empty);
>  
>  	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
> -			ailp->ail_mount->m_fsname);
> +			ailp->ail_mount->m_super->s_id);
>  	if (IS_ERR(ailp->ail_task))
>  		goto out_free_ailp;
>  
> 
