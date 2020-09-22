Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6E9C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B7DB239D2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h8/+9Y12"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIVPva (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:51:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgIVPv3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 11:51:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFmfEB145637;
        Tue, 22 Sep 2020 15:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=S0Dd7mAQDHyk7rm/0KV8wPg1wQKiCMOycSw+PLSG91s=;
 b=h8/+9Y12/mxGxZHKuydru0hppBcQxBVVGbr4f2W9iFBa/fPqaNmdYL6FC8YaMUPkWOnH
 a+fY8jcJpRM9rn5V7HjG92e2zTr3vbkbnNJ44Dt0HEeKqQZnIhbql2XFWyvlJtTdHHiU
 Y7IL5bsfg6xUYlHPXXgT8hSdk1clzhw096CWQBP9+Atn3zKtKbY2gOZb8+XUpn29b2pb
 yvq1AxKgitxP74PK9TEC8WMXLCscsbnsg466/HN4hfBNCcvxVLURSeJ/tfxRhDwS3ant
 LWNaFN4AD0ekZku9toTlTc82NVlJB4mjM7Ks4gqcSG0ptVcE03YnD8k0s7VtaNj8D2wW 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnudp65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 15:51:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFnsQq004812;
        Tue, 22 Sep 2020 15:51:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33nuw48qwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 15:51:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MFpN10003533;
        Tue, 22 Sep 2020 15:51:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 08:51:22 -0700
Date:   Tue, 22 Sep 2020 08:51:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: use the log grant push threshold to decide if
 we're going to relog deferred items
Message-ID: <20200922155122.GF7955@magnolia>
References: <160031338724.3624707.1335084348340671147.stgit@magnolia>
 <160031340936.3624707.125940597283537162.stgit@magnolia>
 <20200917152829.GC1874815@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917152829.GC1874815@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=5 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=5 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220122
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 11:28:29AM -0400, Brian Foster wrote:
> On Wed, Sep 16, 2020 at 08:30:09PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we've landed a means for the defer ops manager to ask log items
> > to relog themselves to move the log tail forward, we can improve how we
> > decide when to relog so that we're not just using an arbitrary hardcoded
> > value.
> > 
> > The XFS log has "push threshold", which tells us how far we'd have to
> > move the log tail forward to keep 25% of the ondisk log space available.
> > We use this threshold to decide when to force defer ops chains to relog
> > themselves.  This avoids unnecessary relogging (which adds extra steps
> > to metadata updates) while helping us to avoid pinning the tail.
> > 
> > A better algorithm would be to relog only when we detect that the time
> > required to move the tail forward is greater than the time remaining
> > before all the log space gets used up, but letting the upper levels
> > drive the relogging means that it is difficult to coordinate relogging
> > the lowest LSN'd intents first.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> FYI, the commit log doesn't match the git branch referenced in the cover
> letter.

