Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69DB57F37
	for <xfs@oss.sgi.com>; Sat, 21 Mar 2015 09:48:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5A23AC001
	for <xfs@oss.sgi.com>; Sat, 21 Mar 2015 07:48:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HifDAGIgJI1cnlmk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Mar 2015 07:48:26 -0700 (PDT)
Date: Sat, 21 Mar 2015 10:48:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
Message-ID: <20150321144823.GC15941@bfoster.bfoster>
References: <20150316060020.GB28557@dastard>
	<20150317132514.GA52950@bfoster.bfoster>
	<20150317212835.GB28621@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150317212835.GB28621@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 18, 2015 at 08:28:35AM +1100, Dave Chinner wrote:
> On Tue, Mar 17, 2015 at 09:25:15AM -0400, Brian Foster wrote:
> > On Mon, Mar 16, 2015 at 05:00:20PM +1100, Dave Chinner wrote:
> > > Hi Folks,
> > > 
> > > As I told many people at Vault last week, I wrote a document
> > > outlining how we should modify the on-disk structures of XFS to
> > > support host aware SMR drives on the (long) plane flights to Boston.
> > > 
> > > TL;DR: not a lot of change to the XFS kernel code is required, no
> > > specific SMR awareness is needed by the kernel code.  Only
> > > relatively minor tweaks to the on-disk format will be needed and
> > > most of the userspace changes are relatively straight forward, too.
> > > 
> > > The source for that document can be found in this git tree here:
> > > 
> > > git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation
> > > 
> > > in the file design/xfs-smr-structure.asciidoc. Alternatively,
> > > pull it straight from cgit:
> > > 
> > > https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/design/xfs-smr-structure.asciidoc
> > > 
> > > Or there is a pdf version built from the current TOT on the xfs.org
> > > wiki here:
> > > 
> > > http://xfs.org/index.php/Host_Aware_SMR_architecture
> > > 
> > > Happy reading!
> > > 
> > 
> > Hi Dave,
> > 
> > Thanks for sharing this. Here are some thoughts/notes/questions/etc.
> > from a first pass. This is mostly XFS oriented and I'll try to break it
> > down by section.
> > 
> > I've also attached a diff to the original doc with some typo fixes and
> > whatnot. Feel free to just fold it into the original doc if you like.
> > 
> > == Concepts
> > 
> > - With regard to the assumption that the CMR region is not spread around
> > the drive, I saw at least one presentation at Vault that suggested
> > otherwise (the skylight one iirc). That said, it was theoretical and
> > based on a drive-managed drive. It is in no way clear to me whether that
> > is something to expect for host-managed drives.
> 
> AFAIK, the CMR region is contiguous. The skylight paper spells it
> out pretty clearly that it is a contiguous 20-25GB region on the
> outer edge of the seagate drives. Other vendors I've spoken to
> indicate that the region in host managed drives is also contiguous
> and at the outer edge, and some vendors have indicated they have
> much more of it that the seagate drives analysed in the skylight
> paper.
> 
> If it is not contiguous, then we can use DM to make that problem go
> away. i.e. use DM to stitch the CMR zones back together into a
> contiguous LBA region. Then we can size AGs in the data device to
> map to the size of the individual disjoint CMR regions, and we
> have a neat, well aligned, isolated solution to the problem without
> having to modify the XFS code at all.
> 

Looking back at the slides, that was apparently one of the emulated
drives. So I guess that bit was more oriented towards showcasing the
experimental method than to suggest how one of the drives works.
Regardless, it seems reasonable to me to use dm to stitch things
together (or go the other direction and split things up) if need be.

> > - It isn't clear to me here and in other places whether you propose to
> > use the CMR regions as a "metadata device" or require some other
> > randomly writeable storage to serve that purpose.
> 
> CMR as the "metadata device" if there is nothing else we can use.
> I'd really like to see hybrid drives with the "CMR" zone being the
> flash region in the drive....
> 

Ok.

