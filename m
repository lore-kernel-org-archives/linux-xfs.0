Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E2327F50
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 01:14:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4CF118F8049
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 23:14:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	E2o5lgADH8SslmeU for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 23:14:18 -0700 (PDT)
Date: Thu, 28 Mar 2013 17:14:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: oops from deliberate block trashing (of course!)
Message-ID: <20130328061415.GF6369@dastard>
References: <CAJzLF9nPt9aOrH+Dj12b5os74XT8ke9g4G=DA9xgR0AyehvaBA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJzLF9nPt9aOrH+Dj12b5os74XT8ke9g4G=DA9xgR0AyehvaBA@mail.gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 28, 2013 at 01:18:24AM -0400, Michael L. Semon wrote:
> Hi!  This report was requested by Dave because I was praising
> xfs_repair and didn't fully describe the problem that xfs_repair was
> repairing.  Blame me if this is a bad bug report or a matter of XFS
> just doing its job.
...
> 
> Michael
> 
> ==== FIRST OOPS: overwrite full XFS partition with ASCII 'f' (0x66)
> byte at random locations...
> 
> mount partition, cd to mountpoint, and run `find . -type f | wc -l`:
> 
> XFS (sdb2): Mounting Filesystem
> XFS (sdb2): Ending clean mount
> XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 169

Ok, that's a XFS_WANT_CORRUPTED_RETURN() detecting a corrupted block
and on a debug kernel that fires an assert. On a production kernel
a EFSCORRUPTED error will be reported without any panic.

> Call Trace:
>  [<c12b9f20>] __xfs_dir3_data_check+0x5e0/0x710
>  [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
>  [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
>  [<c105baba>] ? dequeue_task+0x8a/0xb0
>  [<c12b7526>] xfs_dir3_block_read_verify+0x36/0xe0

Ok, so that's a directory data block, and it's failed because it
hasn't found the correct hashed index value for the name in the
block. Obviously you overwrote a byte in either the name or the hash
value...

So, this is OK - it's a real corruption that has been detected here,
and so production kernels will handle it just fine.

> ==== SECOND OOPS: xfs_db blocktrash test
> 
> root@oldsvrhw:~# xfs_db -x /dev/sdb2
> xfs_db> blockget
> xfs_db> blocktrash -n 10240 -s 755366564 -3 -x 1 -y 16
> blocktrash: 0/17856 inode block 6 bits starting 423:0 randomized
> [lots of blocktrash stuff removed but still available]
> blocktrash: 3/25387 dir block 2 bits starting 1999:1 randomized
> xfs_db> quit
> root@oldsvrhw:~# mount /dev/sdb2 /mnt/hole-test/
> root@oldsvrhw:~# cd /mnt/hole-test/
> root@oldsvrhw:/mnt/hole-test# find . -type f
> 
> XFS (sdb2): Mounting Filesystem
> XFS (sdb2): Ending clean mount
> XFS (sdb2): Invalid inode number 0x40000000800084
> XFS (sdb2): Internal error xfs_dir_ino_validate at line 160 of file
> fs/xfs/xfs_dir2.c.  Caller 0xc12b9d0d
> 
> Pid: 97, comm: kworker/0:1H Not tainted 3.9.0-rc1+ #1
> Call Trace:
>  [<c1270cbb>] xfs_error_report+0x4b/0x50
>  [<c12b9d0d>] ? __xfs_dir3_data_check+0x3cd/0x710
>  [<c12b6326>] xfs_dir_ino_validate+0xb6/0x180
>  [<c12b9d0d>] ? __xfs_dir3_data_check+0x3cd/0x710
>  [<c12b9d0d>] __xfs_dir3_data_check+0x3cd/0x710
>  [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
>  [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0

And here we validating a different directory block, and finding that
the inode number it points to is invalid. So, same thing - debug
kernel fires an assert, production kernel returns EFSCORRUPTED.

What you are seeing is that the verifiers are doing their job as
intended - catching corruption that is on disk as soon as we
possibly can. i.e. before it has the chance of being propagated
further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
