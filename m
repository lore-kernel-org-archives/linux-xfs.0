Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89616C432BE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B29A6056B
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236592AbhHEHAr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 03:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235991AbhHEHAr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Aug 2021 03:00:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 682F160ED6;
        Thu,  5 Aug 2021 07:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628146833;
        bh=jqmih2Qcvl0SjAhwf7kEeOXhjR4dY5TGRJfxqwM+A+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iqrpDb/djz8za5V0mZHYxsuwFgSzFgKD3e53lCt2m6/jDM0AXTgRUTepeJ1x+nUaK
         Ls+eLIeyR5tgrsFU+UWChH3L/2k41bCmZxrc9KggnT+Rjr8MJg/thRmQYz7O5tGDHl
         reJ1CAGP75HH3o8sugclSawDjr2iaEzHHlwIceMJWyaZO5P4jyQYJUnLHIGmzSZxF8
         miokpaJG6WIOShdCyZeugFwL/hVMmnOAOlGPED04JKGlzTfIPXV/GOg0nOVnotuoGV
         sUjuFR4zp/zVusZe0a0IvZxlFoDyWHYIzO+kU/EqAFKvNG64O3eY4NFABh31RQQGLd
         Tx/hLerIyBnUA==
Date:   Thu, 5 Aug 2021 00:00:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 05/14] xfs: per-cpu deferred inode inactivation queues
Message-ID: <20210805070032.GW3601443@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812921040.2589546.137433781469727121.stgit@magnolia>
 <20210805064324.GE2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805064324.GE2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 05, 2021 at 04:43:24PM +1000, Dave Chinner wrote:
