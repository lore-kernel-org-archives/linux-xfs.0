Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1ED0C18E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 14:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89387206EC
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 14:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LE82aMDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgCQO51 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 10:57:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:52742 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgCQO51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 10:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584457045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UWmaPqrNPOCoKuqErZFBZJCIJvpHEFOaIHjmwu68lpo=;
        b=LE82aMDj7a4+cbu0FVpS0hMMV1JviQk0y7ZFCEF3UGeapECCzWnA/asDGgCz3QF/SY7yOn
        59qs1zsKUbRqVhZy6H7OR4BVMBb2gz8CQKXuHYs1UhkWVDkhFW8lzNk57C37bmg7aLHIvR
        hHGEm0kyGreiZESZTHCJkfWXIoWToZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-AXBkAb6dMyqJy1rbxAXB5w-1; Tue, 17 Mar 2020 10:57:23 -0400
X-MC-Unique: AXBkAb6dMyqJy1rbxAXB5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B9E0101213F;
        Tue, 17 Mar 2020 14:56:29 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 951CE1001B34;
        Tue, 17 Mar 2020 14:56:28 +0000 (UTC)
Date:   Tue, 17 Mar 2020 10:56:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix unmount hang and memory leak on shutdown
 during quotaoff
Message-ID: <20200317145626.GJ24078@bfoster>
References: <20200316170032.19552-1-bfoster@redhat.com>
 <20200316170032.19552-3-bfoster@redhat.com>
 <20200316213223.GU256767@magnolia>
 <20200317114011.GB22894@bfoster>
 <20200317144607.GB256713@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317144607.GB256713@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 07:46:07AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 17, 2020 at 07:40:11AM -0400, Brian Foster wrote:
> > On Mon, Mar 16, 2020 at 02:32:23PM -0700, Darrick J. Wong wrote:
> > > On Mon, Mar 16, 2020 at 01:00:32PM -0400, Brian Foster wrote:
> > > > AIL removal of the quotaoff start intent and free of both quotaoff
> > > > intents is currently limited to the ->iop_committed() handler of the
> > > > end intent. This executes when the end intent is committed to the
> > > > on-disk log and marks the completion of the operation. The problem
> > > > with this is it assumes the success of the operation. If a shutdown
> > > > or other error occurs during the quotaoff, it's possible for the
> > > > quotaoff task to exit without removing the start intent from the
> > > > AIL. This results in an unmount hang as the AIL cannot be emptied.
> > > > Further, no other codepath frees the intents and so this is also a
> > > > memory leak vector.
> > > 
> > > And I'm guessing that you'd rather we taught the quota items to be
> > > self-releasing under error rather than making the quotaoff code be smart
> > > enough to free the quotaoff-start item?
> > > 
> > 
> > It's a combination of both because they are separate transactions... If
> > the item is "owned" by a transaction and the transaction aborts, we
> > "release" all attached items as we would for any other transaction/item.
> > Once the start transaction commits, the start item is AIL resident and
> > there's no guarantee we'll ever get to the end transaction (i.e. a
> > shutdown could cause the transaction allocation to fail). The quotaoff
> > code handles cleaning up the start item in that scenario. This is
> > similar to the whole EFD holding a reference to the EFI model, except
> > quotaoff is a bit more hacky..
> > 
> > From a development perspective, my approach was to fix up the intent
> > handling such that adheres to common practice wrt to transactions and
> > then address the gap(s) in the quotaoff code (i.e. the separate
> > start/end transactions being an implementation detail of quotaoff).
> 
> <nod> Sounds like a reasonable approach for a pretty odd duck.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> > > > First, update the high level quotaoff error path to directly remove
> > > > and free the quotaoff start intent if it still exists in the AIL at
> > > > the time of the error. Next, update both of the start and end
> > > > quotaoff intents with an ->iop_release() callback to properly handle
> > > > transaction abort.
> > > 
> > > I wonder, does this mean that we can drop the if (->io_release) check in
> > > xfs_trans_free_items?  ISTR we were wondering at one point if there ever
> > > was a real use case for items that don't have a release function.
> > > 
> > 
> > Hmm.. this was reworked fairly recently IIRC to condense some of the
> > callbacks. This used to be an ->iop_unlock() call. It was renamed to
> > ->iop_release() to primarily handle the abort scenario (yet can also be
> > called via log I/O completion based on a magic flag) and the non-abort
> > ->iop_unlock() call was folded into ->iop_committing(). Clear as mud? :)
> > In any event, I'm not aware of any further effort to remove
> > ->iop_release() from xfs_trans_free_items() as that is the typical abort
> > path that this patch relies on..
> 
> Oh, I didn't mean dropping ->iop_release completely, I just wondered
> about removing the conditional, e.g.
> 
> 	if (->iop_release)
> 		->iop_release(...);
> 
> becomes:
> 
> 	->iop_release(...);
> 
> Now that every log item type (I think?) actually has a release method.
> 

Ah, I misread. -ENOCOFFEE I guess. :P That seems reasonable to me, but
tbh I'm not sure it's worth saving 1 LOC either. *shrug*

Brian

