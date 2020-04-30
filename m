Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187F8C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6DEB20836
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SxS9onF/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgD3SQp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:16:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48236 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgD3SQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:16:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UHxZU9182969;
        Thu, 30 Apr 2020 18:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jQ191uaXQ71LVCkHQ00vAzD04OJgtajQtl60VYvRIAM=;
 b=SxS9onF/U0I1SYHR9Jj0rAt6icndorXDqEfvEos4b9OCkREhTVeqH38XPbqInFIvS2SA
 V0OT7CaVU++mbpnDfKMjg4d8siIBJvhmhb2qLdDIW8t7l2xwCUzpKx7PVx8LQ7XGKJcl
 ne2Tbx20LB1LJ2Ei29MuLFM1ybkI2w/M4HiJXxFyUbTL7P1jQO08LB+g1PQzijgWyIfA
 RckjNGYRMR/Y+fMDKiTuA57TR1ct6SpEO6Y5Rd7KzKRfmTTCahU6gfMFfkiMyGZ3ObTK
 SmjKwcTqzR2bQ95vkqI+H9Zjv87vlTTS3/YAW3dlSsp3XVo/j8yhGdL6+P6YHfhSAi1z +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30p2p0jhxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:16:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UI6XcW111154;
        Thu, 30 Apr 2020 18:16:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30qtkwx9nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:16:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UIGe5S004354;
        Thu, 30 Apr 2020 18:16:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:16:40 -0700
Date:   Thu, 30 Apr 2020 11:16:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 02/17] xfs: factor out buffer I/O failure code
Message-ID: <20200430181639.GC6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=2 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:38PM -0400, Brian Foster wrote:
> We use the same buffer I/O failure code in a few different places.
> It's not much code, but it's not necessarily self-explanatory.
> Factor it into a helper and document it in one place.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c      | 21 +++++++++++++++++----
>  fs/xfs/xfs_buf.h      |  1 +
>  fs/xfs/xfs_buf_item.c | 21 +++------------------
>  fs/xfs/xfs_inode.c    |  6 +-----
>  4 files changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9ec3eaf1c618..d5d6a68bb1e6 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1248,6 +1248,22 @@ xfs_buf_ioerror_alert(
>  			-bp->b_error);
>  }
>  
> +/*
> + * To simulate an I/O failure, the buffer must be locked and held with at least
> + * three references. The LRU reference is dropped by the stale call. The buf
> + * item reference is dropped via ioend processing. The third reference is owned
> + * by the caller and is dropped on I/O completion if the buffer is XBF_ASYNC.
> + */
> +void
> +xfs_buf_ioend_fail(
> +	struct xfs_buf	*bp)
> +{
> +	bp->b_flags &= ~XBF_DONE;
> +	xfs_buf_stale(bp);
> +	xfs_buf_ioerror(bp, -EIO);
> +	xfs_buf_ioend(bp);
> +}
> +
>  int
>  xfs_bwrite(
>  	struct xfs_buf		*bp)
> @@ -1480,10 +1496,7 @@ __xfs_buf_submit(
>  
>  	/* on shutdown we stale and complete the buffer immediately */
>  	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
> -		xfs_buf_ioerror(bp, -EIO);
> -		bp->b_flags &= ~XBF_DONE;
> -		xfs_buf_stale(bp);
> -		xfs_buf_ioend(bp);
> +		xfs_buf_ioend_fail(bp);
>  		return -EIO;
>  	}
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 9a04c53c2488..06ea3eef866e 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -263,6 +263,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>  		xfs_failaddr_t failaddr);
>  #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
>  extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
> +void xfs_buf_ioend_fail(struct xfs_buf *);
>  
>  extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
>  static inline int xfs_buf_submit(struct xfs_buf *bp)
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8796adde2d12..b452a399a441 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -471,28 +471,13 @@ xfs_buf_item_unpin(
>  		xfs_buf_relse(bp);
>  	} else if (freed && remove) {
>  		/*
> -		 * There are currently two references to the buffer - the active
> -		 * LRU reference and the buf log item. What we are about to do
> -		 * here - simulate a failed IO completion - requires 3
> -		 * references.
> -		 *
> -		 * The LRU reference is removed by the xfs_buf_stale() call. The
> -		 * buf item reference is removed by the xfs_buf_iodone()
> -		 * callback that is run by xfs_buf_do_callbacks() during ioend
> -		 * processing (via the bp->b_iodone callback), and then finally
> -		 * the ioend processing will drop the IO reference if the buffer
> -		 * is marked XBF_ASYNC.
> -		 *
> -		 * Hence we need to take an additional reference here so that IO
> -		 * completion processing doesn't free the buffer prematurely.
> +		 * The buffer must be locked and held by the caller to simulate
> +		 * an async I/O failure.
>  		 */
>  		xfs_buf_lock(bp);
>  		xfs_buf_hold(bp);
>  		bp->b_flags |= XBF_ASYNC;
> -		xfs_buf_ioerror(bp, -EIO);
> -		bp->b_flags &= ~XBF_DONE;
> -		xfs_buf_stale(bp);
> -		xfs_buf_ioend(bp);
> +		xfs_buf_ioend_fail(bp);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d1772786af29..909ca7c0bac4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3630,11 +3630,7 @@ xfs_iflush_cluster(
>  	 */
>  	ASSERT(bp->b_iodone);
>  	bp->b_flags |= XBF_ASYNC;
> -	bp->b_flags &= ~XBF_DONE;
> -	xfs_buf_stale(bp);
> -	xfs_buf_ioerror(bp, -EIO);
> -	xfs_buf_ioend(bp);
> -
> +	xfs_buf_ioend_fail(bp);
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  
>  	/* abort the corrupt inode, as it was not attached to the buffer */
> -- 
> 2.21.1
> 