> On Wed, Aug 04, 2021 at 07:06:50PM -0700, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Move inode inactivation to background work contexts so that it no
> > longer runs in the context that releases the final reference to an
> > inode. This will allow process work that ends up blocking on
> > inactivation to continue doing work while the filesytem processes
> > the inactivation in the background.
> > 
> > A typical demonstration of this is unlinking an inode with lots of
> > extents. The extents are removed during inactivation, so this blocks
> > the process that unlinked the inode from the directory structure. By
> > moving the inactivation to the background process, the userspace
> > applicaiton can keep working (e.g. unlinking the next inode in the
> > directory) while the inactivation work on the previous inode is
> > done by a different CPU.
> > 
> > The implementation of the queue is relatively simple. We use a
> > per-cpu lockless linked list (llist) to queue inodes for
> > inactivation without requiring serialisation mechanisms, and a work
> > item to allow the queue to be processed by a CPU bound worker
> > thread. We also keep a count of the queue depth so that we can
> > trigger work after a number of deferred inactivations have been
> > queued.
> > 
> > The use of a bound workqueue with a single work depth allows the
> > workqueue to run one work item per CPU. We queue the work item on
> > the CPU we are currently running on, and so this essentially gives
> > us affine per-cpu worker threads for the per-cpu queues. THis
> > maintains the effective CPU affinity that occurs within XFS at the
> > AG level due to all objects in a directory being local to an AG.
> > Hence inactivation work tends to run on the same CPU that last
> > accessed all the objects that inactivation accesses and this
> > maintains hot CPU caches for unlink workloads.
> > 
> > A depth of 32 inodes was chosen to match the number of inodes in an
> > inode cluster buffer. This hopefully allows sequential
> > allocation/unlink behaviours to defering inactivation of all the
> > inodes in a single cluster buffer at a time, further helping
> > maintain hot CPU and buffer cache accesses while running
> > inactivations.
> > 
> > A hard per-cpu queue throttle of 256 inode has been set to avoid
> > runaway queuing when inodes that take a long to time inactivate are
> > being processed. For example, when unlinking inodes with large
> > numbers of extents that can take a lot of processing to free.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [djwong: tweak comments and tracepoints, convert opflags to state bits]
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> .....
> > @@ -740,6 +751,25 @@ xfs_fs_sync_fs(
> >  		flush_delayed_work(&mp->m_log->l_work);
> >  	}
> >  
> > +	/*
> > +	 * Flush all deferred inode inactivation work so that the free space
> > +	 * counters will reflect recent deletions.  Do not force the log again
> > +	 * because log recovery can restart the inactivation from the info that
> > +	 * we just wrote into the ondisk log.
> > +	 *
> > +	 * For regular operation this isn't strictly necessary since we aren't
> > +	 * required to guarantee that unlinking frees space immediately, but
> > +	 * that is how XFS historically behaved.
> > +	 *
> > +	 * If, however, the filesystem is at FREEZE_PAGEFAULTS, this is our
> > +	 * last chance to complete the inactivation work before the filesystem
> > +	 * freezes and the log is quiesced.  The background worker will not
> > +	 * activate again until the fs is thawed because the VFS won't evict
> > +	 * any more inodes until freeze_super drops s_umount and we disable the
> > +	 * worker in xfs_fs_freeze.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -854,6 +884,17 @@ xfs_fs_freeze(
> >  	 */
> >  	flags = memalloc_nofs_save();
> >  	xfs_blockgc_stop(mp);
> > +
> > +	/*
> > +	 * Stop the inodegc background worker.  freeze_super already flushed
> > +	 * all pending inodegc work when it sync'd the filesystem after setting
> > +	 * SB_FREEZE_PAGEFAULTS, and it holds s_umount, so we know that inodes
> > +	 * cannot enter xfs_fs_destroy_inode until the freeze is complete.
> > +	 * If the filesystem is read-write, inactivated inodes will queue but
> > +	 * the worker will not run until the filesystem thaws or unmounts.
> > +	 */
> > +	xfs_inodegc_stop(mp);
> > +
> >  	xfs_save_resvblks(mp);
> >  	ret = xfs_log_quiesce(mp);
> >  	memalloc_nofs_restore(flags);
> 
> I still think this freeze handling is problematic. While I can't easily trigger
> the problem I saw, I still don't really see what makes the flush in
> xfs_fs_sync_fs() prevent races with the final stage of freeze before
> inactivation is stopped......
> 
> .... and ....
> 
> as I write this the xfs/517 loop goes boom on my pmem test setup (but no DAX):
> 
> SECTION       -- xfs
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test3 5.14.0-rc4-dgc #506 SMP PREEMPT Thu Aug 5 15:49:49 AEST 2021
> MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/pmem1
> MOUNT_OPTIONS -- -o dax=never -o context=system_u:object_r:root_t:s0 /dev/pmem1 /mnt/scratch
> 
> generic/390 3s ...  3s
> xfs/517 43s ... 
> Message from syslogd@test3 at Aug  5 15:56:24 ...
> kernel:[  162.849634] XFS: Assertion failed: mp->m_super->s_writers.frozen < SB_FREEZE_FS, file: fs/xfs/xfs_icache.c, line: 1889
> 
> I suspect that we could actually target this better and close the
> race by doing something like:
> 
> xfs_fs_sync_fs()
> {
> 	....
> 
> 	/*
> 	 * If we are called with page faults frozen out, it means we are about
> 	 * to freeze the transaction subsystem. Take the opportunity to shut
> 	 * down inodegc because once SB_FREEZE_FS is set it's too late to
> 	 * prevent inactivation races with freeze. The fs doesn't get called
> 	 * again by the freezing process until after SB_FREEZE_FS has been set,
> 	 * so it's now or never.
> 	 *
> 	 * We don't care if this is a normal syncfs call that does this or
> 	 * freeze that does this - we can run this multiple times without issue
> 	 * and we won't race with a restart because a restart can only occur when
> 	 * the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> 	 */
> 	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT)
> 		xfs_inodegc_stop(mp);

LOL, a previous version of this series actually did this part this way,
but...

> }
> 
> xfs_fs_freeze()
> {
> .....
> error:
> 	/*
> 	 * We need to restart the inodegc on error because we stopped it at
> 	 * SB_FREEZE_PAGEFAULT level and a thaw is not going to be run to
> 	 * restart it now. We are at SB_FREEZE_FS level here, so we can restart
> 	 * safely without racing with a stop in xfs_fs_sync_fs().
> 	 */
> 	if (error)
> 		xfs_inodegc_start(mp);

...missed this part.  If this fixes x517 and doesn't break g390 for you,
I'll meld it into the series.  I think the reasoning here makes sense.

--D

> 	return error:
> }
> 
> The stop and "restart on error" are done under the same s_umount hold, so they
> are atomic w.r.t. to other freeze operations so doesn't have the problems with
> nested freeze/thaw (g/390) that my last patch had.
> 
> Your thoughts?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
