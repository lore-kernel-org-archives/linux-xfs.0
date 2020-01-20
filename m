Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BAFC32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67EF122522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:22:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gOEUTii5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgATWWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:22:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54826 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgATWWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:22:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMIKLA030932;
        Mon, 20 Jan 2020 22:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=d/9BnT63H1HLCfbxGtECJ+86P+RE70WOVmuf+o3MfB0=;
 b=gOEUTii51W0JrCo23LDSyTOXJhfM/vWUp2eggDhpCo+jzknO5rBsc0pxRdLfeNwl7XDK
 /SPYlK9HoIqGL7ufZ5AMTWHdcTqzmqdQlYAXNhtryhElMwYiDAYEm1eoxaMjxppzi10H
 2TDTCqXYjpXiEnirORPY3avJH5jlx1LW/1ShbTy7s3EH1r+yiQZ+yWnViegcghmp2c7k
 mx0taEk88F68sJOvFk4ydxgqyUVt9wJslazki+NvfLwH8PFR46UxVKVX+Yehvi/6xbjH
 x7pt4co5sS5+u6fPvBmVyLU888pRBA6MuJk+d5fQyMGFTcN/Mx8zl/VMis59xlH/qhS+ 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnr1ga2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:22:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMJR8N125665;
        Mon, 20 Jan 2020 22:22:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xmbj4f20u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:22:28 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00KMMR8l011305;
        Mon, 20 Jan 2020 22:22:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:22:27 -0800
Date:   Mon, 20 Jan 2020 14:22:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/11] xfs: make xfs_buf_read return an error code
Message-ID: <20200120222226.GZ8247@magnolia>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924222437.3029431.18011964422343623236.stgit@magnolia>
 <20200119215720.GE9407@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119215720.GE9407@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200187
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 20, 2020 at 08:57:20AM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2020 at 10:23:44PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert xfs_buf_read() to return numeric error codes like most
> > everywhere else in xfs.  Hoist the callers' error logging and EFSBADCRC
> > remapping code into xfs_buf_read to reduce code duplication.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_attr_remote.c |   16 +++-------------
> >  fs/xfs/xfs_buf.c                |   33 +++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_buf.h                |   14 +++-----------
> >  fs/xfs/xfs_log_recover.c        |   26 +++++++-------------------
> >  fs/xfs/xfs_symlink.c            |   17 ++++-------------
> >  5 files changed, 50 insertions(+), 56 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > index a266d05df146..46c516809086 100644
> > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > @@ -418,20 +418,10 @@ xfs_attr_rmtval_get(
> >  			       (map[i].br_startblock != HOLESTARTBLOCK));
> >  			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
> >  			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
> > -			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
> > -					&xfs_attr3_rmt_buf_ops);
> > -			if (!bp)
> > -				return -ENOMEM;
> > -			error = bp->b_error;
> > -			if (error) {
> > -				xfs_buf_ioerror_alert(bp, __func__);
> > -				xfs_buf_relse(bp);
> > -
> > -				/* bad CRC means corrupted metadata */
> > -				if (error == -EFSBADCRC)
> > -					error = -EFSCORRUPTED;
> > +			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
> > +					0, &bp, &xfs_attr3_rmt_buf_ops);
> > +			if (error)
> >  				return error;
> > -			}
> >  
> >  			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
> >  							&offset, &valuelen,
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index a00e63d08a3b..8c9cd1ab870b 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -851,6 +851,39 @@ xfs_buf_read_map(
> >  	return bp;
> >  }
> >  
> > +int
> > +xfs_buf_read(
> > +	struct xfs_buftarg	*target,
> > +	xfs_daddr_t		blkno,
> > +	size_t			numblks,
> > +	xfs_buf_flags_t		flags,
> > +	struct xfs_buf		**bpp,
> > +	const struct xfs_buf_ops *ops)
> > +{
> > +	struct xfs_buf		*bp;
> > +	int			error;
> > +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> > +
> > +	*bpp = NULL;
> > +	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
> > +	if (!bp)
> > +		return -ENOMEM;
> > +	error = bp->b_error;
> > +	if (error) {
> > +		xfs_buf_ioerror_alert(bp, __func__);
> > +		xfs_buf_stale(bp);
> > +		xfs_buf_relse(bp);
> > +
> > +		/* bad CRC means corrupted metadata */
> > +		if (error == -EFSBADCRC)
> > +			error = -EFSCORRUPTED;
> > +		return error;
> > +	}
> > +
> > +	*bpp = bp;
> > +	return 0;
> > +}
> 
> I'd just put all this in xfs_buf_read_map() and leave
> xfs_buf_read() as a simple wrapper around xfs_buf_read_map().
> 
> Also:
> 
> 	if (!bp->b_error) {
> 		*bpp = bp;
> 		return 0;
> 	}
> 	/* handle error without extra indenting */

Yeah, Christoph nudged me towards that at the end of last week, too.

> 
> > -	const struct xfs_buf_ops *ops)
> > -{
> > -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> > -	return xfs_buf_read_map(target, &map, 1, flags, ops);
> > -}
> > +int xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,
> > +		xfs_buf_flags_t flags, struct xfs_buf **bpp,
> > +		const struct xfs_buf_ops *ops);
> >  
> >  static inline void
> >  xfs_buf_readahead(
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 0d683fb96396..ac79537d3275 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2745,15 +2745,10 @@ xlog_recover_buffer_pass2(
> >  	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
> >  		buf_flags |= XBF_UNMAPPED;
> >  
> > -	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
> > -			  buf_flags, NULL);
> > -	if (!bp)
> > -		return -ENOMEM;
> > -	error = bp->b_error;
> > -	if (error) {
> > -		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
> > -		goto out_release;
> > -	}
> > +	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
> > +			  buf_flags, &bp, NULL);
> > +	if (error)
> > +		return error;
> 
> I'd argue that if we are touching every remaining xfs_buf_read() call
> like this, we should get rid of it and just call xfs_buf_read_map()
> instead.

FWIW I changed out this patch to leave xfs_buf_read as a static inline
and shoved all the buffer state and ioerror_alert refactoring to the end
of the series, so at least this part is a straight conversion.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