> > == Journal modifications
> > 
> > - The tail->head log zeroing behavior on mount comes to mind here. Maybe
> > the writes are still sequential and it's not a problem, but we should
> > consider that with the proposition.  It's probably not critical as we do
> > have the out of using the cmr region here (as noted). I assume we can
> > also cleanly relocate the log without breaking anything else (e.g., the
> > current location is performance oriented rather than architectural,
> > yes?).
> 
> We place the log anywhere in the data device LBA space. You might
> want to go look up what L_AGNUM does in mkfs. :)
> 
> And if we can use the CMR region for the log, then that's what we'll
> do - "no modifications required" is always the best solution.
> 
> > == Data zones
> > 
> > - Will this actually support data overwrite or will that return error?
> 
> We'll support data overwrite. xfs_get_blocks() will need to detect
> overwrite....
> 
> > - TBH, I've never looked at realtime functionality so I don't grok the
> > high level approach yet. I'm wondering... have you considered a design
> > based on reflink and copy-on-write?
> 
> Yes, I have. Complex, invasive and we don't even have basic reflink
> infrastructure yet. Such a solution pushes us a couple of years
> out, as opposed to having something before the end of the year...
> 

It certainly would take longer to implement, but the point is that it's
a potential reuse of a mechanism we already plan to implement. I suppose
a zone aware allocation is a more simple problem for now and we can
revisit it down the road.

> > I know the current plan is to
> > disentangle the reflink tree from the rmap tree, but my understanding is
> > the reflink tree is still in the pipeline. Assuming we have that
> > functionality, it seems like there's potential to use it to overcome
> > some of the overwrite complexity.
> 
> There isn't much overwrite complexity - it's simply clearing bits
> in a zone bitmap to indicate free space, allocating new blocks and
> then rewriting bmbt extent records. It's fairly simple, really ;)
> 

Perhaps, but it's not really the act of marking blocks allocated or free
that I was interested in. It's the combination of managing the zone
write constraints in the write path and the allocator, finding free
blocks vs. stale blocks, etc. (e.g., the "extent lifecycle" for lack of
a better term).

> > Just as a handwaving example, use the
> > per-zone inode to hold an additional reference to each allocated extent
> > in the zone, thus all writes are handled as if the file had a clone. If
> > the only reference drops to the zoneino, the extent is freed and thus
> > stale wrt to the zone cleaner logic.
> > 
> > I suspect we would still need an allocation strategy, but I expect we're
> > going to have zone metadata regardless that will help deal with that.
> > Note that the current sparse inode proposal includes an allocation range
> > limit mechanism (for the inode record overlaps an ag boundary case),
> > which could potentially be used/extended to build something on top of
> > the existing allocator for zone allocation (e.g., if we had some kind of
> > zone record with the write pointer that indicated where it's safe to
> > allocate from). Again, just thinking out loud here.
> 
> Yup, but the bitmap allocator doesn't have support for many of the
> btree allocator controls.  It's a simple, fast, deterministic
> allocator, and we only need it is to track freed space in the zones
> as all allocation from the zones is going to be sequential...
> 

Right, the point is that the traditional allocator has some mechanisms
that might facilitate zone compliant allocation provided we have the
associated zone metadata. E.g., the allocation range mechanism
facilitates allocation within a particular zone, within a "usable" range
of a zone, or across a wider set of zones of similar state, depending on
the allocator implementation details.

Anyways, I don't want to hijack this thread too much. :) I might send
you something separately for a sanity check or brainstorming purposes.

> > == Zone cleaner
> > 
> > - Paragraph 3 - "fixpel?" I would have just fixed this, but I can't
> > figure out what it's supposed to say. ;)
> > 
> > - The idea sounds sane, but the dependency on userspace for a critical
> > fs mechanism sounds a bit scary to be honest. Is in kernel allocation
> > going to throttle/depend on background work in the userspace cleaner in
> > the event of low writeable free space?
> 
> Of course. ENOSPC always throttles ;)
> 

Heh. :)

> I expect the cleaner will work zone group at a time; locking new,
> non-cleaner based allocations out of the zone group while it cleans
> zones. This means the cleaner should always be able to make progress
> w.r.t. ENOSPC - it gets triggered on a zone group before it runs out
> of clean zones for freespace defrag purposes....
> 

There's some interesting allocation dynamics going on here that aren't
fully clear to me. E.g., on the one hand we want zone groups to be
fairly large to help manage the zone count, on the other we're
potentially locking out a TB-sized zone group at a time while the
userspace tool does its thing..? I take it this means we'll also want
some way to actually do zone-cleaning allocations (i.e., the extents
copied from the cleaned zones) from this zone from the userspace tool
while other general users are locked out. Even with that, incorporating
any kind of locality into the allocator seems futile if the target zone
group for an independently active file could be locked down at any given
point in time.

