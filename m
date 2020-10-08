Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBA1C43467
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 11:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F135A217BA
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 11:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LhBYMWcs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgJHL3j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 07:29:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726065AbgJHL3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 07:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602156576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aua9HPYfP8yZzHytmUbpZdQ43sv/apKrpB4m+rjtzx8=;
        b=LhBYMWcs7bg4mHgh55aEHylYQ2dyd3jsm/U+pMQN1j2+s5yTnDvWLi7ox3VjwN4YO5F01k
        N/iqMV6svaUHcIOGamXhpeUnR1Uy/fchsOqa5Qug9NFd2QqkKsB9pExjuuwxrQa8UknMpi
        VgE4+ZHkSB/DWvnIQ0U/TGhvVXZfg0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-BKN_Naw6OOiHY62sfmLBnA-1; Thu, 08 Oct 2020 07:29:34 -0400
X-MC-Unique: BKN_Naw6OOiHY62sfmLBnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2BBC18C9F46;
        Thu,  8 Oct 2020 11:29:33 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52B0F76655;
        Thu,  8 Oct 2020 11:29:33 +0000 (UTC)
Date:   Thu, 8 Oct 2020 07:29:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rework quotaoff logging to avoid log deadlock
 on active fs
Message-ID: <20201008112931.GB702156@bfoster>
References: <20201001150310.141467-1-bfoster@redhat.com>
 <20201001150310.141467-4-bfoster@redhat.com>
 <20201007222416.GG6540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007222416.GG6540@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 03:24:16PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 01, 2020 at 11:03:10AM -0400, Brian Foster wrote:
