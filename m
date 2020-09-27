Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265E6C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE27423A05
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:30:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zh6hjtvA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgI0Xac (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:30:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38420 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgI0Xac (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:30:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNUSbo075505;
        Sun, 27 Sep 2020 23:30:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=anD33kgmVOJTvRQ61/mGxbmtQu0RW0OtxbBdZRns6ms=;
 b=Zh6hjtvAbvQzMfRJrKCFd9+7MYzolfqlaRxYqCzReoGJMqeMqaeNktrOFrJFqltErDXz
 O9s3p3NzFxlnNxNsC2ZFaPpI9uDkpZ1+McKPgYoUtGiM6sc5xoQCHsgGpSOcYb0hY9Bo
 5TRLQIgjtCVICzQlxk200NqdvN6CQKdlkXGs1gqBKCb5VtTFQtvGW0OokacVodepsu1A
 go+gk116NeTkemlCgQAULjFLudEhPu1njOt4yKRIVtmgA2XCqfJXSc3BeSvynInBUvK6
 i6laNzfdmcbfCVdl+6CG80xkGbLM2WYrJkOoQHp/5GgEhKsuL1UmJAMWD9OgGOjfoSTS FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33su5ajm6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:30:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNTcV2155553;
        Sun, 27 Sep 2020 23:30:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33tfju3egf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:30:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08RNUQ8e006085;
        Sun, 27 Sep 2020 23:30:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:30:26 -0700
Date:   Sun, 27 Sep 2020 16:30:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: periodically relog deferred intent items
Message-ID: <20200927233025.GA49547@magnolia>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919968.1401135.1020138085396332868.stgit@magnolia>
 <20200927230823.GA14422@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927230823.GA14422@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270225
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270225
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 09:08:23AM +1000, Dave Chinner wrote:
> On Tue, Sep 22, 2020 at 10:33:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a subtle design flaw in the deferred log item code that can lead
> > to pinning the log tail.  Taking up the defer ops chain examples from
> > the previous commit, we can get trapped in sequences like this:
> > 
> > Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
> > chain will look like the following if the transaction rolls succeed:
> > 
> > t1: D0(t0), D1(t0), D2(t0), D3(t0)
> > t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
> > t3: d5(t1), D1(t0), D2(t0), D3(t0)
> > ...
> > t9: d9(t7), D3(t0)
> > t10: D3(t0)
> > t11: d10(t10), d11(t10)
> > t12: d11(t10)
> > 
> > In transaction 9, we finish d9 and try to roll to t10 while holding onto
> > an intent item for D3 that we logged in t0.
> > 
> > The previous commit changed the order in which we place new defer ops in
> > the defer ops processing chain to reduce the maximum chain length.  Now
> > make xfs_defer_finish_noroll capable of relogging the entire chain
> > periodically so that we can always move the log tail forward.  Most
> > chains will never get relogged, except for operations that generate very
> > long chains (large extents containing many blocks with different sharing
> > levels) or are on filesystems with small logs and a lot of ongoing
> > metadata updates.
> > 
> > Callers are now required to ensure that the transaction reservation is
> > large enough to handle logging done items and new intent items for the
> > maximum possible chain length.  Most callers are careful to keep the
> > chain lengths low, so the overhead should be minimal.
> > 
> > The decision to relog an intent item is made based on whether or not the
> > intent was added to the current checkpoint.  If so, the checkpoint is
> > still open and there's no point in relogging.  Otherwise, the old
> > checkpoint is closed and we relog the intent to add it to the current
> > one.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++
> >  fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_trace.h         |    1 +
> >  fs/xfs/xfs_trans.h         |   10 ++++++++
> >  7 files changed, 173 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 84a70edd0da1..c601cc2af254 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -17,6 +17,7 @@
> >  #include "xfs_inode_item.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> > +#include "xfs_log.h"
> >  
> >  /*
> >   * Deferred Operations in XFS
> > @@ -361,6 +362,52 @@ xfs_defer_cancel_list(
> >  	}
> >  }
> >  
> > +/*
> > + * Prevent a log intent item from pinning the tail of the log by logging a
> > + * done item to release the intent item; and then log a new intent item.
> > + * The caller should provide a fresh transaction and roll it after we're done.
> > + */
> > +static int
> > +xfs_defer_relog(
> > +	struct xfs_trans		**tpp,
> > +	struct list_head		*dfops)
> > +{
> > +	struct xfs_defer_pending	*dfp;
> > +	xfs_lsn_t			threshold_lsn;
> > +
> > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +
> > +	/*
> > +	 * Figure out where we need the tail to be in order to maintain the
> > +	 * minimum required free space in the log.
> > +	 */
> > +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> > +	if (threshold_lsn == NULLCOMMITLSN)
> > +		return 0;
> 
> This smells of premature optimisation.
> 
> When we are in a tail-pushing scenario (i.e. any sort of
> sustained metadata workload) this will always return true, and so we
> will relog every intent that isn't in the current checkpoint every
> time this is called.  Under light load, we don't care if we add a
> little bit of relogging overhead as the CIL slowly flushes/pushes -
> it will have neglible impact on performance because there is little
> load on the journal.
> 
> However, when we are under heavy load the code will now be reading
> the grant head and log position accounting variables during every
> commit, hence greatly increasing the number and temporal
> distribution of accesses to the hotest cachelines in the log. We
> currently never access these cache lines during commit unless the
> unit reservation has run out and we have to regrant physical log
> space for the transaction to continue (i.e. we are into slow path
> commit code). IOWs, this is like causing far more than double the
> number of accesses to the grant head, the log tail, the
> last_sync_lsn, etc, all of which is unnecessary exactly when we care
> about minimising contention on the log space accounting variables...
> 
> Given that it is a redundant check under heavy load journal load
> when access to the log grant/head/tail are already contended,
> I think we should just be checking the "in current checkpoint" logic
> and not making it conditional on the log being near full.

<nod> FWIW I broke this patch up again into the first part that
only does relogging if the checkpoints don't match, and a second part
that does the LSN push target check to see if I could observe any
difference.

Across a ~4h fstests run I noticed that there was about ~20% fewer
relogs, but OTOH the total runtime didn't change noticeably.  I kind of
wondered if the increased cacheline contention would at least slow down
the frontend a bit to give the log a chance to push things out, but
haven't had time to dig any further than "ran fstests, recorded runtimes
and grep | wc -l'd the ftrace log".

Anyway, I was about to resend with all these patches rebased against
something resembling the 5.10 branch, so expect to see this broken out a
bit.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
