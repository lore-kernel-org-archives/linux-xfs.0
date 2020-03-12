Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98711C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65406206F7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I7lrK0ZD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgCLXt3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 19:49:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56710 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCLXt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 19:49:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNgcjZ098235;
        Thu, 12 Mar 2020 23:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aee8DgUwJmFGkvFhA1c0O77cXDqX/EsObDElb7cKChw=;
 b=I7lrK0ZDrA72lwkQPc6+HRIPrxqxYATcE06mgomEUEnjGrU95uIVhas9FqQipVRZu7Ev
 zawd+liiyNr8VWpdjKuL3BRbF7MxvYwsvqZmXBzM+TVNvuk1mtK8Z7cBC4HrvIfZXdHc
 Yi3Sa2jfZl/s5hu65ZJJfH2EhuwhiVJroQ1+GP8TNJgKgW0rRHzZ47d+qIt4v1YmSd49
 aVOe3Xgsv6eKYrs3rZFTwxlisq8gqRCqPYpJXXqMDOkxZAxN5t0reTvJHcZoTfcrxHoy
 ipZEJ3coqd0vedlRlkzyfDh/GAOgErwMNqzvbdDbhmSifEHp0paWyX2Z73YDeysECUbh oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yqtaes543-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:49:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNgDgx182251;
        Thu, 12 Mar 2020 23:49:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yqta9rtb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:49:21 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CNnJne013424;
        Thu, 12 Mar 2020 23:49:19 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 16:49:19 -0700
Date:   Thu, 12 Mar 2020 16:49:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: remove the unused return value from
 xfs_log_unmount_write
Message-ID: <20200312234916.GU8045@magnolia>
References: <20200312143959.583781-1-hch@lst.de>
 <20200312143959.583781-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312143959.583781-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003120117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:39:57PM +0100, Christoph Hellwig wrote:
> Remove the ignored return value from xfs_log_unmount_write, and also
> remove a rather pointless assert on the return value from xfs_log_force.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

AFAICT the lack of error returning is acceptable because the vfs doesn't
care what failures we encounter while unmounting and xfs will log all of
its complaints as it crashes out of the kernel?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 796ff37d5bb5..fa499ddedb94 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -953,8 +953,7 @@ xfs_log_write_unmount_record(
>   * currently architecture converted and "Unmount" is a bit foo.
>   * As far as I know, there weren't any dependencies on the old behaviour.
>   */
> -
> -static int
> +static void
>  xfs_log_unmount_write(xfs_mount_t *mp)
>  {
>  	struct xlog	 *log = mp->m_log;
> @@ -962,7 +961,6 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  #ifdef DEBUG
>  	xlog_in_core_t	 *first_iclog;
>  #endif
> -	int		 error;
>  
>  	/*
>  	 * Don't write out unmount record on norecovery mounts or ro devices.
> @@ -971,11 +969,10 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
>  	    xfs_readonly_buftarg(log->l_targ)) {
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> -		return 0;
> +		return;
>  	}
>  
> -	error = xfs_log_force(mp, XFS_LOG_SYNC);
> -	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
> +	xfs_log_force(mp, XFS_LOG_SYNC);
>  
>  #ifdef DEBUG
>  	first_iclog = iclog = log->l_iclog;
> @@ -1007,7 +1004,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  		iclog = log->l_iclog;
>  		atomic_inc(&iclog->ic_refcnt);
>  		xlog_state_want_sync(log, iclog);
> -		error =  xlog_state_release_iclog(log, iclog);
> +		xlog_state_release_iclog(log, iclog);
>  		switch (iclog->ic_state) {
>  		case XLOG_STATE_ACTIVE:
>  		case XLOG_STATE_DIRTY:
> @@ -1019,9 +1016,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  			break;
>  		}
>  	}
> -
> -	return error;
> -}	/* xfs_log_unmount_write */
> +}
>  
>  /*
>   * Empty the log for unmount/freeze.
> -- 
> 2.24.1
> 
