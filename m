Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56E4C4363C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 16:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F42A206FA
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 16:30:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WpcRkjhZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388060AbgJBQaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 12:30:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgJBQaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 12:30:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092GJpoC152163;
        Fri, 2 Oct 2020 16:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=H2oKJvaZyLpoDnqXRLrzhCZ9xB2lOOp7p/wiB4iQVh4=;
 b=WpcRkjhZnbO9jEusfKw75KFo1KtmVu+WtbL1bC29s+J8WqN7f1CB+XrW2j0Qt/znO/fi
 +603bo7/gI/VP1IX8iJnNsx5H4usR66w4RXTIf6L7uELqJcGQ+zaYlzDKP/hsul5LlWs
 PiKXyGGBXolgPdmL1nmt2JnmyphUk3bvJj7R7imYoGf+7BKc89npdhnQIwYzVL3eqQDw
 TlQWyTrNU2f7A77cZ1Twn0/d0yBD+aoywFFsmEc4ZCv5p3w2wE6wCwzc2terk1xqZ772
 wf5r36TyYsys400L8AGH+CyNaI4HsCMLb+3SQe+VYoglrXxzE3mqQkXx0PdSlHiFbjbM Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkmbt79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 16:30:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092GKtZ1028755;
        Fri, 2 Oct 2020 16:30:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdxst9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 16:30:46 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092GUj7b012674;
        Fri, 2 Oct 2020 16:30:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 09:30:45 -0700
Date:   Fri, 2 Oct 2020 09:30:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: clean up xfs_bui_item_recover
 iget/trans_alloc/ilock ordering
Message-ID: <20201002163044.GY49547@magnolia>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
 <160140144017.830434.9012644788797432565.stgit@magnolia>
 <20201002162754.GA4708@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002162754.GA4708@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 12:27:54PM -0400, Brian Foster wrote:
> On Tue, Sep 29, 2020 at 10:44:00AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In most places in XFS, we have a specific order in which we gather
> > resources: grab the inode, allocate a transaction, then lock the inode.
> > xfs_bui_item_recover doesn't do it in that order, so fix it to be more
> > consistent.  This also makes the error bailout code a bit less weird.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_bmap_item.c |   42 ++++++++++++++++++++++--------------------
> >  1 file changed, 22 insertions(+), 20 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index c1f2cc3c42cb..1c9cb5a04bb5 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> ...
> > @@ -512,18 +513,19 @@ xfs_bui_item_recover(
> >  		xfs_bmap_unmap_extent(tp, ip, &irec);
> >  	}
> >  
> > +	/* Commit transaction, which frees tp. */
> >  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> > +	if (error)
> > +		goto err_unlock;
> > +	return 0;
> > +
> > +err_cancel:
> > +	xfs_trans_cancel(tp);
> > +err_unlock:
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +err_rele:
> >  	xfs_irele(ip);
> 
> What happened to the unlock and irele in the non-error path?

xfs_defer_capture_and_consume did that, but see christoph's reply.

--D

> Brian
> 
> >  	return error;
> > -
> > -err_inode:
> > -	xfs_trans_cancel(tp);
> > -	if (ip) {
> > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -		xfs_irele(ip);
> > -	}
> > -	return error;
> >  }
> >  
> >  STATIC bool
> > 
> 
