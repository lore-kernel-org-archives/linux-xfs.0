Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D88617F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 21:14:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF5248F8035
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 19:14:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	o2dpZFelZPjYiPvt for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 19:14:11 -0700 (PDT)
Date: Tue, 18 Aug 2015 12:14:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS File system in trouble
Message-ID: <20150818021408.GH714@dastard>
References: <20150728123307.GC38784@bfoster.bfoster>
	<55B79BFD.6020509@mygrande.net>
	<20150728221150.GA26604@bfoster.bfoster>
	<55BE7C75.4060604@mygrande.net> <55C06F41.4030502@mygrande.net>
	<20150804224240.GU16638@dastard> <55C8006C.8070807@mygrande.net>
	<55CC375C.10902@mygrande.net> <20150814012635.GT3902@dastard>
	<55CE75CA.5070506@mygrande.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55CE75CA.5070506@mygrande.net>
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
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: "Rhorer, Leslie" <Leslie.Rhorer@level3.com>, Brian Foster <bfoster@redhat.com>, Kris Rusocki <kszysiu@braxis.org>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Aug 14, 2015 at 06:12:10PM -0500, Leslie Rhorer wrote:
> 
> 	OK, try http://fletchergeek.com/images/md0.metadump.gz.  It's only
> about 18M.

There's a very specific corruption that has occurred here. There are
7 inodes in a row (i.e. same 4k block) with the same corruption
signature. Only the first inode has the version number corrupted, so
that is the only one that is being picked up as corrupt on
allocation, however.

The pattern is that there are certain fields that have wacky values.
The timestamps, the uid/gid, the projid_lo/hi, dmstate
(completely unused field), the extent size and the generation
number.

The generation number is particularly interesting, because every
inode in a chunk is stamped with the same number when the inode
chunk is allocated on disk. The majority of the inodes in the chunk
(which have no corruption) have a value of 0x93dc8d4. One of the
corrupted inodes has a value of 0x7b4bada6, which if valid means the
inode has been allocated and freed almost 2 billion times.

That doesn't seem reasonable, especially as the other corrupted
inodes also having generation cycle deltas of between 50 million and
1.2 billion I'm verymuch doubting these numbers are correct as it
implies that these 7 inodes have run through almost 3.7 billion
inode alloc/free cycles just by themselves.

What's really interesting is this pattern shows up in most of the
corrupted inodes:

600: 494e0000 02020000 00bdf700 00aa4ae8 00000000 005a4a00 00054800 00a94806
                         ^^^^     ^^^^		    ^^^^     ^^^^     ^^^^
620: 011cc1e5 3c3aa24c 1ca3ba8c 00a94800 004bf6a2 3868ff92 00000000 00000000
                                  ^^^^     ^^^^
640: 00000000 00000000 0087f500 00000000 00000002 00000000 004b0000 093880d4
                         ^^^^                                ^^^^     ^^^^

All the highlighted bytes are ones that I can confirm are corrupt.
They are all the middle 2 bytes of a 4 byte word, and they are all
random garbage. The last four (of 7) corrupted inodes have the same corrupted
bytes. The bytes have different values, but they all have, at
minimum, the above bytes corrupted. The initial inode that was
corrupted (with version = 3) has more corrupted bytes than the
others, but the corruption follows a very similar pattern and is
almost identical in inodes 2 and 3.

Patterns of corruption like this don't come from software. All of
the corruptions are in the first 64 byte cacheline of the inodes,
and all have a very similar pattern of corruption and the corrupted
byte values all appear to be random. Given that you initially said
this:

| I found the problem with md5sum (and probably nfs, as
| well).  One of the memory modules in the server was bad.  The
| problem with XFS persists.  Every time tar tried to create the
| directory:

That's what caused the corruption on disk. XFS has validated the
buffer while it was hot in the CPU cache, and when submitted to the
hardware to DMA it to disk it first has to be written back to
memory. That inode buffer page happened to span the bad memory
location and so the inodes were corrupted on their way to disk by
the bad memory.

Not a software bug, but a clear demonstration of why we consider
metadata CRCs very important. On a v5 filesystem, this type of
metadata corruption will show up as a CRC failure, and hence we'll
know straight away that the likely cause is a hardware issue....

And to close the loop, I have confirmed that Roger's patch fixes
repair - it detects the bad inode and fixes it (tested against
xfsprogs 4.2.0-rc1).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
