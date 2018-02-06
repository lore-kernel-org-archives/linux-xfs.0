Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from synagogue.naos.co.nz ([203.171.38.148]:38210 "EHLO
        synagogue.naos.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbeBFCEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 21:04:14 -0500
Subject: Storage considerations for XFS layout documentation (was Re:
 Rationale for hardware RAID 10 su, sw values in FAQ)
References: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
 <20170927004302.GB3666@dastard>
 <db821c38-1307-0681-ffc2-4400ffd8d27a@mcneill.gen.nz>
 <20170927043308.GC3666@dastard>
 <c7ade829-9385-c517-581b-8dc73def5693@mcneill.gen.nz>
 <0dbebe1a-4704-0880-87cc-f029921b6c7f@mcneill.gen.nz>
 <20171220222933.GH4094@dastard>
From: Ewen McNeill <xfs@ewen.mcneill.gen.nz>
Message-ID: <bf90dcac-c3d0-b87e-a3cb-87c2dd202c7b@mcneill.gen.nz>
Date: Tue, 6 Feb 2018 14:56:22 +1300
MIME-Version: 1.0
In-Reply-To: <20171220222933.GH4094@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

On 21/12/17 11:29, Dave Chinner wrote:
>> On 28/09/17 12:36, Ewen McNeill wrote:
>>> Perhaps the perfect is the enemy of the good here.  Would it help
>>> if I were to write up some text covering:
>>> [... storage media/RAID considerations for xfs layout ...]
>> [...]
> Sure, if you've got time to write something it would be greatly
> appreciated.

I finally found some time to write up some storage technology background 
that impacts on file system layout, and some recommendations on 
alignment and su/sw values.

It... turned out longer than "a page or so" (my fingers default to 
verbose, not terse!), and I suspect in practice most of it is common to 
*all* filesystems and would be better in another document referenced 
from XFS_Performance_Tuning/filesystem_tunables.asciidoc, rather than 
inlined in the XFS document.

But it is the sort of documentation I was hoping to find, as a sysadmin, 
when I went looking last year -- including enough background to 
understand *why* particular values are recommended -- so I think it's 
all useful somewhere in the kernel documentation.

There's a non-trivial amount of yak shaving required to, eg, try to 
contribute it via a kernel git patch (and I'm unclear what the 
documentation subtree requires for contributions anyway).  So given that 
I'm not even sure it all belongs in 
XFS_Performance_Tuning/filesystem_tunables.asciidoc I thought I'd just 
include what I wrote here (ie, linux-xfs) in the hope that it is useful. 
  If you, eg, want to accept it as is into that document I can work on 
turning it into an actual patch.  Or feel free to cut'n'paste it into 
the existing document or another nearby document in the kernel source.

Below is written as a replacement for:

-=- cut here -=-
==== Alignment to storage geometry

TODO: This is extremely complex and requires an entire chapter to itself.
-=- cut here -=-

portion of the 
https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc 
document.  I believe it's valid asciidoc (seems to format okay here) if 
one puts enough "higher level" headers in as a prefix to make the 
asciidoc tools happy).

Ewen

PS: Please CC me on all comments; I'm not subscribed to linux-xfs.

-=- cut here -=-
==== Alignment to storage geometry

XFS can be used on a wide variety of storage technology (spinning
magnetic disks, SSDs), on single disks or spanned across multiple
disks (with software or hardware RAID).  Potentially there are
multiple layers of abstraction between the physical storage medium
and the file system (XFS), including software layers like LVM, and
potentially https://en.wikipedia.org/wiki/Flash_memory_controller[flash
translation layers] or
https://en.wikipedia.org/wiki/Hierarchical_storage_management[hierachical
storage management].

Each of these technology choices has its own requirements for best
alignment, and/or its own trade offs between latency and performance,
and the combination of multiple layers may introduce additional
alignment or layout constraints.

The goal of file system alignment to the storage geometry is to:

* maximise throughput (eg, through locality or parallelism)

* minimise latency (at least for common activities)

* minimise storage overhead (such as write amplification
due to read-modify-write -- RMW -- cycles).

===== Physical Storage Technology

Modern storage technology divides into two broad categories:

* magnetic storage on spinning media (eg, HDD)

