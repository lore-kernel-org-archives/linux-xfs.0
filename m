Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71850C433E7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 17:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4969C2071B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 17:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DLopFLBu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgIARFI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 13:05:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56170 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbgIAREz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 13:04:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081H3khW156641;
        Tue, 1 Sep 2020 17:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=R6d/UKZkFJaAv0anYK16+ZLmvBCHcTFWjKHCDy6pe4U=;
 b=DLopFLBuRcsNtbQWfn08TUWIB+VdOp16sxqkX3+YsIFA6zcgk6orN5Z4NBLoUT7c6aYt
 +6tGnR71Xzymn5R3BfRlUzLvaajemJ8tRPVE081IgrYrYHN8kPrhVBMHHIc8FTvD72/g
 NNKek32BcT22qAlTUdiBAo3MMWvk9SRJGtSkvqeS5+ImpZ3/LLRtWFb9fgeFGJkmybeP
 y+uot6+H6daBLFFHUvHtafAyruCxBlIZpsxFA0OvzVQBOWJgAemZMCU2oxgWZpCIzFwI
 NRgXcMGED7c2/Nbi2n0yWqzjHy5FGj7dl/yDxG6kGpuubHqNntJh/Mtx9NUcQKALdUNz 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 339dmmv6jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 17:04:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081Gxhk8029592;
        Tue, 1 Sep 2020 17:02:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3380xwt4a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 17:02:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 081H2oJU023445;
        Tue, 1 Sep 2020 17:02:50 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 10:02:50 -0700
Date:   Tue, 1 Sep 2020 10:02:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: reuse _xfs_buf_read for re-reading the
 superblock
Message-ID: <20200901170249.GH6096@magnolia>
References: <20200901155018.2524-1-hch@lst.de>
 <20200901155018.2524-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901155018.2524-16-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=1
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 05:50:18PM +0200, Christoph Hellwig wrote:
> Instead of poking deeply into buffer cache internals when re-reading the
> superblock during log recovery just generalize _xfs_buf_read and use it
> there.  Note that we don't have to explicitly set up the ops as they
> must be set from the initial read.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me isn't too thrilled by the forward declaration of __xfs_buf_submit
but oh well. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c         | 15 ++++++++++++---
>  fs/xfs/xfs_buf.h         |  9 +--------
>  fs/xfs/xfs_log_recover.c |  8 +-------
>  3 files changed, 14 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7f8abcbe98a447..4e4cf91f4f9fe7 100644
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
> @@ -751,7 +760,7 @@ xfs_buf_get_map(
>  	return 0;
>  }
>  
> -STATIC int
> +int
>  _xfs_buf_read(
>  	xfs_buf_t		*bp,
>  	xfs_buf_flags_t		flags)
> @@ -759,7 +768,7 @@ _xfs_buf_read(
>  	ASSERT(!(flags & XBF_WRITE));
>  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
>  
> -	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
> +	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
>  
>  	return xfs_buf_submit(bp);
> @@ -1639,7 +1648,7 @@ xfs_buf_iowait(
>   * safe to reference the buffer after a call to this function unless the caller
>   * holds an additional reference itself.
>   */
> -int
> +static int
>  __xfs_buf_submit(
>  	struct xfs_buf	*bp,
>  	bool		wait)
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 9eb4044597c985..bfd2907e7bc454 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -249,6 +249,7 @@ int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
>  int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
>  			  size_t numblks, int flags, struct xfs_buf **bpp,
>  			  const struct xfs_buf_ops *ops);
> +int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
>  void xfs_buf_hold(struct xfs_buf *bp);
>  
>  /* Releasing Buffers */
> @@ -275,14 +276,6 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
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
> index 4f5569aab89a08..64cddef61b991a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3309,13 +3309,7 @@ xlog_do_recover(
>  	 */
>  	xfs_buf_lock(bp);
>  	xfs_buf_hold(bp);
> -	ASSERT(bp->b_flags & XBF_DONE);
> -	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
> -	ASSERT(!(bp->b_flags & XBF_WRITE));
> -	bp->b_flags |= XBF_READ;
> -	bp->b_ops = &xfs_sb_buf_ops;
> -
> -	error = xfs_buf_submit(bp);
> +	error = _xfs_buf_read(bp, XBF_READ);
>  	if (error) {
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_buf_ioerror_alert(bp, __this_address);
> -- 
> 2.28.0
> 
