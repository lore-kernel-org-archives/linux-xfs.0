Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD40B7F5D
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 13:23:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77B73AC001
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 11:23:24 -0700 (PDT)
Received: from mx0b-00003501.pphosted.com (mx0b-00003501.pphosted.com
	[67.231.152.68]) by cuda.sgi.com with ESMTP id 5SG9nObCUegbFdIA
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2015 11:23:20 -0700 (PDT)
Received: from pps.filterd (m0075030.ppops.net [127.0.0.1])
	by mx0b-00003501.pphosted.com (8.14.5/8.14.5) with SMTP id
	t2GILnfY008019 for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 14:23:19 -0400
Received: from mail-ig0-f180.google.com (mail-ig0-f180.google.com
	[209.85.213.180])
	by mx0b-00003501.pphosted.com with ESMTP id 1t63ppg8pm-3
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 14:23:19 -0400
Received: by mail-ig0-f180.google.com with SMTP id ue6so50534587igb.1
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 11:23:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426519733.4000.11.camel@HansenPartnership.com>
References: <20150316060020.GB28557@dastard>
	<1426519733.4000.11.camel@HansenPartnership.com>
Date: Mon, 16 Mar 2015 12:23:19 -0600
Message-ID: <CAKdFiL7S=x57OzO-ak9i3E3BrEsqmiRxpNpTJY_pKKVspd_YEg@mail.gmail.com>
Subject: Re: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
From: Adrian Palmer <adrian.palmer@seagate.com>
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
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Dave Chinner <david@fromorbit.com>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, ext4 development <linux-ext4@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, xfs@oss.sgi.com

Thanks for the document!  I think we are off to a good start going in
a common direction.  We have quite a few details to iron out, but I
feel that we are getting there by everyone simply expressing what's
needed.

My additions are in-line.


Adrian Palmer
Firmware Engineer II
R&D Firmware
Seagate, Longmont Colorado
720-684-1307
adrian.palmer@seagate.com


On Mon, Mar 16, 2015 at 9:28 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> [cc to linux-scsi added since this seems relevant]
> On Mon, 2015-03-16 at 17:00 +1100, Dave Chinner wrote:
>> Hi Folks,
>>
>> As I told many people at Vault last week, I wrote a document
>> outlining how we should modify the on-disk structures of XFS to
>> support host aware SMR drives on the (long) plane flights to Boston.
>>
>> TL;DR: not a lot of change to the XFS kernel code is required, no
>> specific SMR awareness is needed by the kernel code.  Only
>> relatively minor tweaks to the on-disk format will be needed and
>> most of the userspace changes are relatively straight forward, too.
>>
>> The source for that document can be found in this git tree here:
>>
>> git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation
>>
>> in the file design/xfs-smr-structure.asciidoc. Alternatively,
>> pull it straight from cgit:
>>
>> https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/design/xfs-smr-structure.asciidoc
>>
>> Or there is a pdf version built from the current TOT on the xfs.org
>> wiki here:
>>
>> http://xfs.org/index.php/Host_Aware_SMR_architecture
>>
>> Happy reading!
>
> I don't think it would have caused too much heartache to post the entire
> doc to the list, but anyway
>
> The first is a meta question: What happened to the idea of separating
> the fs block allocator from filesystems?  It looks like a lot of the
> updates could be duplicated into other filesystems, so it might be a
> very opportune time to think about this.
>

That's not a half-bad idea.  In speaking to EXT4 dev group, we're
already looking at pulling the block allocator out and making it
plugable.  I'm looking at doing a clean re-write anyway for SMR.
However, the question I have is in Cow vs non-CoW system differences
for allocation preferences, and what other changes need to be made in
*all* the file systems.

>
>> == Data zones
>>
>> What we need is a mechanism for tracking the location of zones (i.e. start LBA),
>> free space/write pointers within each zone, and some way of keeping track of
>> that information across mounts. If we assign a real time bitmap/summary inode
>> pair to each zone, we have a method of tracking free space in the zone. We can
>> use the existing bitmap allocator with a small tweak (sequentially ascending,
>> packed extent allocation only) to ensure that newly written blocks are allocated
>> in a sane manner.
>>
>> We're going to need userspace to be able to see the contents of these inodes;
>> read only access wil be needed to analyse the contents of the zone, so we're
>> going to need a special directory to expose this information. It would be useful
>> to have a ".zones" directory hanging off the root directory that contains all
>> the zone allocation inodes so userspace can simply open them.
>
> The ZBC standard is being constructed.  However, all revisions agree
> that the drive is perfectly capable of tracking the zone pointers (and
> even the zone status).  Rather than having you duplicate the information
> within the XFS metadata, surely it's better with us to come up with some
> block way of reading it from the disk (and caching it for faster
> access)?
>

