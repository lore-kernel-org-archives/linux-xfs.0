Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E21FC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 473FE2054F
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kVVy4kTT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgHaUkg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 16:40:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53142 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgHaUkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 16:40:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKNem3076970;
        Mon, 31 Aug 2020 20:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ceA9QqPzsfM1HRVLawwOJdNRPx6XSX6lOPr1Oyog0UY=;
 b=kVVy4kTT8NMsASo/s0DusVMLUi6cPOuBW8cP6/RuuaecieoiZ1EO9KX8wHsBOwzUjTvS
 qb3+OCiADOmxw4Drwr7M4Vkl0kKW4JyPe/NcoEA0+/Z/vzT31b6LTHYmIXf3Tw0CuKxE
 wr001P6kdGLf+b2jpArK6jMMiaG6yCuuADpZQCMOAfejbq5T1mJpsXBR5z0lCdJqN2uf
 XdlbVI2lCNu2U4M6F7oW8XHQGqH/5elXNGcxbasZcUyGuXV4J5INVJ9ljbYWx+Bb8bEa
 5Mflanq+9tvHIbzxU+IfuYBvb3XmgbFCJ5pe4UP9zsYt/ti+2/YxKROLTomDY1RdITAS KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 337qrhfhbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 20:40:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKL8Qo032566;
        Mon, 31 Aug 2020 20:40:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3380km6whc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 20:40:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VKeUXs032722;
        Mon, 31 Aug 2020 20:40:30 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 13:40:29 -0700
Date:   Mon, 31 Aug 2020 13:40:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs: reuse _xfs_buf_read for re-reading the
 superblock
Message-ID: <20200831204033.GV6107@magnolia>
References: <20200830061512.1148591-1-hch@lst.de>
 <20200830061512.1148591-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830061512.1148591-14-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 08:15:12AM +0200, Christoph Hellwig wrote:
> Instead of poking deeply into buffer cache internals when re-reading the
> superblock during log recovery just generalize _xfs_buf_read and use it
> there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c         | 24 +++++++++++++++++-------
>  fs/xfs/xfs_buf.h         | 10 ++--------
>  fs/xfs/xfs_log_recover.c | 11 +++--------
>  3 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7f8abcbe98a447..0de6b110391202 100644
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
> @@ -751,16 +760,18 @@ xfs_buf_get_map(
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
>  	ASSERT(!(flags & XBF_WRITE));
>  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
>  
> -	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
> +	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
> +	bp->b_ops = ops;
>  
>  	return xfs_buf_submit(bp);
>  }
> @@ -825,8 +836,7 @@ xfs_buf_read_map(
>  	if (!(bp->b_flags & XBF_DONE)) {
>  		/* Initiate the buffer read and wait. */
>  		XFS_STATS_INC(target->bt_mount, xb_get_read);
> -		bp->b_ops = ops;
> -		error = _xfs_buf_read(bp, flags);
> +		error = _xfs_buf_read(bp, flags, ops);
>  
>  		/* Readahead iodone already dropped the buffer, so exit. */
>  		if (flags & XBF_ASYNC)
> @@ -1639,7 +1649,7 @@ xfs_buf_iowait(
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
> index 5449cba657352c..1771bc3646f4b1 100644
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

Question: xfs_getsb() returns mp->m_sb_bp.  The only place we set that
variable is in xfs_readsb immediately after setting b_ops by hand.  Is
there some circumstance where at the end of log recovery, m_sb_bp is set
to a buffer but that buffer's ops are not set to xfs_sb_buf_ops?

In other words, do we have to do all this surgery on _xfs_buf_read to
set the ops?  If they're not set (or worse, set to something else) at
this point then there's probably something seriously wrong...

...possibly my understanding of this buffer. ;)

--D

>  	if (error) {
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_buf_ioerror_alert(bp, __this_address);
> -- 
> 2.28.0
> 
