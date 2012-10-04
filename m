Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94DpEpn154076 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 08:51:14 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id enlypgScySI9ZLlj for
	<xfs@oss.sgi.com>; Thu, 04 Oct 2012 06:52:39 -0700 (PDT)
Message-ID: <506D950C.304@redhat.com>
Date: Thu, 04 Oct 2012 09:54:20 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: sparse files
References: <506D462D.3030709@strike.wu.ac.at>
In-Reply-To: <506D462D.3030709@strike.wu.ac.at>
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
To: Alexander 'Leo' Bergolth <leo@strike.wu.ac.at>
Cc: xfs@oss.sgi.com

On 10/04/2012 04:17 AM, Alexander 'Leo' Bergolth wrote:
> Hi!
> 
> I am trying to create a sparse qemu qcow2 image on xfs. (Centos 6.3)
> Unfortunately this doesn't produce the expected results:
> Creating a 10G file results in 16GB of disk usage!
> Doing the same on ext4 produces a 10G sparse file with only 1.8M allocated...
> (See the block bitmaps below.)
> 
> Is this related to dynamic speculative preallocation?
> http://serverfault.com/questions/406069/why-are-my-xfs-filesystems-suddenly-consuming-more-space-and-full-of-sparse-file
> 

It appears so. I suspect a part of that 16GB is eventually trimmed as it
extends past the end of the file (and if I added correctly, the bmap
output below shows around 9GB, which is what I reproduce as well).

Basically for each write that extends the size of the file, XFS
preallocates a certain number of blocks depending on the current file
size. It starts out small and as the file size gets larger, this
preallocation gets larger as well (up to 8GB). If the next write after a
prealloc happens to occur after a seek into or past the preallocated
space, that space becomes permanent. It looks like we have to zero said
space as well, to ensure stale data is not exposed from the block
device, which I think accounts for the extra time this command requires
as well.

> Are there any recommended filesystem options that optimize xfs behavior for hosting (sparse) virtual disk images?
> 

As the link you posted notes, you can use the allocsize=X option to curb
this behavior. E.g., when using allocsize=64k I see equivalent behavior
on XFS as you have reported for ext4.

Brian

> Cheers,
> --leo
> 
> -------------------- 8< --------------------
> $  qemu-img create -f qcow2 -o 'preallocation=metadata' onxfs.img 10G
> Formatting 'onxfs.img', fmt=qcow2 size=10737418240 encryption=off cluster_size=65536 preallocation='metadata' 
> $ du -hs onxfs.img 16G     onxfs.img
> 
> $ ls -ls onxfs.img 16253692 -rw-r--r-- 1 leo users 10739318784 Oct  2 14:22 onxfs.img
> 
> # xfs_bmap -v onxfs.img onxfs.img:
>  EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET              TOTAL
>    0: [0..1023]:            168294344..168295367  3 (11007944..11008967)    1024
>    1: [1024..1049215]:      hole                                         1048192
>    2: [1049216..1049727]:   168295368..168295879  3 (11008968..11009479)     512
>    3: [1049728..2097919]:   hole                                         1048192
>    4: [2097920..3146495]:   165668600..166717175  3 (8382200..9430775)   1048576
>    5: [3146496..3146623]:   hole                                             128
>    6: [3146624..5243775]:   163571448..165668599  3 (6285048..8382199)   2097152
>    7: [5243776..5244159]:   hole                                             384
>    8: [5244160..9438463]:   159377144..163571447  3 (2090744..6285047)   4194304
>    9: [9438464..9439103]:   hole                                             640
>   10: [9439104..17827711]:  52616968..61005575    1 (188168..8576775)    8388608
>   11: [17827712..17828991]: hole                                            1280
>   12: [17828992..20975231]: 105886128..109032367  2 (1028528..4174767)   3146240
> 
> # xfs_info /srv
> meta-data=/dev/mapper/vg_1-lv_srv isize=256    agcount=4, agsize=6553600 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> -------------------- 8< --------------------
> $ qemu-img create -f qcow2 -o 'preallocation=metadata' onext4.img 10G
> Formatting 'onext4.img', fmt=qcow2 size=10737418240 encryption=off cluster_size=65536 preallocation='metadata' 
> $ du -h onext4.img 1.8M    onext4.img
> 
> $ ls -ls onext4.img 1744 -rw-r--r-- 1 leo users 10739318784 Oct  2 14:25 onext4.img
> 
> debugfs:  stat /leo/onext4.img
> Inode: 1048578   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 3370152928    Version: 0x00000000:00000001
> User:   501   Group:   100   Size: 10739318784
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 3488
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x506add38:7909fe14 -- Tue Oct  2 14:25:28 2012
>  atime: 0x506add38:731c2ccc -- Tue Oct  2 14:25:28 2012
>  mtime: 0x506add38:7909fe14 -- Tue Oct  2 14:25:28 2012
> crtime: 0x506add36:5320b76c -- Tue Oct  2 14:25:26 2012
> Size of extra inode fields: 28
> EXTENTS:
> (0): 33856, (16): 33872, (32-79): 33888-33935, (131152-131167): 34896-34911, (262240-262255): 36960-36975, (393328-393343): 39024-39039, (524416-524447): 41088-41119, (655520-655535): 43168-43183, (786608-786623): 45232-45247, (917696-917711): 47296-47311, (1048784-1048815)
> : 49360-49391, (1179888-1179903): 51440-51455, (1310976-1310991): 53504-53519, (1442064-1442079): 55568-55583, (1573152-1573183): 57632-5
> 7663, (1704256-1704271): 59712-59727, (1835344-1835359): 61776-61791, (1966432-1966447): 63840-63855, (2097520-2097551): 65904-65935, (22
> 28624-2228639): 67984-67999, (2359712-2359727): 70048-70063, (2490800-2490815): 72112-72127, (2621887-2621903): 74175-74191
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
