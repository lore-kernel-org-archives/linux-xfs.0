Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RDxOZc049569 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 07:59:24 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 041CCBD955
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 05:58:40 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id yFzrHpG0vNVbv8tb for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 05:58:40 -0800 (PST)
Message-ID: <497F130F.4010107@sandeen.net>
Date: Tue, 27 Jan 2009 07:58:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs open questions
References: <200901270928.29215@zmi.at>
In-Reply-To: <200901270928.29215@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> Dear list,
> 
> I'm new here, experienced admin, trying to understand XFS correctly. 
> I've read 
> http://xfs.org/index.php/XFS_Status_Updates
> http://oss.sgi.com/projects/xfs/training/index.html
> http://en.wikipedia.org/wiki/Xfs
> and still have some xfs questions, which I guess should be in the FAQ 
> also because they were the first questions I raised when trying XFS. I 
> hope this is the correct list to ask this, and hope this very long first 
> mail isn't too intrusive:
> 
> - Stripe Alignment
> It's very nice to have the FS understand where it runs on, and that you 
> can optimize for it. But the documentation on how to do that correctly 
> is incomplete.
> http://oss.sgi.com/projects/xfs/training/xfs_slides_04_mkfs.pdf
> On page 5 is an example an an "8+1 RAID". Does it mean "9 disks in 
> RAID-5"? So 8 are data and 1 is parity, and for XFS only the data disks 
> are important?
> If so, when I have a 8 disks RAID 6 (where 2 are parity, 6 data) and a 8 
> disks RAID-50 (again 2 parity, 6 data) would be the same?
> Let's say I have 64k stripe size on the RAID controller, with above 8 
> disks RAID 6. So best performance would be
> mkfs -d su=64k,sw=$((64*6))k
> is that correct? It would be good if there's clearer documentation with 
> more examples.

I think that's all correct.  It's basically this: stripe unit is
per-disk, sripe width is unit*data_disks.  And then there's the added
bonus of the differing units on su/sw vs. sunit/swidth.  :)

I'd love to be able to update these pdf files, but despite asking for
the source document several times over a couple months, nothing has been
provided.  Unfortunately 'til then it's up to SGI to update them and the
community can't help much (SGI: hint, hint).

> - 64bit Inodes
> On the allocator's slides 
> http://oss.sgi.com/projects/xfs/training/xfs_slides_06_allocators.pdf
> it's said that if the volume is >1TB, 32bit Inodes make the FS suffer, 
> and that 64bit Inodes should be used. Is that a safe function? 

It is safe from the filesystem integrity perspective, but as you note
below some applications may have trouble.

> Documentation says some backup tools can't handle 64bit Inodes, are 
> there problems with other programs as well? 

Potentially, yes:
http://sandeen.net/wordpress/?p=9

> Is the system fully 
> supporting 64bit Inodes? 64bit Linux kernel needed I guess?

The very latest (2.6.29) kernels can use the inode64 option on a 32-bit
machine.  And stat64 can be used on a 32bit machine as well, but it's up
to apps to do this.

> And if I already created a FS >1TB with 32bit Inodes, it would be better 
> to recreate it with 64bit Inodes and restore all data then?

You can always mount with inode64; your data allocation patterns will be
somewhat different.  In the first case, your data will be more heavily
shifted towards the high blocks of the filesystem, to keep room
available for (32-bit) inodes in the lower blocks.

> - Allocation Groups
> When I create a XFS with 2TB, and I know it will be growing as we expand 
> the RAID later, how do I optimize the AG's? If I now start with 
> agcount=16, and later expand the RAID +1TB so having 3 instead 2TB, what 
> happens to the agcount? Is it increased, or are existing AGs expanded so 
> you still have 16 AGs? I guess that new AG's are created, but it's 
> nowhere documented.

Yes, growing a filesystem simply fills out the last AG to full size if
it's not already, and then adds additional AGs on the end, with a
potentially "short" ag on the end, depending on the size.

I would not get overly concerned with AG count; newer mkfs.xfs has lower
defaults (i.e. creates larger AGs, 4 by default, even for a 2T
filesystem) but to some degree what's "best" depends both on the storage
underneath and the way the fs will be used.

