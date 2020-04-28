Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE91C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EDEF2072A
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:23:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="njVkC7XJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgD1WXJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:23:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgD1WXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:23:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMJOnF089987;
        Tue, 28 Apr 2020 22:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dnjIbyq47rawfRaNYamT9WPNZCpRqDwRtPKdypjUSmU=;
 b=njVkC7XJz/83i64Gj85OIGPF1D/K9uH1c9su7jNxVm01nB9ncUkuLLtMf8CPAiuTDOF+
 QAYpf0npyNz+QnepAc+izNAUb5JWPUEbbWPsUIs532VYLpJo/1zWT/Ue5ZAjAUACV+WT
 d6uLzRelTq7ON/lodgA2GjerUlCOat23H/TU5ORhP1/GdMVIcCD9V9fAtr1xu5nDyztY
 qKoi3DJmpLUkJ2jXNckiT4Ug00mPn8D0Q/IsMiyPRj269/M4txiqEqjOlPx/co0qy6WA
 A5KJFoCR4ghzt3jqSc1dL1DhLZbp0vAj5zCbHXNru0bw/nIhs/Tgu8Nuehn/g40Eyhm4 lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01ns6uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:23:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMN2Qf127320;
        Tue, 28 Apr 2020 22:23:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30my0ekmy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:23:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SMMmSh022418;
        Tue, 28 Apr 2020 22:22:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:22:48 -0700
Date:   Tue, 28 Apr 2020 15:22:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: reduce log recovery transaction block
 reservations
Message-ID: <20200428222247.GI6742@magnolia>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130035.2142108.11825776210575708747.stgit@magnolia>
 <20200424140408.GE53690@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424140408.GE53690@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=2 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 24, 2020 at 10:04:08AM -0400, Brian Foster wrote:
> On Tue, Apr 21, 2020 at 07:08:20PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > On filesystems that support them, bmap intent log items can be used to
> > change mappings in inode data or attr forks.  However, if the bmbt must
> > expand, the enormous block reservations that we make for finishing
> > chains of deferred log items become a liability because the bmbt block
> > allocator sets minleft to the transaction reservation and there probably
> > aren't any AGs in the filesystem that have that much free space.
> > 
> > Whereas previously we would reserve 93% of the free blocks in the
> > filesystem, now we only want to reserve 7/8ths of the free space in the
> > least full AG, and no more than half of the usable blocks in an AG.  In
> > theory we shouldn't run out of space because (prior to the unclean
> > shutdown) all of the in-progress transactions successfully reserved the
> > worst case number of disk blocks.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_log_recover.c |   55 ++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 43 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index e9b3e901d009..a416b028b320 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2669,6 +2669,44 @@ xlog_recover_process_data(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Estimate a block reservation for a log recovery transaction.  Since we run
> > + * separate transactions for each chain of deferred ops that get created as a
> > + * result of recovering unfinished log intent items, we must be careful not to
> > + * reserve so many blocks that block allocations fail because we can't satisfy
> > + * the minleft requirements (e.g. for bmbt blocks).
> > + */
> > +static int
> > +xlog_estimate_recovery_resblks(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		*resblks)
> > +{
> > +	struct xfs_perag	*pag;
> > +	xfs_agnumber_t		agno;
> > +	unsigned int		free = 0;
> > +	int			error;
> > +
> > +	/* Don't use more than 7/8th of the free space in the least full AG. */
> > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > +		unsigned int	ag_free;
> > +
> > +		error = xfs_alloc_pagf_init(mp, NULL, agno, 0);
> > +		if (error)
> > +			return error;
> > +		pag = xfs_perag_get(mp, agno);
> > +		ag_free = pag->pagf_freeblks + pag->pagf_flcount;
> > +		free = max(free, (ag_free * 7) / 8);
> > +		xfs_perag_put(pag);
> > +	}
> > +
> 
> Somewhat unfortunate that we have to iterate all AGs for each chain. I'm
> wondering if that has any effect on a large recovery on fs' with an
> inordinate AG count. Have you tested under those particular conditions?
> I suppose it's possible the recovery is slow enough that this won't
> matter...

I admit I haven't actually looked at that.  A more precise way to handle
this would be for each intent recovery function to store its own worst
case resblks estimation in the recovery freezer so that we'd be using
roughly the same space requirements as the pre-crash transaction, but
that's also a lot more complicated than this kludge.

> Also, perhaps not caused by this patch but does this
> outsized/manufactured reservation have the effect of artificially
> steering allocations to a particular AG if one happens to be notably
> larger than the rest?

It tends to steer allocations towards whichever AGs were less full at
the start of each transaction.  Were we to shift to scanning the AGs
once for the entire recovery cycle, I think I'd probably pick a smaller
ratio.

--D

> Brian
> 
> > +	/* Don't try to reserve more than half the usable AG blocks. */
> > +	*resblks = min(free, xfs_alloc_ag_max_usable(mp) / 2);
> > +	if (*resblks == 0)
> > +		return -ENOSPC;
> > +
> > +	return 0;
> > +}
> > +
> >  /* Take all the collected deferred ops and finish them in order. */
> >  static int
> >  xlog_finish_defer_ops(
> > @@ -2677,27 +2715,20 @@ xlog_finish_defer_ops(
> >  {
> >  	struct xfs_defer_freezer *dff, *next;
> >  	struct xfs_trans	*tp;
> > -	int64_t			freeblks;
> >  	uint			resblks;
> >  	int			error = 0;
> >  
> >  	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
> > +		error = xlog_estimate_recovery_resblks(mp, &resblks);
> > +		if (error)
> > +			break;
> > +
> >  		/*
> >  		 * We're finishing the defer_ops that accumulated as a result
> >  		 * of recovering unfinished intent items during log recovery.
> >  		 * We reserve an itruncate transaction because it is the
> > -		 * largest permanent transaction type.  Since we're the only
> > -		 * user of the fs right now, take 93% (15/16) of the available
> > -		 * free blocks.  Use weird math to avoid a 64-bit division.
> > +		 * largest permanent transaction type.
> >  		 */
> > -		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> > -		if (freeblks <= 0) {
> > -			error = -ENOSPC;
> > -			break;
> > -		}
> > -
> > -		resblks = min_t(int64_t, UINT_MAX, freeblks);
> > -		resblks = (resblks * 15) >> 4;
> >  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> >  				0, XFS_TRANS_RESERVE, &tp);
> >  		if (error)
> > 
> 
