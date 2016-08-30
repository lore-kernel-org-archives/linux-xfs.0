Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA0CA7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 21:39:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D4CFAC004
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 19:39:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5BKpM8HEKR6YKId0 for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2016 19:39:36 -0700 (PDT)
Date: Tue, 30 Aug 2016 12:39:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: Internal error xfs_trans_cancel at line 984 of file
	fs/xfs/xfs_trans.c
Message-ID: <20160830023905.GU19025@dastard>
References: <20160829103754.GH27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829103754.GH27776@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 29, 2016 at 06:37:54PM +0800, Eryu Guan wrote:
> Hi,
> 
> I've hit an XFS internal error then filesystem shutdown with 4.8-rc3
> kernel but not with 4.8-rc2
.....
> I attached a script too to reproduce it. Please note that the XFS
> partition needs about 40G frees space, and it may take hours to finish
> based on your memory setup on your host.

Ugh. can you try to narrow the cause so it takes less time to
reproduce? This is almost certainly one of two things:

	1) a ENOSPC issue where an AG is almost-but-not-quite full,
	but fixing up the freelist results in there being not enough
	blocks left to allocate the data extent; or

	2) we've split a delalloc extent so many times that we've
	run out of indirect block reservation and we hit ENOSPC as a
	result.

For the latter, I suspect a test case where we take a large delalloc
range and use sync_file_range to do single page writeback to "binary
split" the delalloc range. i.e. start with a 128MB delalloc, then
sync a 4k block at offset 64MB, then 4k at 32MB, then 16MB, then
8MB, ... all the way down to writing the first block in the file,
and also all the way up to the final block in the file.

Then write every second 4k block to cause worse case growth of the
bmbt and hopefully then exhaust the indirect block reservation for
that delalloc region...

> [root@hp-dl360g9-15 ~]# xfs_info /
> meta-data=/dev/mapper/systemvg-root isize=256    agcount=16, agsize=2927744 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0 spinodes=0
> data     =                       bsize=4096   blocks=46843904, imaxpct=25
>          =                       sunit=64     swidth=192 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=22912, version=2
>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Does it reproduce on a CRC enabled filesystem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
