Return-Path: <SRS0=pdRq=4R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A7CC3F2D6
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 05:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D040C246A2
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 05:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DmuLdhnL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgB2Ffi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Feb 2020 00:35:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2Ffh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Feb 2020 00:35:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T5NeIY007429;
        Sat, 29 Feb 2020 05:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0U3St6RoWoLsQcF36vsWNAKx+iufIeSZOMNmo6Tm8So=;
 b=DmuLdhnLPIoJDf40E3TI5R6B7kcvdXN2vmyD+ZaSa/YXs42RHiEJatjnVVQZnqE2NiMi
 88qBhKPLfB1Ls6MOF/VCGSyYh1dzyz4DjEUaf1W2z3603RXAsFzxKybl461+ggshgp0U
 /0HmVP0A+RMFosma4w3dom7neFoR0dve7IZDbraa1qQgNQlYNa6TYr12VkyE1hT+Irhs
 DIECyy6Q87LBqTz82fRuykSifQUZWxN2aA4+tfjl/4Ud9OcUcmL1KuAfH0k297PwP3Rm
 uzN77CIWrcOWPejez5yzDYYhSYYy7fpuUJLDBFBYpQ0g+5GWMvapv/WJZ4p6VwE0OEt9 Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yffcu0852-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 05:35:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T5WkX5124830;
        Sat, 29 Feb 2020 05:35:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yfe0db981-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 05:35:33 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01T5ZW9T013538;
        Sat, 29 Feb 2020 05:35:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 21:35:32 -0800
Date:   Fri, 28 Feb 2020 21:35:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 6/9] xfs: automatically relog the quotaoff start
 intent
Message-ID: <20200229053531.GV8045@magnolia>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-7-bfoster@redhat.com>
 <20200228011640.GT8045@magnolia>
 <20200228140413.GF2751@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228140413.GF2751@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 09:04:13AM -0500, Brian Foster wrote:
