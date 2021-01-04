Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077C6C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C771620780
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbhADTwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 14:52:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36632 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbhADTwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 14:52:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104Jj17W165839;
        Mon, 4 Jan 2021 19:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=L3j1NjPnMPb5DxMOqpd2R9I8QDtLZd875DsnxycbDsQ=;
 b=M4vONVBpqpmC7ecsF8tXXLv5xBM0y6SuBeMM91hFFIqC72z1vb+vJAx9uhBAaRSGUfqj
 E0V65Q1UHgwPK6Rps6NTZL7JKN/+8C04wHQ/Z/mTraPpL0O7+SSi9U8pIz9q5oO9DuGB
 dx6cHmt5IrlXHDZAXd5UdEbrD59BbDdOfpMR3ZSoMDR3GU79b1nR/XI38RlDic8qiXM7
 AYnE81O8eMrARyFGgxdcWTAV9JDP5tJUp9vuRuBByjrX/umJ5gqLVS5wmmB7d5OWiVQr
 Z+257BztwHo1xMWtFqhIoJxn46gjZkYMDVkgOVYmOeq4G63WDr9psi6nv155JyyKPXHY YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35tebap1t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 19:51:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104Jihle092979;
        Mon, 4 Jan 2021 19:51:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1f7rp30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 19:51:17 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104JpGaq009929;
        Mon, 4 Jan 2021 19:51:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 19:51:16 +0000
Date:   Mon, 4 Jan 2021 11:51:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     wenli xie <wlxie7296@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, chiluk@ubuntu.com,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210104195115.GO6918@magnolia>
References: <20210104194437.GJ38809@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104194437.GJ38809@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 11:44:37AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When overlayfs is running on top of xfs and the user unlinks a file in
> the overlay, overlayfs will create a whiteout inode and ask xfs to
> "rename" the whiteout file atop the one being unlinked.  If the file
> being unlinked loses its one nlink, we then have to put the inode on the
> unlinked list.
> 
> This requires us to grab the AGI buffer of the whiteout inode to take it
> off the unlinked list (which is where whiteouts are created) and to grab
> the AGI buffer of the file being deleted.  If the whiteout was created
> in a higher numbered AG than the file being deleted, we'll lock the AGIs
> in the wrong order and deadlock.
> 
> Therefore, grab all the AGI locks we think we'll need ahead of time, and
> in the correct order.
> 
> Reported-by: wenli xie <wlxie7296@gmail.com>
> Tested-by: wenli xie <wlxie7296@gmail.com>
> Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b7352bc4c815..dd419a1bc6ba 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3000,6 +3000,48 @@ xfs_rename_alloc_whiteout(
>  	return 0;
>  }
>  
> +/*
> + * For the general case of renaming files, lock all the AGI buffers we need to
> + * handle bumping the nlink of the whiteout inode off the unlinked list and to
> + * handle dropping the nlink of the target inode.  We have to do this in
> + * increasing AG order to avoid deadlocks.

One thing that occurred to me 5 seconds after hitting Send is that we
can still screw up the locking order if we grab even one AGI and the
dirent operations require the allocation of a new block for the
directory.  I /think/ the solution to that is to set tp->t_firstblock to
prevent the allocation from happening in a lower AG, though it's too bad
we can't just carve up rename operations into multiple smaller
transactions...

--D

> + */
> +static int
> +xfs_rename_lock_agis(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*wip,
> +	struct xfs_inode	*target_ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*bp;
> +	xfs_agnumber_t		agi_locks[2] = { NULLAGNUMBER, NULLAGNUMBER };
> +	int			error;
> +
> +	if (wip)
> +		agi_locks[0] = XFS_INO_TO_AGNO(mp, wip->i_ino);
> +
> +	if (target_ip && VFS_I(target_ip)->i_nlink == 1)
> +		agi_locks[1] = XFS_INO_TO_AGNO(mp, target_ip->i_ino);
> +
> +	if (agi_locks[0] != NULLAGNUMBER && agi_locks[1] != NULLAGNUMBER &&
> +	    agi_locks[0] > agi_locks[1])
> +		swap(agi_locks[0], agi_locks[1]);
> +
> +	if (agi_locks[0] != NULLAGNUMBER) {
> +		error = xfs_read_agi(mp, tp, agi_locks[0], &bp);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (agi_locks[1] != NULLAGNUMBER) {
> +		error = xfs_read_agi(mp, tp, agi_locks[1], &bp);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * xfs_rename
>   */
> @@ -3130,6 +3172,10 @@ xfs_rename(
>  		}
>  	}
>  
> +	error = xfs_rename_lock_agis(tp, wip, target_ip);
> +	if (error)
> +		return error;
> +
>  	/*
>  	 * Directory entry creation below may acquire the AGF. Remove
>  	 * the whiteout from the unlinked list first to preserve correct
