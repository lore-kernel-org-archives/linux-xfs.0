Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2162C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 15:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A10D422B47
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 15:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgLIPwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 10:52:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728561AbgLIPwE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 10:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607529037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CkRBQsa+/VvOhI1Lb3arQOLR7e6J1EAouM101Lj0XOQ=;
        b=XekSPsvVm4zt74LwqPazxGzgEkpgE6LBQ9v43wCMWQhmAILEDNyKoUun4zaDZVFx2mshBb
        r1SyvpAGENjquRmcgZm3kepSyJyDq8RLst/AxmOtSlxZ8MD0fNPWpjuTNL8QMbQ16Nrfw4
        mHsnOA++wj0dqZIs9z/JYtj5VoiYqEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-EQyw53y7O12Wv2CBKQNsmw-1; Wed, 09 Dec 2020 10:50:35 -0500
X-MC-Unique: EQyw53y7O12Wv2CBKQNsmw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D733E8F1DE1;
        Wed,  9 Dec 2020 15:50:27 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FD7C60BF1;
        Wed,  9 Dec 2020 15:50:27 +0000 (UTC)
Date:   Wed, 9 Dec 2020 10:50:25 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201209155025.GA1860561@bfoster>
References: <20201208004028.GU629293@magnolia>
 <20201208111906.GA1679681@bfoster>
 <20201208181027.GB1943235@magnolia>
 <20201208191913.GB1685621@bfoster>
 <20201209032624.GH1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209032624.GH1943235@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 07:26:24PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 08, 2020 at 02:19:13PM -0500, Brian Foster wrote:
