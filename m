Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67D7C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A1D2085B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:14:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IohdDCgz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgGAXOz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 19:14:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgGAXOz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:14:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061N3P1A172287;
        Wed, 1 Jul 2020 23:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Tdw9r5KdqT4sXozzK6WfvjsInPl+MISKp3MfDThCZrk=;
 b=IohdDCgzQot1UHwl1kZOFXSUDfGhr/2XecFUuhrhTzl6yh+ktynGlSjcrJFNnNtNOC2R
 oXDODu5ZxN4o5GNkaLmCDMW8w8SpcGKJrZlAuFqGh4CnlXEagI337Q00D6Sq7Z/bb6Pu
 T8t0NzUOdED3KDDQh8cGoFLRCHKpz19pkKCh5LNginfwtvqP9m0GTXsx7prJhQxmzPke
 GYz9OIesMy8oLkij7Nxq8G9Wk/D0AOHJ2czQdTf2E4vhND1alNeN4jKk1OmzA98g1ZVp
 Bhz7rAWOd6IxU555LXMCffD4+CmprNjMb01SJasKbR6yyBjLa2nSUFs68ZPN+hiIe5j7 Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31ywrbujfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 23:14:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061Mwmlb067424;
        Wed, 1 Jul 2020 23:14:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31y52kwd4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 23:14:52 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061NEoW7007111;
        Wed, 1 Jul 2020 23:14:51 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 23:14:50 +0000
Date:   Wed, 1 Jul 2020 16:14:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] xfs: remove qcore from incore dquots
Message-ID: <20200701231449.GO7625@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353178119.2864738.14352743945962585449.stgit@magnolia>
 <20200701230754.GC2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701230754.GC2005@dread.disaster.area>
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

On Thu, Jul 02, 2020 at 09:07:54AM +1000, Dave Chinner wrote:
> On Tue, Jun 30, 2020 at 08:43:01AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we've stopped using qcore entirely, drop it from the incore
> > dquot.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > @@ -1180,7 +1184,6 @@ xfs_qm_dqflush(
> >  	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
> >  	struct xfs_buf		*bp;
> >  	struct xfs_dqblk	*dqb;
> > -	struct xfs_disk_dquot	*ddqp;
> >  	xfs_failaddr_t		fa;
> >  	int			error;
> >  
> > @@ -1204,22 +1207,6 @@ xfs_qm_dqflush(
> >  	if (error)
> >  		goto out_abort;
> >  
> > -	/*
> > -	 * Calculate the location of the dquot inside the buffer.
> > -	 */
> > -	dqb = bp->b_addr + dqp->q_bufoffset;
> > -	ddqp = &dqb->dd_diskdq;
> > -
> > -	/* sanity check the in-core structure before we flush */
> > -	fa = xfs_dquot_verify(mp, &dqp->q_core, dqp->q_id, 0);
> > -	if (fa) {
> > -		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> > -				dqp->q_id, fa);
> > -		xfs_buf_relse(bp);
> > -		error = -EFSCORRUPTED;
> > -		goto out_abort;
> > -	}
> > -
> >  	fa = xfs_qm_dqflush_check(dqp);
> >  	if (fa) {
> >  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> > @@ -1229,7 +1216,9 @@ xfs_qm_dqflush(
> >  		goto out_abort;
> >  	}
> >  
> > -	xfs_dquot_to_disk(ddqp, dqp);
> > +	/* Flush the incore dquot to the ondisk buffer. */
> > +	dqb = bp->b_addr + dqp->q_bufoffset;
> > +	xfs_dquot_to_disk(&dqb->dd_diskdq, dqp);
> 
> Oh, this is really hard to read now. d, q, b, and p are all the same
> shape just at different rotations/mirroring, so this now just looks
> like a jumble of random letter salad...
> 
> Can you rename dqb to dqblk so it's clearly the pointer to the
> on-disk dquot block and so easy to differentiate at a glance from
> the in-memory dquot pointer?

Ok.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