> On Thu, Feb 27, 2020 at 05:16:40PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 27, 2020 at 08:43:18AM -0500, Brian Foster wrote:
> > > The quotaoff operation has a rare but longstanding deadlock vector
> > > in terms of how the operation is logged. A quotaoff start intent is
> > > logged (synchronously) at the onset to ensure recovery can handle
> > > the operation if interrupted before in-core changes are made. This
> > > quotaoff intent pins the log tail while the quotaoff sequence scans
> > > and purges dquots from all in-core inodes. While this operation
> > > generally doesn't generate much log traffic on its own, it can be
> > > time consuming. If unrelated, concurrent filesystem activity
> > > consumes remaining log space before quotaoff is able to acquire log
> > > reservation for the quotaoff end intent, the filesystem locks up
> > > indefinitely.
> > > 
> > > quotaoff cannot allocate the end intent before the scan because the
> > > latter can result in transaction allocation itself in certain
> > > indirect cases (releasing an inode, for example). Further, rolling
> > > the original transaction is difficult because the scanning work
> > > occurs multiple layers down where caller context is lost and not
> > > much information is available to determine how often to roll the
> > > transaction.
> > > 
> > > To address this problem, enable automatic relogging of the quotaoff
> > > start intent. This automatically relogs the intent whenever AIL
> > > pushing finds the item at the tail of the log. When quotaoff
> > > completes, wait for relogging to complete as the end intent expects
> > > to be able to permanently remove the start intent from the log
> > > subsystem. This ensures that the log tail is kept moving during a
> > > particularly long quotaoff operation and avoids the log reservation
> > > deadlock.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_trans_resv.c |  3 ++-
> > >  fs/xfs/xfs_dquot_item.c        |  7 +++++++
> > >  fs/xfs/xfs_qm_syscalls.c       | 12 +++++++++++-
> > >  3 files changed, 20 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > > index 1f5c9e6e1afc..f49b20c9ca33 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > > @@ -935,7 +935,8 @@ xfs_trans_resv_calc(
> > >  	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> > >  
> > >  	resp->tr_qm_quotaoff.tr_logres = xfs_calc_qm_quotaoff_reservation(mp);
> > > -	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> > > +	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
> > > +	resp->tr_qm_quotaoff.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > >  
> > >  	resp->tr_qm_equotaoff.tr_logres =
> > >  		xfs_calc_qm_quotaoff_end_reservation();
> > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > index d60647d7197b..ea5123678466 100644
> > > --- a/fs/xfs/xfs_dquot_item.c
> > > +++ b/fs/xfs/xfs_dquot_item.c
> > > @@ -297,6 +297,13 @@ xfs_qm_qoff_logitem_push(
> > >  	struct xfs_log_item	*lip,
> > >  	struct list_head	*buffer_list)
> > >  {
> > > +	struct xfs_log_item	*mlip = xfs_ail_min(lip->li_ailp);
> > > +
> > > +	if (test_bit(XFS_LI_RELOG, &lip->li_flags) &&
> > > +	    !test_bit(XFS_LI_RELOGGED, &lip->li_flags) &&
> > > +	    !XFS_LSN_CMP(lip->li_lsn, mlip->li_lsn))
> > > +		return XFS_ITEM_RELOG;
> > > +
> > >  	return XFS_ITEM_LOCKED;
> > >  }
> > >  
> > > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > > index 1ea82764bf89..7b48d34da0f4 100644
> > > --- a/fs/xfs/xfs_qm_syscalls.c
> > > +++ b/fs/xfs/xfs_qm_syscalls.c
> > > @@ -18,6 +18,7 @@
> > >  #include "xfs_quota.h"
> > >  #include "xfs_qm.h"
> > >  #include "xfs_icache.h"
> > > +#include "xfs_trans_priv.h"
> > >  
> > >  STATIC int
> > >  xfs_qm_log_quotaoff(
> > > @@ -31,12 +32,14 @@ xfs_qm_log_quotaoff(
> > >  
> > >  	*qoffstartp = NULL;
> > >  
> > > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
> > > +				XFS_TRANS_RELOG, &tp);
> > 
> > Humm, maybe I don't understand how this works after all.  From what I
> > can tell from this patch, (1) the quotaoff transaction is created with
> > RELOG, so (2) the AIL steals some reservation from it for an eventual
> > relogging of the quotaoff item, and then (3) we log the quotaoff item.
> > 
> 
> Yep.
> 
> > Later, the AIL can decide to trigger the workqueue item to take the
> > ticket generated in step (2) to relog the item we logged in step (3) to
> > move the log tail forward, but what happens if there are further delays
> > and the AIL needs to relog again?  That ticket from (2) is now used up
> > and is gone, right?
> > 
> > I suppose some other RELOG transaction could wander in and generate a
> > new relog ticket, but as this is the only RELOG transaction that gets
> > created anywhere, that won't happen.  Is there some magic I missed? :)
> > 
> 
> xfs_ail_relog() only ever rolls its transaction, even if nothing else
> happens to be queued at the time, so the relog ticket constantly
> regrants. Since relogs never commit, the relog ticket always has
> available relog reservation so long as XFS_LI_RELOG items exist. Once
> there are no more relog items or transactions, the pending reservation
> is released via xfs_trans_ail_relog_put() -> xfs_log_done().

Aha, that's the subtlety I didn't quite catch. :)

Now that I see how this works for the simple case, I guess I'll try to
figure out on my own what would happen if we flooded the system with a
/lot/ of reloggable items.  Though I bet you've already done that, given
our earlier speculating about closing the writeback hole.

> It might be more simple to reason about the reservation model if you
> factor out the dynamic relog ticket bits. This is basically equivalent
> to the AIL allocating a relog transaction at mount time, constantly
> rolling it with relog items when they pass through, and then cancelling
> the reservation at unmount time. All of the extra XFS_TRANS_RELOG and
> reference counting and ticket management stuff is purely so we only have
> an active relog reservation when relogging is being used.

<nod>

--D

> Brian
> 
> > --D
> > 
> > >  	if (error)
> > >  		goto out;
> > >  
> > >  	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
> > >  	xfs_trans_log_quotaoff_item(tp, qoffi);
> > > +	xfs_trans_relog_item(&qoffi->qql_item);
> > >  
> > >  	spin_lock(&mp->m_sb_lock);
> > >  	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
> > > @@ -69,6 +72,13 @@ xfs_qm_log_quotaoff_end(
> > >  	int			error;
> > >  	struct xfs_qoff_logitem	*qoffi;
> > >  
> > > +	/*
> > > +	 * startqoff must be in the AIL and not the CIL when the end intent
> > > +	 * commits to ensure it is not readded to the AIL out of order. Wait on
> > > +	 * relog activity to drain to isolate startqoff to the AIL.
> > > +	 */
> > > +	xfs_trans_relog_item_cancel(&startqoff->qql_item, true);
> > > +
> > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
> > >  	if (error)
> > >  		return error;
> > > -- 
> > > 2.21.1
> > > 
> > 
> 
