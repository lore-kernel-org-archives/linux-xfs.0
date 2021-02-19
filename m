Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECB5C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 17:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6304B64E60
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 17:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBSRXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 12:23:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229919AbhBSRXo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Feb 2021 12:23:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C9F864E60;
        Fri, 19 Feb 2021 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613755383;
        bh=KVzdwOj7FtceSRV81k2DuZJ3qU1clfgDBClaCPLdGMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A81Qe42/5tcGqOmOy73b7uUR81dCtn3jHuFCSkXjd+gmZKJFnIF3Mbvu8moMzXO1P
         kOe7ZAe9PsvlhgiK8guc3gjcT3J++Ik/A75i/bc3YWd3uUBlMYBj1R/NY+jlW41p2c
         DgJ8OnHnHCWQVRJM6nWYSwk3CUKOPBMpgPORaAZIHfnLQBV9YqiaRKetaKDXNMuxmU
         RYGk+qvNYp2FQfVYEjLjwp8HjBwRLZx+EDxjUyikwMOYoT5o37+UNtOMWWwpZ/gM8P
         Sq4hgc6Og3rCcNV07L+FD9fGbYk0+Pf0vfg3mZoOyHzVXf+e6Rh61BKbusUi+mMsHu
         D87Vtbq6QpaEA==
Date:   Fri, 19 Feb 2021 09:23:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't nest transactions when scanning for eofblocks
Message-ID: <20210219172302.GC7193@magnolia>
References: <20210219042940.GB7193@magnolia>
 <20210219130953.GB757814@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219130953.GB757814@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 19, 2021 at 08:09:53AM -0500, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 08:29:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Brian Foster reported a lockdep warning on xfs/167:
> > 
> > ============================================
> > WARNING: possible recursive locking detected
> > 5.11.0-rc4 #35 Tainted: G        W I
> > --------------------------------------------
> > fsstress/17733 is trying to acquire lock:
> > ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > 
> > but task is already holding lock:
> > ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> > 
> > stack backtrace:
> > CPU: 38 PID: 17733 Comm: fsstress Tainted: G        W I       5.11.0-rc4 #35
> > Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
> > Call Trace:
> >  dump_stack+0x8b/0xb0
> >  __lock_acquire.cold+0x159/0x2ab
> >  lock_acquire+0x116/0x370
> >  xfs_trans_alloc+0x1ad/0x310 [xfs]
> >  xfs_free_eofblocks+0x104/0x1d0 [xfs]
> >  xfs_blockgc_scan_inode+0x24/0x60 [xfs]
> >  xfs_inode_walk_ag+0x202/0x4b0 [xfs]
> >  xfs_inode_walk+0x66/0xc0 [xfs]
> >  xfs_trans_alloc+0x160/0x310 [xfs]
> >  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> >  xfs_alloc_file_space+0x105/0x300 [xfs]
> >  xfs_file_fallocate+0x270/0x460 [xfs]
> >  vfs_fallocate+0x14d/0x3d0
> >  __x64_sys_fallocate+0x3e/0x70
> >  do_syscall_64+0x33/0x40
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > The cause of this is the new code that spurs a scan to garbage collect
> > speculative preallocations if we fail to reserve enough blocks while
> > allocating a transaction.  While the warning itself is a fairly benign
> > lockdep complaint, it does bring to light a potential livelock.
> > 
> > Specifically, when we kick off that scan, we're still holding onto the
> > transaction's log reservation.  If the blockgc scan finds something to
> > free, it will need its own transaction, which means that it can block on
> > the log grant.  This means that if there are enough writer threads to
> > take all the log reservation space with that first transaction, the
> > second reservation attempts will all block on log space that cannot be
> > freed, leading to a livelock.
> > 
> 
> The text above around a prospective livelock doesn't seem accurate.
> Otherwise the code looks fine to me. I don't have a preference between
> this patch or the other one...

Doh, that was leftover from when I thought there was a real log
reservation deadlock opportunity.  Will post v2.

--D

> Brian
> 
> > Fix this by freeing the transaction and jumping back to xfs_trans_alloc
> > like this patch in the V4 submission[1].
> > 
> > [1] https://lore.kernel.org/linux-xfs/161142798066.2171939.9311024588681972086.stgit@magnolia/
> > 
> > Fixes: a1a7d05a0576 ("xfs: flush speculative space allocations when we run out of space")
> > Reported-by: Brian Foster <bfoster@redhat.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_trans.c |   13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 44f72c09c203..377f3961d7ed 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -260,6 +260,7 @@ xfs_trans_alloc(
> >  	struct xfs_trans	**tpp)
> >  {
> >  	struct xfs_trans	*tp;
> > +	bool			want_retry = true;
> >  	int			error;
> >  
> >  	/*
> > @@ -267,6 +268,7 @@ xfs_trans_alloc(
> >  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
> >  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
> >  	 */
> > +retry:
> >  	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
> >  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> >  		sb_start_intwrite(mp->m_super);
> > @@ -289,7 +291,9 @@ xfs_trans_alloc(
> >  	tp->t_firstblock = NULLFSBLOCK;
> >  
> >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > -	if (error == -ENOSPC) {
> > +	if (error == -ENOSPC && want_retry) {
> > +		xfs_trans_cancel(tp);
> > +
> >  		/*
> >  		 * We weren't able to reserve enough space for the transaction.
> >  		 * Flush the other speculative space allocations to free space.
> > @@ -297,8 +301,11 @@ xfs_trans_alloc(
> >  		 * other locks.
> >  		 */
> >  		error = xfs_blockgc_free_space(mp, NULL);
> > -		if (!error)
> > -			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > +		if (error)
> > +			return error;
> > +
> > +		want_retry = false;
> > +		goto retry;
> >  	}
> >  	if (error) {
> >  		xfs_trans_cancel(tp);
> > 
> 
