Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3570EC3A59F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 00:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02E521848
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 00:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lUDHq9X0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfH0Amy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 20:42:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32914 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfH0Amy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 20:42:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R0cTSt119970;
        Tue, 27 Aug 2019 00:41:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5CoosGammeEEnn0B6O23Reg7t70oQ9Exr5J+XtD5pN0=;
 b=lUDHq9X0xd+DcEflSyfjPWezcr65qlD27LQaUkd5Yp/Rqh0LGcsDiFtjEzPJhSKmka0/
 F76mHlK4IMW6WoBo6w0nrcTF9/0ERJKcevCYfYz1jhnG2O4Y26iModJKkAMd7R7jndCW
 4C5dN2DdvY75sHpXGVSmGhIFFGz6LeOwVAAQEpe37Bsvjug2k8QK3jNakpR1YKRK6OXB
 kzoT/XZ51NR5LcQ2hkjJ4ZVjQzWO8AVzWTtMaH6fljbjfZfzPn74W2B8sXisMKXV8NXq
 hRrCNQS+Q6WOTHFfh3DUJPYXujX3+1QGEgsMnUdoLGLKHcsvLOJZRpDPX/Ew1ek96vfB Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t8pnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 00:41:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R0d7aN014321;
        Tue, 27 Aug 2019 00:41:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2umj27f58r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 00:41:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7R0fhlr007799;
        Tue, 27 Aug 2019 00:41:44 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 17:41:43 -0700
