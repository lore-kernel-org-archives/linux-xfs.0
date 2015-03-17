Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 491017F56
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 08:25:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 086C6304048
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 06:25:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xfq0wiIyRgEfMQlq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 06:25:16 -0700 (PDT)
Date: Tue, 17 Mar 2015 09:25:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
Message-ID: <20150317132514.GA52950@bfoster.bfoster>
References: <20150316060020.GB28557@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20150316060020.GB28557@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 16, 2015 at 05:00:20PM +1100, Dave Chinner wrote:
> Hi Folks,
> 
> As I told many people at Vault last week, I wrote a document
> outlining how we should modify the on-disk structures of XFS to
> support host aware SMR drives on the (long) plane flights to Boston.
> 
> TL;DR: not a lot of change to the XFS kernel code is required, no
> specific SMR awareness is needed by the kernel code.  Only
> relatively minor tweaks to the on-disk format will be needed and
> most of the userspace changes are relatively straight forward, too.
> 
> The source for that document can be found in this git tree here:
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation
> 
> in the file design/xfs-smr-structure.asciidoc. Alternatively,
> pull it straight from cgit:
> 
> https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/design/xfs-smr-structure.asciidoc
> 
> Or there is a pdf version built from the current TOT on the xfs.org
> wiki here:
> 
> http://xfs.org/index.php/Host_Aware_SMR_architecture
> 
> Happy reading!
> 

Hi Dave,

Thanks for sharing this. Here are some thoughts/notes/questions/etc.
from a first pass. This is mostly XFS oriented and I'll try to break it
down by section.

I've also attached a diff to the original doc with some typo fixes and
whatnot. Feel free to just fold it into the original doc if you like.

== Concepts

- With regard to the assumption that the CMR region is not spread around
the drive, I saw at least one presentation at Vault that suggested
otherwise (the skylight one iirc). That said, it was theoretical and
based on a drive-managed drive. It is in no way clear to me whether that
is something to expect for host-managed drives.

- It isn't clear to me here and in other places whether you propose to
use the CMR regions as a "metadata device" or require some other
randomly writeable storage to serve that purpose.

== Journal modifications

- The tail->head log zeroing behavior on mount comes to mind here. Maybe
the writes are still sequential and it's not a problem, but we should
consider that with the proposition. It's probably not critical as we do
have the out of using the cmr region here (as noted). I assume we can
also cleanly relocate the log without breaking anything else (e.g., the
current location is performance oriented rather than architectural,
yes?).

== Data zones

- Will this actually support data overwrite or will that return error?

- TBH, I've never looked at realtime functionality so I don't grok the
high level approach yet. I'm wondering... have you considered a design
based on reflink and copy-on-write? I know the current plan is to
disentangle the reflink tree from the rmap tree, but my understanding is
the reflink tree is still in the pipeline. Assuming we have that
functionality, it seems like there's potential to use it to overcome
some of the overwrite complexity. Just as a handwaving example, use the
per-zone inode to hold an additional reference to each allocated extent
in the zone, thus all writes are handled as if the file had a clone. If
the only reference drops to the zoneino, the extent is freed and thus
stale wrt to the zone cleaner logic.

I suspect we would still need an allocation strategy, but I expect we're
going to have zone metadata regardless that will help deal with that.
Note that the current sparse inode proposal includes an allocation range
limit mechanism (for the inode record overlaps an ag boundary case),
which could potentially be used/extended to build something on top of
the existing allocator for zone allocation (e.g., if we had some kind of
zone record with the write pointer that indicated where it's safe to
allocate from). Again, just thinking out loud here.

== Zone cleaner

- Paragraph 3 - "fixpel?" I would have just fixed this, but I can't
figure out what it's supposed to say. ;)

- The idea sounds sane, but the dependency on userspace for a critical
fs mechanism sounds a bit scary to be honest. Is in kernel allocation
going to throttle/depend on background work in the userspace cleaner in
the event of low writeable free space? What if that userspace thing
dies, etc.? I suppose an implementation with as much mechanism in libxfs
as possible allows us greatest flexibility to go in either direction
here.

