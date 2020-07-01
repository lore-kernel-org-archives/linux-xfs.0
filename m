Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6F1C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D68192082F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V7DF8QGg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgGAXNs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 19:13:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgGAXNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:13:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061N0Crg092593;
        Wed, 1 Jul 2020 23:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=trojpq8LOIyQHfisJ9fvceAwceVMqf2afuIhKjwnLnk=;
 b=V7DF8QGg9mZuTZBLtfbChoqRlkD28iSmYNcb1sZxijSsZribye3jOlfsU3a+szkbuVuY
 HB9O7vGl+8AGn+yMEb0Ql1kGt+ZVLPOq2lPTPgUybbovIog+3zOo/CUN7Uje9pMwGjuX
 rCuC8+Lawjf+ml7+RihgYxwJjly3GF8f54S6knXtNxiKv9a71GcZ2NbbSnm32la1H1mO
 27dQQvUoq+nffRHrztU7xksH9hxr6JRwMUcys+QFrOtSrP5gyJcVU6Pok4W6/YbHLD3n
 pGuTyrphUmVTIpVtr3CIRGTXHFyuQ2SI2WI7EdI7qZWxfadOp0T6//zidOHR9fxuK50S 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31xx1e26v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 23:13:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061MvooX046000;
        Wed, 1 Jul 2020 23:13:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31xg200kwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 23:13:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061NDiTZ030455;
        Wed, 1 Jul 2020 23:13:44 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 23:13:44 +0000
Date:   Wed, 1 Jul 2020 16:13:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: stop using q_core limits in the quota code
Message-ID: <20200701231343.GN7625@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353175596.2864738.3236954866547071975.stgit@magnolia>
 <20200701230136.GB2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701230136.GB2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=987 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 09:01:36AM +1000, Dave Chinner wrote:
> On Tue, Jun 30, 2020 at 08:42:36AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add limits fields in the incore dquot, and use that instead of the ones
> > in qcore.  This eliminates a bunch of endian conversions and will
> > eventually allow us to remove qcore entirely.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > @@ -124,82 +123,67 @@ xfs_qm_adjust_dqtimers(
> >  	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
> >  
> >  #ifdef DEBUG
> > -	if (d->d_blk_hardlimit)
> > -		ASSERT(be64_to_cpu(d->d_blk_softlimit) <=
> > -		       be64_to_cpu(d->d_blk_hardlimit));
> > -	if (d->d_ino_hardlimit)
> > -		ASSERT(be64_to_cpu(d->d_ino_softlimit) <=
> > -		       be64_to_cpu(d->d_ino_hardlimit));
> > -	if (d->d_rtb_hardlimit)
> > -		ASSERT(be64_to_cpu(d->d_rtb_softlimit) <=
> > -		       be64_to_cpu(d->d_rtb_hardlimit));
> > +	if (dq->q_blk.hardlimit)
> > +		ASSERT(dq->q_blk.softlimit <= dq->q_blk.hardlimit);
> > +	if (dq->q_ino.hardlimit)
> > +		ASSERT(dq->q_ino.softlimit <= dq->q_ino.hardlimit);
> > +	if (dq->q_rtb.hardlimit)
> > +		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
> >  #endif
> 
> You can get rid of the ifdef DEBUG here - if ASSERT is not defined
> then the compiler will elide all this code anyway.

OK.

> >  /* Allocate and initialize the dquot buffer for this in-core dquot. */
> > @@ -1123,9 +1119,29 @@ static xfs_failaddr_t
> >  xfs_qm_dqflush_check(
> >  	struct xfs_dquot	*dqp)
> >  {
> > +	struct xfs_disk_dquot	*ddq = &dqp->q_core;
> > +
> >  	if (hweight8(dqp->dq_flags & XFS_DQ_ALLTYPES) != 1)
> >  		return __this_address;
> >  
> > +	if (dqp->q_id == 0)
> > +		return NULL;
> > +
> > +	if (dqp->q_blk.softlimit &&
> > +	    be64_to_cpu(ddq->d_bcount) > dqp->q_blk.softlimit &&
> > +	    !ddq->d_btimer)
> > +		return __this_address;
> > +
> > +	if (dqp->q_ino.softlimit &&
> > +	    be64_to_cpu(ddq->d_icount) > dqp->q_ino.softlimit &&
> > +	    !ddq->d_itimer)
> > +		return __this_address;
> > +
> > +	if (dqp->q_rtb.softlimit &&
> > +	    be64_to_cpu(ddq->d_rtbcount) > dqp->q_rtb.softlimit &&
> > +	    !ddq->d_rtbtimer)
> > +		return __this_address;
> 
> These are new in this patch. These are checked by
> xfs_dquot_verify(), so what's the reason for duplicating the checks
> here?

The new functions perform spot-checks of the incore dquot before we start
flushing them out to disk, because the goal of this patch is to further
decouple the incore and ondisk dquots ahead of the y2038 support series.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
