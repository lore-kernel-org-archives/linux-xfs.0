Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCECC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76F32247F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404356AbhAZNbv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:31:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404367AbhAZN1d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 08:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611667566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4DxTYwltXo6SOHgCTUbVMWGCeoebM3A8z7epLTPRlgs=;
        b=THYKGPJWPV7xiFaqYNIiVbexj1kQMzx5psZkvAfXaStz/PqWqV9kzIwdqwlwHoxfOGfrxk
        /wtCA5UFsx1B/JKefvmmXsbilX+jr0gxB+TqYIXhRaAjLIUyrPw3lRA271Fn+uyHlIRP7P
        b4PVNwfCKTPFOAQWsNehBTOi0y9mal0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-OxWTpTvoM_mGLaGvz4Vgkw-1; Tue, 26 Jan 2021 08:26:04 -0500
X-MC-Unique: OxWTpTvoM_mGLaGvz4Vgkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F3681005513;
        Tue, 26 Jan 2021 13:26:03 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AB3A60C6A;
        Tue, 26 Jan 2021 13:26:02 +0000 (UTC)
Date:   Tue, 26 Jan 2021 08:26:00 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210126132600.GB2158252@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142795294.2171939.2305516748220731694.stgit@magnolia>
 <20210124093953.GC670331@infradead.org>
 <20210125181623.GL2047559@bfoster>
 <20210125185735.GB7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125185735.GB7698@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 10:57:35AM -0800, Darrick J. Wong wrote:
> On Mon, Jan 25, 2021 at 01:16:23PM -0500, Brian Foster wrote:
> > On Sun, Jan 24, 2021 at 09:39:53AM +0000, Christoph Hellwig wrote:
> > > > +	/* We only allow one retry for EDQUOT/ENOSPC. */
> > > > +	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
> > > > +		*retry = false;
> > > > +		return error;
> > > > +	}
> > > 
> > > > +	/* Release resources, prepare for scan. */
> > > > +	xfs_trans_cancel(*tpp);
> > > > +	*tpp = NULL;
> > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > +
> > > > +	/* Try to free some quota for this file's dquots. */
> > > > +	*retry = true;
> > > > +	xfs_blockgc_free_quota(ip, 0);
> > > > +	return 0;
> > > 
> > > I till have grave reservations about this calling conventions.  And if
> > > you just remove the unlock and th call to xfs_blockgc_free_quota here
> > > we don't equire a whole lot of boilerplate code in the callers while
> > > making the code possible to reason about for a mere human.
> > > 
> > 
> > I agree that the retry pattern is rather odd. I'm curious, is there a
> > specific reason this scanning task has to execute outside of transaction
> > context in the first place?
> 
> Dave didn't like the open-coded retry and told me to shrink the call
> sites to:
> 
> 	error = xfs_trans_reserve_quota(...);
> 	if (error)
> 		goto out_trans_cancel;
> 	if (quota_retry)
> 		goto retry;
> 
> So here we are, slowly putting things almost all the way back to where
> they were originally.  Now I have a little utility function:
> 
> /*
>  * Cancel a transaction and try to clear some space so that we can
>  * reserve some quota.  The caller must hold the ILOCK; when this
>  * function returns, the transaction will be cancelled and the ILOCK
>  * will have been released.
>  */
> int
> xfs_trans_cancel_qretry(
> 	struct xfs_trans	*tp,
> 	struct xfs_inode	*ip)
> {
> 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> 
> 	xfs_trans_cancel(tp);
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 
> 	return xfs_blockgc_free_quota(ip, 0);
> }
> 
> Which I guess reduces the amount of call site boilerplate from 4 lines
> to two, only now I've spent half of last week on this.
> 
> > Assuming it does because the underlying work
> > may involve more transactions or whatnot, I'm wondering if this logic
> > could be buried further down in the transaction allocation path.
> > 
> > For example, if we passed the quota reservation and inode down into a
> > new variant of xfs_trans_alloc(), it could acquire the ilock and attempt
> > the quota reservation as a final step (to avoid adding an extra
> > unconditional ilock cycle). If quota res fails, iunlock and release the
> > log res internally and perform the scan. From there, perhaps we could
> > retry the quota reservation immediately without logres or the ilock by
> > saving references to the dquots, and then only reacquire logres/ilock on
> > success..? Just thinking out loud so that might require further
> > thought...
> 
> Yes, that's certainly possible, and probably a good design goal to have
> a xfs_trans_alloc_quota(tres, ip, whichfork, nblks, &tp) that one could
> call to reserve a transaction, lock the inode, and reserve the
> appropriate amounts of quota to handle mapping nblks into an inode fork.
> 
> However, there are complications that don't make this a trivial switch:
> 
> 1. Reflink and (new) swapext don't actually know how many blocks they
> need to reserve until after they've grabbed the two ILOCKs, which means
> that the wrapper is of no use here.
> 

IMO, it's preferable to define a clean/usable interface if we can find
one that covers the majority of use cases and have to open code a
handful of outliers than define a cumbersome interface that must be used
everywhere to accommodate the outliers. Perhaps we'll find cleaner ways
to deal with open coded outliers over time..? Perhaps (at least in the
reflink case) we could attempt a worst case quota reservation with the
helper, knowing that it will have invoked the scan on -EDQUOT, and then
fall back to a more accurate open-coded xfs_trans_reserve_() call (that
will no longer fall into retry loops on failure)..?

> 2. For the remaining quota reservation callsites, you have to deal with
> the bmap code that computes qblocks for reservation against the realtime
> device.  This is opening a huge can of worms because:
> 
> 3. Realtime and quota are not supported, which means that none of that
> code ever gets properly QA'd.  It would be totally stupid to rework most
> of the quota reservation callsites and still leave that logic bomb.
> This gigantic piece of technical debt needs to be paid off, either by
> fixing the functionality and getting it under test, or by dropping rt
> quota support completely and officially.
> 

I'm not following what you're referring to here. Can you point to
examples in the code for reference, please?

Brian

> My guess is that fixing rt quota is probably going to take 10-15
> patches, and doing more small cleanups to convert the callsites will be
> another 10 or so.
> 
> 4. We're already past -rc5, and what started as two cleanup patchsets of
> 13 is now four patchsets of 27 patches, and I /really/ would just like
> to get these patches merged without expanding the scope of work even
> further.
> 
> --D
> 
> > Brian
> > 
> 

