Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1D6C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 22:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79EC7207D8
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 22:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PYa4UkBg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgE0Wjl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 18:39:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0Wjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 18:39:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RMM9Tv156818;
        Wed, 27 May 2020 22:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oKDejOo/j364DsCMusTbd5S4WFiPlJXaPwvFYdrDWGM=;
 b=PYa4UkBgD2zYO1uQx5rKkkb3pyrsL1ZRAkSIODOt023j5vWBt+SOXuD7br/9txqIeKAb
 DIAvEpR3ptyQdiO4NgxT3c8QzV4VRLb0QoyK4DFMH4+PCmxHkVFi1nN82y/QBWuim66W
 l2yPxAfoTY5cRa3ysdCALKM1/HLE+sS+gS8cyE4+7DxxPgjPWADNYYlZCUOa+pjyCcme
 hGupXMfFC0bF/a7hFBzCr3UOa/xdUP/NtZmxjzPXaN0LCjLdM8IRTtiFr4qdCDn1Cn89
 mkfyj9oDba8OlxRLAkny3vbCK+r0gxTFVWjvB9e7P0OSihLybRRXDGb7Q2E8+D9hFY6J aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 318xe1j295-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 22:39:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RMHbuJ184348;
        Wed, 27 May 2020 22:39:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 317dkv9kkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 22:39:36 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04RMdZwb024390;
        Wed, 27 May 2020 22:39:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 15:39:35 -0700
Date:   Wed, 27 May 2020 15:39:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: reduce log recovery transaction block
 reservations
Message-ID: <20200527223934.GP8230@magnolia>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130035.2142108.11825776210575708747.stgit@magnolia>
 <20200424140408.GE53690@bfoster>
 <20200428222247.GI6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428222247.GI6742@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=5 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=5 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 03:22:47PM -0700, Darrick J. Wong wrote:
> On Fri, Apr 24, 2020 at 10:04:08AM -0400, Brian Foster wrote:
> > On Tue, Apr 21, 2020 at 07:08:20PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > On filesystems that support them, bmap intent log items can be used to
> > > change mappings in inode data or attr forks.  However, if the bmbt must
> > > expand, the enormous block reservations that we make for finishing
> > > chains of deferred log items become a liability because the bmbt block
> > > allocator sets minleft to the transaction reservation and there probably
> > > aren't any AGs in the filesystem that have that much free space.
> > > 
> > > Whereas previously we would reserve 93% of the free blocks in the
> > > filesystem, now we only want to reserve 7/8ths of the free space in the
> > > least full AG, and no more than half of the usable blocks in an AG.  In
> > > theory we shouldn't run out of space because (prior to the unclean
> > > shutdown) all of the in-progress transactions successfully reserved the
> > > worst case number of disk blocks.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_log_recover.c |   55 ++++++++++++++++++++++++++++++++++++----------
> > >  1 file changed, 43 insertions(+), 12 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index e9b3e901d009..a416b028b320 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -2669,6 +2669,44 @@ xlog_recover_process_data(
> > >  	return 0;
> > >  }
> > >  
> > > +/*
> > > + * Estimate a block reservation for a log recovery transaction.  Since we run
> > > + * separate transactions for each chain of deferred ops that get created as a
> > > + * result of recovering unfinished log intent items, we must be careful not to
> > > + * reserve so many blocks that block allocations fail because we can't satisfy
> > > + * the minleft requirements (e.g. for bmbt blocks).
> > > + */
> > > +static int
> > > +xlog_estimate_recovery_resblks(
> > > +	struct xfs_mount	*mp,
> > > +	unsigned int		*resblks)
> > > +{
> > > +	struct xfs_perag	*pag;
> > > +	xfs_agnumber_t		agno;
> > > +	unsigned int		free = 0;
> > > +	int			error;
> > > +
> > > +	/* Don't use more than 7/8th of the free space in the least full AG. */
> > > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > > +		unsigned int	ag_free;
> > > +
> > > +		error = xfs_alloc_pagf_init(mp, NULL, agno, 0);
> > > +		if (error)
> > > +			return error;
> > > +		pag = xfs_perag_get(mp, agno);
> > > +		ag_free = pag->pagf_freeblks + pag->pagf_flcount;
> > > +		free = max(free, (ag_free * 7) / 8);
> > > +		xfs_perag_put(pag);
> > > +	}
> > > +
> > 
> > Somewhat unfortunate that we have to iterate all AGs for each chain. I'm
> > wondering if that has any effect on a large recovery on fs' with an
> > inordinate AG count. Have you tested under those particular conditions?
> > I suppose it's possible the recovery is slow enough that this won't
> > matter...
> 
> I admit I haven't actually looked at that.  A more precise way to handle
> this would be for each intent recovery function to store its own worst
> case resblks estimation in the recovery freezer so that we'd be using
> roughly the same space requirements as the pre-crash transaction, but
> that's also a lot more complicated than this kludge.

I've been testing a new patch that rips out all of this in favor of
stealing the unused block reservation from the transaction that the log
item recovery function creates instead of this hokey AG iteration mess.
The results look promising, and I think I'll do this instead.

Granted, this now means that log intent item recovery must be very
careful to reserve enough blocks for the entire chain of operations that
could be created.  This shouldn't be too heavy a lift since we don't
have that many intent types yet, and at least at first glance the
resblks we ask for now looked ok to me.

--D

> > Also, perhaps not caused by this patch but does this
> > outsized/manufactured reservation have the effect of artificially
> > steering allocations to a particular AG if one happens to be notably
> > larger than the rest?
> 
> It tends to steer allocations towards whichever AGs were less full at
> the start of each transaction.  Were we to shift to scanning the AGs
> once for the entire recovery cycle, I think I'd probably pick a smaller
> ratio.
> 
> --D
> 
> > Brian
> > 
> > > +	/* Don't try to reserve more than half the usable AG blocks. */
> > > +	*resblks = min(free, xfs_alloc_ag_max_usable(mp) / 2);
> > > +	if (*resblks == 0)
> > > +		return -ENOSPC;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  /* Take all the collected deferred ops and finish them in order. */
> > >  static int
> > >  xlog_finish_defer_ops(
> > > @@ -2677,27 +2715,20 @@ xlog_finish_defer_ops(
> > >  {
> > >  	struct xfs_defer_freezer *dff, *next;
> > >  	struct xfs_trans	*tp;
> > > -	int64_t			freeblks;
> > >  	uint			resblks;
> > >  	int			error = 0;
> > >  
> > >  	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
> > > +		error = xlog_estimate_recovery_resblks(mp, &resblks);
> > > +		if (error)
> > > +			break;
> > > +
> > >  		/*
> > >  		 * We're finishing the defer_ops that accumulated as a result
> > >  		 * of recovering unfinished intent items during log recovery.
> > >  		 * We reserve an itruncate transaction because it is the
> > > -		 * largest permanent transaction type.  Since we're the only
> > > -		 * user of the fs right now, take 93% (15/16) of the available
> > > -		 * free blocks.  Use weird math to avoid a 64-bit division.
> > > +		 * largest permanent transaction type.
> > >  		 */
> > > -		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> > > -		if (freeblks <= 0) {
> > > -			error = -ENOSPC;
> > > -			break;
> > > -		}
> > > -
> > > -		resblks = min_t(int64_t, UINT_MAX, freeblks);
> > > -		resblks = (resblks * 15) >> 4;
> > >  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> > >  				0, XFS_TRANS_RESERVE, &tp);
> > >  		if (error)
> > > 
> > 