- I'm also wondering how much real overlap there is in xfs_fsr (another
thing I haven't really looked at :) beyond that it calls swapext.
E.g., cleaning a zone sounds like it must map back to N files that could
have allocated extents in the zone vs. considering individual files for
defragmentation, fragmentation of the parent file may not be as much of
a consideration as resetting zones, etc. It sounds like a separate tool
might be warranted, even if there is code to steal from fsr. :)

== Reverse mapping btrees

- This is something I still need to grok, perhaps just because the rmap
code isn't available yet. But I'll note that this does seem like
another bit that could be unnecessary if we could get away with using
the traditional allocator.

== Mkfs

- We have references to the "metadata device" as well as random write
regions. Similar to my question above, is there an expectation of a
separate physical metadata device or is that terminology for the random
write regions?

Finally, some general/summary notes:

- Some kind of data structure outline would eventually make a nice
addition to this document. I understand it's probably too early yet,
but we are talking about new per-zone inodes, new and interesting
relationships between AGs and zones (?), etc. Fine grained detail is not
required, but an outline or visual that describes the high-level
mappings goes a long way to facilitate reasoning about the design.

- A big question I had (and something that is touched on down thread wrt
to embedded flash) is whether the random write zones are runtime
configurable. If so, couldn't this facilitate use of existing AG
metadata (now that I think of it, it's not clear to me whether the
realtime mechanism excludes or coexists with AGs)? IOW, we obviously
need this kind of space for inodes, dirs, xattrs, btrees, etc.
regardless. It would be interesting if we had the added flexibility to
align it with AGs.

Thanks again!

Brian

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

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="smr-typos.diff"

diff --git a/design/xfs-smr-structure.asciidoc b/design/xfs-smr-structure.asciidoc
index dd959ab..2fea88f 100644
--- a/design/xfs-smr-structure.asciidoc
+++ b/design/xfs-smr-structure.asciidoc
@@ -95,7 +95,7 @@ going to need a special directory to expose this information. It would be useful
 to have a ".zones" directory hanging off the root directory that contains all
 the zone allocation inodes so userspace can simply open them.
 
-THis biggest issue that has come to light here is the number of zones in a
+This biggest issue that has come to light here is the number of zones in a
 device. Zones are typically 256MB in size, and so we are looking at 4,000
 zones/TB. For a 10TB drive, that's 40,000 zones we have to keep track of. And if
 the devices keep getting larger at the expected rate, we're going to have to
@@ -112,24 +112,24 @@ also have other benefits...
 While it seems like tracking free space is trivial for the purposes of
 allocation (and it is!), the complexity comes when we start to delete or
 overwrite data. Suddenly zones no longer contain contiguous ranges of valid
-data; they have "freed" extents in the middle of them that contian stale data.
+data; they have "freed" extents in the middle of them that contain stale data.
 We can't use that "stale space" until the entire zone is made up of "stale"
 extents. Hence we need a Cleaner.
 
 === Zone Cleaner
 
 The purpose of the cleaner is to find zones that are mostly stale space and
-consolidate the remaining referenced data into a new, contigious zone, enabling
+consolidate the remaining referenced data into a new, contiguous zone, enabling
 us to then "clean" the stale zone and make it available for writing new data
 again.
 
-The real complexity here is finding the owner of the data that needs to be move,
-but we are in the process of solving that with the reverse mapping btree and
-parent pointer functionality. This gives us the mechanism by which we can
+The real complexity here is finding the owner of the data that needs to be
+moved, but we are in the process of solving that with the reverse mapping btree
+and parent pointer functionality. This gives us the mechanism by which we can
 quickly re-organise files that have extents in zones that need cleaning.
 
 The key word here is "reorganise". We have a tool that already reorganises file
-layout: xfs_fsr. The "Cleaner" is a finely targetted policy for xfs_fsr -
+layout: xfs_fsr. The "Cleaner" is a finely targeted policy for xfs_fsr -
 instead of trying to minimise fixpel fragments, it finds zones that need
 cleaning by reading their summary info from the /.zones/ directory and analysing
 the free bitmap state if there is a high enough percentage of stale blocks. From
@@ -142,7 +142,7 @@ Hence we don't actually need any major new data moving functionality in the
 kernel to enable this, except maybe an event channel for the kernel to tell
 xfs_fsr it needs to do some cleaning work.
 
