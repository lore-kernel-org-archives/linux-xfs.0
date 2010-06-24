Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5OFJB7m177637 for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 10:19:11 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A296153ECDB
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 08:21:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NeT5Rmdrn44to6wS for
	<xfs@oss.sgi.com>; Thu, 24 Jun 2010 08:21:53 -0700 (PDT)
Message-ID: <4C2377ED.8090300@sandeen.net>
Date: Thu, 24 Jun 2010 10:21:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS peculiar behavior
References: <4C21B9AF.9010307@ics.forth.gr> <20100623231700.GP6590@dastard>
	<4C236791.1030709@ics.forth.gr>
In-Reply-To: <4C236791.1030709@ics.forth.gr>
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
To: Yannis Klonatos <klonatos@ics.forth.gr>
Cc: andi@firstfloor.org, xfs@oss.sgi.com

On 06/24/2010 09:11 AM, Yannis Klonatos wrote:
> Hello again,
> 
>          First of all, thank you all for your quick replies. I attach 
> all the information you requested in your responses.
> 
> 1) The output of xfs_info is the following:
>
> meta-data=/dev/sdf     isize=256    agcount=32, agsize=45776328 blks
>          =             sectsz=512   attr=0
> data     =             bsize=4096   blocks=1464842496, imaxpct=25
>          =             sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2    bsize=4096
> log      =internal     bsize=4096   blocks=32768, version=1
>          =             sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none         extsz=4096   blocks=0, rtextents=0
> 
> 2) The output of xfs_bmap in the lineitem.MYI table of the TPC-H 
> workload is at one run:
> 
> /mnt/test/mysql/tpch/lineitem.MYI:
>   EXT: FILE-OFFSET           BLOCK-RANGE              AG  AG-OFFSET         TOTAL
>     0: [0..6344271]:         11352529416..11358873687 31 (72..6344343)    6344272
>     1: [6344272..10901343]:  1464842608..1469399679    4 (112..4557183)   4557072
>     2: [10901344..18439199]: 1831053200..1838591055    5 (80..7537935)    7537856
>     3: [18439200..25311519]: 2197263840..2204136159    6 (96..6872415)    6872320
>     4: [25311520..26660095]: 2563474464..2564823039    7 (96..1348671)    1348576
> 
> Given that all disk blocks are in units of 512-byte blocks, if I 
> interpret the output
> correctly the first file is at block 1465352792 = 698.4GByte offset and 
> the last block
> is at 5421.1GByte offset, meaning that this specific table is split over 
> a 4,7TByte distance.

The file started out in the last AG, and then had to wrap around,
because it hit the end of the filesystem. :)  It was then somewhat
sequential in AGs 4,5,6,7 after that, though not perfectly so.

This run was with a clean filesystem?  Was the mountpoint
/mnt/test?  XFS distributes new directories into new AGs (allocation
groups, or disk regions) for parallelism, and then files in those dirs
start populating the same AG.  So if /mnt/test/mysql/tpch ended up in
the last AG (#31) then the file likely started there, too.

Also, the "inode32" allocator biases data towards the end of the
filesystem, because inode numbers in xfs reflect their on-disk location,
and to keep inodes numbers below 2^32, it must save space in the lower
portions of the filesystem.  You might want to re-test with a fresh
filesystem mounted with the "inode64" mount option.

> However, in another run (with a clean file system again)
> 
> /mnt/test/mysql/tpch/lineitem.MYI:
>   EXT: FILE-OFFSET      BLOCK-RANGE              AG AG-OFFSET           
> TOTAL
>     0: [0..26660095]:   11352529416..11379189511 31 (72..26660167)   
> 26660096

Hmm.

> 3) For the copy, as i mentioned in my previous mail, i copied the 
> database over nfs using the cp -R linux program.
> Thus, i believe all the files are copied sequentially, the one after the 
> other, with no other concurrent write operations
> running at the background. The file-system was pristine before the cp 
> with no files, and just the mount directory was
> created (all the other necessary files and directories are created from 
> the cp program).

IIRC, copies over NFS can affect xfs allocator performance, because
(IIRC) it tends to close the filehandle periodically and xfs loses the
allocator context.  We used to have a filehandle cache which held them
open, but that went away some time ago.

Dave will probably correct significant swaths of this information for
me, though ;)

> 4)  The version of xfsprogs is 2.9.4 (acquired with xfs_info -v) and the 
> version of the kernel is 2.6.18-164.11.1.el5.

Ah!  A Red Hat kernel; have you asked your Red Hat support folks for
help on this issue?

-Eric

>          If you require any further information let me know. Let me 
> state that i can also provide you with the complete
> data-set if you feel it necessary trying to reproduce the issue.
> 
> Thanks,
> Yannis Klonatos
>>> Hi all!
>>>
>>>          I have come across the following peculiar behavior in XFS
>>> and i would appreciate any information anyone
>>> could provide.
>>>          In our lab we have a system that has twelve 500GByte hard
>>> disks (total capacity 6TByte), connected to an
>>> Areca (ARC-1680D-IX-12) SAS storage controller. The disks are
>>> configured as a RAID-0 device. Then I create
>>> a clean XFS filesystem on top of the raid volume, using the whole
>>> capacity. We use this test-setup to measure
>>> performance improvement for a TPC-H experiment. We copy the database
>>> over the clean XFS filesystem using the
>>> cp utility. The database used in our experiments is 56GBytes in size
>>> (data + indices).
>>>          The problem is that i have noticed that XFS may - not all
>>> times - split a table over a large disk distance. For
>>> example in one run i have noticed that a file of 13GByte is split
>>> over a 4,7TByte distance (I calculate this distance
>>> by subtracting the final block used for the file with the first one.
>>> The two disk blocks values are acquired using the
>>> FIBMAP ioctl).
>>>          Is there some reasoning behind this (peculiar) behavior? I
>>> would expect that since the underlying storage is so
>>> large, and the dataset is so small, XFS would try to minimize disk
>>> seeks and thus place the file sequentially in disk.
>>> Furthermore, I understand that there may be some blocks left unused
>>> by XFS between subsequent file blocks used
>>> in order to handle any write appends that may come afterward. But i
>>> wouldn't expect such a large splitting of a single
>>> file.
>>>          Any help?
>>>      
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
