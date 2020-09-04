Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1719BC433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 22:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D6C2083B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 22:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgIDW3n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 18:29:43 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39287 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728012AbgIDW3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 18:29:43 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EA3E6822903;
        Sat,  5 Sep 2020 08:29:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kEKDA-0000RL-FJ; Sat, 05 Sep 2020 08:29:36 +1000
Date:   Sat, 5 Sep 2020 08:29:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: quotaoff, transaction quiesce, and dquot logging
Message-ID: <20200904222936.GH12131@dread.disaster.area>
References: <20200904155949.GF529978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904155949.GF529978@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=IuRgj43g c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=7-415B0cAAAA:8
        a=cz2PgkpBsDL-bNuyME8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 11:59:49AM -0400, Brian Foster wrote:
> Hi Dave,
> 
> I'm finally getting back to the quotaoff thing we discussed a ways
> back[1] and doing some auditing to make sure that I understand the
> approach and that it seems correct. To refresh, your original prototype
> and the slightly different one I'm looking into implement the same
> general scheme:
> 
> 1.) quiesce the transaction subsystem
> 2.) disable quota(s) (update state flags)
> 3.) log quotaoff start/end items (synchronous)
> 4.) open the transaction subsystem
> 5.) release all inode dquot references and purge dquots
> 
> The idea is that the critical invariant requred for quotaoff is that no
> dquots are logged after the quotaoff end item is committed to the log.
> Otherwise there is no guarantee that the tail pushes past the quotaoff
> item and a subsequent crash/recovery incorrectly replays dquot changes
> for an inactive quota mode.
> 
> As it is, I think there's at least one assumption we've made that isn't
> entirely accurate. It looks to me that steps 1-4 don't guarantee that
> dquots aren't logged after the transaction subsystem is released. The
> current code (and my prototype) only clear the *QUOTA_ACTIVE flags at
> that point, and various transactions might have already acquired or
> attached dquots to inodes before the transaction allocation even occurs.
> Once the transaction is allocated, various paths basically only care if
> we have a dquot or not.
> 
> For example, xfs_create() gets the dquots up front, allocs the
> transaction and xfs_trans_reserve_quota_bydquots() attaches any of the
> associated dquots to the transaction. xfs_trans_reserve_quota_bydquots()
> checks for (!QUOTA_ON() || !QUOTA_RUNNING()), but those only help us if
> all quotas have been disabled. Consider if one of multiple active quotas
> are being turned off, and that this path already has dquots for both,
> for example.

Right, that's one of the main problems I tried to solve.

> 
> I do notice that your prototype[1] clears all of the quota flags (not
> just the ACTIVE flags) after the transaction barrier is released. This
> prevents further modifications in some cases, but it doesn't seem like
> that is enough to avoid violating the invariant described above. E.g.,
> xfs_trans_apply_dquot_deltas() logs the dquot regardless of whether
> changes are made (and actually looks like it can make some changes on
> the dquot even if the transaction doesn't) after the dquot is attached
> to the transaction.

It should, because the transaction barrier includes a draining
mechanism to wait for all quota modifying transactions already
running to drain out. That is, any transaction marked with
XFS_TRANS_QUOTA (via it's initial reservation) will have an elevated
q->qi_active_trans count, and that only gets decremented when the
transaction completes and the dquot is released from the
transaction (i.e. in xfs_trans_free_dqinfo()).

The barrier sets the XFS_QUOTA_OFF_RUNNING_BIT, at which point new
transactions marked with XFS_TRANS_QUOTA will enter
xfs_trans_quota_enabled() in xfs_trans_alloc(). If the
XFS_QUOTA_OFF_RUNNING_BIT is set, they block waiting for it to be
cleared.

This forms the "no new quota modifying transactions can start" part
of the barrier.

If quota is running and the XFS_QUOTA_OFF_RUNNING_BIT is not set,
they increment q->qi_active_trans to indicate that there is a
running dquot modifying transaction in progress. This state is
maintained across transaction duplication/rolling so the reference
only goes away when the transaction is completely finished with
dquots and released them from the transaction.

The quota off code sets the XFS_QUOTA_OFF_RUNNING_BIT the waits for
q->qi_active_trans to go to zero, thereby setting the "stop new
xacts from starting" barrier and then waiting for all dquot
modifying xacts to complete. At this point, there are not
transactions holding dquot references, no dquots being modified,
and all new transactions that might modify dquots are being held in
xfs_trans_alloc() and will check xfs_trans_quota_running() when they
are woken. 

At this point, we might still have uncommitted dquots in the CIL,
so we do a xfs_log_force(mp, XFS_LOG_SYNC) to flush all the
modifications to the journal, thereby guaranteeing that we order
them in the journal before the first quotaoff item is committed.

With all dquot mods being stable now, and no new modifications able
to occur, we can clear all the quota flags in one go. We
don't need to keep the quotas we are turning off running while we
clear out all the inode references to them, because once the
running/active/acct/enforced flags are cleared, no new modification
will try to modify that quota because all the "is this quota type
running" checks will fail the moment we clear all the in-memory
quota flags.

IOWs, the barrier mechanism I added was designed to provide the
exact "no dquots are logged after the quotaoff item is committed to
the log" invariant you describe. It's basically the same mechanism
we use for draining direct IO via taking IOLOCKs to prevent new
submissions and calling inode_dio_wait() to drain everything in
flight....

> This does make me wonder a bit whether we should rework the transaction
> commit path to avoid modifying/logging the dquot completely if the quota
> is inactive or accounting is disabled.

If there are no dquots for an inactive quota type attached to the
transaction, it won't log anything. That's what the barrier+drain
acheives.

> When starting to look around with
> that in mind, I see the following in xfs_quota_defs.h:
> 
> /*
>  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
>  * quota will be not be switched off as long as that inode lock is held.
>  */
> #define XFS_IS_QUOTA_ON(mp)     ((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
>                                                    XFS_GQUOTA_ACTIVE | \
>                                                    XFS_PQUOTA_ACTIVE))
> ...
> 
> So I'm wondering how safe that actually would be, or even how safe it is
> to clear the ACCT|ENFD flags before we release/purge dquots.

I don't see any problem with this - we only care that when we
restart transactions that the dquots for the disabled quota type are
not joined into new transactions, and clearing the ACTIVE flag for
that dquot type should do that.

> It seems
> like that conflicts with the above documentation, at least, but I'm not
> totally clear on the reason for that rule.

Releasing the dquot in the quota-off code required an inode lock
cycle to guarantee that the inode was not currently being modified
in a transaction that might hold a reference to the dquota. Hence
the ACTIVE check under the inode lock is the only way to guarantee
the dquot doesn't get ripped out from underneath an inode/dquot
modification in progress...

> In any event, I'm still
> poking around a bit, but unless I'm missing something in the analysis
> above it doesn't seem like this is a matter of simply altering the
> quotaoff path as originally expected. Thoughts or ideas appreciated.

I suspect you missed the importance of q->qi_active_trans for
draining all active quota modifying transactions before making quota
flag changes...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
