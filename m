Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCEBC2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 16:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74EA52063A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 16:52:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BBCpeVOr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfLXQwY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 11:52:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLXQwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 11:52:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOGnVC3120406;
        Tue, 24 Dec 2019 16:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=f4dQLTDai+dyaK8zbcQJWy49SdSMqdE5IVWgHZvVLjs=;
 b=BBCpeVOrzof4tD1KdyZS7a8HEfBkzh/s/sPN7oFWq/alnduOQNrauXoWOl6+G1uIjLtm
 MHmToBDqcZ63xDa2nCzt9hO4phdx1JjvTBN8zQPzTPguQoNhdu4hX9JkVnYQ83MA7twG
 lPDfGmVMSrBg3R6GVEUatXFVzUpEBwREO00zf+GlUQTKeGcGwjmLYpCaZcek0js8Y+jV
 ruKr4zoApYRZZltegBw27xEgl6Z2TmzhVlyWyo6AEzlXtQxpExprXEpm0fzbLUcmuB5z
 eyBvDXHIYVL7L39ezw28P8Qr4awjBn2HwWwRI7gwIcJaQj1zY/8mRGtACmajknrYUIxS 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x1attmev7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 16:52:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOGma3f029586;
        Tue, 24 Dec 2019 16:52:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x37te7hes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 16:52:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBOGqFjJ021842;
        Tue, 24 Dec 2019 16:52:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 08:52:15 -0800
Date:   Tue, 24 Dec 2019 08:52:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: fix totally broken unit conversion in
 directory invalidation
Message-ID: <20191224165214.GA7489@magnolia>
References: <20191218042402.GL12765@magnolia>
 <20191224083843.GA1739@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224083843.GA1739@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 24, 2019 at 12:38:43AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 17, 2019 at 08:24:02PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Your humble author forgot that xfs_dablk_t has the same units as
> > xfs_fileoff_t, and totally screwed up the directory buffer invalidation
> > loop in dir_binval.  Not only is there an off-by-one error in the loop
> > conditional, but the unit conversions are wrong.
> 
> Can we kill off xfs_dablk_t?  I found the concept very, very confusing
> when touching the dir code.

I personally wouldn't mind if that happened (as a separate patch).

> > --- a/libxfs/xfs_dir2.h
> > +++ b/libxfs/xfs_dir2.h
> > @@ -308,6 +308,16 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
> >  		  sizeof(struct xfs_dir2_leaf_tail));
> >  }
> >  
> > +/*
> > + * For a given dir/attr geometry and extent mapping record, walk every file
> > + * offset block (xfs_dablk_t) in the mapping that corresponds to the start
> > + * of a logical directory block (xfs_dir2_db_t).
> > + */
> > +#define for_each_xfs_bmap_dabno(geo, irec, dabno) \
> > +	for ((dabno) = round_up((irec)->br_startoff, (geo)->fsbcount); \
> > +	     (dabno) < (irec)->br_startoff + (irec)->br_blockcount; \
> > +	     (dabno) += (geo)->fsbcount)
> 
> I think not having the magic for macro would be cleaner..

Eh, yeah, we don't really need it...

--D

> 
> > +	xfs_dablk_t		dabno;
> >  	int			error = 0;
> >  
> >  	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> > @@ -1286,11 +1286,7 @@ dir_binval(
> >  	geo = tp->t_mountp->m_dir_geo;
> >  	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> >  	for_each_xfs_iext(ifp, &icur, &rec) {
> > -		dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
> > -				geo->fsbcount - 1);
> > -		end_dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
> > -				rec.br_blockcount);
> > -		for (; dabno <= end_dabno; dabno += geo->fsbcount) {
> > +		for_each_xfs_bmap_dabno(geo, &rec, dabno) {
> >  			bp = NULL;
> >  			error = -libxfs_da_get_buf(tp, ip, dabno, -2, &bp,
> >  					whichfork);
> 
> But either way, the fix looks good.
