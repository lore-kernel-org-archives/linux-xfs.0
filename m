Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 19DB27F58
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 00:18:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF7A1304048
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 22:18:09 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HBNuEd7GpygDAEIF for <xfs@oss.sgi.com>;
	Sun, 24 Aug 2014 22:18:04 -0700 (PDT)
Date: Mon, 25 Aug 2014 15:18:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bad performance on touch/cp file on XFS system
Message-ID: <20140825051801.GY26465@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
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
To: Zhang Qiang <zhangqiang.buaa@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 25, 2014 at 11:34:34AM +0800, Zhang Qiang wrote:
> Dear XFS community & developers,
> 
> I am using CentOS 6.3 and xfs as base file system and use RAID5 as hardware
> storage.
> 
> Detail environment as follow:
>    OS: CentOS 6.3
>    Kernel: kernel-2.6.32-279.el6.x86_64
>    XFS option info(df output): /dev/sdb1 on /data type xfs
> (rw,noatime,nodiratime,nobarrier)
> 
> Detail phenomenon:
> 
>     # df
>     Filesystem            Size  Used Avail Use% Mounted on
>     /dev/sda1              29G   17G   11G  61% /
>     /dev/sdb1             893G  803G   91G  90% /data
>     /dev/sda4             2.2T  1.6T  564G  75% /data1
> 
>     # time touch /data1/1111
>     real    0m23.043s
>     user    0m0.001s
>     sys     0m0.349s
> 
>     # perf top
>     Events: 6K cycles
>      16.96%  [xfs]                     [k] xfs_inobt_get_rec
>      11.95%  [xfs]                     [k] xfs_btree_increment
>      11.16%  [xfs]                     [k] xfs_btree_get_rec
>       7.39%  [xfs]                     [k] xfs_btree_get_block
>       5.02%  [xfs]                     [k] xfs_dialloc
>       4.87%  [xfs]                     [k] xfs_btree_rec_offset
>       4.33%  [xfs]                     [k] xfs_btree_readahead
>       4.13%  [xfs]                     [k] _xfs_buf_find
>       4.05%  [kernel]                  [k] intel_idle
>       2.89%  [xfs]                     [k] xfs_btree_rec_addr
>       1.04%  [kernel]                  [k] kmem_cache_free
> 
> 
> It seems that some xfs kernel function spend much time (xfs_inobt_get_rec,
> xfs_btree_increment, etc.)
> 
> I found a bug in bugzilla [1], is that is the same issue like this?

No.

> It's very greatly appreciated if you can give constructive suggestion about
> this issue, as It's really hard to reproduce from another system and it's
> not possible to do upgrade on that online machine.

You've got very few free inodes, widely distributed in the allocated
inode btree. The CPU time above is the btree search for the next
free inode.

This is the issue solved by this series of recent commits to add a
new on-disk free inode btree index:

53801fd xfs: enable the finobt feature on v5 superblocks
0c153c1 xfs: report finobt status in fs geometry
a3fa516 xfs: add finobt support to growfs
3efa4ff xfs: update the finobt on inode free
2b64ee5 xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
6dd8638 xfs: use and update the finobt on inode allocation
0aa0a75 xfs: insert newly allocated inode chunks into the finobt
9d43b18 xfs: update inode allocation/free transaction reservations for finobt
aafc3c2 xfs: support the XFS_BTNUM_FINOBT free inode btree type
8e2c84d xfs: reserve v5 superblock read-only compat. feature bit for finobt
57bd3db xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers

Which is of no help to you, however, because it's not available in
any CentOS kernel.

There's really not much you can do to avoid the problem once you've
punched random freespace holes in the allocated inode btree. IT
generally doesn't affect many people; those that it does affect are
normally using XFS as an object store indexed by a hard link farm
(e.g. various backup programs do this).

If you dump the superblock via xfs_db, the difference between icount
and ifree will give you idea of how much "needle in a haystack"
searching is going on. You can probably narrow it down to a specific
AG by dumping the AGI headers and checking the same thing. filling
in all the holes (by creating a bunch of zero length files in the
appropriate AGs) might take some time, but it should make the
problem go away until you remove more filesystem and create random
free inode holes again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
