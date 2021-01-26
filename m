Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F274FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 20:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A318C22A83
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 20:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbhAZFTC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730810AbhAZBpL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 20:45:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1AEA230FF;
        Tue, 26 Jan 2021 00:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611620943;
        bh=umEP6264tJiQQq+8Lg6Cx26qTba/MjF85eUxJ11rzhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kf4L7TSHQMXI4qdbmGty7v/eeQ4Y7Nv7HH/SiVh59KB1Ir/+/dH5uWlrx2zxUQNjd
         yv4v4/b63bkx95LAg19jZCfY0itir8lgKxERI7zA9CBF4maeVSgsPBNXaW87vg2xqp
         Tt46O9XXCHRlt6zO52wCwFht6N3JXNhH4Ir++38rXT9CcTF4T/4bzEIMF+Qjyy7Mck
         bBcF0gpCS8hFPV4a0iZRU6yKOoLWdPmoR7DxScdDM7UkQT2fOjqW+LcfuYE7sncdrb
         mxuKB6euJGFZnfGv0Uw3kbD3ftUxhJeQCY3FU5ANWJnh0B8RHlpEkPeydo2g7mpUOF
         vzCDkW9Ne1OIg==
Date:   Mon, 25 Jan 2021 16:29:01 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210126002901.GI7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142798066.2171939.9311024588681972086.stgit@magnolia>
 <20210124094816.GE670331@infradead.org>
 <20210125200216.GE7698@magnolia>
 <20210125210628.GP2047559@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125210628.GP2047559@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 04:06:28PM -0500, Brian Foster wrote:
> On Mon, Jan 25, 2021 at 12:02:16PM -0800, Darrick J. Wong wrote:
> > On Sun, Jan 24, 2021 at 09:48:16AM +0000, Christoph Hellwig wrote:
> > > > +retry:
> > > >  	/*
> > > >  	 * Allocate the handle before we do our freeze accounting and setting up
> > > >  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
> > > > @@ -285,6 +289,22 @@ xfs_trans_alloc(
> > > >  	tp->t_firstblock = NULLFSBLOCK;
> > > >  
> > > >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > > +	if (error == -ENOSPC && tries > 0) {
> > > > +		xfs_trans_cancel(tp);
> > > > +
> > > > +		/*
> > > > +		 * We weren't able to reserve enough space for the transaction.
> > > > +		 * Flush the other speculative space allocations to free space.
> > > > +		 * Do not perform a synchronous scan because callers can hold
> > > > +		 * other locks.
> > > > +		 */
> > > > +		error = xfs_blockgc_free_space(mp, NULL);
> > > > +		if (error)
> > > > +			return error;
> > > > +
> > > > +		tries--;
> > > > +		goto retry;
> > > > +	}
> > > >  	if (error) {
> > > >  		xfs_trans_cancel(tp);
> > > >  		return error;
> > > 
> > > Why do we need to restart the whole function?  A failing
> > > xfs_trans_reserve should restore tp to its initial state, and keeping
> > > the SB_FREEZE_FS counter increased also doesn't look harmful as far as

I'm curious about your motivation for letting transaction nest here.
Seeing as the ENOSPC return should be infrequent, are you simply not
wanting to cycle the memory allocators and the FREEZE_FS counters?

Hm.  I guess at this point the only resources we hold are the FREEZE_FS
counter and *tp itself.  The transaction doesn't have any log space
grants or block reservation associated with it, and I guess we're not in
PF_MEMALLOC_NOFS mode either.  So I guess this is ok, except...

> > > I can tell.  So why not:
> > > 
> > > 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > 	if (error == -ENOSPC) {
> > > 		/*
> > > 		 * We weren't able to reserve enough space for the transaction.
> > > 		 * Flush the other speculative space allocations to free space.
> > > 		 * Do not perform a synchronous scan because callers can hold
> > > 		 * other locks.
> > > 		 */
> > > 		error = xfs_blockgc_free_space(mp, NULL);
> > 
> > xfs_blockgc_free_space runs the blockgc scan directly, which means that
> > it creates transactions to free blocks.  Since we can't have nested
> > transactions, we have to drop tp here.
> > 
> 
> Technically, I don't think it's a problem to hold a transaction memory
> allocation (and superblock write access?) while diving into the scanning
> mechanism.

...except that doing so will collide with what we've been telling Yafang
(as part of his series to detect nested transactions) as far as when is
the appropriate time to set current->journal_info/PF_MEMALLOC_NOFS.

> BTW, this also looks like a landmine passing a NULL eofb into
> the xfs_blockgc_free_space() tracepoint.

Errk, will fix that.

--D

> Brian
> 
> > --D
> > 
> > > 		if (error)
> > > 			return error;
> > > 		error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > 	}
> > >  	if (error) {
> > >   		xfs_trans_cancel(tp);
> > >   		return error;
> > > 
> > > ?
> > 
> 
