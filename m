Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 757007F58
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 16:19:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6A6BAC005
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 14:19:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gvuutkTXVtbGz10S for <xfs@oss.sgi.com>;
	Tue, 01 Apr 2014 14:19:40 -0700 (PDT)
Date: Wed, 2 Apr 2014 08:19:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: run an eofblocks scan on ENOSPC/EDQUOT
Message-ID: <20140401211926.GH17603@dastard>
References: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
	<1396012563-60973-5-git-send-email-bfoster@redhat.com>
	<20140331222246.GF17603@dastard>
	<20140401135518.GC21540@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140401135518.GC21540@bfoster.bfoster>
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

On Tue, Apr 01, 2014 at 09:55:18AM -0400, Brian Foster wrote:
> On Tue, Apr 01, 2014 at 09:22:47AM +1100, Dave Chinner wrote:
> > On Fri, Mar 28, 2014 at 09:16:02AM -0400, Brian Foster wrote:
> ...
> > >  	/*
> > > -	 * If we just got an ENOSPC, try to write back all dirty inodes to
> > > -	 * convert delalloc space to free up some of the excess reserved
> > > -	 * metadata space.
> > > +	 * If we hit ENOSPC or a quota limit, use the selective nature of the
> > > +	 * eofblocks scan to try and free up some lingering speculative
> > > +	 * preallocation delalloc blocks.
> > > +	 *
> > > +	 * If we hit a quota limit, only scan for files covered by the quota. We
> > > +	 * also consider ENOSPC here because project quota failure can return
> > > +	 * ENOSPC instead of EDQUOT. The quota scanning only sets 'scanned' if
> > > +	 * the inode is covered by a quota with low free space. This should
> > > +	 * minimize interference with global ENOSPC handling.
> > > +	 *
> > > +	 * If a scan does not free enough space, resort to the inode flush big
> > > +	 * hammer to convert delalloc space to free up some of the excess
> > > +	 * reserved metadata space.
> > >  	 */
> > > +	if ((ret == -EDQUOT || ret == -ENOSPC) && !scanned) {
> > > +		scanned = xfs_inode_free_quota_eofblocks(ip);
> > > +		if (scanned)
> > > +			goto write_retry;
> > > +	}
> > > +	if (ret == -ENOSPC && !scanned) {
> > > +		struct xfs_eofblocks eofb = {0,};
> > 
> > IIRC, you can just use "{ 0 }" for initialisation, no "," needed.
> > 
> > > +
> > > +		eofb.eof_scan_owner = ip->i_ino; /* for locking */
> > > +		eofb.eof_flags = XFS_EOF_FLAGS_SYNC | XFS_EOF_FLAGS_FLUSH;
> > > +		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> > > +		scanned = 1;
> > > +		goto write_retry;
> > > +	}
> > >  	if (ret == -ENOSPC && !enospc) {
> > >  		enospc = 1;
> > >  		xfs_flush_inodes(ip->i_mount);
> > 
> > This seems overly complex and fragile. I'd much prefer that we don't
> > bury data writeback deep in the EOF block freeing code - we've done
> > a lot of work in the past to remove exactly that sort of behaviour
> > from XFS inode scanners.
> 
> I think the fragility comes from the fact that we can't detect a
> particular quota failure or a project quota failure from a global
> failure. IIRC from looking at this way back when, there wasn't a clear
> solution to that problem. It didn't seem worth getting too far into for
> the purpose of this little bit of functionality. In that sense, the
> fragility will be there regardless.
> 
> It would be nice to simplify this, however. It took a little bit of
> staring at this to try and make it effective and somewhat succinct.
> 
> > I'd prefer to see something like this:
> > 
> > 	if (ret == -EDQUOT && !enospc) {
> > 		enospc = 1;
> > 		xfs_inode_free_quota_eofblocks(ip);
> > 		goto retry;
> > 	else if (ret == -ENOSPC && !enospc) {
> > 		enospc = 1;
> > 		xfs_flush_inodes(ip->i_mount);
> > 		....
> > 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> > 		goto retry;
> > 	}
> > 
> 
> What I don't like about this, in particular, is xfs_flush_inodes() could
> be unnecessary. We have a max preallocation size of 8GB, so the
> eofblocks scan alone can free up gigabytes of space. Now that I think of
> it, this is kind of a flaw in the proposed logic as well.

The issue is that an eofblock scan is expensive, and there's no
limiting on how many inodes can have the EOF tag set and there's no
limiting on the number of concurrent scans that can be run. i.e.
when an active project that has many processes writing to it runs
out of space, every process will enter xfs_icache_free_eofblocks()
function and start issuing data flush requests on dirty inodes. It
causes unbound writeback concurrency, and we know that this is a bad
thing to do to your storage...

xfs_flush_inodes() only runs one scan of the currently dirty
inodes at a time because it serialises on the flusher thread. We get
optimised writeback patterns rather than random data writeback from
as many threads hitting the eofblocks scanner at once. History has
shown that this is the most efficient way to clean dirty data -
optimise once and in the correct place, then use it everywhere.

Yes, it means that there is a global flush when a project quota runs
out of space, but it means that we only do it once and we don't burn
excessive CPU walking radix trees scanning inodes needlessly every
time we get a storm of processes hammering project quota ENOSPC.

FWIW, if we want to filter the list of dirty inodes to writeback, we
should look at providing a filter callback to the generic inode code
that gets called on each dirty inode. That way we can use the
optimised writeback code to quickly find and dispatch only the dirty
inodes that match the quota id we are having problems with....

> > This way has specific behaviours for EDQUOT vs ENOSPC, and we treat
> > them appropriately with a minimum of differences. And ENOSPC is
> > global, because we can't tell the difference here between a project
> > quota ENOSPC and a global ENOSPC at this point.
> > 
> 
> The main difference I see is that the original logic is centered around
> figuring out how to do an eofblocks scan vs. xfs_flush_inodes() only
> when necessary. In other words, we always attempt to do an eofblocks
> scan first then fall back to the inode flush. Where it gets a bit ugly
> is where we try to determine what kind of scan to run due to lack of
> information. The flush aspect of things is a little confused as well I
> suppose.
> 
> Alternatively, the logic above is designed around categorization of the
> possible error conditions. I agree that it is more simple, but not quite
> as effective as noted above. We would continue to run a global inode
> flush when eofblocks can clean up effectively for the time being or due
> to a project quota failure that should ideally not impact the wider fs.

Sure, but we've found in the past that just issuing a global flush
is far better from both the CPU and IO efficiency POV than
concurrent inode cache scans to find matching dirty inodes and
flushing them.

> I wonder if something like the following would simplify this enough, yet
> still provide nicer behavior:
> 
> 	/*
> 	 * If this is an allocation failure, attempt an eofblocks scan
> 	 * before we resort to an inode flush...
> 	 */
> 	if ((ret == -EDQUOT || ret == -ENOSPC) && !scanned) {
> 		scanned = xfs_inode_enospc_eofblocks(ip);
> 		if (scanned)
> 			goto retry;
> 		scanned = 1;	/* try this once */
> 	}
> 	if (ret == -ENOSPC && !enospc) {
> 		enospc = 1;
> 		xfs_flush_inodes();
> 		goto retry;
> 	}
> 
> This consolidates the eofblocks scan logic to a separate helper to
> simplify things. The helper can run the quota scan and/or the global
> scan based on the data regarding the situation (i.e., the inode and
> associated quota characteristics). This allows us to preserve the notion
> of attempting a lightweight recovery first and a heavyweight recovery
> second, reserving the inode flush for when space is truly tight.
> Thoughts?

It's still damn clunky, IMO. It's still trying to work around the
fact that project quotas use ENOSPC rather than EDQUOT, and that
makes the logic rather twisted. And it still has that hidden data
flush in it so it can't really be called lightweight...


> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index bd0ab7d..471ccfa 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -33,6 +33,9 @@
> ...
> > > +
> > > +	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
> > > +		dq = xfs_inode_dquot(ip, XFS_DQ_PROJ);
> > > +		if (dq && xfs_dquot_lowsp(dq)) {
> > > +			eofb.eof_prid = xfs_get_projid(ip);
> > > +			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
> > > +					 XFS_EOF_FLAGS_PRID|
> > > +					 XFS_EOF_FLAGS_FLUSH;
> > > +			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> > > +			scanned = 1;
> > > +		}
> > > +	}
> > 
> > I really don't like the fact that project quota is hiding a data
> > flush in the "free_quota_eofblocks" logic. It just strikes me a the
> > wrong thing to do because if it's a real ENOSPC we're just going to
> > have to do this anyway...
> > 
> 
> I was under the impression that a flush was important for project quotas
> based on freeing up reserved metadata space (from our past discussions
> on the original eofblocks work). I could have just misunderstood the
> point at the time.

It is important - I'm not saying that we should not flush dirty
data. What I am disagreeing with is the implementation of data
flushing in the patch....

> If so, I can just remove the flush flag on the
> eofblocks scan in the logic proposed above and let the inode flush
> handle this for both cases.
> 
> If we go that route, any preference as to whether to keep the support
> for doing a flush in eofblocks at all? I included it primarily for the
> project quota case. With that dropped, I could just drop the first
> couple of patches here.

Yes, you could do that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