> >  fs/xfs/libxfs/xfs_defer.c |   32 +++++++++++++++++++++++++-------
> >  fs/xfs/xfs_log.c          |   41 +++++++++++++++++++++++++++++++----------
> >  fs/xfs/xfs_log.h          |    2 ++
> >  3 files changed, 58 insertions(+), 17 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 7938e4d3af90..97ec36f32a0a 100644
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
> > @@ -372,15 +373,35 @@ xfs_defer_relog(
> >  	struct list_head		*dfops)
> >  {
> >  	struct xfs_defer_pending	*dfp;
> > +	xfs_lsn_t			threshold_lsn;
> >  
> >  	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> >  
> > +	/*
> > +	 * Figure out where we need the tail to be in order to maintain the
> > +	 * minimum required free space in the log.
> > +	 */
> > +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> > +	if (threshold_lsn == NULLCOMMITLSN)
> > +		return 0;
> > +
> >  	list_for_each_entry(dfp, dfops, dfp_list) {
> > +		/*
> > +		 * If the log intent item for this deferred op is behind the
> > +		 * threshold, we're running out of space and need to relog it
> > +		 * to release the tail.
> > +		 */
> > +		if (dfp->dfp_intent == NULL ||
> 
> Any reason the NULL check isn't in the previous patch?

No.  Now that I've squashed all these patches together, all the wonky
churn should be eliminated.

> > +		    XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) < 0)
> > +			continue;
> > +
> 
> Logic looks backwards, we should relog (not skip) if li_lsn is within
> the threshold, right?

Oops, fixed now.

> >  		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
> >  		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
> >  	}
> >  
> > -	return xfs_defer_trans_roll(tpp);
> > +	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
> > +		return xfs_defer_trans_roll(tpp);
> 
> I suspect this churn is eliminated if this code uses the threshold logic
> from the start..
> 
> > +	return 0;
> >  }
> >  
> >  /*
> > @@ -444,7 +465,6 @@ xfs_defer_finish_noroll(
> >  	struct xfs_trans		**tp)
> >  {
> >  	struct xfs_defer_pending	*dfp;
> > -	unsigned int			nr_rolls = 0;
> >  	int				error = 0;
> >  	LIST_HEAD(dop_pending);
> >  
> > @@ -471,11 +491,9 @@ xfs_defer_finish_noroll(
> >  			goto out_shutdown;
> >  
> >  		/* Every few rolls we relog all the intent items. */
> > -		if (!(++nr_rolls % 7)) {
> > -			error = xfs_defer_relog(tp, &dop_pending);
> > -			if (error)
> > -				goto out_shutdown;
> > -		}
> > +		error = xfs_defer_relog(tp, &dop_pending);
> > +		if (error)
> > +			goto out_shutdown;
> >  
> >  		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
> >  				       dfp_list);
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index ad0c69ee8947..62c9e0aaa7df 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1475,14 +1475,15 @@ xlog_commit_record(
> >  }
> >  
> >  /*
> > - * Push on the buffer cache code if we ever use more than 75% of the on-disk
> > - * log space.  This code pushes on the lsn which would supposedly free up
> > - * the 25% which we want to leave free.  We may need to adopt a policy which
> > - * pushes on an lsn which is further along in the log once we reach the high
> > - * water mark.  In this manner, we would be creating a low water mark.
> > + * Compute the LSN push target needed to push on the buffer cache code if we
> > + * ever use more than 75% of the on-disk log space.  This code pushes on the
> > + * lsn which would supposedly free up the 25% which we want to leave free.  We
> > + * may need to adopt a policy which pushes on an lsn which is further along in
> > + * the log once we reach the high water mark.  In this manner, we would be
> > + * creating a low water mark.
> >   */
> > -STATIC void
> > -xlog_grant_push_ail(
> > +xfs_lsn_t
> > +xlog_grant_push_threshold(
> >  	struct xlog	*log,
> >  	int		need_bytes)
> >  {
> > @@ -1508,7 +1509,7 @@ xlog_grant_push_ail(
> >  	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
> >  	free_threshold = max(free_threshold, 256);
> >  	if (free_blocks >= free_threshold)
> > -		return;
> > +		return NULLCOMMITLSN;
> >  
> >  	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
> >  						&threshold_block);
> > @@ -1528,13 +1529,33 @@ xlog_grant_push_ail(
> >  	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
> >  		threshold_lsn = last_sync_lsn;
> >  
> > +	return threshold_lsn;
> > +}
> > +
> > +/*
> > + * Push on the buffer cache code if we ever use more than 75% of the on-disk
> > + * log space.  This code pushes on the lsn which would supposedly free up
> > + * the 25% which we want to leave free.  We may need to adopt a policy which
> > + * pushes on an lsn which is further along in the log once we reach the high
> > + * water mark.  In this manner, we would be creating a low water mark.
> > + */
> > +STATIC void
> > +xlog_grant_push_ail(
> > +	struct xlog	*log,
> > +	int		need_bytes)
> > +{
> > +	xfs_lsn_t	threshold_lsn;
> > +
> > +	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
> > +	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
> > +		return;
> > +
> >  	/*
> >  	 * Get the transaction layer to kick the dirty buffers out to
> >  	 * disk asynchronously. No point in trying to do this if
> >  	 * the filesystem is shutting down.
> >  	 */
> > -	if (!XLOG_FORCED_SHUTDOWN(log))
> > -		xfs_ail_push(log->l_ailp, threshold_lsn);
> > +	xfs_ail_push(log->l_ailp, threshold_lsn);
> >  }
> 
> Separate refactoring patch for the xfs_log.c bits, please.

Ok, fixed.

--D

> Brian
> 
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> > index 1412d6993f1e..58c3fcbec94a 100644
> > --- a/fs/xfs/xfs_log.h
> > +++ b/fs/xfs/xfs_log.h
> > @@ -141,4 +141,6 @@ void	xfs_log_quiesce(struct xfs_mount *mp);
> >  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
> >  bool	xfs_log_in_recovery(struct xfs_mount *);
> >  
> > +xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
> > +
> >  #endif	/* __XFS_LOG_H__ */
> > 
> 
