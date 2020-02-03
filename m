Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799D1C35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 20:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D78720658
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 20:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JEWKHg/u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgBCUO7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 15:14:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48816 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgBCUO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 15:14:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 013KDSmU105000;
        Mon, 3 Feb 2020 20:14:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=MtfZBnete9IBNqxOZFErsB7K39Z5xa39JtSrUSqDlvw=;
 b=JEWKHg/uP2H24zXje3hr2tmWQ0dKvJbzJuRbPI17yBtGrRTHaNuI2KFvfOeC45fL6q45
 i+5aZGvgLuTEVoimPbMcZssrpDwuR8M8WhMgLV8TYsr8tQST7DSDXdCW1LOFkc5hq0Rc
 nOmsAzTxQybm/JlA1ym486DoFV6yXQQVAO4J9EYtXFWkkUArb2qvM6gka0aHL71IO6RH
 nrKXYyCnKKRh8asWlShXzbrc3aR9ZRB7pOdH/R9FMJELPxuxQHKho+mBfR39XKwmTbKW
 lwqk0gzcTr7INajnKf9z+3J8FARMKs4e9L1UoasBnVFc2DVmScDFZgEMSTfAhV54UDrx pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xwyg9efqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Feb 2020 20:14:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 013KDHEd079167;
        Mon, 3 Feb 2020 20:14:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xxsbhbddh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Feb 2020 20:14:47 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 013KEkLM011484;
        Mon, 3 Feb 2020 20:14:46 GMT
Received: from localhost (/10.159.136.124)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Feb 2020 12:14:46 -0800
Date:   Mon, 3 Feb 2020 12:14:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200203201445.GA6870@magnolia>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535059.2406747.264640456606868955.stgit@magnolia>
 <20200119204925.GC9407@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119204925.GC9407@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9520 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002030145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9520 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002030145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 20, 2020 at 07:49:25AM +1100, Dave Chinner wrote:
> On Wed, Jan 15, 2020 at 10:15:50PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When writing to a delalloc region in the data fork, commit the new
> > allocations (of the da reservation) as unwritten so that the mappings
> > are only marked written once writeback completes successfully.  This
> > fixes the problem of stale data exposure if the system goes down during
> > targeted writeback of a specific region of a file, as tested by
> > generic/042.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |   28 +++++++++++++++++-----------
> >  1 file changed, 17 insertions(+), 11 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 4544732d09a5..220ea1dc67ab 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4190,17 +4190,7 @@ xfs_bmapi_allocate(
> >  	bma->got.br_blockcount = bma->length;
> >  	bma->got.br_state = XFS_EXT_NORM;
> >  
> > -	/*
> > -	 * In the data fork, a wasdelay extent has been initialized, so
> > -	 * shouldn't be flagged as unwritten.
> > -	 *
> > -	 * For the cow fork, however, we convert delalloc reservations
> > -	 * (extents allocated for speculative preallocation) to
> > -	 * allocated unwritten extents, and only convert the unwritten
> > -	 * extents to real extents when we're about to write the data.
> > -	 */
> > -	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
> > -	    (bma->flags & XFS_BMAPI_PREALLOC))
> > +	if (bma->flags & XFS_BMAPI_PREALLOC)
> >  		bma->got.br_state = XFS_EXT_UNWRITTEN;
> >  
> >  	if (bma->wasdel)
> > @@ -4608,8 +4598,24 @@ xfs_bmapi_convert_delalloc(
> >  	bma.offset = bma.got.br_startoff;
> >  	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
> >  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
> > +
> > +	/*
> > +	 * When we're converting the delalloc reservations backing dirty pages
> > +	 * in the page cache, we must be careful about how we create the new
> > +	 * extents:
> > +	 *
> > +	 * New CoW fork extents are created unwritten, turned into real extents
> > +	 * when we're about to write the data to disk, and mapped into the data
> > +	 * fork after the write finishes.  End of story.
> > +	 *
> > +	 * New data fork extents must be mapped in as unwritten and converted
> > +	 * to real extents after the write succeeds to avoid exposing stale
> > +	 * disk contents if we crash.
> > +	 */
> >  	if (whichfork == XFS_COW_FORK)
> >  		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> > +	else
> > +		bma.flags = XFS_BMAPI_PREALLOC;
> 
> 	bma.flags = XFS_BMAPI_PREALLOC;
> 	if (whichfork == XFS_COW_FORK)
> 		bma.flags |= XFS_BMAPI_COWFORK;
> 
> However, I'm still not convinced that this is the right/best
> solution to the problem. It is the easiest, yes, but the down side
> on fast/high iops storage and/or under low memory conditions has
> potential to be extremely significant.
> 
> I suspect that heavy users of buffered O_DSYNC writes into sparse
> files are going to notice this the most - there are databases out
> there that work this way. And I suspect that most of the workloads
> that use buffered O_DSYNC IO heavily won't see this change for years
> as enterprise upgrade cycles are notoriously slow.
> 
> IOWs, all I see this change doing is kicking the can down the road
> and guaranteeing that we'll still have to solve this stale data
> exposure problem more efficiently in the future. And instead of
> doing it now when we have the time and freedom to do the work, it
> will have to be done urgently under high priority escalation
> pressures...

FWIW I'm *already* under urgent high priority GA blocker escalation
pressure, which is why this came up again.

Granted it did take 12 days of losing the battle with the distro folks
that this really isn't a release blocker (but teh sekuritehs!!) but...oh
right, I forgot that xfs actually /does/ crash more than once per day in
our environment.

I guess *we* will find out how much performance really disappears if you
do it this way. :P

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
