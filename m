Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C14C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 04:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE202071A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 04:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IvDGjXED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgAXEeh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 23:34:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60694 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbgAXEeg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 23:34:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O4XqDE003301;
        Fri, 24 Jan 2020 04:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lwP4uoaEeNUIwHxXopTnkgJtss9SC2KM0SDjlE3aX8c=;
 b=IvDGjXEDwaz2zWmlhFnOJUdqDkDeSDa6msSHROps4BeNbulR7x+OhaJvu3dIDF2PRxcp
 Hr/JJKSNXsIIsUmz1JrZAiVZ/E1xotzY6fYdw9Nz7Kq8imVXVOUkFlP3n342TBoKAlG9
 1OoGAzOMK7jh/AI1qrfVKCJZgXvz68aHJnPeFVdr/uLDF6PIj8ftV23s8bgn6lTzMamr
 DLA0IjWqWHKRe0e7CxRnXKY9pvFFAZuNfPGy0qBPCme8dkYCuWh3io3QoQ0Ca5aeqX4C
 Qqd0L+WWWcmHfmMU2jxA7f7n/FII3Hb3ENhKNsV+sqxSDNme6PQzIUTDsFUoVFfLbZsl Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xktnrpmnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 04:34:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O4XlIg193542;
        Fri, 24 Jan 2020 04:34:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xqnrsekg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 04:34:27 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O4YQAT023439;
        Fri, 24 Jan 2020 04:34:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 20:34:25 -0800
Date:   Thu, 23 Jan 2020 20:34:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 05/12] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200124043423.GC8247@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976534245.2388944.13378396804109422541.stgit@magnolia>
 <20200124013152.GF7090@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124013152.GF7090@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 24, 2020 at 12:31:52PM +1100, Dave Chinner wrote:
> On Wed, Jan 22, 2020 at 11:42:22PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert xfs_buf_read_map() to return numeric error codes like most
> > everywhere else in xfs.  This involves moving the open-coded logic that
> > reports metadata IO read / corruption errors and stales the buffer into
> > xfs_buf_read_map so that the logic is all in one place.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> 
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index b5b3a78ef31c..56e7f8126cd7 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -298,36 +298,17 @@ xfs_trans_read_buf_map(
> >  		return 0;
> >  	}
> >  
> > -	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
> > -	if (!bp) {
> > -		if (!(flags & XBF_TRYLOCK))
> > -			return -ENOMEM;
> > -		return tp ? 0 : -EAGAIN;
> > -	}
> > -
> > -	/*
> > -	 * If we've had a read error, then the contents of the buffer are
> > -	 * invalid and should not be used. To ensure that a followup read tries
> > -	 * to pull the buffer from disk again, we clear the XBF_DONE flag and
> > -	 * mark the buffer stale. This ensures that anyone who has a current
> > -	 * reference to the buffer will interpret it's contents correctly and
> > -	 * future cache lookups will also treat it as an empty, uninitialised
> > -	 * buffer.
> > -	 */
> > -	if (bp->b_error) {
> > -		error = bp->b_error;
> > -		if (!XFS_FORCED_SHUTDOWN(mp))
> > -			xfs_buf_ioerror_alert(bp, __func__);
> > -		bp->b_flags &= ~XBF_DONE;
> > -		xfs_buf_stale(bp);
> > -
> > +	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
> > +	switch (error) {
> > +	case 0:
> > +		break;
> > +	case -EFSCORRUPTED:
> > +	case -EIO:
> >  		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
> > -			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
> > -		xfs_buf_relse(bp);
> > -
> > -		/* bad CRC means corrupted metadata */
> > -		if (error == -EFSBADCRC)
> > -			error = -EFSCORRUPTED;
> > +			xfs_force_shutdown(tp->t_mountp,
> > +					SHUTDOWN_META_IO_ERROR);
> > +		/* fall through */
> > +	default:
> >  		return error;
> >  	}
> 
> Same question as Christoph - we're only trying to avoid ENOMEM and
> EAGAIN errors from shutting down the filesystem here, right?
> Every other type of IO error that could end up on bp->b_error would
> result in a shutdown, so perhaps this should be the other way
> around:
> 
> 	switch (error) {
> 	case 0:
> 		break;
> 	default:
> 		/* shutdown stuff */
> 		/* fall through */
> 	case -ENOMEM:
> 	case -EAGAIN:
> 		return error;
> 	}

I agree that ENOMEM ought to be on the list of things that don't
immediately cause a shutdown if the transaction is dirty.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
