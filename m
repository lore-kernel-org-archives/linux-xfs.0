Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AF2C433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Jan 2022 22:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiAWWnw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Jan 2022 17:43:52 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56113 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229944AbiAWWnv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jan 2022 17:43:51 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F3D1B10C3792;
        Mon, 24 Jan 2022 09:43:47 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nBlaM-003Q3T-C9; Mon, 24 Jan 2022 09:43:46 +1100
Date:   Mon, 24 Jan 2022 09:43:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220123224346.GJ59729@dread.disaster.area>
References: <20220121142454.1994916-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121142454.1994916-1-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61edda25
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=wUPi4CxvGOlWWrG8X90A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 09:24:54AM -0500, Brian Foster wrote:
> The XFS inode allocation algorithm aggressively reuses recently
> freed inodes. This is historical behavior that has been in place for
> quite some time, since XFS was imported to mainline Linux. Once the
> VFS adopted RCUwalk path lookups (also some time ago), this behavior
> became slightly incompatible because the inode recycle path doesn't
> isolate concurrent access to the inode from the VFS.
> 
> This has recently manifested as problems in the VFS when XFS happens
> to change the type or properties of a recently unlinked inode while
> still involved in an RCU lookup. For example, if the VFS refers to a
> previous incarnation of a symlink inode, obtains the ->get_link()
> callback from inode_operations, and the latter happens to change to
> a non-symlink type via a recycle event, the ->get_link() callback
> pointer is reset to NULL and the lookup results in a crash.
> 
> To avoid this class of problem, isolate in-core inodes for recycling
> with an RCU grace period. This is the same level of protection the
> VFS expects for inactivated inodes that are never reused, and so
> guarantees no further concurrent access before the type or
> properties of the inode change. We don't want an unconditional
> synchronize_rcu() event here because that would result in a
> significant performance impact to mixed inode allocation workloads.
> 
> Fortunately, we can take advantage of the recently added deferred
> inactivation mechanism to mitigate the need for an RCU wait in most
> cases. Deferred inactivation queues and batches the on-disk freeing
> of recently destroyed inodes, and so significantly increases the
> likelihood that a grace period has elapsed by the time an inode is
> freed and observable by the allocation code as a reuse candidate.
> Capture the current RCU grace period cookie at inode destroy time
> and refer to it at allocation time to conditionally wait for an RCU
> grace period if one hadn't expired in the meantime.  Since only
> unlinked inodes are recycle candidates and unlinked inodes always
> require inactivation, we only need to poll and assign RCU state in
> the inactivation codepath.

I think this assertion is incorrect.

Recycling can occur on any inode that has been evicted from the VFS
cache. i.e. while the inode is sitting in XFS_IRECLAIMABLE state
waiting for the background inodegc to run (every ~5s by default) a
->lookup from the VFS can occur and we find that same inode sitting
there in XFS_IRECLAIMABLE state. This lookup then hits the recycle
path.

In this case, even though we re-instantiate the inode into the same
identity, it goes through a transient state where the inode has it's
identity returned to the default initial "just allocated" VFS state
and this transient state can be visible from RCU lookups within the
RCU grace period the inode was evicted from. This means the RCU
lookup could see the inode with i_ops having been reset to
&empty_ops, which means any method called on the inode at this time
(e.g. ->get_link) will hit a NULL pointer dereference.

This requires multiple concurrent lookups on the same inode that
just got evicted, some which the RCU pathwalk finds the old stale
dentry/inode pair, and others that don't find that old pair. This is
much harder to trip over but, IIRC, we used to see this quite a lot
with NFS server workloads when multiple operations on a single inode
could come in from multiple clients and be processed in parallel by
knfsd threads. This was quite a hot path before the NFS server had an
open-file cache added to it, and it probably still is if the NFS
server OFC is not large enough for the working set of files being
accessed...

Hence we have to ensure that RCU lookups can't find an evicted inode
through anything other than xfs_iget() while we are re-instantiating
the VFS inode state in xfs_iget_recycle().  Hence the RCU state
sampling needs to be done unconditionally for all inodes going
through ->destroy_inode so we can ensure grace periods expire for
all inodes being recycled, not just those that required
inactivation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
