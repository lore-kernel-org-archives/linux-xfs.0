Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A3ECA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A7221655
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rXMUQKzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503294AbfJXPce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:32:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503276AbfJXPce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 11:32:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFCa2J020961;
        Thu, 24 Oct 2019 15:32:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LYCdtBNbl3dq95RUBT5pf/h7QCJ0VPznVcRd5UM91So=;
 b=rXMUQKzZ6dvwn/ggvGq8qHVN0AgNk9pcrZGEGOwZPQF4JQoaypUsnwhS1O1KuWV4tgc4
 rey+wI6WxXwnJ5a5xzZOTVGvCeReXnpOLUoYn7AuZsL1ylk22icl2XNRy1Pc8wZospei
 T0zIf6z8dY8XABGwy1iDLo7rgAN1MpsahJ7aljJJwnPM9wIbM2K3/l+S/d+ZFS3081IZ
 KVIxveh6AgFupp2vqM5c4von316P8yoHioFvCK7RfhVh3sSf+3xLhSrWZifAWJxLqa99
 LIOhCr20O7AGLVOytPglT7e1MSOkDxjtwrkVcnC5Bx40fphUNhqm/GvdvQ5hvu5y11Ox fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vqu4r4943-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:32:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OF4U1B016744;
        Thu, 24 Oct 2019 15:32:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vtjkjxryh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:32:03 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9OFW2UV013237;
        Thu, 24 Oct 2019 15:32:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 15:32:02 +0000
Date:   Thu, 24 Oct 2019 08:32:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 10/17] xfs: add xfs_remount_ro() helper
Message-ID: <20191024153201.GT913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190348766.27074.17456421465521004386.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190348766.27074.17456421465521004386.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:27PM +0800, Ian Kent wrote:
> Factor the remount read only code into a helper to simplify the
> subsequent change from the super block method .remount_fs to the
> mount-api fs_context_operations method .reconfigure.
> 
> This helper is only used by the mount code, so locate it along with
> that code.
> 
> While we are at it change STATIC -> static for xfs_save_resvblks().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks like a straightforward code extraction, so

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |   76 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 45 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c07e41489e75..97c3f1edb69c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -48,6 +48,7 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  #endif
>  
>  static void xfs_restore_resvblks(struct xfs_mount *mp);
> +static void xfs_save_resvblks(struct xfs_mount *mp);
>  
>  /*
>   * Table driven mount option parser.
> @@ -519,6 +520,47 @@ xfs_remount_rw(
>  	return 0;
>  }
>  
> +static int
> +xfs_remount_ro(
> +	struct xfs_mount	*mp)
> +{
> +	int			error;
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
>  struct proc_xfs_info {
>  	uint64_t	flag;
>  	char		*str;
> @@ -1224,7 +1266,7 @@ xfs_fs_statfs(
>  	return 0;
>  }
>  
> -STATIC void
> +static void
>  xfs_save_resvblks(struct xfs_mount *mp)
>  {
>  	uint64_t resblks = 0;
> @@ -1378,37 +1420,9 @@ xfs_fs_remount(
>  
>  	/* rw -> ro */
>  	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
> -		/*
> -		 * Cancel background eofb scanning so it cannot race with the
> -		 * final log force+buftarg wait and deadlock the remount.
> -		 */
> -		xfs_stop_block_reaping(mp);
> -
> -		/* Get rid of any leftover CoW reservations... */
> -		error = xfs_icache_free_cowblocks(mp, NULL);
> -		if (error) {
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -			return error;
> -		}
> -
> -		/* Free the per-AG metadata reservation pool. */
> -		error = xfs_fs_unreserve_ag_blocks(mp);
> -		if (error) {
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		error = xfs_remount_ro(mp);
> +		if (error)
>  			return error;
> -		}
> -
> -		/*
> -		 * Before we sync the metadata, we need to free up the reserve
> -		 * block pool so that the used block count in the superblock on
> -		 * disk is correct at the end of the remount. Stash the current
> -		 * reserve pool size so that if we get remounted rw, we can
> -		 * return it to the same size.
> -		 */
> -		xfs_save_resvblks(mp);
> -
> -		xfs_quiesce_attr(mp);
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
>  	}
>  
>  	return 0;
> 
