Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3ABC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB3720738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xokHTajb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHRXDL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:03:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45476 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRXDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 19:03:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMwDo2006562;
        Tue, 18 Aug 2020 23:03:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jMrJz/XfHncnanvjQKipACezlUWficLtp2G9TZLzke0=;
 b=xokHTajb+keXGxU6W2alm0150N06ZQMFUDTV76lNgzpzLZeuUYCdg1SsquW1857RZOsM
 U5BewOaUS9nAaX3CkBVOh4iQxBQ1PtCWod9YGbWC42uR80AlstzxxT1oiC8zcwNklxj/
 w/f0y9KYiV3pbjHmlnUaeO9yJDf6GQK675kC63ivt4y4yZlH9dyqnaANMFUj56EEZ5lR
 LvxrdsPjqxCyg2OaswgtXT0r77mriHORHy0gOuZ2G4Jjtl/vhC6Mbx8uc+yAuM9Y1gcq
 qmjGnniEqbEiNK/DSJ3H3ilfnhDkydihffIGaHuGBSkVBujXSeYYuw6bFUK90704DGv1 aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74r7q60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 23:03:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMwFXw102120;
        Tue, 18 Aug 2020 23:03:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfseuwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 23:03:02 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IN31fk009588;
        Tue, 18 Aug 2020 23:03:01 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 16:03:01 -0700
Date:   Tue, 18 Aug 2020 16:02:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs: reuse _xfs_buf_read for re-reading the
 superblock
Message-ID: <20200818230256.GN6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-14-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:53PM +0200, Christoph Hellwig wrote:
> Instead of poking deeply into buffer cache internals when re-reading the
> superblock during log recovery just generalize _xfs_buf_read and use it
> there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c         | 28 +++++++++++++++++++---------
>  fs/xfs/xfs_buf.h         | 10 ++--------
>  fs/xfs/xfs_log_recover.c | 11 +++--------
>  3 files changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1172d5fa06aad2..34d88c8b50854a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -52,6 +52,15 @@ static kmem_zone_t *xfs_buf_zone;
>   *	  b_lock (trylock due to inversion)
>   */
>  
> +static int __xfs_buf_submit(struct xfs_buf *bp, bool wait);
> +
> +static inline int
> +xfs_buf_submit(
> +	struct xfs_buf		*bp)
> +{
> +	return __xfs_buf_submit(bp, !(bp->b_flags & XBF_ASYNC));
> +}
> +
>  static inline int
>  xfs_buf_is_vmapped(
>  	struct xfs_buf	*bp)
> @@ -753,16 +762,18 @@ xfs_buf_get_map(
>  	return 0;
>  }
>  
> -STATIC int
> +int
>  _xfs_buf_read(
> -	xfs_buf_t		*bp,
> -	xfs_buf_flags_t		flags)
> +	struct xfs_buf		*bp,
> +	xfs_buf_flags_t		flags,
> +	const struct xfs_buf_ops *ops)
>  {
> -	ASSERT(!(flags & XBF_WRITE));
>  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
> +	ASSERT(!(flags & XBF_WRITE));
>  
> -	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
> -	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
> +	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
> +	bp->b_flags |= flags & (XBF_ASYNC | XBF_READ_AHEAD);

Doesn't this change mean that the caller's XBF_READ never gets set
in bp->b_flags?  If the buffer is already in memory but doesn't have
XBF_DONE set, how does XBF_READ get set?  Maybe I'm missing something?

--D

> +	bp->b_ops = ops;
>  
>  	return xfs_buf_submit(bp);
>  }
> @@ -827,8 +838,7 @@ xfs_buf_read_map(
>  	if (!(bp->b_flags & XBF_DONE)) {
>  		/* Initiate the buffer read and wait. */
>  		XFS_STATS_INC(target->bt_mount, xb_get_read);
> -		bp->b_ops = ops;
> -		error = _xfs_buf_read(bp, flags);
> +		error = _xfs_buf_read(bp, flags, ops);
>  
>  		/* Readahead iodone already dropped the buffer, so exit. */
>  		if (flags & XBF_ASYNC)
> @@ -1637,7 +1647,7 @@ xfs_buf_iowait(
>   * safe to reference the buffer after a call to this function unless the caller
>   * holds an additional reference itself.
>   */
> -int
> +static int
>  __xfs_buf_submit(
>  	struct xfs_buf	*bp,
>  	bool		wait)
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 9eb4044597c985..db172599d32dc1 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -249,6 +249,8 @@ int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
>  int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
>  			  size_t numblks, int flags, struct xfs_buf **bpp,
>  			  const struct xfs_buf_ops *ops);
> +int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags,
> +		const struct xfs_buf_ops *ops);
>  void xfs_buf_hold(struct xfs_buf *bp);
>  
>  /* Releasing Buffers */
> @@ -275,14 +277,6 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>  #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
>  extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
>  void xfs_buf_ioend_fail(struct xfs_buf *);
> -
> -extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
> -static inline int xfs_buf_submit(struct xfs_buf *bp)
> -{
> -	bool wait = bp->b_flags & XBF_ASYNC ? false : true;
> -	return __xfs_buf_submit(bp, wait);
> -}
> -
>  void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
>  void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
>  #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b181f3253e6e74..04f76a75886744 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3305,16 +3305,11 @@ xlog_do_recover(
>  	xlog_assign_tail_lsn(mp);
>  
>  	/*
> -	 * Now that we've finished replaying all buffer and inode
> -	 * updates, re-read in the superblock and reverify it.
> +	 * Now that we've finished replaying all buffer and inode updates,
> +	 * re-read in the superblock and reverify it.
>  	 */
>  	bp = xfs_getsb(mp);
> -	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
> -	ASSERT(!(bp->b_flags & XBF_WRITE));
> -	bp->b_flags |= XBF_READ;
> -	bp->b_ops = &xfs_sb_buf_ops;
> -
> -	error = xfs_buf_submit(bp);
> +	error = _xfs_buf_read(bp, XBF_READ, &xfs_sb_buf_ops);
>  	if (error) {
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_buf_ioerror_alert(bp, __this_address);
> -- 
> 2.26.2
> 
