Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4AD4E7F56
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 10:29:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2BED68F8049
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 08:29:03 -0700 (PDT)
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com
	[66.63.167.143]) by cuda.sgi.com with ESMTP id 7WVaK9QKNcDEduz0
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 08:28:57 -0700 (PDT)
Message-ID: <1426519733.4000.11.camel@HansenPartnership.com>
Subject: Re: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 16 Mar 2015 11:28:53 -0400
In-Reply-To: <20150316060020.GB28557@dastard>
References: <20150316060020.GB28557@dastard>
Mime-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, xfs@oss.sgi.com

[cc to linux-scsi added since this seems relevant]
On Mon, 2015-03-16 at 17:00 +1100, Dave Chinner wrote:
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

I don't think it would have caused too much heartache to post the entire
doc to the list, but anyway

The first is a meta question: What happened to the idea of separating
the fs block allocator from filesystems?  It looks like a lot of the
updates could be duplicated into other filesystems, so it might be a
very opportune time to think about this.


> == Data zones
> 
> What we need is a mechanism for tracking the location of zones (i.e. start LBA),
> free space/write pointers within each zone, and some way of keeping track of
> that information across mounts. If we assign a real time bitmap/summary inode
> pair to each zone, we have a method of tracking free space in the zone. We can
> use the existing bitmap allocator with a small tweak (sequentially ascending,
> packed extent allocation only) to ensure that newly written blocks are allocated
> in a sane manner.
> 
> We're going to need userspace to be able to see the contents of these inodes;
> read only access wil be needed to analyse the contents of the zone, so we're
> going to need a special directory to expose this information. It would be useful
> to have a ".zones" directory hanging off the root directory that contains all
> the zone allocation inodes so userspace can simply open them.

The ZBC standard is being constructed.  However, all revisions agree
that the drive is perfectly capable of tracking the zone pointers (and
even the zone status).  Rather than having you duplicate the information
within the XFS metadata, surely it's better with us to come up with some
block way of reading it from the disk (and caching it for faster
access)?


> == Quantification of Random Write Zone Capacity
> 
> A basic guideline is that for 4k blocks and zones of 256MB, we'll need 8kB of
> bitmap space and two inodes, so call it 10kB per 256MB zone. That's 40MB per TB
> for free space bitmaps. We'll want to suport at least 1 million inodes per TB,
> so that's another 512MB per TB, plus another 256MB per TB for directory
> structures. There's other bits and pieces of metadata as well (attribute space,
> internal freespace btrees, reverse map btrees, etc.
> 
> So, at minimum we will probably need at least 2GB of random write space per TB
> of SMR zone data space. Plus a couple of GB for the journal if we want the easy
> option. For those drive vendors out there that are listening and want good
> performance, replace the CMR region with a SSD....

This seems to be a place where standards work is still needed.  Right at
the moment for Host Managed, the physical layout of the drives makes it
reasonably simple to convert edge zones from SMR to CMR and vice versa
at the expense of changing capacity.  It really sounds like we need a
simple, programmatic way of doing this.  The question I'd have is: are
you happy with just telling manufacturers ahead of time how much CMR
space you need and hoping they comply, or should we push for a standards
way of flipping end zones to CMR?


> === Crash recovery
> 
> Write pointer location is undefined after power failure. It could be at an old
> location, the current location or anywhere in between. The only guarantee that
> we have is that if we flushed the cache (i.e. fsync'd a file) then they will at
> least be in a position at or past the location of the fsync.
> 
> Hence before a filesystem runs journal recovery, all it's zone allocation write
> pointers need to be set to what the drive thinks they are, and all of the zone
> allocation beyond the write pointer need to be cleared. We could do this during
> log recovery in kernel, but that means we need full ZBC awareness in log
> recovery to iterate and query all the zones.

If you just use a cached zone pointer provided by block, this should
never be a problem because you'd always know where the drive thought the
pointer was.


> === RAID on SMR....
> 
> How does RAID work with SMR, and exactly what does that look like to
> the filesystem?
> 
> How does libzbc work with RAID given it is implemented through the scsi ioctl
> interface?

Probably need to cc dm-devel here.  However, I think we're all agreed
this is RAID across multiple devices, rather than within a single
device?  In which case we just need a way of ensuring identical zoning
on the raided devices and what you get is either a standard zone (for
mirror) or a larger zone (for hamming etc).

James


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