Maybe 256MB zone groups means that's less of a practical issue..? I'm
probably reading too far into it at this point... :P

> I also expect that the cleaner won't be used in many bulk storage
> applications as data is never deleted. I also expect tht XFS-SMR
> won't be used for general purpose storage applications - that's what
> solid state storage will be used for - and so the cleaner is not
> something we need to focus a lot of time and effort on.
> 
> And the thing that distributed storage guys should love: if we put
> the cleaner in userspace, then they can *write their own cleaners*
> that are customised to their own storage algorithms.
> 
> > What if that userspace thing
> > dies, etc.? I suppose an implementation with as much mechanism in libxfs
> > as possible allows us greatest flexibility to go in either direction
> > here.
> 
> If the cleaner dies of can't make progress, we ENOSPC. Whether the
> cleaner is in kernel or userspace is irrelevant to how we handle
> such cases.
> 
> > - I'm also wondering how much real overlap there is in xfs_fsr (another
> > thing I haven't really looked at :) beyond that it calls swapext.
> > E.g., cleaning a zone sounds like it must map back to N files that could
> > have allocated extents in the zone vs. considering individual files for
> > defragmentation, fragmentation of the parent file may not be as much of
> > a consideration as resetting zones, etc. It sounds like a separate tool
> > might be warranted, even if there is code to steal from fsr. :)
> 
> As I implied above, zone cleaning is addressing exactly the same
> problem as we are currently working on in xfs_fsr: defragmenting
> free space.
> 

Ah, Ok. That is an interesting connection. There also seems to be an
interesting correlation between zone cleaning and overwrite handling +
unlink/truncate + discard handling (if you represent a zone with an
inode that tracks a particular fsb range and references "stale" blocks
before they are ultimately freed).

> > == Reverse mapping btrees
> > 
> > - This is something I still need to grok, perhaps just because the rmap
> > code isn't available yet. But I'll note that this does seem like
> > another bit that could be unnecessary if we could get away with using
> > the traditional allocator.
> > 
> > == Mkfs
> > 
> > - We have references to the "metadata device" as well as random write
> > regions. Similar to my question above, is there an expectation of a
> > separate physical metadata device or is that terminology for the random
> > write regions?
> 
> "metadata device" == "data device" == "CMR" == "random write region"
> 
> > Finally, some general/summary notes:
> > 
> > - Some kind of data structure outline would eventually make a nice
> > addition to this document. I understand it's probably too early yet,
> > but we are talking about new per-zone inodes, new and interesting
> > relationships between AGs and zones (?), etc. Fine grained detail is not
> > required, but an outline or visual that describes the high-level
> > mappings goes a long way to facilitate reasoning about the design.
> 
> Sure, a plane flight is not long enough to do this. Future
> revisions, as the structure is clarified.
> 

Of course. :)

> > - A big question I had (and something that is touched on down thread wrt
> > to embedded flash) is whether the random write zones are runtime
> > configurable. If so, couldn't this facilitate use of existing AG
> > metadata (now that I think of it, it's not clear to me whether the
> > realtime mechanism excludes or coexists with AGs)?
> 
> the "realtime device" contains only user data. It contains no
> filesystem metadata at all. That separation of user data and
> filesystem metadata is what makes it so appealing for supporting SMR
> devices....
> 
> > IOW, we obviously
> > need this kind of space for inodes, dirs, xattrs, btrees, etc.
> > regardless. It would be interesting if we had the added flexibility to
> > align it with AGs.
> 
> I'm trying to keep the solution as simple as possible. No alignment,
> single whole disk only, metadata in the "data device" on CMR and
> user data in "real time" zones on SMR.
> 

Understood. From the commentary here and our irc discussion, my take
away is that the primary objective is to get to some kind of SMR capable
solution sooner rather than later. Beyond that, you have concerns about
the complexity of making the current format work with smr drives. That
all sounds reasonable to me.

I get a bit more concerned when we start talking about implementing
solutions to the same problems we've mostly solved with the existing
algorithms, such as zone reservation vs. preallocation, zone group
rotoring vs. ag rotoring, etc. At some point, I think it will be worth
taking a harder look at whether we could reuse the more traditional
layout and algorithms...

Brian

> > diff --git a/design/xfs-smr-structure.asciidoc b/design/xfs-smr-structure.asciidoc
> > index dd959ab..2fea88f 100644
> 
> Oh, there's a patch. Thanks! ;)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
