Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF78C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 21:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355886AbhLFVzS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 16:55:18 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41531 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355557AbhLFVzS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 16:55:18 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 2A45C8698E8;
        Tue,  7 Dec 2021 08:51:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1muLtf-00HYfB-MA; Tue, 07 Dec 2021 08:51:43 +1100
Date:   Tue, 7 Dec 2021 08:51:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Gonzalo Siero Humet <gsierohu@redhat.com>
Subject: Re: [RFD] XFS inode reclaim (inactivation) under fs freeze
Message-ID: <20211206215143.GI449541@dread.disaster.area>
References: <Ya5IeB3iBBcpD1z+@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya5IeB3iBBcpD1z+@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61ae85f1
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=7-415B0cAAAA:8
        a=Q99jk5y9W0baHjx8qOUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 06, 2021 at 12:29:28PM -0500, Brian Foster wrote:
> Hi,
> 
> We have reports on distro (pre-deferred inactivation) kernels that inode
> reclaim (i.e. via drop_caches) can deadlock on the s_umount lock when
> invoked on a frozen XFS fs. This occurs because drop_caches acquires the
> lock and then blocks in xfs_inactive() on transaction alloc for an inode
> that requires an eofb trim. Unfreeze blocks on the same lock and thus
> the fs is deadlocked (in a frozen state). As far as I'm aware, this has
> been broken for some time and probably just not observed because reclaim
> under freeze is a rare and unusual situation.
>     
> With deferred inactivation, the deadlock problem actually goes away
> because ->destroy_inode() will never block when the filesystem is
> frozen. There is new/odd behavior, however, in that lookups of a pending
> inactive inode spin loop waiting for the pending inactive state to
> clear. That won't happen until the fs is unfrozen.

That's existing behaviour for any inode that is stuck waiting for
inactivation, regardless of how it is stuck. We've always had
situations where lookups would spin waiting on indoes when there are
frozen filesystems preventing XFS_IRECLAIMABLE inodes from making
progress.

IOWs, this is not new behaviour - accessing files stuck in reclaim
during freeze have done this for a couple of decades now...

> Also, the deferred inactivation queues are not consistently flushed on
> freeze. I've observed that xfs_freeze invokes an xfs_inodegc_flush()
> indirectly via xfs_fs_statfs(), but fsfreeze does not.

Userspace does not need to flush the inactivatin queues on freeze -
- the XFS kernel side freeze code has a full queue flush in it. It's
a bit subtle, but it is there.

> Therefore, I
> suspect it may be possible to land in this state from the onset of a
> freeze based on prior reclaim behavior. (I.e., we may want to make this
> flush explicit on freeze, depending on the eventual solution.)

xfs_inodegc_stop() does a full queue flush and it's called during
freeze from xfs_fs_sync_fs() after the page faults have been frozen
and waited on. i.e. it does:

	xfs_inodegc_queue_all()
	for_each_online_cpu(cpu) {
		gc = per_cpu_ptr(mp->m_inodegc, cpu);
		cancel_work_sync(&gc->work);
	}

xfs_inodegc_queue_all() queues works all the pending non-empty per
cpu queues, then we run cancel_work_sync() on them.
cancel_work_sync() runs __flush_work() internally, and so
it is almost the same as running { flush_work(); cancel_work(); }
except that it serialises against other attemps to queue/cancel as
it marks the work as having a cancel in progress.

> Some internal discussion followed on potential improvements in response
> to the deadlock report. Dave suggested potentially preventing reclaim of
> inodes that would require inactivation, keeping them in cache, but it
> appears we may not have enough control in the local fs to guarantee this
> behavior out of the vfs and shrinkers (Dave can chime in on details, if
> needed).

My idea was to check for inactivation being required in ->drop_inode
and preventing linked inodes from being immediately reclaimed and
hence inactivated by ensuring they always remain in the VFS cache.

This does not work because memory pressure will run the shrinkers
and the inode cache shrinker does not give us an opportunity to say
"do not reclaim this inode" before it evicts them from cache. Hence
we'll get linked inodes that require inactivation work through the
shrinker rather than from iput_final.

> He also suggested skipping eofb trims and sending such inodes
> directly to reclaim.

This is what we do on read-only filesystems. This is exactly what
happens if a filesystem is remounted RO with open files backed by
clean inodes that have post-eof speculative preallocation attached
when the remount occurs. This would just treat frozen filesystems
the same as we currently treat remount,ro situations.

> My current preference is to invoke an inodegc flush
> and blockgc scan during the freeze sequence so presumably no pending
> inactive but potentially accessible (i.e. not unlinked) inodes can
> reside in the queues for the duration of a freeze. Perhaps others have
> different ideas or thoughts on these.

We have xfs_blockgc_flush_all() to do such a scan. We only do that
at hard ENOSPC right now because it's an expensive, slow operation,
especially if we have large caches and the system is under heavy CPU
load. I'm not sure we really want to force such an operation to be
performed during a freeze - freeze is supposed to put the filesystem
into a consistent state on disk as fast as possible with minimum
system-wide interruption. Doing stuff like force-trimming all
post-eof speculative prealloc is not necessary to make the on-disk
format consistent. Hence force-trimming seems more harmful to me
than just treating the frozen state like a temporary RO state in
terms of blockgc....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