> > The quotaoff operation logs two log items. The start item is
> > committed first, followed by the bulk of the in-core quotaoff
> > processing, and then the quotaoff end item is committed to release
> > the start item from the log. The problem with this mechanism is that
> > quite a bit of processing can be required to release dquots from all
> > in-core inodes and subsequently flush/purge all dquots in the
> > system. This processing work doesn't generally generate much log
> > traffic itself, but the start item pins the tail of the log. If an
> > external workload consumes the remaining log space before the
> > transaction for the end item is allocated, a log deadlock can occur.
> > 
> > The purpose of the separate start and end log items is primarily to
> > ensure that log recovery does not incorrectly recover dquot data
> > after an fs crash where a quotaoff was in progress. If we only
> > logged a single quotaoff item, for example, it could fall behind the
> > tail of the log before the last dquot modification was made and
> > incorrectly replay dquot changes that might have occurred after the
> > start item committed but before quotaoff deactivated the quota.
> > 
> > With that context, we can make some small changes to the quotaoff
> > algorithm to provide the same general log ordering guarantee without
> > such a large window to create a log deadlock vector. Rather than
> > place a start item in the log for the duration of quotaoff
> > processing, we can quiesce the transaction subsystem up front to
> > guarantee that no further dquots are logged from that point forward.
> > IOW, we pause the transaction subsystem, commit the quotaoff start
> > and end items, deactivate the associated quota such that subsequent
> > transactions no longer modify associated dquots, and resume the
> > transaction subsystem. The transaction pause is somewhat of a heavy
> > weight operation, but quotaoff is already a rare, slow and
> > performance disruptive operation and the quiesce is only required
> > for two small transactions.
> > 
> > Altogether, this means that the dquot rele/purge sequence occurs
> > after the quotaoff end item has committed and thus can technically
> > fall off the end of the log. This is safe because the remaining
> > processing is in-core work that doesn't involve logging dquots and
> > we've guaranteed that no further dquots are modified by external
> > transactions. This allows quotaoff to complete without risking log
> > deadlock regardless of how much dquot processing is required.
> > 
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_qm_syscalls.c | 133 +++++++++++++++++++--------------------
> >  fs/xfs/xfs_trans_dquot.c |   2 +
> >  2 files changed, 67 insertions(+), 68 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index ca1b57d291dc..b8e55f4947bd 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
...
> > @@ -163,89 +162,87 @@ xfs_qm_scall_quotaoff(
> >  	}
> >  
> >  	/*
> > -	 * Nothing to do?  Don't complain. This happens when we're just
> > -	 * turning off quota enforcement.
> > +	 * Nothing to do? Don't complain. This happens when we're just turning
> > +	 * off quota enforcement.
> >  	 */
> >  	if ((mp->m_qflags & flags) == 0)
> >  		goto out_unlock;
> >  
> >  	/*
> > -	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
> > -	 * and synchronously. If we fail to write, we should abort the
> > -	 * operation as it cannot be recovered safely if we crash.
> > +	 * Quotaoff must deactivate the associated quota mode(s), release dquots
> > +	 * from inodes and purge them from the system all while the filesystem
> > +	 * remains active. We have two quotaoff log records that traditionally
> > +	 * bound the start and end of this sequence. This guarantees that no
> > +	 * dquots are modified after the end item hits the log, but quotaoff can
> > +	 * be time consuming and thus prone to deadlock because the start item
> > +	 * pins the tail the of log in the meantime (and we can't hold the end
> > +	 * transaction open across the dqrele scan).
> > +	 *
> > +	 * The critical aspect of correctly logging quotaoff is that no dquots
> > +	 * are modified after the quotaoff end item hits the on-disk log.
> > +	 * Otherwise the quotaoff can fall off the tail and log recovery can
> > +	 * replay incorrect data. Instead of letting the start item sit in the
> > +	 * log while quotaoff completes, we can provide the same guarantee via a
> > +	 * runtime barrier for dquot modifications. Specifically, we pause all
> > +	 * transactions on the system via the transaction subsystem lock, log
> > +	 * both start and end items (via sync transactions, which drains the
> > +	 * CIL), deactivate the quota, and then resume the transaction subsystem
> > +	 * while quotaoff completes.
> > +	 *
> > +	 * This is safe because the remaining quotaoff work is in-core cleanup
> > +	 * and all subsequent transactions should see the updated quota state
> > +	 * due to memory ordering provided by the lock. We also avoid deadlock
> > +	 * by committing both items sequentially with near exclusive access to
> > +	 * the transaction subsystem.
> >  	 */
> > +	percpu_down_write(&mp->m_trans_rwsem);
> > +
> >  	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
> > -	if (error)
> > +	if (error) {
> > +		percpu_up_write(&mp->m_trans_rwsem);
> >  		goto out_unlock;
> > +	}
> >  
> > -	/*
> > -	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
> > -	 * to take care of the race between dqget and quotaoff. We don't take
> > -	 * any special locks to reset these bits. All processes need to check
> > -	 * these bits *after* taking inode lock(s) to see if the particular
> > -	 * quota type is in the process of being turned off. If *ACTIVE, it is
> > -	 * guaranteed that all dquot structures and all quotainode ptrs will all
> > -	 * stay valid as long as that inode is kept locked.
> > -	 *
> > -	 * There is no turning back after this.
> > -	 */
> >  	mp->m_qflags &= ~inactivate_flags;
> >  
> > +	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
> > +	if (error) {
> > +		percpu_up_write(&mp->m_trans_rwsem);
> > +		/* We're screwed now. Shutdown is the only option. */
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +		goto out_unlock;
> > +	}
> > +
> > +	percpu_up_write(&mp->m_trans_rwsem);
> 
> Hmm, so if I read this correctly, you're changing what gets written to
> the log from:
> 
> 	<quotaoff intent>
> 	<transactions that maybe log dquots but we don't care>
> 	...now the qflags get cleared...
> 	<transactions that maybe log dquots but we don't care>
> 	...run around purging dquots...
> 	<transactions that maybe log dquots but we don't care>
> 	<quotaoff done>
> 
> to something that looks more like:
> 
> 	<transactions that log dquots>
> 	<quotaoff intent, all other transactions locked out>
> 	...now the qflags get cleared; no other transactions...
> 	<quotaoff done, turn off the lockout>
> 	<transactions that wont log dquots>
> 	...run around purging dquots...
> 

Yep, pretty much. The idea is to preserve the behavior that no dquots
are logged after the quotaoff end item to guarantee the log can never
hold a modified dquot after a previous quotaoff falls off the tail.
Rather than doing that by bounding the quotaoff operation with the two
log items, we introduce a runtime quiesce that deterministically
disables dquot activity and log the items after that point.

> Is that right?  I guess that makes sense, though it's sort of a pity
> that we now make every transaction grab a read lock.  Though I guess
> there's not much that can be done about that; it's better than pinning
> the log tail.  I don't even think there's a good way to relog that
> quotaoff-intent item, is there?  Since you'd have to, I dunno, do all
> the checks that xfs_defer_relog() does to decide if it should relog an
> intent item?
> 

