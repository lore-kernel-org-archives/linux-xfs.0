Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF70C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 06:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96F092083B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 06:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uKm6LdsJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIQGhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 02:37:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56696 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgIQGhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 02:37:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H6NlCf092733;
        Thu, 17 Sep 2020 06:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZVAsnphUUz/yOCoEtO8rlBMRkGzhFyCmwj3g3gEGfYU=;
 b=uKm6LdsJnnUxN77NlFb8p6tKKfGQSF4wzUNW/qgk946EgxXr+DVmcX1K8/Y8IQ3+1F01
 ci+Ju8hTq2WEFGR4E3kk2bLHp33Elb28nGsg8639Rk9gnzVnS9IHGkaCKvtxb9Hup5eD
 omJ5eHawcSp7TkzYs/7QjpjQrrqIiQMJlwBsK9cqywDIUSfmcqpELHWiyagOTFXSZQNc
 dElmcFoE0vouDD7ZHIpNO0JJ96cCw0BCkjR5nMzVp5LVd20+dn3xkQ17cCpIwGCPMwtX
 9p4LzIpNC8hco7M6py4AylApAnn0ivLqPZOG+ndKwjDW2WHOb/4t1moNJCs+E7OFDR5V CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrr76p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 06:37:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H6PWoF189442;
        Thu, 17 Sep 2020 06:37:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h88aef8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 06:37:01 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H6axIQ002674;
        Thu, 17 Sep 2020 06:37:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 06:36:59 +0000
Date:   Wed, 16 Sep 2020 23:36:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: attach inode to dquot in xfs_bui_item_recover
Message-ID: <20200917063658.GS7955@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <160031333615.3624373.7775190767495604737.stgit@magnolia>
 <20200917045456.GC12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917045456.GC12131@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170049
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 02:54:56PM +1000, Dave Chinner wrote:
> On Wed, Sep 16, 2020 at 08:28:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In the bmap intent item recovery code, we must be careful to attach the
> > inode to its dquots (if quotas are enabled) so that a change in the
> > shape of the bmap btree doesn't cause the quota counters to be
> > incorrect.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_bmap_item.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 815a0563288f..598f713831c9 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -24,6 +24,7 @@
> >  #include "xfs_error.h"
> >  #include "xfs_log_priv.h"
> >  #include "xfs_log_recover.h"
> > +#include "xfs_quota.h"
> >  
> >  kmem_zone_t	*xfs_bui_zone;
> >  kmem_zone_t	*xfs_bud_zone;
> > @@ -498,6 +499,10 @@ xfs_bui_item_recover(
> >  	if (error)
> >  		goto err_inode;
> >  
> > +	error = xfs_qm_dqattach(ip);
> > +	if (error)
> > +		goto err_inode;
> 
> Won't this deadlock as the inode is already locked when it is
> returned by xfs_iget()?

DOH, yes.  The patch "xfs: clean up xfs_bui_item_recover
iget/trans_alloc/ilock ordering" obscures that...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
