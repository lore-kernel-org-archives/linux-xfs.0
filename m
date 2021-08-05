Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01974C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 22:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBCF860EBB
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 22:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhHEWiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 18:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232319AbhHEWiQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Aug 2021 18:38:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C78E60EBB;
        Thu,  5 Aug 2021 22:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628203081;
        bh=BV76XWXyudjzDdWH/guZUTrBniL4nuXL6wmVrvqeKJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cor4YG/8CI5whlvObgObN9kbfgYzIlkvQgwrLn/WsHlkO0uEykebrnonZ5nFGYhXW
         A3T4mRFfb348Tx+J+XbFPB0+15n9TXkxdD+74eE7u4jJG/Z9qU3g5wJ2mWeeGbYkeP
         a99QXi7RvMRkGX+tRNyl6xFgZmd7zRhfQbgeuwMFl8bDvd1g0dQy/Kt3RmnkB+zaPp
         KGHBhtq2KFUOocjdcL7vw9R2Kmq0bygT/l1TiQa/SUkmSkGvM0tzJQGGAnDXLdxqYI
         zOTLh7XtpUnis+AF8rOePko6xMzez0PGUt1jjEB1VeS4PP27i96X2rW54AT5ZF3ZrO
         9ndGiIoPKgpjw==
Date:   Thu, 5 Aug 2021 15:38:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 05/14] xfs: per-cpu deferred inode inactivation queues
Message-ID: <20210805223801.GA3601443@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812921040.2589546.137433781469727121.stgit@magnolia>
 <20210805064324.GE2757197@dread.disaster.area>
 <20210805070032.GW3601443@magnolia>
 <20210805221502.GF2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805221502.GF2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 06, 2021 at 08:15:02AM +1000, Dave Chinner wrote:
> On Thu, Aug 05, 2021 at 12:00:32AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 05, 2021 at 04:43:24PM +1000, Dave Chinner wrote:
> > > On Wed, Aug 04, 2021 at 07:06:50PM -0700, Darrick J. Wong wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Move inode inactivation to background work contexts so that it no
> > > > longer runs in the context that releases the final reference to an
> > > > inode. This will allow process work that ends up blocking on
> > > > inactivation to continue doing work while the filesytem processes
> > > > the inactivation in the background.
> ....
> > > > @@ -854,6 +884,17 @@ xfs_fs_freeze(
> > > >  	 */
> > > >  	flags = memalloc_nofs_save();
> > > >  	xfs_blockgc_stop(mp);
> > > > +
> > > > +	/*
> > > > +	 * Stop the inodegc background worker.  freeze_super already flushed
> > > > +	 * all pending inodegc work when it sync'd the filesystem after setting
> > > > +	 * SB_FREEZE_PAGEFAULTS, and it holds s_umount, so we know that inodes
> > > > +	 * cannot enter xfs_fs_destroy_inode until the freeze is complete.
> > > > +	 * If the filesystem is read-write, inactivated inodes will queue but
> > > > +	 * the worker will not run until the filesystem thaws or unmounts.
> > > > +	 */
> > > > +	xfs_inodegc_stop(mp);
> > > > +
> > > >  	xfs_save_resvblks(mp);
> > > >  	ret = xfs_log_quiesce(mp);
> > > >  	memalloc_nofs_restore(flags);
> > > 
> > > I still think this freeze handling is problematic. While I can't easily trigger
> > > the problem I saw, I still don't really see what makes the flush in
> > > xfs_fs_sync_fs() prevent races with the final stage of freeze before
> > > inactivation is stopped......
> > > 
> > > .... and ....
> > > 
> > > as I write this the xfs/517 loop goes boom on my pmem test setup (but no DAX):
> > > 
> > > SECTION       -- xfs
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 test3 5.14.0-rc4-dgc #506 SMP PREEMPT Thu Aug 5 15:49:49 AEST 2021
> > > MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/pmem1
> > > MOUNT_OPTIONS -- -o dax=never -o context=system_u:object_r:root_t:s0 /dev/pmem1 /mnt/scratch
> > > 
> > > generic/390 3s ...  3s
> > > xfs/517 43s ... 
> > > Message from syslogd@test3 at Aug  5 15:56:24 ...
> > > kernel:[  162.849634] XFS: Assertion failed: mp->m_super->s_writers.frozen < SB_FREEZE_FS, file: fs/xfs/xfs_icache.c, line: 1889
> > > 
> > > I suspect that we could actually target this better and close the
> > > race by doing something like:
> > > 
> > > xfs_fs_sync_fs()
> > > {
> > > 	....
> > > 
> > > 	/*
> > > 	 * If we are called with page faults frozen out, it means we are about
> > > 	 * to freeze the transaction subsystem. Take the opportunity to shut
> > > 	 * down inodegc because once SB_FREEZE_FS is set it's too late to
> > > 	 * prevent inactivation races with freeze. The fs doesn't get called
> > > 	 * again by the freezing process until after SB_FREEZE_FS has been set,
> > > 	 * so it's now or never.
> > > 	 *
> > > 	 * We don't care if this is a normal syncfs call that does this or
> > > 	 * freeze that does this - we can run this multiple times without issue
> > > 	 * and we won't race with a restart because a restart can only occur when
> > > 	 * the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> > > 	 */
> > > 	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT)
> > > 		xfs_inodegc_stop(mp);
> > 
> > LOL, a previous version of this series actually did this part this way,
> > but...
> > 
> > > }
> > > 
> > > xfs_fs_freeze()
> > > {
> > > .....
> > > error:
> > > 	/*
> > > 	 * We need to restart the inodegc on error because we stopped it at
> > > 	 * SB_FREEZE_PAGEFAULT level and a thaw is not going to be run to
> > > 	 * restart it now. We are at SB_FREEZE_FS level here, so we can restart
> > > 	 * safely without racing with a stop in xfs_fs_sync_fs().
> > > 	 */
> > > 	if (error)
> > > 		xfs_inodegc_start(mp);
> > 
> > ...missed this part.  If this fixes x517 and doesn't break g390 for you,
> > I'll meld it into the series.  I think the reasoning here makes sense.
> 
> Nope, both x517 and g390 still fire this assert, so there's
> something else we're missing here.
> 
> I keep wondering if we should be wrapping the entire flush mechanism
> in a rwsem - read for flush, write for start/stop - so that we
> aren't ever still processing a stop while a concurrent start runs or
> vice versa...

Funny you should mention that, I /do/ have a patch in djwong-dev adding
such a rwsem, though for different purposes (permitting scrub to lock
out freeze requests from userspace).

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