* flash storage (eg, SSD or https://en.wikipedia.org/wiki/NVM_Express[NVMe])

These two storage technology families have distinct features that influence
the optimal file system layout.

*Magnetic Storage*: accessing magnetic storage requires moving a
physical read/write head across the magnetic media, which takes a
non-trivial amount of time (ms).  The seek time required to move
the head to the correct location is approximately linearly proportional
to the distance the head needs to move, which means two locations
near each other are faster to access than two locations far away.
Performance can be improved by locating data regularly accessed
together "near" each other.  (See also
https://en.wikipedia.org/wiki/Hard_disk_drive_performance_characteristics[Wikipeida
Overview of HDD performance characteristics].)

*4KiB physical sectors HDD*: Most larger modern magnetic HDDs (many
2TiB+, almost all 4TiB+) use 4KiB physical sectors to help minimise
storage overhead (of sector headers/footers and inter-sector gaps),
and thus maximise storage density.  But for backwards compatibility
they continue to present the illusion of 512 byte logical sectors.
Alignment of file system data structures and user data blocks to
the start of (4KiB) _physical_ sectors avoids unnecessarily spanning
a read or write across two physical sectors, and thus avoids write
amplification.

*Flash Storage*: Flash storage has both a page size (smallest unit
that can be written at once), _and_ an erase block size (smallest
unit that can be erased) which is typically much larger (eg, 128KiB).
A key limitation of flash storage is that only one value can be
written to it on an individual bit/byte level.  This means that
updates to physical flash storage usually involve an erase cycle
to "blank the slate" with a single common value, followed by writing
the bits that should have the other value (and writing back
the unmodified data -- a read-modify-write cycle).  To further
complicate matters, most flash storage physical media has a limitation
on how many times a given physical storage cell can be erased, depending
on the technology used (typically in the order of 10000 times).

To compensate for these technological limitations, all flash storage
suitable for use with XFS uses a Flash Translation Layer within the
device, which provides both wear levelling and relocation of
individual pages to different erase blocks as they are updated (to
minimise the amount that needs to be updated with each write, and
reduce the frequency blocks are erased).  These are often implemented
on-device as a type of log structured file system, hidden within the
device.

For a file system like XFS, a key consideration is to avoid spanning
data structures across erase blocks boundaries, as that would mean
that multiple erase blocks would need updating for a single change.
https://en.wikipedia.org/wiki/Write_amplification[Write amplification]
within the SSD may still result in multiple updates to physical
media for a single update, but this can be reduced by advising the
flash storage of blocks that do not need to be preserved (eg, with
the `discard` mount option, or by using `fstrim`) so it stops copying
those blocks around.

===== RAID

RAID provides a way to combine multiple storage devices into one
larger logical storage device, with better performance or more
redundancy (and sometimes both, eg, RAID-10).  There are multiple
RAID array arrangements ("levels") with different performance
considerations.  RAID can be implemented both directly in the Linux
kernel ("software RAID", eg the "MD" subsystem), or within a dedicated
controller card ("hardware RAID").  The filesystem layout considerations
are similar for both, but where the "MD" subsystem is used modern user
space tools can often automatically determine key RAID parameters and
use those to tune the layout of higher layers; for hardware RAID
these key values typically need to be manually determined and provided
to user space tools by hand.

*RAID 0* stripes data across two or more storage devices, with
the aim of increasing performance, but provides no redundancy (in fact
the data is more at risk as failure of any disk probably renders the
data inaccessible).  For XFS storage layout the key consideration is
to maximise parallel access to all the underlying storage devices by
avoiding "hot spots" that are reliant on a single underlying device.

*RAID 1* duplicates data (identically) across two more more
storage devices, with the aim of increasing redundancy.  It may provide
a small read performance boost if data can be read from multiple
disks at once, but provides no write performance boost (data needs
to be written to all disks).  There are no special XFS storage layout
considerations for RAID 1, as every disk has the same data.

*RAID 5* organises data into stripes across three or more storage
devices, where N-1 storage devices contain file system data, and
the remaining storage device contains parity information which
allows recalculation of the contents of any one other storage device
(eg in the event that storage device fails).  To avoid the "parity"
block being a hot spot, its location is rotated amongst all the
member storage devices (unlike RAID 4 which had a parity hot spot).
Writes to RAID-5 require reading multiple elements of the RAID 5
parity block set (to be able to recalculate the parity values), and
writing at least the modified data block and parity block.  The
performance of RAID 5 is improved by having a high hit rate on
caching (thus avoiding the read part of the read-modify-write cycle),
but there is still an inevitable write overhead.

