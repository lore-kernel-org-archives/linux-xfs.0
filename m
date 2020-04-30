Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48223C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23E9D2073E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:48:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OdDSEpoT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgD3Ssf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:48:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3Ssf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:48:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIm5d3078482;
        Thu, 30 Apr 2020 18:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hYMPJ0JAfiS9Ruki4WRjD6E3F7mTu0pYRA+FlXU/kxw=;
 b=OdDSEpoT3AFkSlpo+p7J7SApMx8aMTzEMfxe6EUuhYD7eOiFPgV981tSjuGyj4qVELpi
 E3hNXWyGxA3Hgagoaw7a1p38XQCcZUdQaBf/hjXOxKTFcNySQTZSSqPdLcuFeYbnrS4U
 8y7+3LN4pZq1eovwXmaV/m66m/XK9/aejeckLl+uqjkJd4wSs28wpqqTO5Pdi0sBwvbe
 P+xTNoN5BuSeiDZWvE8BEKEyWNrV9Ke052xdG43Ww4FW9q2tK3YTMIAsgPWif/1a4rwR
 TL/5NfFtJQzFKaG2dqA0M853VDyunOJppBQ2EAxDLprtfphUn3krItd3nkS77MCVGYsm tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30p01p3sfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:48:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIZVvg149771;
        Thu, 30 Apr 2020 18:46:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30qtjxw81v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:46:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UIkUjx022797;
        Thu, 30 Apr 2020 18:46:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:46:30 -0700
Date:   Thu, 30 Apr 2020 11:46:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 09/17] xfs: abort consistently on dquot flush failure
Message-ID: <20200430184629.GJ6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-10-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:45PM -0400, Brian Foster wrote:
> The dquot flush handler effectively aborts the dquot flush if the
> filesystem is already shut down, but doesn't actually shut down if
> the flush fails. Update xfs_qm_dqflush() to consistently abort the
> dquot flush and shutdown the fs if the flush fails with an
> unexpected error.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c | 32 ++++++++++----------------------
>  1 file changed, 10 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 265feb62290d..ffe607733c50 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1068,6 +1068,7 @@ xfs_qm_dqflush(
>  	struct xfs_buf		**bpp)
>  {
>  	struct xfs_mount	*mp = dqp->q_mount;
> +	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
>  	struct xfs_buf		*bp;
>  	struct xfs_dqblk	*dqb;
>  	struct xfs_disk_dquot	*ddqp;
> @@ -1083,32 +1084,16 @@ xfs_qm_dqflush(
>  
>  	xfs_qm_dqunpin_wait(dqp);
>  
> -	/*
> -	 * This may have been unpinned because the filesystem is shutting
> -	 * down forcibly. If that's the case we must not write this dquot
> -	 * to disk, because the log record didn't make it to disk.
> -	 *
> -	 * We also have to remove the log item from the AIL in this case,
> -	 * as we wait for an emptry AIL as part of the unmount process.
> -	 */
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> -		struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
> -		dqp->dq_flags &= ~XFS_DQ_DIRTY;
> -
> -		xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
> -
> -		error = -EIO;
> -		goto out_unlock;
> -	}
> -
>  	/*
>  	 * Get the buffer containing the on-disk dquot
>  	 */
>  	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
>  				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
>  				   &bp, &xfs_dquot_buf_ops);
> -	if (error)
> +	if (error == -EAGAIN)
>  		goto out_unlock;
> +	if (error)
> +		goto out_abort;
>  
>  	/*
>  	 * Calculate the location of the dquot inside the buffer.
> @@ -1123,9 +1108,8 @@ xfs_qm_dqflush(
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
>  				be32_to_cpu(dqp->q_core.d_id), fa);
>  		xfs_buf_relse(bp);
> -		xfs_dqfunlock(dqp);
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		return -EFSCORRUPTED;
> +		error = -EFSCORRUPTED;
> +		goto out_abort;
>  	}
>  
>  	/* This is the only portion of data that needs to persist */
> @@ -1174,6 +1158,10 @@ xfs_qm_dqflush(
>  	*bpp = bp;
>  	return 0;
>  
> +out_abort:
> +	dqp->dq_flags &= ~XFS_DQ_DIRTY;
> +	xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  out_unlock:
>  	xfs_dqfunlock(dqp);
>  	return error;
> -- 
> 2.21.1
> 
