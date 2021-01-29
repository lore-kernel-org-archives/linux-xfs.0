Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D26C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 17:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 128D664E05
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 17:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhA2RhY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 12:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhA2RfU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Jan 2021 12:35:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B63AE64E05;
        Fri, 29 Jan 2021 17:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611941670;
        bh=ITq5igd+T87Zvqu0GYWZwTHCSVZPd8svOnWGRzXSRWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GqvLHsK5Cu4HXk+/oON9zTGeU1dyqm5/lGbR8gMtICiypviYnTJ2ymIM1NDviApfc
         tXoI/O/Y8hausSrlidqYhiF3vK0pgDj1AMv53vH2I6kjWai5bdPM2aDFp2yIOtkTmY
         0COOSqp8yVsf6rKtCublv7dE5ZiaSF7yxObd1nvyTYVuw2OswOn85biEMlEtVv4wtz
         CWgUqiWBae5Ac/tsWt4knuENRbuxjcPaqJs5JBbkPN9hCYi+tvMGxPvtEFn23xekBp
         5ixLzglwL2RGYNsXgpAAyWxek1I5T1BQEVWcjr9wY7Q/tpZiiKSZpRkx2bFjWi1Fua
         Wjfn0SZ/DmGAg==
Date:   Fri, 29 Jan 2021 09:34:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 12/12] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210129173430.GH7695@magnolia>
References: <161188666613.1943978.971196931920996596.stgit@magnolia>
 <161188673444.1943978.15159087396736987395.stgit@magnolia>
 <20210129161047.GH2665284@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129161047.GH2665284@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 29, 2021 at 11:10:47AM -0500, Brian Foster wrote:
> On Thu, Jan 28, 2021 at 06:18:54PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a fs modification (creation, file write, reflink, etc.) is unable to
> > reserve enough space to handle the modification, try clearing whatever
> > space the filesystem might have been hanging onto in the hopes of
> > speeding up the filesystem.  The flushing behavior will become
> > particularly important when we add deferred inode inactivation because
> > that will increase the amount of space that isn't actively tied to user
> > data.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_trans.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index b08bb5a8fb60..3c2b26a21c6d 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -289,6 +289,18 @@ xfs_trans_alloc(
> >  	tp->t_firstblock = NULLFSBLOCK;
> >  
> >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > +	if (error == -ENOSPC) {
> > +		/*
> > +		 * We weren't able to reserve enough space for the transaction.
> > +		 * Flush the other speculative space allocations to free space.
> > +		 * Do not perform a synchronous scan because callers can hold
> > +		 * other locks.
> > +		 */
> > +		error = xfs_blockgc_free_space(mp, NULL);
> > +		if (error)
> > +			return error;
> > +		error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > +	}
> 
> We probably want to cancel the transaction if the scan fails. Perhaps
> tweak this to:
> 
> 		...
> 		error = xfs_blockgc_free_space(mp, NULL);
> 		if (!error)
> 			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> 	}
> 	...
> 
> Hm?

Doh, yes, good catch!  Will fix.

--D

> Brian
> 
> >  	if (error) {
> >  		xfs_trans_cancel(tp);
> >  		return error;
> > 
> 