For XFS storage layout on RAID 5 the key considerations are the
read-modify-write cycle to update the parity blocks (and avoiding
needing to unnecessarily modify multiple parity blocks), as well as
increasing parallelism by avoiding hot spots on a single underlying
storage device.  For this XFS needs to know both the stripe size on
an underlying disk, and how many of those stripes can be stored before
it cycles back to the same underlying disk (N-1).

*RAID 6* is an extension of the RAID 5 idea, which uses two parity
blocks per set, so N-2 storage devices contain file system data and
the remaining two storage device contain parity information.  This
increases the overhead of writes, for the benefit of being able to
recover information if more than one storage device fails at the
same time (including, eg, during the recovery from the first storage
device failing -- a not unknown even with larger storage devices and
thus longer RAID parity rebuild recovery times).

For XFS storage layout on RAID 6, the considerations are the same
as RAID 5, but only N-2 disks contain user data.

*RAID 10* is a conceptual combination of RAID 1 and RAID 0, across
at least four underlying storage devices.  It provides both storage
redundancy (like RAID 1) and interleaving for performance (like
RAID 0).  The write performance (particularly for smaller writes)
is usually better than RAID 5/6, at the cost of less usable storage
space.  For XFS storage layout the RAID-0 performance considerations
apply -- spread the work across the underlying storage devices to
maximise parallelism.

A further layout consideration with RAID is that RAID arrays typically
need to store some metadata with each RAID array that helps it
locate the underlying storage devices.  This metadata may be stored
at the start or end of the RAID member devices.  If it is stored
at the start of the member devices, then this may introduce alignment
considerations.  For instance the Linux "MD" subsystem has multiple
metadata formats, and formats 0.9/1.0 store the metadata at the end
of the RAID member devices and formats 1.1/1.2 store the metadata
at the beginning of the RAID member devices.  Modern user space
tools will typically try to ensure user data starts on a 1MiB
boundary ("Data Offset").

Hardware RAID controllers may use either of these techniques too, and
may require manual determination of the relevant offsets from documentation
or vendor tools.

===== Disk partitioning

Disk partitioning impacts on file system alignment to the underlying
storage blocks in two ways:

* the starting sectors of each partition need to be aligned to the
underlying storage blocks for best performance.  With modern Linux
user space tools this will typically happen automatically, but older
Linux and other tools often would attempt to align to historically
relevant boundaries (eg, 63-sector tracks) that are not only
irrelevant to modern storage technology but due to the odd number
(63) result in misalignment to the underlying storage blocks (eg,
4KiB sector HDD, 128KiB erase block SSD, or RAID array stripes).

* the partitioning system may require storing metadata about the
partition locations between partitions (eg, `MBR` logical partitions),
which may throw off the alignment of the start of the partition
from the optimal location.  Use of `GPT` partitioning is recommended
for modern systems to avoid this, or if `MBR` partitioning is used
either use only the 4 primary partitions or take extra care when
adding logical partitions.

Modern Linux user space tools will typically attempt to align on
1MiB boundaries to maximise the chance of achieving a good alignment;
beware if using older tools, or storage media partitioned with older
tools.

===== Storage Virtualisation and Encryption

Storage virtualisation such as the Linux kernel LVM (Logical Volume
Manager) introduce another layer of abstraction between the storage
device and the file system.  These layers may also need to store
their own metadata, which may affect alignment with the underlying
storage sectors or erase blocks.

LVM needs to store metadata the physical volumes (PV) -- typically
192KiB at the start of the physical volume (check the "1st PE" value
with `pvs -o name,pe_start`).  This holds both physical volume
information as well as volume group (VG) and logical volume (LV)
information.  The size of this metadata can be adjusted at `pvcreate`
time to help improve alignment of the user data with the underlying
storage.

Encrypted volumes (such as LUKS) also need to store their own
metadata at the start of the volume.  The size of this metadata
depends on the key size used for encryption.  Typical sizes are
1MiB (256-bit key) or 2MiB (512-bit key), stored at the start of
the underlying volume.  These headers may also cause alignment
issues with the underlying storage, although probably only in the
case of wider RAID 5/6/10 sets.  The `--align-payload` argument
to `cryptsetup` may be used to influence the data alignment of
the user data in the encrypted volume (it takes a value in 512
byte logical sectors), or a detached header (`--header DEVICE`)
may be used to store the header somewhere other than the start
of the underlying device.

===== Determining `su`/`sw` values

Assuming every layer in your storage stack is properly aligned with
the underlying layers, the remaining step is to give +mkfs.xfs+
appropriate values to guide the XFS layout across the underlying
storage to minimise latency and hot spots and maximise performance.
In some simple cases (eg, modern Linux software RAID) +mkfs.xfs+ can
automatically determine these values; in other cases they may need
to be manually calculated and supplied.

