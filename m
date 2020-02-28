Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1E3C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59AFE246AE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IZwMFTt4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgB1ODR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 09:03:17 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34955 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725892AbgB1ODR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 09:03:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582898596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vxx5AQ2wUbmvb+kQOGbqq4GRkzst6imctRw+fDApFU0=;
        b=IZwMFTt4fvZZLoJkzPgu9TJxZnKv02y2CD98YjNNCNY7ZMq2iW3ievg9EUJOEfvuGnbGoa
        isKQzHaG1JjnsdJTFTWpfqzrVI4ZcKsfA3zuxHU1yrwouS5ZxXzbvGL1glG8YqelqTvT+W
        Qe802sSZVN/YGfy2v9bKjI44EQeDbIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-whDW31uoNGGwVUdFhyHSmQ-1; Fri, 28 Feb 2020 09:03:12 -0500
X-MC-Unique: whDW31uoNGGwVUdFhyHSmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22C7A107ACCA;
        Fri, 28 Feb 2020 14:03:11 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD9658C066;
        Fri, 28 Feb 2020 14:03:10 +0000 (UTC)
Date:   Fri, 28 Feb 2020 09:03:09 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 6/9] xfs: automatically relog the quotaoff start
 intent
Message-ID: <20200228140309.GE2751@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-7-bfoster@redhat.com>
 <137e4060-5936-171d-802a-9bf72195663c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <137e4060-5936-171d-802a-9bf72195663c@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 04:19:42PM -0700, Allison Collins wrote:
> 
> 
> On 2/27/20 6:43 AM, Brian Foster wrote:
> > The quotaoff operation has a rare but longstanding deadlock vector
> > in terms of how the operation is logged. A quotaoff start intent is
> > logged (synchronously) at the onset to ensure recovery can handle
> > the operation if interrupted before in-core changes are made. This
> > quotaoff intent pins the log tail while the quotaoff sequence scans
> > and purges dquots from all in-core inodes. While this operation
> > generally doesn't generate much log traffic on its own, it can be
> > time consuming. If unrelated, concurrent filesystem activity
> > consumes remaining log space before quotaoff is able to acquire log
> > reservation for the quotaoff end intent, the filesystem locks up
> > indefinitely.
> > 
> > quotaoff cannot allocate the end intent before the scan because the
> > latter can result in transaction allocation itself in certain
> > indirect cases (releasing an inode, for example). Further, rolling
> > the original transaction is difficult because the scanning work
> > occurs multiple layers down where caller context is lost and not
> > much information is available to determine how often to roll the
> > transaction.
> > 
> > To address this problem, enable automatic relogging of the quotaoff
> > start intent. This automatically relogs the intent whenever AIL
> > pushing finds the item at the tail of the log. When quotaoff
> > completes, wait for relogging to complete as the end intent expects
> > to be able to permanently remove the start intent from the log
> > subsystem. This ensures that the log tail is kept moving during a
> > particularly long quotaoff operation and avoids the log reservation
> > deadlock.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >   fs/xfs/libxfs/xfs_trans_resv.c |  3 ++-
> >   fs/xfs/xfs_dquot_item.c        |  7 +++++++
> >   fs/xfs/xfs_qm_syscalls.c       | 12 +++++++++++-
> >   3 files changed, 20 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 1f5c9e6e1afc..f49b20c9ca33 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -935,7 +935,8 @@ xfs_trans_resv_calc(
> >   	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> >   	resp->tr_qm_quotaoff.tr_logres = xfs_calc_qm_quotaoff_reservation(mp);
> > -	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> > +	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
> > +	resp->tr_qm_quotaoff.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> What's the reason for the log count change here?  Otherwise looks ok.
> 

Permanent transactions have a separate default log count (2 instead of
1) because they are intended to be rolled (at least once). This
basically means the initial allocation will acquire enough log
reservation for the initial transaction and a subsequent roll, similar
to how all other permanant transactions are initialized in this file.
This is required for quotaoff because the transaction now uses
XFS_TRANS_RELOG, which requires a roll up front.

Brian

> Allison
> >   	resp->tr_qm_equotaoff.tr_logres =
> >   		xfs_calc_qm_quotaoff_end_reservation();
> > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > index d60647d7197b..ea5123678466 100644
> > --- a/fs/xfs/xfs_dquot_item.c
> > +++ b/fs/xfs/xfs_dquot_item.c
> > @@ -297,6 +297,13 @@ xfs_qm_qoff_logitem_push(
> >   	struct xfs_log_item	*lip,
> >   	struct list_head	*buffer_list)
> >   {
> > +	struct xfs_log_item	*mlip = xfs_ail_min(lip->li_ailp);
> > +
> > +	if (test_bit(XFS_LI_RELOG, &lip->li_flags) &&
> > +	    !test_bit(XFS_LI_RELOGGED, &lip->li_flags) &&
> > +	    !XFS_LSN_CMP(lip->li_lsn, mlip->li_lsn))
> > +		return XFS_ITEM_RELOG;
> > +
> >   	return XFS_ITEM_LOCKED;
> >   }
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index 1ea82764bf89..7b48d34da0f4 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -18,6 +18,7 @@
> >   #include "xfs_quota.h"
> >   #include "xfs_qm.h"
> >   #include "xfs_icache.h"
> > +#include "xfs_trans_priv.h"
> >   STATIC int
> >   xfs_qm_log_quotaoff(
> > @@ -31,12 +32,14 @@ xfs_qm_log_quotaoff(
> >   	*qoffstartp = NULL;
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
> > +				XFS_TRANS_RELOG, &tp);
> >   	if (error)
> >   		goto out;
> >   	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
> >   	xfs_trans_log_quotaoff_item(tp, qoffi);
> > +	xfs_trans_relog_item(&qoffi->qql_item);
> >   	spin_lock(&mp->m_sb_lock);
> >   	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
> > @@ -69,6 +72,13 @@ xfs_qm_log_quotaoff_end(
> >   	int			error;
> >   	struct xfs_qoff_logitem	*qoffi;
> > +	/*
> > +	 * startqoff must be in the AIL and not the CIL when the end intent
> > +	 * commits to ensure it is not readded to the AIL out of order. Wait on
> > +	 * relog activity to drain to isolate startqoff to the AIL.
> > +	 */
> > +	xfs_trans_relog_item_cancel(&startqoff->qql_item, true);
> > +
> >   	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
> >   	if (error)
> >   		return error;
> > 
> 

