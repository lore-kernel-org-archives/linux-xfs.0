Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11F1C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 18:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C35452082F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 18:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4XQeBit"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbgGAS1P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 14:27:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43000 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732911AbgGAS1O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 14:27:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061IHN3k059733;
        Wed, 1 Jul 2020 18:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fI5y4uFVlf5Dd6wQYeRYeV5fTryZBqBOrrrOyu6Q/es=;
 b=J4XQeBitxCcGRXTeCMveU68ut+R0puINoXLfkq+R2v4wHzhVVWSyl/c6pQY5xVKrhrDC
 Q5RlzKx4z16YMUcF0O++3hcR/k0CtGcD0/TYtGCdssijBmb1rhXRFBYENGT1M4PjsUOI
 6K9GMpiwaomOcoxypgMQOg2PlBgoQDWdVx4WDU3UlQCg05qVOyjhsNAsL+paqwTKpTMw
 hy37OkJpYaLWD4Ny2DBrHn4CsHfhEE0FQy4l1UfYoEr7NI1RqUohsYTdqJ6aOU9Dfbxq
 mbwy9VoPqFA35ZpsKrRh50hBgPhMXaI81ge9fN+1v6nXmbgwx9o4033HQJe/uI9M8XYO jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31ywrbtdm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 18:27:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061IIcLh174280;
        Wed, 1 Jul 2020 18:25:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvubnt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 18:25:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061IP9Ze026670;
        Wed, 1 Jul 2020 18:25:09 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 18:25:09 +0000
Date:   Wed, 1 Jul 2020 11:25:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
Message-ID: <20200701182508.GV7606@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172899.2864738.6438709598863248951.stgit@magnolia>
 <20200701084208.GC25171@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701084208.GC25171@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 09:42:08AM +0100, Christoph Hellwig wrote:
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
> 
> The comment looks a little weird, as this also checks d_id.  Also
> xfs_dquot_verify verifies d_flags against generally bogus value, it
> just doesn't check that it matches the type we are looking for.
> Last but not least dqp->dq_flags only contains the type at this
> point.
> 
> So what about something like:
> 
> 	/*
> 	 * Ensure we got the type and ID we were looking for.  Everything else
> 	 * we checked by the verifier.
> 	 */
> 	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
> 	    ddqp->d_id != dqp->q_core.d_id)

Sounds good to me.  I'll make that change.

--D

> 