Date:   Mon, 26 Aug 2019 17:41:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v2] xfs: Fix ABBA deadlock between AGI and AGF in rename()
Message-ID: <20190827004142.GW1037350@magnolia>
References: <fe64be10-d7af-81ab-03e9-274c5a86407b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe64be10-d7af-81ab-03e9-274c5a86407b@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 24, 2019 at 11:45:15AM +0800, kaixuxia wrote:
> When performing rename operation with RENAME_WHITEOUT flag, we will
> hold AGF lock to allocate or free extents in manipulating the dirents
> firstly, and then doing the xfs_iunlink_remove() call last to hold
> AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
> 
> The big problem here is that we have an ordering constraint on AGF
> and AGI locking - inode allocation locks the AGI, then can allocate
> a new extent for new inodes, locking the AGF after the AGI. Hence
> the ordering that is imposed by other parts of the code is AGI before
> AGF. So we get an ABBA deadlock between the AGI and AGF here.
> 
> Process A:
> Call trace:
>  ? __schedule+0x2bd/0x620
>  schedule+0x33/0x90
>  schedule_timeout+0x17d/0x290
>  __down_common+0xef/0x125
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  down+0x3b/0x50
>  xfs_buf_lock+0x34/0xf0 [xfs]
>  xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_buf_get_map+0x37/0x230 [xfs]
>  xfs_buf_read_map+0x29/0x190 [xfs]
>  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
>  xfs_read_agf+0xa6/0x180 [xfs]
>  ? schedule_timeout+0x17d/0x290
>  xfs_alloc_read_agf+0x52/0x1f0 [xfs]
>  xfs_alloc_fix_freelist+0x432/0x590 [xfs]
>  ? down+0x3b/0x50
>  ? xfs_buf_lock+0x34/0xf0 [xfs]
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_alloc_vextent+0x301/0x6c0 [xfs]
>  xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
>  ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
>  xfs_dialloc+0x116/0x290 [xfs]
>  xfs_ialloc+0x6d/0x5e0 [xfs]
>  ? xfs_log_reserve+0x165/0x280 [xfs]
>  xfs_dir_ialloc+0x8c/0x240 [xfs]
>  xfs_create+0x35a/0x610 [xfs]
>  xfs_generic_create+0x1f1/0x2f0 [xfs]
>  ...
> 
> Process B:
> Call trace:
>  ? __schedule+0x2bd/0x620
>  ? xfs_bmapi_allocate+0x245/0x380 [xfs]
>  schedule+0x33/0x90
>  schedule_timeout+0x17d/0x290
>  ? xfs_buf_find+0x1fd/0x6c0 [xfs]
>  __down_common+0xef/0x125
>  ? xfs_buf_get_map+0x37/0x230 [xfs]
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  down+0x3b/0x50
>  xfs_buf_lock+0x34/0xf0 [xfs]
>  xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_buf_get_map+0x37/0x230 [xfs]
>  xfs_buf_read_map+0x29/0x190 [xfs]
>  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
>  xfs_read_agi+0xa8/0x160 [xfs]
>  xfs_iunlink_remove+0x6f/0x2a0 [xfs]
>  ? current_time+0x46/0x80
>  ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
>  xfs_rename+0x57a/0xae0 [xfs]
>  xfs_vn_rename+0xe4/0x150 [xfs]
>  ...
> 
> In this patch we move the xfs_iunlink_remove() call to
> before acquiring the AGF lock to preserve correct AGI/AGF locking
> order.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 83 +++++++++++++++++++++++++++---------------------------
>  1 file changed, 42 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6467d5e..8ffd44f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3282,7 +3282,8 @@ struct xfs_iunlink {
>  					spaceres);
>  
>  	/*
> -	 * Set up the target.
> +	 * Check for expected errors before we dirty the transaction
> +	 * so we can return an error without a transaction abort.
>  	 */
>  	if (target_ip == NULL) {
>  		/*
> @@ -3294,6 +3295,46 @@ struct xfs_iunlink {
>  			if (error)
>  				goto out_trans_cancel;
>  		}
> +	} else {
> +		/*
> +		 * If target exists and it's a directory, check that whether
> +		 * it can be destroyed.
> +		 */
> +		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
> +		    (!xfs_dir_isempty(target_ip) ||
> +		     (VFS_I(target_ip)->i_nlink > 2))) {
> +			error = -EEXIST;
> +			goto out_trans_cancel;
> +		}
> +	}
> +
> +	/*
> +	 * Directory entry creation below may acquire the AGF. Remove
> +	 * the whiteout from the unlinked list first to preserve correct
> +	 * AGI/AGF locking order. This dirties the transaction so failures
> +	 * after this point will abort and log recovery will clean up the
> +	 * mess.
> +	 *
> +	 * For whiteouts, we need to bump the link count on the whiteout
> +	 * inode. After this point, we have a real link, clear the tmpfile
> +	 * state flag from the inode so it doesn't accidentally get misused
> +	 * in future.
> +	 */
> +	if (wip) {
> +		ASSERT(VFS_I(wip)->i_nlink == 0);
> +		error = xfs_iunlink_remove(tp, wip);
> +		if (error)
> +			goto out_trans_cancel;
> +
> +		xfs_bumplink(tp, wip);
> +		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> +		VFS_I(wip)->i_state &= ~I_LINKABLE;
> +	}
> +
> +	/*
> +	 * Set up the target.
> +	 */
> +	if (target_ip == NULL) {
>  		/*
>  		 * If target does not exist and the rename crosses
>  		 * directories, adjust the target directory link count
> @@ -3312,22 +3353,6 @@ struct xfs_iunlink {
>  		}
>  	} else { /* target_ip != NULL */
>  		/*
> -		 * If target exists and it's a directory, check that both
> -		 * target and source are directories and that target can be
> -		 * destroyed, or that neither is a directory.
> -		 */
> -		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
> -			/*
> -			 * Make sure target dir is empty.
> -			 */
> -			if (!(xfs_dir_isempty(target_ip)) ||
> -			    (VFS_I(target_ip)->i_nlink > 2)) {
> -				error = -EEXIST;
> -				goto out_trans_cancel;
> -			}
> -		}
> -
> -		/*
>  		 * Link the source inode under the target name.
>  		 * If the source inode is a directory and we are moving
>  		 * it across directories, its ".." entry will be

...will be replaced and then we droplink the target_ip.

Question: Will we have the same ABBA deadlock potential here if we have
to allocate a block from AG 2 to hold the directory entry, but then we
drop target_ip onto the unlinked list, and target_ip was also from AG 2?
We also have to lock the AGI to put things on the unlinked list.

Granted, that's a slightly different use case, but they seem related...

--D

> @@ -3417,30 +3442,6 @@ struct xfs_iunlink {
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	/*
> -	 * For whiteouts, we need to bump the link count on the whiteout inode.
> -	 * This means that failures all the way up to this point leave the inode
> -	 * on the unlinked list and so cleanup is a simple matter of dropping
> -	 * the remaining reference to it. If we fail here after bumping the link
> -	 * count, we're shutting down the filesystem so we'll never see the
> -	 * intermediate state on disk.
> -	 */
> -	if (wip) {
> -		ASSERT(VFS_I(wip)->i_nlink == 0);
> -		xfs_bumplink(tp, wip);
> -		error = xfs_iunlink_remove(tp, wip);
> -		if (error)
> -			goto out_trans_cancel;
> -		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> -
> -		/*
> -		 * Now we have a real link, clear the "I'm a tmpfile" state
> -		 * flag from the inode so it doesn't accidentally get misused in
> -		 * future.
> -		 */
> -		VFS_I(wip)->i_state &= ~I_LINKABLE;
> -	}
> -
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>  	if (new_parent)
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
