Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A0D77F58
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 00:11:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C49C5AC005
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 22:11:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BsHYzYIdmLJjTEf7 for <xfs@oss.sgi.com>;
	Tue, 01 Apr 2014 22:11:06 -0700 (PDT)
Date: Wed, 2 Apr 2014 16:11:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: run an eofblocks scan on ENOSPC/EDQUOT
Message-ID: <20140402051103.GL17603@dastard>
References: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
	<1396012563-60973-5-git-send-email-bfoster@redhat.com>
	<20140331222246.GF17603@dastard>
	<20140401135518.GC21540@bfoster.bfoster>
	<20140401211926.GH17603@dastard>
	<20140401232022.GA15934@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140401232022.GA15934@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 01, 2014 at 07:20:23PM -0400, Brian Foster wrote:
> On Wed, Apr 02, 2014 at 08:19:26AM +1100, Dave Chinner wrote:
> > On Tue, Apr 01, 2014 at 09:55:18AM -0400, Brian Foster wrote:
> > Yes, it means that there is a global flush when a project quota runs
> > out of space, but it means that we only do it once and we don't burn
> > excessive CPU walking radix trees scanning inodes needlessly every
> > time we get a storm of processes hammering project quota ENOSPC.
> > 
> 
> It's not clear to me that excess scanning is an issue, but it seems

Have 100 threads hit ENOSPC on the same project quota at the same
time on a filesystem with a couple of thousand AGs with a few
million cached inode, and then you'll see the problem....

> orthogonal to how we organize the enospc logic (at least once the flush
> is out of the equation). IOW, we'll invoke the scanner with the same
> frequency either way. Or maybe you are just referring to scanning
> specifically for the purpose of doing flushes as a waste..?

Well, lots of concurrent scanning for the same purpose is highly
inefficient - look at the amount of additional serialisation in the
inode recalim walker that is aimed at reducing concurrency to one
reclaim thread per AG at a time...

I expect that if the serialisation on xfs_flush_inodes() isn't
sufficient to throttle eofblock scanning concurrency in case like
the above then we'll know about it pretty quickly.

> > > simplify things. The helper can run the quota scan and/or the global
> > > scan based on the data regarding the situation (i.e., the inode and
> > > associated quota characteristics). This allows us to preserve the notion
> > > of attempting a lightweight recovery first and a heavyweight recovery
> > > second, reserving the inode flush for when space is truly tight.
> > > Thoughts?
> > 
> > It's still damn clunky, IMO. It's still trying to work around the
> > fact that project quotas use ENOSPC rather than EDQUOT, and that
> > makes the logic rather twisted. And it still has that hidden data
> > flush in it so it can't really be called lightweight...
> > 
> 
> Ok. Well if the high level logic is the issue, we could still turn that
> inside out a bit to use your EDQUOT/ENOSPC logic, yet still preserve the
> standalone eofblocks scan. It might be a few more lines, but perhaps
> more clear. E.g.:
> 
> 	if (ret == -EDQUOT && !enospc) {
> 		enospc = 1;
> 		xfs_inode_free_quota_eofblocks(ip);
> 		goto retry;
> 	else if (ret == -ENOSPC && !enospc) {
> 		if (!scanned) {
> 			struct xfs_eofblocks eofb = {0};
> 			...
> 			scanned = 1;
> 			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> 			goto retry;
> 		}
> 
> 		enospc = 1;
> 		xfs_flush_inodes(ip->i_mount);
> 		goto retry;
> 	}
> 
> Thoughts on that?

Even more convoluted. :/

Look at it this way - I've never been a fan of this "retry write on
enospc once" code. It's a necessary evil due to the reality of
locking orders and having to back out of the write far enough to
safely trigger dirty inode writeback so we *might* be able to write
this data. Making this code more finicky and tricky is the last
thing I think we should be doing.

I don't have any better ideas at this point - I'm still tired and
jetlagged and need to sort out everything for a merge window pull of
the current tree, so time for me to think up a creative solution is
limited. I'm hoping that you might be able to think of a different
way entirely of doing this "write retry on ENOSPC" that dolves all
these problems simply and easily ;)

> We'll handle project quota ENOSPC just as we handle
> global ENOSPC with respect to the scan and the flush, but we'll still
> have the opportunity to free up a decent amount of space without
> initiating I/O. The project quota scan down in free_quota_eofblocks()
> might be rendered pointless as well.

Well, therein lies an avenue of investigation: for EOF block
trimming, why would we need to do a flush first, even for project
quotas? And if we aren't going to flush data, why does it need to be
done at this level? Can it be done deep in the quota code where we
know exactly what quota ran out of space?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
