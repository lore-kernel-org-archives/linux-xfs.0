Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p651t4P8211840 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 20:55:04 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16644179402F
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 18:55:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DkdRaauUW1RxKhuc for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 18:55:01 -0700 (PDT)
Date: Tue, 5 Jul 2011 11:54:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] remove filestreams support?
Message-ID: <20110705015458.GZ561@dastard>
References: <20110704153443.GA21501@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110704153443.GA21501@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jul 04, 2011 at 11:34:43AM -0400, Christoph Hellwig wrote:
> I'd like to know if there are any people actively using the filestreams
> support in XFS (-o filestreams).  It's pretty much a fringe feature, and
> I've not seen any user reports for it, while it never passes all its
> XFSQA tests reliably.  It was added specificly for CXFS media streaming
> operations on one particular array model that hasn't been sold for a
> long time.  The feature purely is an in-memory one so unlike for example
> the realtime device there are no issue about beeing able to read old
> filesystems.  The filestreams specific files are around 1500 lines of
> code, not even counting the hooks in the core XFS codebase.
> 
> If no serious users reply to this mail I'd like to add a deprecation
> warning to the mount option in the Linux 3.0 release cycle, with a goal
> to drop it 4 releases later.

I'm not so concerned about the actual filestreams allocator - it
makes a fair bit of mess through the allocator logic that I've always
disliked. However, there are bits of it that could be useful in
future, and if done right we could retain the filestreams allocator
functionality for those that need it.

That is, the act of assigning an inode or group of inodes to an
allocation group for the express purpose of providing locality of
allocation is useful. I've been looking at using this functionality
for cgroup-aware allocation. In that case, different cgroups would
be assigned different AGs to keep them logically (and potentially
physically) separate, and inodes that are dirtied by a process in
a cgroups would then be associated with the assigned AG.

In fact, I'd suggest that this makes a more sensible method of
implementing a filestreams policy, because simply placing the
competing stream writer processes into separate cgroups would have
the same effect as the current "associate all the files in a
directory our process group is about to create with the same AG"
policy without needing on-disk flags or mount options to trigger
that behaviour.

The worst of the filestreams implementation is the
code needed to handle the potential locking inversions of also
having to get the parent directory inode during allocation to set up
the association, and this would no longer be needed.

It also gets around the problem of having to maintain and time out
associations via reference counts as well (the whole mru cache
thingy), because the cgroup association can be looked up from the
inode whenever it is needed, including during writeback when doing
delayed allocation (dependent on cgroup-aware flusher
infrastructure, but that is in progress). This greatly simplfies the
code that we'd need to maintain as well....

So rather than deprecating the functionality, perhaps we should look
at implementing it through a simpler, more generic, better
integrated interface? That will increase the usefulness of the
functionality for a much wider audience than it has now, and also
provide the virt/blk throttling folk with exactly the "don't cross
the streams" functionality they suggest filesystems are unable to
support easily.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