-If we arrange zones into zoen groups, we also have a method for keeping new
+If we arrange zones into zone groups, we also have a method for keeping new
 allocations out of regions we are re-organising. That is, we need to be able to
 mark zone groups as "read only" so the kernel will not attempt to allocate from
 them while the cleaner is running and re-organising the data within the zones in
@@ -166,17 +166,17 @@ inode to track the zone's owner information.
 == Mkfs
 
 Mkfs is going to have to integrate with the userspace zbc libraries to query the
-layout of zones from the underlying disk and then do some magic to lay out al
+layout of zones from the underlying disk and then do some magic to lay out all
 the necessary metadata correctly. I don't see there being any significant
 challenge to doing this, but we will need a stable libzbc API to work with and
-it will need ot be packaged by distros.
+it will need to be packaged by distros.
 
-If mkfs cannot find ensough random write space for the amount of metadata we
-need to track all the space in the sequential write zones and a decent amount of
-internal fielsystem metadata (inodes, etc) then it will need to fail. Drive
-vendors are going to need to provide sufficient space in these regions for us
-to be able to make use of it, otherwise we'll simply not be able to do what we
-need to do.
+If mkfs cannot find enough random write space for the amount of metadata we need
+to track all the space in the sequential write zones and a decent amount of
+internal filesystem metadata (inodes, etc) then it will need to fail. Drive
+vendors are going to need to provide sufficient space in these regions for us to
+be able to make use of it, otherwise we'll simply not be able to do what we need
+to do.
 
 mkfs will need to initialise all the zone allocation inodes, reset all the zone
 write pointers, create the /.zones directory, place the log in an appropriate
@@ -187,13 +187,13 @@ place and initialise the metadata device as well.
 Because we've limited the metadata to a section of the drive that can be
 overwritten, we don't have to make significant changes to xfs_repair. It will
 need to be taught about the multiple zone allocation bitmaps for it's space
-reference checking, but otherwise all the infrastructure we need ifor using
+reference checking, but otherwise all the infrastructure we need for using
 bitmaps for verifying used space should already be there.
 
-THere be dragons waiting for us if we don't have random write zones for
+There be dragons waiting for us if we don't have random write zones for
 metadata. If that happens, we cannot repair metadata in place and we will have
 to redesign xfs_repair from the ground up to support such functionality. That's
-jus tnot going to happen, so we'll need drives with a significant amount of
+just not going to happen, so we'll need drives with a significant amount of
 random write space for all our metadata......
 
 == Quantification of Random Write Zone Capacity
@@ -214,7 +214,7 @@ performance, replace the CMR region with a SSD....
 
 The allocator will need to learn about multiple allocation zones based on
 bitmaps. They aren't really allocation groups, but the initialisation and
-iteration of them is going to be similar to allocation groups. To get use going
+iteration of them is going to be similar to allocation groups. To get us going
 we can do some simple mapping between inode AG and data AZ mapping so that we
 keep some form of locality to related data (e.g. grouping of data by parent
 directory).
@@ -273,19 +273,19 @@ location, the current location or anywhere in between. The only guarantee that
 we have is that if we flushed the cache (i.e. fsync'd a file) then they will at
 least be in a position at or past the location of the fsync.
 
-Hence before a filesystem runs journal recovery, all it's zone allocation write
+Hence before a filesystem runs journal recovery, all its zone allocation write
 pointers need to be set to what the drive thinks they are, and all of the zone
 allocation beyond the write pointer need to be cleared. We could do this during
 log recovery in kernel, but that means we need full ZBC awareness in log
 recovery to iterate and query all the zones.
 
-Hence it's not clear if we want to do this in userspace as that has it's own
-problems e.g. we'd need to  have xfs.fsck detect that it's a smr filesystem and
+Hence it's not clear if we want to do this in userspace as that has its own
+problems e.g. we'd need to  have xfs.fsck detect that it's an smr filesystem and
 perform that recovery, or write a mount.xfs helper that does it prior to
 mounting the filesystem. Either way, we need to synchronise the on-disk
 filesystem state to the internal disk zone state before doing anything else.
 
-This needs more thought, because I have a nagging suspiscion that we need to do
+This needs more thought, because I have a nagging suspicion that we need to do
 this write pointer resynchronisation *after log recovery* has completed so we
 can determine if we've got to now go and free extents that the filesystem has
 allocated and are referenced by some inode out there. This, again, will require

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--ikeVEW9yuYc//A+q--
