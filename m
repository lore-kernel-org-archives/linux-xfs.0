Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53MT0Nt036219 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 17:29:00 -0500
Received: from mail-px0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50BE449D119
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 15:28:58 -0700 (PDT)
Received: from mail-px0-f174.google.com (mail-px0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	POzfNVokgJdH2nW8 for <xfs@oss.sgi.com>;
	Fri, 03 Jun 2011 15:28:58 -0700 (PDT)
Received: by pxi15 with SMTP id 15so1562977pxi.5
	for <xfs@oss.sgi.com>; Fri, 03 Jun 2011 15:28:58 -0700 (PDT)
Message-ID: <4DE96026.2030802@philkarn.net>
Date: Fri, 03 Jun 2011 15:28:54 -0700
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: Re: I/O hang, possibly XFS, possibly general
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<19943.56524.969126.59978@tree.ty.sabi.co.UK>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
	<4DE823DD.7060600@philkarn.net> <20110603003907.GW561@dastard>
	<BANLkTikg33_Q89XVuXZgaAAMbhDHnPR+fg@mail.gmail.com>
	<20110603025459.GB561@dastard>
In-Reply-To: <20110603025459.GB561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Paul Anderson <pha@umich.edu>, Linux fs XFS <xfs@oss.sgi.com>

On 6/2/11 7:54 PM, Dave Chinner wrote:

> There are definitely cases where it helps for preventing
> fragmenting, but as a sweeping generalisation it is very, very
> wrong.

Well, if I ever see that in practice I'll change my procedures.

> Do you do that for temporary object files when you build <program X>
> from source?

No, that would involve patching gcc to use fallocate(). I could be wrong
-- I don't know much about gcc internals -- but I think most temp files
go on /tmp, which is not xfs. As I clearly said, I patched only a few
file copy programs like rsync that I use to create long-lived files. I
can't see why the upstream maintainers of those programs shouldn't
accept patches to incorporate fallocate() as long as care is taken to
avoid calling the POSIX version and no other harm is done on file
systems or OSes that don't support it.

> Allocation and freeing has CPU overhead, transaction overhead, log
> space overhead, can cause free space fragmentation when you have a
> mix of short- and long-lived files being preallocated at the same
> time, IO for long lived data does not get packed together closely so
> requires more seeks to issue which leads to significantly worse IO
> performance on RAID5/6 storage sub-systems, etc.

I'll believe that when I see it. Like a lot of people I am moving away
from RAID 5/6.

It is hard to see how keeping files contiguous can lead to free space
fragmentation. Seems to me that when a file is severely fragmented, so
is the free space around it. Keeping a file contiguous also keeps free
space in fewer, larger pieces.

> You do realise that your "attr out of line" problem would have gone
> away by simply increasing the XFS inode size at mkfs time? And that
> there is almost no performance penalty for doing this?  Instead, it
> seems you found a hammer named fallocate() and proceeded to treat
> every tool you have like a nail. :)

You do realize that I started experimenting with attributes well *after*
I had built XFS on a 6 GB (net) RAID5 that took over a week of solid
copying to load to 50%? I had noticed the inode size parameter to
mkfs.xfs but I wasn't about to buy four more disks, mkfs a whole new
file system with bigger inodes and copy all my data (again) just to
waste more space on largely empty inodes and, more importantly, require
many more disk seeks and reads to walk through them all.

The default xfs inode is 256 bytes. That means a single 4KiB block read
fetches 16 inodes at once. Making each inode 512 bytes means reading
only 8 inodes in each 4KiB block. That's arithmetic.

And I'd still have no guarantee of keeping my attributes in the inodes
without some limit on the size of the extent list.

> Changing a single mkfs parameter is far less work than maintaining
> your own forks of multiple tools....

See above. I've since built a new RAID1 array with bigger and faster
drives and am abandoning RAID5, but I still see no reason to waste disk
space and seeks on larger data structures that are mostly empty space. A
long extent table contains overhead information that is useless -- noise
-- to me, the user. Defragmenting a file discards that information and
allows more of the disk's storage and I/O capacity to be used for user data.

The only drawback I can see to keeping a file system defragmented is
that I give up an opportunity for steganography, i.e., hiding
information in the locations and sizes of those seemingly random
sequences of extent allocations. I know this has been done.

> Until aging has degraded your filesystem til free space is
> sufficiently fragmented that you can't allocate large extents any
> more. Then you are completely screwed. :/

Once again, it is very difficult to see how keeping my long-lived files
contiguous causes free space to become more fragmented, not less. Help
me out here; it's highly counter intuitive, and more importantly I
haven't seen that problem, at least not yet.

I have a few extremely large files (many GB) that cannot be allocated a
contiguous area. That's probably because of xfs's strategy of scattering
files around disk to allow room for growth, which fragments the free
space. But that's not a big problem since I don't have very many such
files. Each extent is still pretty big, so sequential I/O is still quite
fast, and if their attributes are squeezed out of their inodes it's not
a big performance hit either.

You seem to take personal offense to my use of fallocate(), which is
hardly my intention. Did you perhaps write the xfs preallocation code
that I'm bypassing? As I said, I still rely on it for log files,
mailboxes and temporary files, and it is much appreciated.

--Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
