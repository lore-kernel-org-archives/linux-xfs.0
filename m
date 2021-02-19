Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58485C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 13:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A9864EAF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 13:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBSNLF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 08:11:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhBSNLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Feb 2021 08:11:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613740177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QUc1V+7IypR/EHEGl0V+abvmhxGsqdZoMXgTIgB7jNI=;
        b=fsLKbHN4Qy45s+3X+h70Idej57UiMDTJQbUb7yCkgQpPU/mNj6avwwlVMl5EDOxBLjIau6
        zhX1Uek0sIC3XLNXxnV5GpqBBveSUwxijklSM1JF7ErN4OsdgL26lhI/WfnUc6129ID3F5
        S345Vzn+3a5WWPtRaZjJ657htFkvZro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-qvsrqDjpOlKpYDY8hD-2cg-1; Fri, 19 Feb 2021 08:09:35 -0500
X-MC-Unique: qvsrqDjpOlKpYDY8hD-2cg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3563107ACE6;
        Fri, 19 Feb 2021 13:09:34 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 496D663B8C;
        Fri, 19 Feb 2021 13:09:34 +0000 (UTC)
Date:   Fri, 19 Feb 2021 08:09:32 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't call into blockgc scan with freeze protection
Message-ID: <20210219130932.GA757814@bfoster>
References: <20210218201458.718889-1-bfoster@redhat.com>
 <20210219032309.GX7193@magnolia>
 <20210219045658.GF4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219045658.GF4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 19, 2021 at 03:56:58PM +1100, Dave Chinner wrote:
> On Thu, Feb 18, 2021 at 07:23:09PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 18, 2021 at 03:14:58PM -0500, Brian Foster wrote:
> > > fstest xfs/167 produced a lockdep splat that complained about a
> > > nested transaction acquiring freeze protection during an eofblocks
> > > scan. Drop freeze protection around the block reclaim scan in the
> > > transaction allocation code to avoid this problem.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
...
> > >  fs/xfs/xfs_trans.c | 19 ++++++++++++++-----
> > >  1 file changed, 14 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 44f72c09c203..c32c62d3b77a 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
...
> > > @@ -288,19 +289,27 @@ xfs_trans_alloc(
> > >  	INIT_LIST_HEAD(&tp->t_dfops);
> > >  	tp->t_firstblock = NULLFSBLOCK;
> > >  
> > > +retry:
> > >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > -	if (error == -ENOSPC) {
> > > +	if (error == -ENOSPC && !retried) {
> > >  		/*
> > >  		 * We weren't able to reserve enough space for the transaction.
> > >  		 * Flush the other speculative space allocations to free space.
> > >  		 * Do not perform a synchronous scan because callers can hold
> > >  		 * other locks.
> > >  		 */
> > > +		retried = true;
> > > +		if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> > > +			sb_end_intwrite(mp->m_super);
> > >  		error = xfs_blockgc_free_space(mp, NULL);
> > > -		if (!error)
> > > -			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > -	}
> > > -	if (error) {
> > > +		if (error) {
> > > +			kmem_cache_free(xfs_trans_zone, tp);
> > > +			return error;
> > > +		}
> 
> This seems dangerous to me. If xfs_trans_reserve() adds anything to
> the transaction even if it fails, this will fail to free it. e.g.
> xfs_log_reserve() call allocate a ticket and attach it to the
> transaction and *then fail*. This code will now leak that ticket.
> 

xfs_trans_reserve() ungrants the log ticket (which frees it, at least in
the allocation case) and disassociates from the transaction on error, so
I don't see how this causes any problems.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

