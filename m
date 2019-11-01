Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117B0CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE45B217D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 19:36:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m+wAwvrx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfKATgH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 15:36:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56944 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfKATgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 15:36:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JYDi2190620;
        Fri, 1 Nov 2019 19:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=P3PtnaSOlDIQM6PGwO8c4QnxQsLg4COuwtBD3DqaPuM=;
 b=m+wAwvrxZgBN6yD20HnCr80W2z+fLPZtHjJrnrAtsKuLxzyClmAw5CtbJ3rlzv1haZwO
 UO1v1HX23bWBKfEH4fvd6vI3LHQCjrH0EtOi/W9wSOlTK74uPmuovp2Yai5Y63KHw1Cd
 cE/xl6ZxlKXTo3uoHpYccLUt3//QX2cJ9KKmfJr3ijAQ0bGoqY81RTSPWOd476dcdnOv
 MZgifNAQl1H8x5vxPE41dhiVmfVqlVGylaQjYQGHoSskznD2T26iKBfS5rSRipHr4K7z
 wBgdsbclug9r9ock9z+lbSLKgrpK5otoHTEiimVdjtY+9lc+Ctw3Ut/3oHgt/4VnxIkW Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vxwhg3q7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:35:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1JXDuw030498;
        Fri, 1 Nov 2019 19:35:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w0qdwv9er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 19:35:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1JZPxa024166;
        Fri, 1 Nov 2019 19:35:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 12:35:24 -0700
Date:   Fri, 1 Nov 2019 12:35:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 07/16] xfs: add xfs_remount_ro() helper
Message-ID: <20191101193522.GE15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259463969.28278.13374185572499414619.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259463969.28278.13374185572499414619.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:50:39PM +0800, Ian Kent wrote:
> Factor the remount read only code into a helper to simplify the
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
>  fs/xfs/xfs_super.c |   73 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 43 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6eaa1b05897a..bdf6c069e3ea 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1246,6 +1246,47 @@ xfs_remount_rw(
>  	return 0;
>  }
>  
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
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> @@ -1316,37 +1357,9 @@ xfs_fs_remount(
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
