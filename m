Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33816 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752897AbeGDXVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 19:21:19 -0400
Date: Thu, 5 Jul 2018 09:21:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/21] xfs: repair the rmapbt
Message-ID: <20180704232115.GP2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986827881.3155.10096839660329617215.stgit@magnolia>
 <20180703053200.GH2234@dastard>
 <20180703235901.GY32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703235901.GY32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 04:59:01PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 03, 2018 at 03:32:00PM +1000, Dave Chinner wrote:
> > On Sun, Jun 24, 2018 at 12:24:38PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Rebuild the reverse mapping btree from all primary metadata.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > ....
> > 
> > > +static inline int xfs_repair_rmapbt_setup(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_inode		*ip)
> > > +{
> > > +	/* We don't support rmap repair, but we can still do a scan. */
> > > +	return xfs_scrub_setup_ag_btree(sc, ip, false);
> > > +}
> > 
> > This comment seems at odds with the commit message....
> 
> This is the Kconfig shim needed if CONFIG_XFS_ONLINE_REPAIR=n.

Ok, that wasn't clear from the patch context.

> > > + * This is the most involved of all the AG space btree rebuilds.  Everywhere
> > > + * else in XFS we lock inodes and then AG data structures, but generating the
> > > + * list of rmap records requires that we be able to scan both block mapping
> > > + * btrees of every inode in the filesystem to see if it owns any extents in
> > > + * this AG.  We can't tolerate any inode updates while we do this, so we
> > > + * freeze the filesystem to lock everyone else out, and grant ourselves
> > > + * special privileges to run transactions with regular background reclamation
> > > + * turned off.
> > 
> > Hmmm. This implies we are going to scan the entire filesystem for
> > every AG we need to rebuild the rmap tree in. That seems like an
> > awful lot of work if there's more than one rmap btree that needs
> > rebuild.
> 
> [some of this Dave and I discussed on IRC, so I'll summarize for
> everyone else here...]

....

> > Given that we've effetively got to shut down access to the
> > filesystem for the entire rmap rebuild while we do an entire
> > filesystem scan, why would we do this online? It's going to be
> > faster to do this rebuild offline (because of all the prefetching,
> > rebuilding all AG trees from the state gathered in the full
> > filesystem passes, etc) and we don't have to hack around potential
> > transaction and memory reclaim deadlock situations, either?
> > 
> > So why do rmap rebuilds online at all?
> 
> The thing is, xfs_scrub will warm the xfs_buf cache during phases 2 and
> 3 while it checks everything.  By the time it gets to rmapbt repairs
> towards the end of phase 4 (if there's enough memory) those blocks will
> still be in cache and online repair doesn't have to wait for the disk.

Therein lies the problem: "if there's enough memory". If there's
enough memory to cache at the filesystem metadata, track all the
bits repair needs to track, and there's no other memory pressure
then it will hit the cache. But populating that cache is still going
to be slower than an offline repair because IO patterns (see below)
and there is competing IO from other work being done on the
system (i.e. online repair competes for IO resources and memory
resources).

As such, I don't see that we're going to have everything we need
cached for any significantly sized or busy filesystem, and that
means we actually have to care about how much IO online repair
algorithms require. We also have to take into account that much of
that IO is going to be synchronous single metadata block reads.
This will be a limitation on any sort of high IO latency storage
(spinning rust, network based block devices, slow SSDs, etc).

> If instead you unmount and run xfs_repair then xfs_repair has to reload
> all that metadata and recheck it, all of which happens with the fs
> offline.

xfs_repair has all sorts of concurrency and prefetching
optimisations that allow it to scan and process metadata orders of
magnitude faster than online repair, especially on slow storage.
i.e. online repair is going to be IO seek bound, while offline
repair is typically IO bandwidth and/or CPU bound.  Offline repair
can do full filesystem metadata scans measured in GB/s; as long as
online repair does serialised synchronous single structure walks it
will be orders of magnitude slower than an offline repair.

> So except for the extra complexity of avoiding deadlocks (which I
> readily admit is not a small task) I at least don't think it's a
> clear-cut downtime win to rely on xfs_repair.

Back then - as it is still now - I couldn't see how the IO load
required by synchronous full filesystem scans one structure at a
time was going to reduce filesystem downtime compared to an offline
repair doing optimised "all metadata types at once" concurrent
linear AG scans.

Keep in mind that online repair will never guarantee that it can fix
all problems, so we're always going to have to offline repair. iWhat
we want to achieve is minimising downtime for users when a repair is
required. With the above IO limitations in mind, I've always
considered that online repair would just be for all the simple,
quick, easy to fix stuff, because complex stuff that required huge
amounts of RAM and full filesystem scans to resolve would always be
done faster offline.

That's why I think that offline repair will be a better choice for
users for the forseeable future if repairing the damage requires
full filesystem metadata scans.

> > > +
> > > +	rre = kmem_alloc(sizeof(struct xfs_repair_rmapbt_extent), KM_MAYFAIL);
> > > +	if (!rre)
> > > +		return -ENOMEM;
> > 
> > This seems like a likely thing to happen given the "no reclaim"
> > state of the filesystem and the memory demand a rmapbt rebuild
> > can have. If we've got GBs of rmap info in the AG that needs to be
> > rebuilt, how much RAM are we going to need to index it all as we
> > scan the filesystem?
> 
> More than I'd like -- at least 24 bytes per record (which at least is no
> larger than the size of the on-disk btree) plus a list_head until I can
> move the repairers away from creating huge lists.

Ok, it kinda sounds a bit like we need to be able to create the new
btree on the fly, rather than as a single operation at the end. e.g.
if the list builds up to, say, 100k records, we push them into the
new tree and can free them. e.g. can we iteratively build the new
tree on disk as we go, then do a root block swap at the end to
switch from the old tree to the new tree?

If that's a potential direction, then maybe we can look at this as a
future direction? It also leads to the posibility of
pausing/continuing repair from where the last chunk of records were
processed, so if we do run out of memory we don't have to start from
the beginning again?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