> --D
> 
> > Brian
> > 
> > > > This means that If the quotaoff start transaction aborts, it frees
> > > > the start intent in the transaction commit path. If the filesystem
> > > > shuts down before the end transaction allocates, the quotaoff
> > > > sequence removes and frees the start intent. If the end transaction
> > > > aborts, it removes the start intent and frees both. This ensures
> > > > that a shutdown does not result in a hung unmount and that memory is
> > > > not leaked regardless of when a quotaoff error occurs.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > FWIW, the code looks reasonable.
> > > 
> > > --D
> > > 
> > > > ---
> > > >  fs/xfs/xfs_dquot_item.c  | 15 +++++++++++++++
> > > >  fs/xfs/xfs_qm_syscalls.c | 13 +++++++------
> > > >  2 files changed, 22 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > > index 2b816e9b4465..cf65e2e43c6e 100644
> > > > --- a/fs/xfs/xfs_dquot_item.c
> > > > +++ b/fs/xfs/xfs_dquot_item.c
> > > > @@ -315,17 +315,32 @@ xfs_qm_qoffend_logitem_committed(
> > > >  	return (xfs_lsn_t)-1;
> > > >  }
> > > >  
> > > > +STATIC void
> > > > +xfs_qm_qoff_logitem_release(
> > > > +	struct xfs_log_item	*lip)
> > > > +{
> > > > +	struct xfs_qoff_logitem	*qoff = QOFF_ITEM(lip);
> > > > +
> > > > +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
> > > > +		if (qoff->qql_start_lip)
> > > > +			xfs_qm_qoff_logitem_relse(qoff->qql_start_lip);
> > > > +		xfs_qm_qoff_logitem_relse(qoff);
> > > > +	}
> > > > +}
> > > > +
> > > >  static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
> > > >  	.iop_size	= xfs_qm_qoff_logitem_size,
> > > >  	.iop_format	= xfs_qm_qoff_logitem_format,
> > > >  	.iop_committed	= xfs_qm_qoffend_logitem_committed,
> > > >  	.iop_push	= xfs_qm_qoff_logitem_push,
> > > > +	.iop_release	= xfs_qm_qoff_logitem_release,
> > > >  };
> > > >  
> > > >  static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
> > > >  	.iop_size	= xfs_qm_qoff_logitem_size,
> > > >  	.iop_format	= xfs_qm_qoff_logitem_format,
> > > >  	.iop_push	= xfs_qm_qoff_logitem_push,
> > > > +	.iop_release	= xfs_qm_qoff_logitem_release,
> > > >  };
> > > >  
> > > >  /*
> > > > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > > > index 1ea82764bf89..5d5ac65aa1cc 100644
> > > > --- a/fs/xfs/xfs_qm_syscalls.c
> > > > +++ b/fs/xfs/xfs_qm_syscalls.c
> > > > @@ -29,8 +29,6 @@ xfs_qm_log_quotaoff(
> > > >  	int			error;
> > > >  	struct xfs_qoff_logitem	*qoffi;
> > > >  
> > > > -	*qoffstartp = NULL;
> > > > -
> > > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> > > >  	if (error)
> > > >  		goto out;
> > > > @@ -62,7 +60,7 @@ xfs_qm_log_quotaoff(
> > > >  STATIC int
> > > >  xfs_qm_log_quotaoff_end(
> > > >  	struct xfs_mount	*mp,
> > > > -	struct xfs_qoff_logitem	*startqoff,
> > > > +	struct xfs_qoff_logitem	**startqoff,
> > > >  	uint			flags)
> > > >  {
> > > >  	struct xfs_trans	*tp;
> > > > @@ -73,9 +71,10 @@ xfs_qm_log_quotaoff_end(
> > > >  	if (error)
> > > >  		return error;
> > > >  
> > > > -	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
> > > > +	qoffi = xfs_trans_get_qoff_item(tp, *startqoff,
> > > >  					flags & XFS_ALL_QUOTA_ACCT);
> > > >  	xfs_trans_log_quotaoff_item(tp, qoffi);
> > > > +	*startqoff = NULL;
> > > >  
> > > >  	/*
> > > >  	 * We have to make sure that the transaction is secure on disk before we
> > > > @@ -103,7 +102,7 @@ xfs_qm_scall_quotaoff(
> > > >  	uint			dqtype;
> > > >  	int			error;
> > > >  	uint			inactivate_flags;
> > > > -	struct xfs_qoff_logitem	*qoffstart;
> > > > +	struct xfs_qoff_logitem	*qoffstart = NULL;
> > > >  
> > > >  	/*
> > > >  	 * No file system can have quotas enabled on disk but not in core.
> > > > @@ -228,7 +227,7 @@ xfs_qm_scall_quotaoff(
> > > >  	 * So, we have QUOTAOFF start and end logitems; the start
> > > >  	 * logitem won't get overwritten until the end logitem appears...
> > > >  	 */
> > > > -	error = xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
> > > > +	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
> > > >  	if (error) {
> > > >  		/* We're screwed now. Shutdown is the only option. */
> > > >  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > @@ -261,6 +260,8 @@ xfs_qm_scall_quotaoff(
> > > >  	}
> > > >  
> > > >  out_unlock:
> > > > +	if (error && qoffstart)
> > > > +		xfs_qm_qoff_logitem_relse(qoffstart);
> > > >  	mutex_unlock(&q->qi_quotaofflock);
> > > >  	return error;
> > > >  }
> > > > -- 
> > > > 2.21.1
> > > > 
> > > 
> > 
> 

