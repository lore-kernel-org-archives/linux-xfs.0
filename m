Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD24C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 18:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9269E23B54
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 18:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730826AbgLHSLP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 13:11:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56514 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730468AbgLHSLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 13:11:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8I5IFE161176;
        Tue, 8 Dec 2020 18:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IAZP48w+F6Kkw2P9Qq/m2ctlpYt2c3iCMWevxrtFsA0=;
 b=QiowGVVzjjvLm2Rl+/c80a+evVeHR92KeEmaVKeK6jewOt5wvgDIbs/HhdyfT7VyKYa2
 f9mtkkGMm29XJruRfd89Aos6kFDrpNGlUEr//8Nqx9zLC29ggRBNOwJ4uo+9Q38HULZX
 qfoA1ybYhAJYQAUt3q8lHnJWBisKkV/r3nEn4LQWm7c/g7hKTlaNlgjzHRZEoneJh/R8
 9JlksTwKdO8HVc19BeAEKKKuw7MlJ0sfaHZ02pr0+Qrfh/UQude6I5k+Frn6l+AcymaT
 WuHHmZNgKYuY6g6rFggglFy4wo7QpaLHokKtW0tmFXC0dGyGYLdhQ6LwMCJqmNiJQ7LY ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825m47x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 18:10:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8I6U2x132643;
        Tue, 8 Dec 2020 18:10:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 358m3y3t4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 18:10:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B8IASO9022447;
        Tue, 8 Dec 2020 18:10:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 10:10:27 -0800
Date:   Tue, 8 Dec 2020 10:10:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201208181027.GB1943235@magnolia>
References: <20201208004028.GU629293@magnolia>
 <20201208111906.GA1679681@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208111906.GA1679681@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080112
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 06:19:06AM -0500, Brian Foster wrote:
> On Mon, Dec 07, 2020 at 04:40:28PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Log incompat feature flags in the superblock exist for one purpose: to
> > protect the contents of a dirty log from replay on a kernel that isn't
> > prepared to handle those dirty contents.  This means that they can be
> > cleared if (a) we know the log is clean and (b) we know that there
> > aren't any other threads in the system that might be setting or relying
> > upon a log incompat flag.
> > 
> > Therefore, clear the log incompat flags when we've finished recovering
> > the log, when we're unmounting cleanly, remounting read-only, or
> > freezing; and provide a function so that subsequent patches can start
> > using this.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > Note: I wrote this so that we could turn on log incompat flags for
> > atomic extent swapping and Allison could probably use it for the delayed
> > logged xattr patchset.  Not gonna try to land this in 5.11, FWIW...
> > ---
> >  fs/xfs/libxfs/xfs_format.h |   15 ++++++
> >  fs/xfs/xfs_log.c           |    8 +++
> >  fs/xfs/xfs_mount.c         |  119 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_mount.h         |    2 +
> >  fs/xfs/xfs_super.c         |    9 +++
> >  5 files changed, 153 insertions(+)
> > 
> ...
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 669a9cf43582..68a5c90ec65b 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> ...
> > @@ -1361,6 +1369,117 @@ xfs_force_summary_recalc(
> >  	xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
> >  }
> >  
> > +/*
> > + * Enable a log incompat feature flag in the primary superblock.  The caller
> > + * cannot have any other transactions in progress.
> > + */
> > +int
> > +xfs_add_incompat_log_feature(
> > +	struct xfs_mount	*mp,
> > +	uint32_t		feature)
> > +{
> > +	struct xfs_dsb		*dsb;
> > +	int			error;
> > +
> > +	ASSERT(hweight32(feature) == 1);
> > +	ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
> > +
> > +	/*
> > +	 * Force the log to disk and kick the background AIL thread to reduce
> > +	 * the chances that the bwrite will stall waiting for the AIL to unpin
> > +	 * the primary superblock buffer.  This isn't a data integrity
> > +	 * operation, so we don't need a synchronous push.
> > +	 */
> > +	error = xfs_log_force(mp, XFS_LOG_SYNC);
> > +	if (error)
> > +		return error;
> > +	xfs_ail_push_all(mp->m_ail);
> > +
> > +	/*
> > +	 * Lock the primary superblock buffer to serialize all callers that
> > +	 * are trying to set feature bits.
> > +	 */
> > +	xfs_buf_lock(mp->m_sb_bp);
> > +	xfs_buf_hold(mp->m_sb_bp);
> > +
> > +	if (XFS_FORCED_SHUTDOWN(mp)) {
> > +		error = -EIO;
> > +		goto rele;
> > +	}
> > +
> > +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
> > +		goto rele;
> > +
> > +	/*
> > +	 * Write the primary superblock to disk immediately, because we need
> > +	 * the log_incompat bit to be set in the primary super now to protect
> > +	 * the log items that we're going to commit later.
> > +	 */
> > +	dsb = mp->m_sb_bp->b_addr;
> > +	xfs_sb_to_disk(dsb, &mp->m_sb);
> > +	dsb->sb_features_log_incompat |= cpu_to_be32(feature);
> > +	error = xfs_bwrite(mp->m_sb_bp);
> > +	if (error)
> > +		goto shutdown;
> > +
> 
> Do we need to do all of this serialization and whatnot to set the
> incompat bit? Can we just modify and log the in-core sb when or before
> an incompatible item is logged, similar to how xfs_sbversion_add_attr2()
> is implemented for example?

Hm.  The goal here is to ensure that the primary super gets updated
before anything starts logging the protected log items.

The first iteration of this patch simply updated the incore superblock
and called xfs_sync_sb(mp, true) to flush it out to the primary super.
This proved to be the source of log livelocks because that function
bholds the primary super and pushes the log and AIL, which sometimes
stalled out because the AIL can't get the lock on the primary super
buffer.

The second version did the bare bwrite, but suffered from the
xfs_buf_lock occasionally stalling for 30s while waiting for a log flush
or something.  This third version forces the log and pushes the AIL
prior to adding the feature bit to speed things up.  There's a small
window between the xfs_buf_relse and the end of xfs_sync_sb where
another thread could start logging items before we add the super update
to the log stream, but the bwrite is supposed to cover that case. :)

