Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC655C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A708D2082F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tx2XGSqU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgGAXQW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 19:16:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39478 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGAXQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:16:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061N3vrL172405;
        Wed, 1 Jul 2020 23:16:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kdRIApguUlMT5ZEzyFmc8Kv3vpOSQpumcPAmePOyP7M=;
 b=tx2XGSqUFn6dCkSo0opqmWONRGp3nI7xexXs/aDzZt7Cqmc+b3QxmkHVJoJTjvJlUBXB
 X/EqK817cF12QG/IXdT6axZsvN4K5E9VNY0++9IBr3Ho+w63hVHF7cQfzQ23w5VHHcqN
 Udb529LjCUQHaTGQOydunlsD8Xk/PnT+y07+2ix2Ihp0FQk7kediToBzhBQr8r0jDIy6
 PaYzlpQmkp0H6SqrH7O1XMJ4Tg4sqUcbhbPi0ZGMiw8s90wYW5xZOsAK09r6aS4AS3RG
 gGw/dQfGS4XB8yjjGVow1InBs69k0Tubx5OC0jJARd87zqWxUDPgz150Kie39rjLItjx Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31ywrbujk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 23:16:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061Mwmhb067405;
        Wed, 1 Jul 2020 23:16:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52kwex6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 23:16:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061NGIOA031434;
        Wed, 1 Jul 2020 23:16:18 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 23:16:18 +0000
Date:   Wed, 1 Jul 2020 16:16:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
Message-ID: <20200701231617.GP7625@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172899.2864738.6438709598863248951.stgit@magnolia>
 <20200701224112.GY2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701224112.GY2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:41:12AM +1000, Dave Chinner wrote:
> On Tue, Jun 30, 2020 at 08:42:09AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > While loading dquot records off disk, make sure that the quota type
> > flags are the same between the incore dquot and the ondisk dquot.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_dquot.c |   23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index d5b7f03e93c8..46c8ca83c04d 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -524,13 +524,27 @@ xfs_dquot_alloc(
> >  }
> >  
> >  /* Copy the in-core quota fields in from the on-disk buffer. */
> > -STATIC void
> > +STATIC int
> >  xfs_dquot_from_disk(
> >  	struct xfs_dquot	*dqp,
> >  	struct xfs_buf		*bp)
> >  {
> >  	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
> >  
> > +	/*
> > +	 * The only field the verifier didn't check was the quota type flag, so
> > +	 * do that here.
> > +	 */
> > +	if ((dqp->dq_flags & XFS_DQ_ALLTYPES) !=
> > +	    (ddqp->d_flags & XFS_DQ_ALLTYPES) ||
> > +	    dqp->q_core.d_id != ddqp->d_id) {
> > +		xfs_alert(bp->b_mount,
> > +			  "Metadata corruption detected at %pS, quota %u",
> > +			  __this_address, be32_to_cpu(dqp->q_core.d_id));
> 
> Probably should indicate which quota type is invalid, too. Also,
> looking at xfs_buf_corruption_error(), it also uses
> 
> 		xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR, ....
> 
> Should that be used here, too?

Yeah.  Will fix.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
