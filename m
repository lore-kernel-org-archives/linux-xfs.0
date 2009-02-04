Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n141TRmI107294 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 19:29:27 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0FC018B8A5F
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 17:28:47 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id CnvTqOg85i5vn4gY for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2009 17:28:47 -0800 (PST)
Message-ID: <4988EF37.7020306@sandeen.net>
Date: Tue, 03 Feb 2009 19:28:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS corruption on ubuntu 2.6.27-9-server
References: <2653B83E-85DA-4949-BCED-AF2BA3D324E1@alink.co.za>
In-Reply-To: <2653B83E-85DA-4949-BCED-AF2BA3D324E1@alink.co.za>
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
To: George Barnett <george@alink.co.za>
Cc: xfs@oss.sgi.com

George Barnett wrote:
> Hi,
> 
> I'm seeing the following errors:
> 
> [822153.422851] Filesystem "md2": XFS internal error xfs_da_do_buf(2)  
> at line 2107 of file /build/buildd/linux-2.6.27/fs/xfs/ 

we really should make that more informative.

What it means is that you read a piece of metadata that did not match
any of the metadata magic numbers.

hard to say whether it might be an xfs bug I think; this does come up
occasionally though and it'd at least be nice to print more details on
the error (what the magic *was*, what block, etc)

Do you happen to have the repair output?

Did your md raid lose power w/ write cache enabled?

-Eric

> xfs_da_btree.c.  Caller 0xffffffffa03be8da
> [822153.422903] Pid: 3273, comm: du Not tainted 2.6.27-9-server #1
> [822153.422905]
> [822153.422906] Call Trace:
> [822153.422931]  [<ffffffffa03cab23>] xfs_error_report+0x43/0x50 [xfs]
> [822153.422956]  [<ffffffffa03be8da>] ? xfs_da_read_buf+0x2a/0x30 [xfs]
> [822153.422976]  [<ffffffffa03cab8d>] xfs_corruption_error+0x5d/0x80  
> [xfs]
> [822153.422995]  [<ffffffffa03be808>] xfs_da_do_buf+0x6a8/0x700 [xfs]
> [822153.423014]  [<ffffffffa03be8da>] ? xfs_da_read_buf+0x2a/0x30 [xfs]
> [822153.423019]  [<ffffffff80305b06>] ? mntput_no_expire+0x36/0x160
> [822153.423022]  [<ffffffff803866e1>] ? aa_permission+0x21/0xd0
> [822153.423041]  [<ffffffffa03be8da>] xfs_da_read_buf+0x2a/0x30 [xfs]
> [822153.423061]  [<ffffffffa03c34fa>] ? xfs_dir2_block_getdents+0x9a/ 
> 0x210 [xfs]
> [822153.423080]  [<ffffffffa03c34fa>] xfs_dir2_block_getdents+0x9a/ 
> 0x210 [xfs]
> [822153.423099]  [<ffffffffa03adf7b>] ? xfs_bmap_last_offset+0x13b/ 
> 0x150 [xfs]
> [822153.423119]  [<ffffffffa03f9970>] ? xfs_hack_filldir+0x0/0x60 [xfs]
> [822153.423138]  [<ffffffffa03f9970>] ? xfs_hack_filldir+0x0/0x60 [xfs]
> [822153.423157]  [<ffffffffa03c148b>] xfs_readdir+0x9b/0xf0 [xfs]
> [822153.423176]  [<ffffffffa03f98a6>] xfs_file_readdir+0xd6/0x1a0 [xfs]
> [822153.423180]  [<ffffffff802f8810>] ? filldir+0x0/0xe0
> [822153.423183]  [<ffffffff80386821>] ? aa_file_permission+0x21/0xf0
> [822153.423185]  [<ffffffff802f8810>] ? filldir+0x0/0xe0
> [822153.423188]  [<ffffffff802f8810>] ? filldir+0x0/0xe0
> [822153.423191]  [<ffffffff802f8a9b>] vfs_readdir+0xbb/0xe0
> [822153.423194]  [<ffffffff802f8c28>] sys_getdents+0x88/0xe0
> [822153.423199]  [<ffffffff8021285a>] system_call_fastpath+0x16/0x1b
> 
> This seems to happen reasonably regularly on my system and causes the  
> filesystem to be marked as dirty.  xfs_repair runs fine, but I end up  
> with a bunch of files moved to lost+found. There are no device errors  
> logged when this happens.
> 
> Mount options:
> 
> /dev/md2 on /data type xfs (rw,noatime)
> 
> Kernel:
> 
> Linux slut 2.6.27-9-server #1 SMP Thu Nov 20 22:56:07 UTC 2008 x86_64  
> GNU/Linux
> 
> Device:
> 
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]  
> [raid4] [raid10]
> md2 : active raid10 sda2[0] sdd2[3] sdb2[1]
>        1947655680 blocks super 1.2 128K chunks 2 far-copies [4/3] [UUUU]
> 
> # xfs_info /dev/md2
> meta-data=/dev/md2               isize=256    agcount=32,  
> agsize=15216064 blks
>           =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=486913920,  
> imaxpct=25
>           =                       sunit=32     swidth=128 blks
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>           =                       sectsz=512   sunit=0 blks, lazy- 
> count=0
> realtime =none                   extsz=524288 blocks=0, rtextents=0
> 
> Any assistance would be greatly appreciated.
> 
> George
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