Yeah, well that was a purpose of the previous automatic relog bits.
Short of that, I'm not aware of a great way to keep the start intent
moving. We can't hold a transaction open across the scan(s), so that
also rules out turning quotaoff into a dfop, for example. We could try
to relog the intent at random points, but that looks to me like a bunch
of busy work to break up the scans for no guarantee in return that the
relog transaction wouldn't still deadlock anyways.

Brian

> --D
> 
> > +
> >  	/*
> > -	 * Give back all the dquot reference(s) held by inodes.
> > -	 * Here we go thru every single incore inode in this file system, and
> > -	 * do a dqrele on the i_udquot/i_gdquot that it may have.
> > -	 * Essentially, as long as somebody has an inode locked, this guarantees
> > -	 * that quotas will not be turned off. This is handy because in a
> > -	 * transaction once we lock the inode(s) and check for quotaon, we can
> > -	 * depend on the quota inodes (and other things) being valid as long as
> > -	 * we keep the lock(s).
> > +	 * Release dquot references held by inodes. Technically some contexts
> > +	 * might not pick up the quota state change until the inode lock is
> > +	 * cycled if there is no transaction. We don't care about that above
> > +	 * because a dquot can't be logged without a transaction and we can't
> > +	 * release/purge a dquot here until we've cycled the locks of all inodes
> > +	 * that reference it.
> >  	 */
> >  	xfs_qm_dqrele_all_inodes(mp, flags);
> >  
> >  	/*
> >  	 * Next we make the changes in the quota flag in the mount struct.
> > -	 * This isn't protected by a particular lock directly, because we
> > -	 * don't want to take a mrlock every time we depend on quotas being on.
> > +	 * This isn't protected by a particular lock directly, because we don't
> > +	 * want to take a mrlock every time we depend on quotas being on.
> >  	 */
> >  	mp->m_qflags &= ~flags;
> >  
> > -	/*
> > -	 * Go through all the dquots of this file system and purge them,
> > -	 * according to what was turned off.
> > -	 */
> > +	/* purge all deactivated dquots from the filesystem */
> >  	xfs_qm_dqpurge_all(mp, dqtype);
> >  
> > -	/*
> > -	 * Transactions that had started before ACTIVE state bit was cleared
> > -	 * could have logged many dquots, so they'd have higher LSNs than
> > -	 * the first QUOTAOFF log record does. If we happen to crash when
> > -	 * the tail of the log has gone past the QUOTAOFF record, but
> > -	 * before the last dquot modification, those dquots __will__
> > -	 * recover, and that's not good.
> > -	 *
> > -	 * So, we have QUOTAOFF start and end logitems; the start
> > -	 * logitem won't get overwritten until the end logitem appears...
> > -	 */
> > -	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
> > -	if (error) {
> > -		/* We're screwed now. Shutdown is the only option. */
> > -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > -		goto out_unlock;
> > -	}
> > -
> > -	/*
> > -	 * If all quotas are completely turned off, close shop.
> > -	 */
> > +	/* if all quotas are completely turned off, close shop */
> >  	if (mp->m_qflags == 0) {
> >  		mutex_unlock(&q->qi_quotaofflock);
> >  		xfs_qm_destroy_quotainfo(mp);
> >  		return 0;
> >  	}
> >  
> > -	/*
> > -	 * Release our quotainode references if we don't need them anymore.
> > -	 */
> > +	/* release our quotainode references if we don't need them anymore */
> >  	if ((dqtype & XFS_QMOPT_UQUOTA) && q->qi_uquotaip) {
> >  		xfs_irele(q->qi_uquotaip);
> >  		q->qi_uquotaip = NULL;
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index 547ba824542e..9839b83e732a 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -52,6 +52,8 @@ xfs_trans_log_dquot(
> >  	struct xfs_dquot	*dqp)
> >  {
> >  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
> > +	/* quotaoff expects no dquots logged after deactivation */
> > +	ASSERT(xfs_this_quota_on(tp->t_mountp, xfs_dquot_type(dqp)));
> >  
> >  	/* Upgrade the dquot to bigtime format if possible. */
> >  	if (dqp->q_id != 0 &&
> > -- 
> > 2.25.4
> > 
> 