The key values to control layout are:

* *`su`*: stripe unit size, in _bytes_ (use `m` or `g` suffixes for
MiB or GiB) that is updatable on a single underlying device (eg,
RAID set member)

* *`sw`*: stripe width, in member elements storing user data before
you wrap around to the first storage device again (ie, excluding
parity disks, spares, etc); this is used to distribute data/metadata
(and thus work) between multiple members of the underlying storage
to reduce hot spots and increase parallelism.

When multiple layers of storage technology are involved, you want to
ensure that each higher layer has a block size that is the same as
the underlying layer, or an even multiple of the underlying layer, and
then give that largest multiple to +mkfs.xfs+.

Formulas for calculating appropriate values for various storage technology:

* *HDD*: alignment to physical sector size (512 bytes or 4KiB).
This will happen automatically due to XFS defaulting to 4KiB block
sizes.

* *Flash Storage*: alignment to erase blocks (eg, 128 KiB).  If you have
a single flash storage device, specify `su=ERASE_BLOCK_SIZE` and `sw=1`.

* *RAID 0*: Set `su=RAID_CHUNK_SIZE` and `sw=NUMBER_OF_ACTIVE_DISKS`, to
spread the work as evenly as possible across all member disks.

* *RAID 1*: No special values required; use the values required from
the underlying storage.

* *RAID 5*: Set `su=RAID_CHUNK_SIZE` and `sw=(NUMBER_OF_ACTIVE_DISKS-1)`,
as one disk is used for parity so the wrap around to the first disk
happens one disk earlier than the full RAID set width.

* *RAID 6*: Set `su=RAID_CHUNK_SIZE` and `sw=(NUMBER_OF_ACTIVE_DISKS-2)`,
as one disk is used for parity so the wrap around to the first disk
happens one disk earlier than the full RAID set width.

* *RAID-10*: The RAID 0 portion of RAID-10 dominates alignment
considerations. The RAID 1 redundancy reduces the effective number
of active disks, eg 2-way mirroring halves the effective number of
active disks, and 3-way mirroring reduces it to one third.  Calculate
the number of effective active disks, and then use the RAID 0 values.
Eg, for 2-way RAID 10 mirroring, use `su=RAID_CHUNK_SIZE` and
`sw=(NUMBER_OF_MEMBER_DISKS / 2)`.

* *RAID-50/RAID-60*: These are logical combinations of RAID 5 and
RAID 0, or RAID 6 and RAID 0 respectively.  Both the RAID 5/6 and
the RAID 0 performance characteristics matter.  Calculate the number
of disks holding parity (2+ for RAID 50; 4+ for RAID 60) and subtract
that from the number of disks in the RAID set to get the number of
data disks.  Then use su=RAID_CHUNK_SIZE` and
`sw=NUMBER_OF_DATA_DISKS`.

For the purpose of calculating these values in a RAID set only the
active storage devices in the RAID set should be included; spares,
even dedicated spares, are outside the layout considerations.

===== A note on `sunit`/`swidth` versus `su`/`sw`

Alignment values historically were specified in `sunit`/`swidth`
values, which provided numbers in _512-byte sectors_, where `swidth`
was some multiple of `sunit`.  These units were historically useful
when all storage technology used 512-byte logical and physical
sectors, and often reported by underlying layers in physical sectors.
However they are increasingly difficult to work with for modern
storage technology with its variety of physical sector and block sizes.

The `su`/`sw` values, introduced later, provide a value in *bytes* (`su`)
and a number of occurrences (`sw`), which are easier to work with when
calculating values for a variety of physical sector and block sizes.

Logically:

* `sunit = su / 512`

* `swidth = sunit * sw`

With the result that `swidth = (su / 512) * sw`.

Use of `sunit` / `swidth` is discouraged, and use of `su` / `sw` is
encouraged to avoid confusion.

*WARNING*: beware that while the `sunit`/`swidth` values are
*specified* to +mkfs.xfs+ in _512-byte sectors_, they are *reported*
by +mkfs.xfs+ (and `xfs_info`) in file system _blocks_ (typically
4KiB, shown in the `bsize` value).  This can be very confusing, and
is another reason to prefer to specify values with `su` / `sw` and
ignore the `sunit` / `swidth` options to +mkfs.xfs+.
-=- cut here -=-