In discussions with Dr. Reinecke, it seems extremely prudent to have a
kernel cache somewhere.  The SD driver would be the base for updating
the cache, but it would need to be available to the allocators, the
/sys fs for userspace utilities, and possibly other processes.  In
EXT4, I don't think it's feasible to have the cache -- however, the
metadata will MIRROR the cache ( BG# = Zone#, databitmap = WP, etc)

>
>> == Quantification of Random Write Zone Capacity
>>
>> A basic guideline is that for 4k blocks and zones of 256MB, we'll need 8kB of
>> bitmap space and two inodes, so call it 10kB per 256MB zone. That's 40MB per TB
>> for free space bitmaps. We'll want to suport at least 1 million inodes per TB,
>> so that's another 512MB per TB, plus another 256MB per TB for directory
>> structures. There's other bits and pieces of metadata as well (attribute space,
>> internal freespace btrees, reverse map btrees, etc.
>>
>> So, at minimum we will probably need at least 2GB of random write space per TB
>> of SMR zone data space. Plus a couple of GB for the journal if we want the easy
>> option. For those drive vendors out there that are listening and want good
>> performance, replace the CMR region with a SSD....
>
> This seems to be a place where standards work is still needed.  Right at
> the moment for Host Managed, the physical layout of the drives makes it
> reasonably simple to convert edge zones from SMR to CMR and vice versa
> at the expense of changing capacity.  It really sounds like we need a
> simple, programmatic way of doing this.  The question I'd have is: are
> you happy with just telling manufacturers ahead of time how much CMR
> space you need and hoping they comply, or should we push for a standards
> way of flipping end zones to CMR?
>

I agree this is an issue, but for HA (and less for HM), there is a lot
of flexability needed for this.  In our BoFs at Vault, we talked about
partitioning needs.  We cannot assume that there is 1 partition per
disk, and that it has absolute boundaries.  Sure a data disk can have
1 partition from LBA 0 to end of disk, but an OS disk can't.  For
example, GPT and EFI cause problems.  On the other end, gamers and
hobbists tend to dual/triple boot....  There cannot be a onesize
partition for all purposes.

The conversion between CMR and SMR zones is not simple.  That's a
hardware format.  Any change in the LBA space would be non-linear.

One idea that I came up with in our BoFs is using flash with an FTL.
If the manufacturers put in enough flash to cover 8 or so zones, then
a command could be implemented to allow the flash to be assigned to
zones.  That way, a limited number of CMR zones can be placed anywhere
on the disk without disrupting format or LBA space.  However, ZAC/ZBC
is to be applied to flash also...

>
>> === Crash recovery
>>
>> Write pointer location is undefined after power failure. It could be at an old
>> location, the current location or anywhere in between. The only guarantee that
>> we have is that if we flushed the cache (i.e. fsync'd a file) then they will at
>> least be in a position at or past the location of the fsync.
>>
>> Hence before a filesystem runs journal recovery, all it's zone allocation write
>> pointers need to be set to what the drive thinks they are, and all of the zone
>> allocation beyond the write pointer need to be cleared. We could do this during
>> log recovery in kernel, but that means we need full ZBC awareness in log
>> recovery to iterate and query all the zones.
>
> If you just use a cached zone pointer provided by block, this should
> never be a problem because you'd always know where the drive thought the
> pointer was.

This would require a look at the order of updating the stack
information, and also WCD vs WCE behavior.  As for the WP, the spec
says that any data after the WP is returned with a clear pattern
(zeros on Seagate drives) -- it is already cleared.

>
>
>> === RAID on SMR....
>>
>> How does RAID work with SMR, and exactly what does that look like to
>> the filesystem?
>>
>> How does libzbc work with RAID given it is implemented through the scsi ioctl
>> interface?
>
> Probably need to cc dm-devel here.  However, I think we're all agreed
> this is RAID across multiple devices, rather than within a single
> device?  In which case we just need a way of ensuring identical zoning
> on the raided devices and what you get is either a standard zone (for
> mirror) or a larger zone (for hamming etc).
>

I agree.  It's up to the DM to mangle the zones and provide proper
modified zone info up to the FS.  In the case of mirror, keeps the
same zone size, just half the total of zones (or half in a condition
of read-only/full).  In stripped paradigms, double (or more if the
zone sizes don't match, or if more that 2 drives) the zone size and
let the DM mod the block numbers to determine the correct disk.  For
EXT4, this REQUIRES the equivalent of 8k Blocks.

> James
>
>

== Kernel implementation

The allocator will need to learn about multiple allocation zones based on
bitmaps. They aren't really allocation groups, but the initialisation and
iteration of them is going to be similar to allocation groups. To get use going
we can do some simple mapping between inode AG and data AZ mapping so that we
keep some form of locality to related data (e.g. grouping of data by parent
directory).

We can do simple things first - simply rotoring allocation across zones will get
us moving very quickly, and then we can refine it once we have more than just a
proof of concept prototype.

Optimising data allocation for SMR is going to be tricky, and I hope to be able
to leave that to drive vendor engineers....

Ideally, we won't need a zbc interface in the kernel, except to erase zones.
I'd like to see an interface that doesn't even require that. For example, we
issue a discard (TRIM) on an entire  zone and that erases it and
resets the write
pointer. This way we need no new infrastructure at the filesystem layer to
implement SMR awareness. In effect, the kernel isn't even aware that it's an SMR
drive underneath it.


Dr. Reinecke has already done the Discard/TRIM stuff.  However, he's
as of yet ignored the zone management pieces.  I have thought
(briefly) of the possible need for a new allocator:  the group
allocator.  As there can only be a few (relatively) zones available at
any one time, We might need a mechanism to tell which are available
and which are not.  The stack will have to collectively work together
to find a way to request and use zones in an orderly fashion.



> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
