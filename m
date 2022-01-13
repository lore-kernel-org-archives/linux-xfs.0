Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054BAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 20:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiAMUnh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 15:43:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35948 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiAMUnh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 15:43:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22AB7B82368
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 20:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75D3C36AE9;
        Thu, 13 Jan 2022 20:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642106614;
        bh=wMJZZ/KfKLdiPz4sEx2BT6sUrTxhIfBXP2BfGWFROBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PopyraB9CxJJta+kyfFQlo02hi5A8/JwvnxX1tObA7oSzXrpDDt+fW1vC3pKAz1yW
         5kA0h579Oi4clFZ1GCoM6xwfQFI6yp322rJvs41uPyUFqsV/KZKYhUBztENRZ7ED2d
         1cIVkelNKq9+kCg7IENj5FSbW81xQ3pZpL3t3y34+UZYxVMKEDgQVMq1WxkrVIeYHB
         LNS/tiOlCJu8cwpZ5hgDHIT9McyUzFLnjtp/HTMQE0TNUOZrFnbxtWcv2iJE8GZz2R
         dFqkoGOD9/igwE82V9UDCMy9965k90nciqEqgOYQN+IGV3KK9cDKrf0BvEPOJ/4lde
         pqGQFDeeCgZaA==
Date:   Thu, 13 Jan 2022 12:43:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220113204334.GF19198@magnolia>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
 <20220113171347.GD19198@magnolia>
 <YeCEgzMtF7KMLKgh@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeCEgzMtF7KMLKgh@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 13, 2022 at 02:58:59PM -0500, Brian Foster wrote:
> On Thu, Jan 13, 2022 at 09:13:47AM -0800, Darrick J. Wong wrote:
> > On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> > > We've had reports on distro (pre-deferred inactivation) kernels that
> > > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > > lock when invoked on a frozen XFS fs. This occurs because
> > > drop_caches acquires the lock
> > 
> > Eww, I hadn't even noticed drop_caches as a way in to a s_umount
> > deadlock.  Good catch!
> > 
> > > and then blocks in xfs_inactive() on
> > > transaction alloc for an inode that requires an eofb trim. unfreeze
> > > then blocks on the same lock and the fs is deadlocked.
> > > 
> > > With deferred inactivation, the deadlock problem is no longer
> > > present because ->destroy_inode() no longer blocks whether the fs is
> > > frozen or not. There is still unfortunate behavior in that lookups
> > > of a pending inactive inode spin loop waiting for the pending
> > > inactive state to clear, which won't happen until the fs is
> > > unfrozen. This was always possible to some degree, but is
> > > potentially amplified by the fact that reclaim no longer blocks on
> > > the first inode that requires inactivation work. Instead, we
> > > populate the inactivation queues indefinitely. The side effect can
> > > be observed easily by invoking drop_caches on a frozen fs previously
> > > populated with eofb and/or cowblocks inodes and then running
> > > anything that relies on inode lookup (i.e., ls).
> > > 
> > > To mitigate this behavior, invoke internal blockgc reclaim during
> > > the freeze sequence to guarantee that inode eviction doesn't lead to
> > > this state due to eofb or cowblocks inodes. This is similar to
> > > current behavior on read-only remount. Since the deadlock issue was
> > > present for such a long time, also document the subtle
> > > ->destroy_inode() constraint to avoid unintentional reintroduction
> > > of the deadlock problem in the future.
> > 
> > Yay for improved documentation. :)
> > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_super.c | 19 +++++++++++++++++--
> > >  1 file changed, 17 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index c7ac486ca5d3..1d0f87e47fa4 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -623,8 +623,13 @@ xfs_fs_alloc_inode(
> > >  }
> > >  
> > >  /*
> > > - * Now that the generic code is guaranteed not to be accessing
> > > - * the linux inode, we can inactivate and reclaim the inode.
> > > + * Now that the generic code is guaranteed not to be accessing the inode, we can
> > > + * inactivate and reclaim it.
> > > + *
> > > + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
> > > + * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
> > > + * allocation in this context. A transaction alloc that blocks on frozen state
> > > + * from a context with ->s_umount held will deadlock with unfreeze.
> > >   */
> > >  STATIC void
> > >  xfs_fs_destroy_inode(
> > > @@ -764,6 +769,16 @@ xfs_fs_sync_fs(
> > >  	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> > >  	 */
> > >  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> > > +		struct xfs_icwalk	icw = {0};
> > > +
> > > +		/*
> > > +		 * Clear out eofb and cowblocks inodes so eviction while frozen
> > > +		 * doesn't leave them sitting in the inactivation queue where
> > > +		 * they cannot be processed.
> > 
> > Would you mind adding an explicit link in the comment between needing to
> > get /all/ the inodes and _FLAG_SYNC?
> > 
> > "We must process every cached inode, so this requires a synchronous
> > cache scan."
> > 
> 
> I changed it to the following to hopefully make it more descriptive
> without making it longer:
> 
>                 /*
>                  * Run a sync blockgc scan to reclaim all eof and cow blocks so
>                  * eviction while frozen doesn't leave inodes sitting in the
>                  * inactivation queue where they cannot be processed.
>                  */

Works for me.

> > > +		 */
> > > +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > > +		xfs_blockgc_free_space(mp, &icw);
> > 
> > This needs to check the return value, right?
> > 
> 
> What do you want to do with the return value? It looks to me that
> nothing actually checks the return value of ->sync_fs(). freeze_super()
> calls sync_filesystem() and that doesn't, at least. That suggests the fs
> is going to freeze regardless and so we probably don't want to bail out
> of here early, at least. We could just warn on error or something and
> then hand it up the stack anyways.. Hm?

Lovely....

$ git grep -- '->sync_fs('
fs/quota/dquot.c:694:           sb->s_op->sync_fs(sb, 1);
fs/quota/dquot.c:2262:          sb->s_op->sync_fs(sb, 1);
fs/sync.c:56:           sb->s_op->sync_fs(sb, 0);
fs/sync.c:63:           sb->s_op->sync_fs(sb, 1);
fs/sync.c:78:           sb->s_op->sync_fs(sb, *(int *)arg);

Indeed, nobody checks the return value.  Let me do some spelunking...

...ok, so ->sync_fs was introduced in 2.5.52:

https://elixir.bootlin.com/linux/v2.5.52/source/include/linux/fs.h#L814

and everybody has ignored the return code since then, despite syncfs(2)
(which /does/ have a return value) being introduced in 2.6.39.  As you
point out, fsfreeze also ignores the return value, which seems suspect
to me.

I /think/ the correct solution here is to fix the entire syncfs ->
sync_filesystem -> ->sync_fs() path to return error codes; fix fsfreeze
to abort if sync_filesystem returns an error; fix xfs_fs_reconfigure to
stop ignoring the return value when remounting; and then apply this
patch.

However, seeing how vfs debates tend to drag on, I'd be willing to
accept this patch if on error it would force_shutdown the filesystem
(and a third patch containing the xfs_fs_reconfigure fix), and a second
series to fix the vfs and remove that shutdown crutch.

How does that sound?

--D

> 
> Brian
> 
> > --D
> > 
> > > +
> > >  		xfs_inodegc_stop(mp);
> > >  		xfs_blockgc_stop(mp);
> > >  	}
> > > -- 
> > > 2.31.1
> > > 
> > 
> 
