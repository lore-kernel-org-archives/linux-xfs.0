Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130EEC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 06:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C578C21D24
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 06:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mj8OpmNg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgIQGre (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 02:47:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37554 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgIQGrd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 02:47:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H6he2J140230;
        Thu, 17 Sep 2020 06:47:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JonsM66/l0vghOYlRM8KFoBv4WqptNigkMQVJux58Cw=;
 b=Mj8OpmNgwkHOstxDhRScCRVsBYw7iVssbKwx9YhesktUH3+RATOTKbNkiq4PrJDHcGD6
 GN7/saW1WNP4eGa1FZR1jL1MMDWxi6qDjMcSK8W5dr+Ba0JTVfRIrt5jC5K9U+SR/cDi
 26th+6b3vXntbl88qq3erajtlCkO8o1Ti6zOoRjxctHa03SZIRLefRSF2yE/nYSmpMUb
 EzluUhYUtAZzEO834eCP98Hfw9HgKXBpheQen6hPn6/nIRVn8PJ6jGfMRh2f5UbVANaA
 gthrbkyCK0gJnAZNk1rKb2iQAqonPjl7TT+yI2auOu4Hq37r/avQQ7wXI0zjZpUnEs5i zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrr77xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 06:47:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H6dX0O026222;
        Thu, 17 Sep 2020 06:47:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h88aev1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 06:47:29 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H6lSm2031104;
        Thu, 17 Sep 2020 06:47:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 06:47:28 +0000
Date:   Wed, 16 Sep 2020 23:47:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: clean up xfs_bui_item_recover
 iget/trans_alloc/ilock ordering
Message-ID: <20200917064727.GT7955@magnolia>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031337657.3624582.4680281255744277782.stgit@magnolia>
 <20200917051333.GF12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917051333.GF12131@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170050
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 03:13:33PM +1000, Dave Chinner wrote:
> On Wed, Sep 16, 2020 at 08:29:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In most places in XFS, we have a specific order in which we gather
> > resources: grab the inode, allocate a transaction, then lock the inode.
> > xfs_bui_item_recover doesn't do it in that order, so fix it to be more
> > consistent.  This also makes the error bailout code a bit less weird.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_bmap_item.c |   40 +++++++++++++++++++++-------------------
> >  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> This probably needs to go before the xfs_qm_dqattach() fix, or
> the dqattach fix need to come after this....

<nod> I'll fix the previous patch.

> > 
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 877afe76d76a..6f589f04f358 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -475,25 +475,26 @@ xfs_bui_item_recover(
> >  	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
> >  		goto garbage;
> >  
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> > -			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> > -	if (error)
> > -		return error;
> > -
> > -	budp = xfs_trans_get_bud(tp, buip);
> > -
> >  	/* Grab the inode. */
> > -	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
> > +	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
> >  	if (error)
> > -		goto err_inode;
> > +		return error;
> >  
> >  	error = xfs_qm_dqattach(ip);
> >  	if (error)
> > -		goto err_inode;
> > +		goto err_rele;
> >  
> >  	if (VFS_I(ip)->i_nlink == 0)
> >  		xfs_iflags_set(ip, XFS_IRECOVERY);
> >  
> > +	/* Allocate transaction and do the work. */
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> > +			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> > +	if (error)
> > +		goto err_rele;
> 
> Hmmmm - don't all the error cased before we call xfs_trans_get_bud()
> need to release the bui?

Yes, I think so.  Come to think of it, the other intent items seem like
they have the same bug.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