The difficulty here is that any other threads that think they might need
to set the log_incompat bit have to be held off until this thread
confirms that the primary super has been updated on disk, because the
three outcomes we want here are (a) feature already set, just go; (b)
feature not set, but by the time you get the locks it's already taken
care of; or (c) feature not set, and you get to do all the updates.

We can't do that with the primary super buffer lock alone (because we
can't bhold it and push the AIL at the same time) but I guess I could
just add a "feature update" mutex into the mix.

> > +	/*
> > +	 * Add the feature bits to the incore superblock before we unlock the
> > +	 * buffer.
> > +	 */
> > +	xfs_sb_add_incompat_log_features(&mp->m_sb, feature);
> > +	xfs_buf_relse(mp->m_sb_bp);
> > +
> > +	/* Log the superblock to disk. */
> > +	return xfs_sync_sb(mp, false);
> > +shutdown:
> > +	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> > +rele:
> > +	xfs_buf_relse(mp->m_sb_bp);
> > +	return error;
> > +}
> > +
> > +/*
> > + * Clear all the log incompat flags from the superblock.
> > + *
> > + * The caller must have freeze protection, cannot have any other transactions
> > + * in progress, must ensure that the log does not contain any log items
> > + * protected by any log incompat bit, and must ensure that there are no other
> > + * threads that could be reading or writing the log incompat feature flag in
> > + * the primary super.  In other words, we can only turn features off as one of
> > + * the final steps of quiescing or unmounting the log.
> > + */
> > +int
> > +xfs_clear_incompat_log_features(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> > +	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
> > +				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
> > +	    XFS_FORCED_SHUTDOWN(mp))
> > +		return 0;
> > +
> > +	/*
> > +	 * Update the incore superblock.  We synchronize on the primary super
> > +	 * buffer lock to be consistent with the add function, though at least
> > +	 * in theory this shouldn't be necessary.
> > +	 */
> > +	xfs_buf_lock(mp->m_sb_bp);
> > +	xfs_buf_hold(mp->m_sb_bp);
> > +
> > +	if (!xfs_sb_has_incompat_log_feature(&mp->m_sb,
> > +				XFS_SB_FEAT_INCOMPAT_LOG_ALL))
> > +		goto rele;
> > +
> > +	xfs_sb_remove_incompat_log_features(&mp->m_sb);
> > +	xfs_buf_relse(mp->m_sb_bp);
> > +
> > +	/* Log the superblock to disk. */
> > +	return xfs_sync_sb(mp, false);
> 
> Ok, so here it looks like we log the superblock change and presumably
> rely on the unmount sequence to write it back...
> 
> > +rele:
> > +	xfs_buf_relse(mp->m_sb_bp);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Update the in-core delayed block counter.
> >   *
> ...
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 343435a677f9..71e304c15e6b 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -919,6 +919,15 @@ xfs_quiesce_attr(
> >  	/* force the log to unpin objects from the now complete transactions */
> >  	xfs_log_force(mp, XFS_LOG_SYNC);
> >  
> > +	/*
> > +	 * Clear log incompat features since we're freezing or remounting ro.
> > +	 * Report failures, though it's not fatal to have a higher log feature
> > +	 * protection level than the log contents actually require.
> > +	 */
> > +	error = xfs_clear_incompat_log_features(mp);
> > +	if (error)
> > +		xfs_warn(mp, "Unable to clear superblock log incompat flags. "
> > +				"Frozen image may not be consistent.");
> >  
> 
> What happens if the modified superblock is written back and then we
> crash during a quiesce but before the log is fully clean? ISTM we could
> end up in recovery of a log with potentially incompatible log items
> where the feature bit has already been cleared. Not sure that's a
> problem with intents, but seems risky in general.

I think you're right that this isn't generally correct.  It works for
intent items because those are all started by front end callers and
those are guaranteed not to be running transactions by the time we get
to xfs_quiesce_attr... but that wouldn't necessarily hold true for other
types of log items that we could create.

> Perhaps this needs to be pushed further down such that similar to
> unmount, we ensure a full/sync AIL push completes (and moves the in-core
> tail) before we log the feature bit change. I do wonder if it's worth
> complicating the log quiesce path to clear feature bits at all, but I
> suppose it could be a little inconsistent to clean the log on freeze yet
> leave an incompat bit around. Perhaps we should push the clear bit
> sequence down into the log quiesce path between completing the AIL push
> and writing the unmount record. We may have to commit a sync transaction
> and then push the AIL again, but that would cover the unmount and freeze
> cases and I think we could probably do away with the post-recovery bit
> clearing case entirely. A current/recovered mount should clear the
> associated bits on the next log quiesce anyways. Hm?

Hm.  You know how xfs_log_quiesce takes and releases the superblock
buffer lock after pushing the AIL but before writing the unmount record?
What if we did the log_incompat feature clearing + bwrite right after
that?

--D

> 
> Brian
> 
> >  	/* Push the superblock and write an unmount record */
> >  	error = xfs_log_sbcount(mp);
> > 
> 