But with defaults, your 2T/4AG filesystem case above would grow to
3T/6AGs, which is fine for many cases.

> - mkfs warnings about stripe width multiples
> For a RAID 5 with 4 disks having 2,4TB on LVM I did:
> # mkfs.xfs -f -L oriondata -b size=4096 -d su=65536,sw=3,agcount=40 -i 
> attr=2 -l lazy-count=1,su=65536 /dev/p3u_data/data1
> Warning: AG size is a multiple of stripe width.  This can cause 
> performance problems by aligning all AGs on the same disk.  To avoid 
> this, run mkfs with an AG size that is one stripe unit smaller, for 
> example 13762544.

Hm it's unfortunate that there are no units on that number.  Easy to fix.

This is to avoid all metadata landing on a single disk; similar to how
mkfs.ext3 wants to use "stride" in its one geometry-tuning knob.

> meta-data=/dev/p3u_data/data1    isize=256    agcount=40, 
> agsize=13762560 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=550502400, 
> imaxpct=5
>          =                       sunit=16     swidth=48 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-
> count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> and so I did it again with
> # mkfs.xfs -f -L oriondata -b size=4096 -d 
> su=65536,sw=3,agsize=13762544b -i attr=2 -l lazy-count=1,su=65536 
> /dev/p3u_data/data1
> meta-data=/dev/p3u_data/data1    isize=256    agcount=40, 
> agsize=13762544 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=550501760, 
> imaxpct=5
>          =                       sunit=16     swidth=48 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-
> count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> It would be good if mkfs would correctly says "... run mkfs with an AG 
> size that is one stripe unit smaller, for example 13762544b". The "b" at 
> the end is very important, that cost me a lot of search in the 
> beginning.

Agreed.

> Is there a limit on the number of AG's? Theoretical and practical? Is 
> there a guideline how many AGs to use? Depending on CPU cores, or number 
> of parallel users, or spindles, or something else? Page 4 of the mkfs 
> docs (link above) says "too few or too many AG's should be avoided", but 
> what numbers are "few" and "many"?

:)

The defaults were recently moved to be lower (4 by default).  Files in
new subdirs are rotated into new AGs, all other things being equal
(space available, 64-bit-inode allocator mode).  To be honest I don't
have a good answer for you on when you'd want more or fewer AGs,
although AGs are parallel independent chunks of the fs to large degree,
so in some cases, more AGs may help certain kinds of parallel
operations.  Perhaps others can chime in a bit more on this tuning ....

> - PostgreSQL
> The PostgreSQL database creates a directory per DB. From the docs I read 
> that this creates all Inodes within the same AG. But wouldn't it be 
> better for performance to have each table on a different AG? This could 
> be manually achieved manually, but I'd like to hear if that's better or 
> not.

Hm, where in the docs, just to be clear?

All things being equal, new subdirs get their inodes & data in new AGs,
and inodes & data for files in that subdir will generally stay in that AG.

[root test]# for I in `seq 1 8`; do mkdir $I; cp file $I; done
[root test]# for I in `seq 1 8`; do xfs_bmap -v $I/file; done
1/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..31]:         96..127           0 (96..127)           32
2/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..31]:         256096..256127    1 (96..127)           32
3/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..31]:         521696..521727    2 (9696..9727)        32
4/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..31]:         768096..768127    3 (96..127)           32
5/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..31]:         128..159          0 (128..159)          32
6/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..31]:         256128..256159    1 (128..159)          32
7/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..31]:         521728..521759    2 (9728..9759)        32
8/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..31]:         768128..768159    3 (128..159)          32

Note how the AG rotors around my 4 AGs in the filesystem.  If the fs is
full and aged, it may not behave exactly this way.

> Or are there other tweaks to remember when using PostgreSQL on XFS? This 
> question was raised on the PostgreSQL admin list, and if there are good 
> guidelines I'm happy to post them there.

I don't have specific experience w/ PostgreSQL but if you have specific
questions or performance problems that you run into, we can probably help.

All good questions, thanks.

-Eric

> mfg zmi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
