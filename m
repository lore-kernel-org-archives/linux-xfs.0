Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED393C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFDA6207BC
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:09:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r/0XSuZP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGQBJX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:09:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbgGQBJW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:09:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06H12RpR189306;
        Fri, 17 Jul 2020 01:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yZ6tmIXQOFerKREbPltSyNNs7lCT0sUVIUAS2o5zUaA=;
 b=r/0XSuZPG3E5pzCQu+An3bVPiXlK3kAsOUyI/bRlgWY7REW/SnrAwEIrkamLIIi78OhI
 ppnT7A7tKyTaS0w+kfDfK0sVYB+BQDodd2fWA/ksstYKbjHcHtMFNltviG/WriZfAC80
 VkEmgCUEU7eHBYYOVBFHo2J71ON6jG5La2lZuPiPzp6c6SHtZSs4HT/uHYT6g4jcS2nd
 yyGqOjVZqsWTk+S1iJRSyY8BTGhZahdbp3HUQADHezWjS9Q6aLRwp7Tykuj+OQHq1/15
 PNpGXgGHKuoZHH1MW43+td3leL/M9oQNIeGiuWae1G8AqmQ4Kzo2mtFeC9uG3EOdeLUx 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274urmkvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 01:09:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06H131MS113388;
        Fri, 17 Jul 2020 01:07:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qc4hr60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 01:07:20 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06H17I9A030991;
        Fri, 17 Jul 2020 01:07:18 GMT
Received: from localhost (/10.159.154.157)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jul 2020 18:07:18 -0700
Date:   Thu, 16 Jul 2020 18:07:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: replace a few open-coded XFS_DQTYPE_REC_MASK
 uses
Message-ID: <20200717010715.GL3151642@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488197022.3813063.2727213433560259185.stgit@magnolia>
 <20200717000242.GU2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717000242.GU2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 10:02:42AM +1000, Dave Chinner wrote:
> On Wed, Jul 15, 2020 at 11:46:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix a few places where we open-coded this mask constant.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_dquot_item_recover.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> > index d7eb85c7d394..93178341569a 100644
> > --- a/fs/xfs/xfs_dquot_item_recover.c
> > +++ b/fs/xfs/xfs_dquot_item_recover.c
> > @@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
> >  	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
> >  		return;
> >  
> > -	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
> > +	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
> >  	ASSERT(type);
> >  	if (log->l_quotaoffs_flag & type)
> >  		return;
> > @@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
> >  	/*
> >  	 * This type of quotas was turned off, so ignore this record.
> >  	 */
> > -	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
> > +	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
> 
> Couldn't these both be converted to xfs_dquot_type(recddq)?

xfs_dquot_type takes a pointer to a incore dquot, not a struct
xfs_disk_dquot, so no.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
