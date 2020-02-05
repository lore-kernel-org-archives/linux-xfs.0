Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11572C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D93142082E
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:09:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DhCe7T47"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgBEAJS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:09:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47584 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbgBEAJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:09:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01503AVe089731;
        Wed, 5 Feb 2020 00:09:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=JPnzWYfT4lBqXtQMpj001Txq/Cs1wKxUgOQ8hpBKkr8=;
 b=DhCe7T47U1t2mvDmUnHrb795tXKp5Y/Ep8G02BpfkZOCv6DF1aUZlXKFOAG5tUX9KtMe
 ib+d6hmNUmzeyTr2asJyu5SP521dDhE60g2M5eJQdtjm/2LA49TYSJA2DzcjSPmBhh94
 ySHkHY0XonfRad41V9ofskTUWpfjHUbzD9vjXWOLvX8k9DVhvgILCdnq0b6FZZ/32aL9
 JmvK0/zt0UXN91mO8kc3ysLkHhK6HzNKUloFWcR3mVd6ux7YRun1gub12Hr4Md6YkgyJ
 QXr/rgnQ82TKmzfhFhwaTB/MkQFv4EoJscWPy9uL7AI2zGt7V/OIVCY0Mh1Z7sJyXt5H 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xyhkf88vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:09:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01504IlO033499;
        Wed, 5 Feb 2020 00:09:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xyhmvjrdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:09:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01509Bak027305;
        Wed, 5 Feb 2020 00:09:12 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:09:11 -0800
Date:   Tue, 4 Feb 2020 16:09:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix invalid pointer dereference in
 xfs_attr3_node_inactive
Message-ID: <20200205000910.GB6870@magnolia>
References: <20200204070636.25572-1-zlang@redhat.com>
 <20200204213932.GM20628@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204213932.GM20628@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 05, 2020 at 08:39:32AM +1100, Dave Chinner wrote:
> On Tue, Feb 04, 2020 at 03:06:36PM +0800, Zorro Lang wrote:
> > This patch fixes below KASAN report. The xfs_attr3_node_inactive()
> > gets 'child_bp' at there:
> >   error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
> >                             child_blkno,
> >                             XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
> >                             &child_bp);
> >   if (error)
> >           return error;
> >   error = bp->b_error;
> > 
> > But it turns to use 'bp', not 'child_bp'. And the 'bp' has been freed by:
> >   xfs_trans_brelse(*trans, bp);
> 
> ....
> > ---
> >  fs/xfs/xfs_attr_inactive.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index bbfa6ba84dcd..26230d150bf2 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -211,7 +211,7 @@ xfs_attr3_node_inactive(
> >  				&child_bp);
> >  		if (error)
> >  			return error;
> > -		error = bp->b_error;
> > +		error = child_bp->b_error;
> >  		if (error) {
> >  			xfs_trans_brelse(*trans, child_bp);
> >  			return error;
> 
> Isn't this dead code now? i.e. any error that occurs on the buffer
> during a xfs_trans_get_buf() call is returned directly and so it's
> caught by the "if (error)" check. Hence this whole child_bp->b_error
> check can be removed, right?

It will be after I send in the second half of the 5.6 merge window.  I
decided to hang onto the buffer error code rework until all of the
kernel fuzz tests finished running and I was satisfied with my own
userspace port of the same series.

(All that is now done, so I'll send that to linus tomorrow.)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
