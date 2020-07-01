Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D459C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B882083E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:33:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KgVuqUpO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgGAXdg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 19:33:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgGAXdf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:33:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061NMSmh135143;
        Wed, 1 Jul 2020 23:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EssZE0Gly1mtg8Sv0ycKdwQueFfp9XzAQurmoQwsfWk=;
 b=KgVuqUpOLqjy7LLLr/8VfdNeP42cB8ePdd+gzhtibpH2W0oT5Th7ns3U3olNf4o4ujJi
 eNGXiWLZ+gS8FyBjIUDUxnewq/0DtQitFxHLFgCRPCAqNl7/jzP+EQVvsn8dkxYSpbgM
 zRhhTYZ1HoRf0PVy8/TeHdBaQ6wC8E3fGZVVct4xHklHzbxaktecHWnhVLo54Ep/FKtU
 JcKwPrQKNebsjwcG2/JlVkiW2aXW7swqGm3oqKtWu5n0xjkwB6mI+mP3fXEXjlfaD/QH
 IcpPaAEXq8ljJdg4665nqaEleM+2vWZvUW9wK+8gP5fjkY+Bsg2QiN2rOb4/t3DTlRqB OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrndc4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 23:33:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061NN24s023831;
        Wed, 1 Jul 2020 23:33:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg17ht1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 23:33:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 061NXWt0002802;
        Wed, 1 Jul 2020 23:33:32 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 23:33:31 +0000
Date:   Wed, 1 Jul 2020 16:33:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: stop using q_core limits in the quota code
Message-ID: <20200701233330.GX7606@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353175596.2864738.3236954866547071975.stgit@magnolia>
 <20200701230136.GB2005@dread.disaster.area>
 <20200701231343.GN7625@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701231343.GN7625@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=940 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=953
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 04:13:43PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 02, 2020 at 09:01:36AM +1000, Dave Chinner wrote:
> > On Tue, Jun 30, 2020 at 08:42:36AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Add limits fields in the incore dquot, and use that instead of the ones
> > > in qcore.  This eliminates a bunch of endian conversions and will
> > > eventually allow us to remove qcore entirely.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ....
> > > @@ -124,82 +123,67 @@ xfs_qm_adjust_dqtimers(
> > >  	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
> > >  
> > >  #ifdef DEBUG
> > > -	if (d->d_blk_hardlimit)
> > > -		ASSERT(be64_to_cpu(d->d_blk_softlimit) <=
> > > -		       be64_to_cpu(d->d_blk_hardlimit));
> > > -	if (d->d_ino_hardlimit)
> > > -		ASSERT(be64_to_cpu(d->d_ino_softlimit) <=
> > > -		       be64_to_cpu(d->d_ino_hardlimit));
> > > -	if (d->d_rtb_hardlimit)
> > > -		ASSERT(be64_to_cpu(d->d_rtb_softlimit) <=
> > > -		       be64_to_cpu(d->d_rtb_hardlimit));
> > > +	if (dq->q_blk.hardlimit)
> > > +		ASSERT(dq->q_blk.softlimit <= dq->q_blk.hardlimit);
> > > +	if (dq->q_ino.hardlimit)
> > > +		ASSERT(dq->q_ino.softlimit <= dq->q_ino.hardlimit);
> > > +	if (dq->q_rtb.hardlimit)
> > > +		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
> > >  #endif
> > 
> > You can get rid of the ifdef DEBUG here - if ASSERT is not defined
> > then the compiler will elide all this code anyway.
> 
> OK.

Actually, not ok.  A later patch in this series will refactor this whole
ugly function (and in the next round the #ifdefs) out of existence, so
I'll leave this part of the patch the way it is.

--D

> > >  /* Allocate and initialize the dquot buffer for this in-core dquot. */
> > > @@ -1123,9 +1119,29 @@ static xfs_failaddr_t
> > >  xfs_qm_dqflush_check(
> > >  	struct xfs_dquot	*dqp)
> > >  {
> > > +	struct xfs_disk_dquot	*ddq = &dqp->q_core;
> > > +
> > >  	if (hweight8(dqp->dq_flags & XFS_DQ_ALLTYPES) != 1)
> > >  		return __this_address;
> > >  
> > > +	if (dqp->q_id == 0)
> > > +		return NULL;
> > > +
> > > +	if (dqp->q_blk.softlimit &&
> > > +	    be64_to_cpu(ddq->d_bcount) > dqp->q_blk.softlimit &&
> > > +	    !ddq->d_btimer)
> > > +		return __this_address;
> > > +
> > > +	if (dqp->q_ino.softlimit &&
> > > +	    be64_to_cpu(ddq->d_icount) > dqp->q_ino.softlimit &&
> > > +	    !ddq->d_itimer)
> > > +		return __this_address;
> > > +
> > > +	if (dqp->q_rtb.softlimit &&
> > > +	    be64_to_cpu(ddq->d_rtbcount) > dqp->q_rtb.softlimit &&
> > > +	    !ddq->d_rtbtimer)
> > > +		return __this_address;
> > 
> > These are new in this patch. These are checked by
> > xfs_dquot_verify(), so what's the reason for duplicating the checks
> > here?
> 
> The new functions perform spot-checks of the incore dquot before we start
> flushing them out to disk, because the goal of this patch is to further
> decouple the incore and ondisk dquots ahead of the y2038 support series.
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
