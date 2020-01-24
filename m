Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2479FC35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 01:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD6172087E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 01:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jqTD0gH5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgAXBIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 20:08:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56544 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbgAXBIS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 20:08:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O13LcI067414;
        Fri, 24 Jan 2020 01:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=o6zzKAUtDEXh0cLvguGlnlE1tneirxFPdL2t8WYt5/0=;
 b=jqTD0gH5z22CePLgdYizBzIoS603pLZ+bsp74ShK6CyNTWyisrVxEHJDH0BWfJ0iWocR
 6XGHAS5pGVXAb/pNn5MGbJOVeix/6OLz71et8vylMXqUSTEvse96VfwsidN0Ih+KZGR6
 aiUanQcXgMasvRHhgstX1gL9qCGbf17k2epR+Jz9mU1D2s5YKmGbZi33Wo2RpQDLtmHq
 xEU5COUF9KHPQXnBaQELImFLFm9RC6WiJTFv5BGwAwWJl1m9OaT6UlZKDI2DOnzjQ5Eq
 Xkn2fSLCrHRAPVg+kOmLYhjucZM92KvCvcKdyaPn2g0NrcwafgkgyU5R+DC8dQBIraGv dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseux4qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 01:08:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O13J0H087730;
        Fri, 24 Jan 2020 01:08:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xqnrs2xfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 01:08:08 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O186RO016801;
        Fri, 24 Jan 2020 01:08:06 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 17:08:06 -0800
Date:   Thu, 23 Jan 2020 17:08:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 02/12] xfs: make xfs_buf_read return an error code
Message-ID: <20200124010802.GZ8247@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976532333.2388944.17938500318924937596.stgit@magnolia>
 <20200123222015.GA15904@infradead.org>
 <20200124001658.GX8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124001658.GX8247@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240006
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 04:16:58PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 23, 2020 at 02:20:15PM -0800, Christoph Hellwig wrote:
> > On Wed, Jan 22, 2020 at 11:42:03PM -0800, Darrick J. Wong wrote:
> > > -				return -ENOMEM;
> > > +			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
> > > +					0, &bp, &xfs_attr3_rmt_buf_ops);
> > > +			if (error)
> > > +				return error;
> > >  			error = bp->b_error;
> > >  			if (error) {
> > >  				xfs_buf_ioerror_alert(bp, __func__);
> > 
> > This still has the bogus b_error check where it should just check the
> > error and report it based on the return value.
> 
> Yes, because at this point midway through the series xfs_buf_read only
> knows how to return -ENOMEM.  I'm changing the *interfaces* here, saving
> most of the behavior changes for the xfs_buf_read_map change...
> 
> > > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > > index 56e081dd1d96..fb60c36a8a5b 100644
> > > --- a/fs/xfs/xfs_buf.h
> > > +++ b/fs/xfs/xfs_buf.h
> > > @@ -213,16 +213,25 @@ xfs_buf_get(
> > >  	return xfs_buf_get_map(target, &map, 1, 0);
> > >  }
> > >  
> > > -static inline struct xfs_buf *
> > > +static inline int
> > >  xfs_buf_read(
> > >  	struct xfs_buftarg	*target,
> > >  	xfs_daddr_t		blkno,
> > >  	size_t			numblks,
> > >  	xfs_buf_flags_t		flags,
> > > +	struct xfs_buf		**bpp,
> > >  	const struct xfs_buf_ops *ops)
> > >  {
> > > +	struct xfs_buf		*bp;
> > >  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> > > -	return xfs_buf_read_map(target, &map, 1, flags, ops);
> > > +
> > > +	*bpp = NULL;
> > > +	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
> > > +	if (!bp)
> > > +		return -ENOMEM;
> > > +
> > > +	*bpp = bp;
> 
> ...because otherwise I end having to migrate all the bp->b_error
> checking into this static inline function, which causes compile errors.
> 
> I could work around /that/ by moving the xfs_buf_read_map conversion
> earlier in the series, but I'd have to rebase the whole series to
> achieve the same end result, which seems pointless.
> 
> But I guess I could go mess around with it and see just how much of a
> pain doing that /actually/ is...

Changing the order to the following:

xfs: make xfs_buf_alloc return an error code
xfs: make xfs_buf_get_map return an error code
xfs: make xfs_buf_read_map return an error code
xfs: make xfs_buf_get return an error code
xfs: make xfs_buf_get_uncached return an error code
xfs: make xfs_buf_read return an error code
xfs: make xfs_trans_get_buf_map return an error code
xfs: make xfs_trans_get_buf return an error code
xfs: remove the xfs_btree_get_buf[ls] functions
xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers
xfs: remove unnecessary null pointer checks from _read_agf callers
xfs: fix xfs_buf_ioerror_alert location reporting

Was a lot less code churn than I thought it would be.

--D

> --D
> 
> > > +	return 0;
> > >  }
> > >  
> > >  static inline void
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index 0d683fb96396..b29806846916 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -2745,10 +2745,10 @@ xlog_recover_buffer_pass2(
> > >  	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
> > >  		buf_flags |= XBF_UNMAPPED;
> > >  
> > > -	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
> > > -			  buf_flags, NULL);
> > > -	if (!bp)
> > > -		return -ENOMEM;
> > > +	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
> > > +			  buf_flags, &bp, NULL);
> > > +	if (error)
> > > +		return error;
> > >  	error = bp->b_error;
> > >  	if (error) {
> > 
> > .. and same here.
> > 