> > On Tue, Dec 08, 2020 at 10:10:27AM -0800, Darrick J. Wong wrote:
> > > On Tue, Dec 08, 2020 at 06:19:06AM -0500, Brian Foster wrote:
> > > > On Mon, Dec 07, 2020 at 04:40:28PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Log incompat feature flags in the superblock exist for one purpose: to
> > > > > protect the contents of a dirty log from replay on a kernel that isn't
> > > > > prepared to handle those dirty contents.  This means that they can be
> > > > > cleared if (a) we know the log is clean and (b) we know that there
> > > > > aren't any other threads in the system that might be setting or relying
> > > > > upon a log incompat flag.
> > > > > 
> > > > > Therefore, clear the log incompat flags when we've finished recovering
> > > > > the log, when we're unmounting cleanly, remounting read-only, or
> > > > > freezing; and provide a function so that subsequent patches can start
> > > > > using this.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > > Note: I wrote this so that we could turn on log incompat flags for
> > > > > atomic extent swapping and Allison could probably use it for the delayed
> > > > > logged xattr patchset.  Not gonna try to land this in 5.11, FWIW...
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_format.h |   15 ++++++
> > > > >  fs/xfs/xfs_log.c           |    8 +++
> > > > >  fs/xfs/xfs_mount.c         |  119 ++++++++++++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/xfs_mount.h         |    2 +
> > > > >  fs/xfs/xfs_super.c         |    9 +++
> > > > >  5 files changed, 153 insertions(+)
> > > > > 
> > > > ...
> > > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > > index 669a9cf43582..68a5c90ec65b 100644
> > > > > --- a/fs/xfs/xfs_mount.c
> > > > > +++ b/fs/xfs/xfs_mount.c
> > > > ...
> > > > > @@ -1361,6 +1369,117 @@ xfs_force_summary_recalc(
> > > > >  	xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
> > > > >  }
> > > > >  
> > > > > +/*
> > > > > + * Enable a log incompat feature flag in the primary superblock.  The caller
> > > > > + * cannot have any other transactions in progress.
> > > > > + */
> > > > > +int
> > > > > +xfs_add_incompat_log_feature(
> > > > > +	struct xfs_mount	*mp,
> > > > > +	uint32_t		feature)
> > > > > +{
> > > > > +	struct xfs_dsb		*dsb;
> > > > > +	int			error;
> > > > > +
> > > > > +	ASSERT(hweight32(feature) == 1);
> > > > > +	ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
> > > > > +
> > > > > +	/*
> > > > > +	 * Force the log to disk and kick the background AIL thread to reduce
> > > > > +	 * the chances that the bwrite will stall waiting for the AIL to unpin
> > > > > +	 * the primary superblock buffer.  This isn't a data integrity
> > > > > +	 * operation, so we don't need a synchronous push.
> > > > > +	 */
> > > > > +	error = xfs_log_force(mp, XFS_LOG_SYNC);
> > > > > +	if (error)
> > > > > +		return error;
> > > > > +	xfs_ail_push_all(mp->m_ail);
> > > > > +
> > > > > +	/*
> > > > > +	 * Lock the primary superblock buffer to serialize all callers that
> > > > > +	 * are trying to set feature bits.
> > > > > +	 */
> > > > > +	xfs_buf_lock(mp->m_sb_bp);
> > > > > +	xfs_buf_hold(mp->m_sb_bp);
> > > > > +
> > > > > +	if (XFS_FORCED_SHUTDOWN(mp)) {
> > > > > +		error = -EIO;
> > > > > +		goto rele;
> > > > > +	}
> > > > > +
> > > > > +	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
> > > > > +		goto rele;
> > > > > +
> > > > > +	/*
> > > > > +	 * Write the primary superblock to disk immediately, because we need
> > > > > +	 * the log_incompat bit to be set in the primary super now to protect
> > > > > +	 * the log items that we're going to commit later.
> > > > > +	 */
> > > > > +	dsb = mp->m_sb_bp->b_addr;
> > > > > +	xfs_sb_to_disk(dsb, &mp->m_sb);
> > > > > +	dsb->sb_features_log_incompat |= cpu_to_be32(feature);
> > > > > +	error = xfs_bwrite(mp->m_sb_bp);
> > > > > +	if (error)
> > > > > +		goto shutdown;
> > > > > +
> > > > 
> > > > Do we need to do all of this serialization and whatnot to set the
> > > > incompat bit? Can we just modify and log the in-core sb when or before
> > > > an incompatible item is logged, similar to how xfs_sbversion_add_attr2()
> > > > is implemented for example?
> > > 
> > > Hm.  The goal here is to ensure that the primary super gets updated
> > > before anything starts logging the protected log items.
> > > 
> > 
> > Ah, right. We can't just dump the change in the log and go because if we
> > crash at that point, an older kernel might not see the superblock update
> > and try to recover subsequent incompat items. I'll have to take another
> > look at the code with your description below in mind to try and wrap my
> > head around that.
> > 
> > Quick thought in the meantime... have you given any thought toward
> > trying to simplify the serialization requirements by perhaps doing the
> > set/clear of the log incompat bits from already isolated contexts? For
> > example, if the filesystem supports some featureX, just set the
> > associated log incompat bit at mount time (before any user transactions
> > can run) and clear it as a final step on clean unmount.
> 
> I don't want to set the log incompat bit until we're actually going to
> use the protected functionality, because setting it at mount time
> unconditionally means that older kernels cannot recover the log.
> 

True, but we're susceptible to that anyways if we don't ever clear the
bit until explicit quiesce (i.e. unmount/freeze). Even if we adopted a
log idle feature bit clearing hook, there's no guarantee the filesystem
will idle between the time incompat items are out of the log and a crash
occurs. ISTM that the only way to truly meet that requirement is to also
clear the feature bit when the last incompat log item falls off the tail
of the log, which really doesn't seem worth the complexity.

I guess this is more of a question of requirements. Is it necessary to
define the requirement as "dirty logs generated by this kernel may be
unrecoverable on older kernels if incompat log items are present in the
active range?" Is it acceptable to alternatively define it as "dirty
logs generated by this kernel must be recovered by a kernel with
equivalent feature support?"

The former is certainly possible, but as noted above I'm skeptical we'd
actually achieve that level of flexibility. There may also be log write
error -> shutdown (or log recovery error) scenarios where things might
be inconsistent. It might be fine from an implementation/correctness
standpoint to have cases where the bit is set but said items hadn't made
it to the log, but if we have to accept that situation anyways, I do
wonder whether the requirements are unnecessarily strict.

The latter option seems quite reasonable to me. I'm not sure a user is
going to know or care enough about whether a dirty log actually has
resident incompat log items unless there is some extremely clear high
level feature association (where I suspect we'd more likely have a
regular incompat feature bit anyways). I suppose it might also depend on
how the bits are used. Do we have use cases where the difference between
setting the incompat state conditionally or unconditionally is
significant?

Brian

> > > The first iteration of this patch simply updated the incore superblock
> > > and called xfs_sync_sb(mp, true) to flush it out to the primary super.
> > > This proved to be the source of log livelocks because that function
> > > bholds the primary super and pushes the log and AIL, which sometimes
> > > stalled out because the AIL can't get the lock on the primary super
> > > buffer.
> > > 
> > > The second version did the bare bwrite, but suffered from the
> > > xfs_buf_lock occasionally stalling for 30s while waiting for a log flush
> > > or something.  This third version forces the log and pushes the AIL
> > > prior to adding the feature bit to speed things up.  There's a small
> > > window between the xfs_buf_relse and the end of xfs_sync_sb where
> > > another thread could start logging items before we add the super update
> > > to the log stream, but the bwrite is supposed to cover that case. :)
> > > 
> > > The difficulty here is that any other threads that think they might need
> > > to set the log_incompat bit have to be held off until this thread
> > > confirms that the primary super has been updated on disk, because the
> > > three outcomes we want here are (a) feature already set, just go; (b)
> > > feature not set, but by the time you get the locks it's already taken
> > > care of; or (c) feature not set, and you get to do all the updates.
> > > 
> > > We can't do that with the primary super buffer lock alone (because we
> > > can't bhold it and push the AIL at the same time) but I guess I could
> > > just add a "feature update" mutex into the mix.
> > > 
> > > > > +	/*
> > > > > +	 * Add the feature bits to the incore superblock before we unlock the
> > > > > +	 * buffer.
> > > > > +	 */
> > > > > +	xfs_sb_add_incompat_log_features(&mp->m_sb, feature);
> > > > > +	xfs_buf_relse(mp->m_sb_bp);
> > > > > +
> > > > > +	/* Log the superblock to disk. */
> > > > > +	return xfs_sync_sb(mp, false);
> > > > > +shutdown:
> > > > > +	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> > > > > +rele:
> > > > > +	xfs_buf_relse(mp->m_sb_bp);
> > > > > +	return error;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Clear all the log incompat flags from the superblock.
> > > > > + *
> > > > > + * The caller must have freeze protection, cannot have any other transactions
> > > > > + * in progress, must ensure that the log does not contain any log items
> > > > > + * protected by any log incompat bit, and must ensure that there are no other
> > > > > + * threads that could be reading or writing the log incompat feature flag in
> > > > > + * the primary super.  In other words, we can only turn features off as one of
> > > > > + * the final steps of quiescing or unmounting the log.
> > > > > + */
> > > > > +int
> > > > > +xfs_clear_incompat_log_features(
> > > > > +	struct xfs_mount	*mp)
> > > > > +{
> > > > > +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> > > > > +	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
> > > > > +				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
> > > > > +	    XFS_FORCED_SHUTDOWN(mp))
> > > > > +		return 0;
> > > > > +
> > > > > +	/*
> > > > > +	 * Update the incore superblock.  We synchronize on the primary super
> > > > > +	 * buffer lock to be consistent with the add function, though at least
> > > > > +	 * in theory this shouldn't be necessary.
> > > > > +	 */
> > > > > +	xfs_buf_lock(mp->m_sb_bp);
> > > > > +	xfs_buf_hold(mp->m_sb_bp);
> > > > > +
> > > > > +	if (!xfs_sb_has_incompat_log_feature(&mp->m_sb,
> > > > > +				XFS_SB_FEAT_INCOMPAT_LOG_ALL))
> > > > > +		goto rele;
> > > > > +
> > > > > +	xfs_sb_remove_incompat_log_features(&mp->m_sb);
> > > > > +	xfs_buf_relse(mp->m_sb_bp);
> > > > > +
> > > > > +	/* Log the superblock to disk. */
> > > > > +	return xfs_sync_sb(mp, false);
> > > > 
> > > > Ok, so here it looks like we log the superblock change and presumably
> > > > rely on the unmount sequence to write it back...
> > > > 
> > > > > +rele:
> > > > > +	xfs_buf_relse(mp->m_sb_bp);
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >  /*
> > > > >   * Update the in-core delayed block counter.
> > > > >   *
> > > > ...
> > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > index 343435a677f9..71e304c15e6b 100644
> > > > > --- a/fs/xfs/xfs_super.c
> > > > > +++ b/fs/xfs/xfs_super.c
> > > > > @@ -919,6 +919,15 @@ xfs_quiesce_attr(
> > > > >  	/* force the log to unpin objects from the now complete transactions */
> > > > >  	xfs_log_force(mp, XFS_LOG_SYNC);
> > > > >  
> > > > > +	/*
> > > > > +	 * Clear log incompat features since we're freezing or remounting ro.
> > > > > +	 * Report failures, though it's not fatal to have a higher log feature
> > > > > +	 * protection level than the log contents actually require.
> > > > > +	 */
> > > > > +	error = xfs_clear_incompat_log_features(mp);
> > > > > +	if (error)
> > > > > +		xfs_warn(mp, "Unable to clear superblock log incompat flags. "
> > > > > +				"Frozen image may not be consistent.");
> > > > >  
> > > > 
> > > > What happens if the modified superblock is written back and then we
> > > > crash during a quiesce but before the log is fully clean? ISTM we could
> > > > end up in recovery of a log with potentially incompatible log items
> > > > where the feature bit has already been cleared. Not sure that's a
> > > > problem with intents, but seems risky in general.
> > > 
> > > I think you're right that this isn't generally correct.  It works for
> > > intent items because those are all started by front end callers and
> > > those are guaranteed not to be running transactions by the time we get
> > > to xfs_quiesce_attr... but that wouldn't necessarily hold true for other
> > > types of log items that we could create.
> > > 
> > > > Perhaps this needs to be pushed further down such that similar to
> > > > unmount, we ensure a full/sync AIL push completes (and moves the in-core
> > > > tail) before we log the feature bit change. I do wonder if it's worth
> > > > complicating the log quiesce path to clear feature bits at all, but I
> > > > suppose it could be a little inconsistent to clean the log on freeze yet
> > > > leave an incompat bit around. Perhaps we should push the clear bit
> > > > sequence down into the log quiesce path between completing the AIL push
> > > > and writing the unmount record. We may have to commit a sync transaction
> > > > and then push the AIL again, but that would cover the unmount and freeze
> > > > cases and I think we could probably do away with the post-recovery bit
> > > > clearing case entirely. A current/recovered mount should clear the
> > > > associated bits on the next log quiesce anyways. Hm?
> > > 
> > > Hm.  You know how xfs_log_quiesce takes and releases the superblock
> > > buffer lock after pushing the AIL but before writing the unmount record?
> > > What if we did the log_incompat feature clearing + bwrite right after
> > > that?
> > > 
> > 
> > Yeah, that's where I was thinking for the unmount side. I'm not sure we
> > want to just bwrite there vs. log+push though. Otherwise, I think
> > there's still a window of potential inconsistency between when the
> > superblock write completes and the unmount record lands on disk. I
> > _think_ the whole log force -> AIL push (i.e. move log tail) -> update
> > super -> log force -> AIL push sequence ensures that if an older kernel
> > saw the updated super, the log would technically be dirty but we'd at
> > least be sure that all incompat log items are behind the tail.
> > Alternatively, I guess we could do a sync sb write after the unmount
> > record and we'd just risk that a clean unmount wouldn't clear the
> > feature bit if the write failed, which might not be so bad. Hmm...
> 
> Hm.  That would work too I think.
> 
> --D
> 
> > 
> > Brian
> > 
> > > --D
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > >  	/* Push the superblock and write an unmount record */
> > > > >  	error = xfs_log_sbcount(mp);
> > > > > 
> > > > 
> > > 
> > 
> 

