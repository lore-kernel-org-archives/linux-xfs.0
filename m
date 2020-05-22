Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521F8C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 21:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19C8620757
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 21:40:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QdTCWGTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgEVVko (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 17:40:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731039AbgEVVko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 17:40:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MLbsBs020235;
        Fri, 22 May 2020 21:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uam5nNa0w7LO5g9oIvzjTwpw95p+g0wUK1tBSLPmQq8=;
 b=QdTCWGTOB61y29rkFV/9Az3yQmqk1bamT4+c6YHCBwmKJGUA6aWG6oohOR1swNPnKHgW
 64DFRdAyNH/xe+HHin9YZY9FmAVspQu3iKc3BtMWj63ZuAUlnC65+UZFsCJ7N7eqbsQX
 9ET5BXV78+RFnV6cc+tIfSz8l0XzctA0HIVYULCACbcq8fj3Fd3CbSHgwyR3fFfZR/dp
 z0+26QPBUBWzCEBAcXcpfmtkH1DarZH4ijIYjB0Whiu+mh336PhmKk4nU45huS9EFw9U
 f8cgJ8P4izay0e5eWWgXHrWOJQQwqawkPtQA6tS2pIBxQX97aiAKBKn3aS9/BaPAcn9T mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284mfuwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 21:40:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MLJJ0C081674;
        Fri, 22 May 2020 21:38:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3150251a33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 21:38:41 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MLcf8s013206;
        Fri, 22 May 2020 21:38:41 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 14:38:40 -0700
Date:   Fri, 22 May 2020 14:38:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/24] xfs: mark dquot buffers in cache
Message-ID: <20200522213839.GH8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-5-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:09PM +1000, Dave Chinner wrote:
> dquot buffers always have write IO callbacks, so by marking them
> directly we can avoid needing to attach ->b_iodone functions to
> them. This avoids an indirect call, and makes future modifications
> much simpler.
> 
> This is largely a rearrangement of the code at this point - no IO
> completion functionality changes at this point, just how the
> code is run is modified.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c       | 12 +++++++++++-
>  fs/xfs/xfs_buf.h       |  2 ++
>  fs/xfs/xfs_buf_item.c  | 10 ++++++++++
>  fs/xfs/xfs_buf_item.h  |  1 +
>  fs/xfs/xfs_dquot.c     |  1 +
>  fs/xfs/xfs_trans_buf.c |  1 +
>  6 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 6105b97028d6a..77d40eb4a11db 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1204,17 +1204,27 @@ xfs_buf_ioend(
>  		bp->b_flags |= XBF_DONE;
>  	}
>  
> +	if (read)
> +		goto out_finish;
> +
>  	/* inodes always have a callback on write */
> -	if (!read && (bp->b_flags & _XBF_INODES)) {
> +	if (bp->b_flags & _XBF_INODES) {

Heh, yes, this does seem like it belongs in the previous patch.

With that moved,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  		xfs_buf_inode_iodone(bp);
>  		return;
>  	}
>  
> +	/* dquots always have a callback on write */
> +	if (bp->b_flags & _XBF_DQUOTS) {
> +		xfs_buf_dquot_iodone(bp);
> +		return;
> +	}
> +
>  	if (bp->b_iodone) {
>  		(*(bp->b_iodone))(bp);
>  		return;
>  	}
>  
> +out_finish:
>  	xfs_buf_ioend_finish(bp);
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index b3e5d653d09f1..cbde44ecb3963 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -32,6 +32,7 @@
>  
>  /* buffer type flags for write callbacks */
>  #define _XBF_INODES	 (1 << 16)/* inode buffer */
> +#define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
>  
>  /* flags used only internally */
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> @@ -55,6 +56,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_INODES,		"INODES" }, \
> +	{ _XBF_DQUOTS,		"DQUOTS" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8659cf4282a64..a42cdf9ccc47d 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1210,6 +1210,16 @@ xfs_buf_inode_iodone(
>  	xfs_buf_ioend_finish(bp);
>  }
>  
> +/*
> + * Dquot buffer iodone callback function.
> + */
> +void
> +xfs_buf_dquot_iodone(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_run_callbacks(bp);
> +	xfs_buf_ioend_finish(bp);
> +}
>  
>  /*
>   * This is the iodone() function for buffers which have been
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index a342933ad9b8d..27d13d29b5bbb 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -60,6 +60,7 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
>  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
>  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
> +void	xfs_buf_dquot_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
>  extern kmem_zone_t	*xfs_buf_item_zone;
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 55b95d45303b8..25592b701db40 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1174,6 +1174,7 @@ xfs_qm_dqflush(
>  	 * Attach an iodone routine so that we can remove this dquot from the
>  	 * AIL and release the flush lock once the dquot is synced to disk.
>  	 */
> +	bp->b_flags |= _XBF_DQUOTS;
>  	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
>  				  &dqp->q_logitem.qli_item);
>  
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 552d0869aa0fe..93d62cb864c15 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -788,5 +788,6 @@ xfs_trans_dquot_buf(
>  		break;
>  	}
>  
> +	bp->b_flags |= _XBF_DQUOTS;
>  	xfs_trans_buf_set_type(tp, bp, type);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 
