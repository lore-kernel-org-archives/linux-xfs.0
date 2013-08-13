Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D81037F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 19:05:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D2B68F8037
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 17:05:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	yHczuFGk5dhHDv2X for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 17:05:20 -0700 (PDT)
Date: Tue, 13 Aug 2013 10:04:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failure growing xfs with linux 3.10.5
Message-ID: <20130813000453.GQ12779@dastard>
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52090C6C.6060604@allmail.net>
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
To: Michael Maier <m1278468@allmail.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

[ re-ccing the list, because finding this is in everyone's interest ]

On Mon, Aug 12, 2013 at 06:25:16PM +0200, Michael Maier wrote:
> Eric Sandeen wrote:
> > On 8/11/13 2:11 AM, Michael Maier wrote:
> >> Hello!
> >>
> >> I think I'm facing the same problem as already described here:
> >> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/54428
> > 
> > Maybe you can try the tracing Dave suggested in that thread?
> > It certainly does look similar.
> 
> I attached a trace report while executing xfs_growfs /mnt on linux 3.10.5 (does not happen with 3.9.8).
> 
> xfs_growfs /mnt
> meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=42, agsize=7700480 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=319815680, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=60160, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
> data blocks changed from 319815680 to 346030080
> 
> The entry in messages was:
> 
> Aug 12 18:09:50 dualc kernel: [  257.368030] ffff8801e8dbd400: 58 46 53 42 00 00 10 00 00 00 00 00 13 10 00 00  XFSB............
> Aug 12 18:09:50 dualc kernel: [  257.368037] ffff8801e8dbd410: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Aug 12 18:09:50 dualc kernel: [  257.368042] ffff8801e8dbd420: 46 91 c6 80 a9 a9 4d 8c 8f e2 18 fd e8 7f 66 e1  F.....M.......f.
> Aug 12 18:09:50 dualc kernel: [  257.368045] ffff8801e8dbd430: 00 00 00 00 04 00 00 04 00 00 00 00 00 00 00 80  ................
> Aug 12 18:09:50 dualc kernel: [  257.368051] XFS (dm-33): Internal error xfs_sb_read_verify at line 730 of file
> /daten2/tmp/rpm/BUILD/kernel-desktop-3.10.5/linux-3.10/fs/xfs/xfs_mount.c.  Caller 0xffffffffa099a2fd
.....
> Aug 12 18:09:50 dualc kernel: [  257.368533] XFS (dm-33): Corruption detected. Unmount and run xfs_repair
> Aug 12 18:09:50 dualc kernel: [  257.368611] XFS (dm-33): metadata I/O error: block 0x3ac00000 ("xfs_trans_read_buf_map") error 117 numblks 1
> Aug 12 18:09:50 dualc kernel: [  257.368623] XFS (dm-33): error 117 reading secondary superblock for ag 16

Ok, so that's reading the secondary superblock for AG 16. You're
growing the filesystem from 42 to 45 AGs, so this problem is not
related to the actual grow operation - it's tripping over a problem
that already exists on disk before the grow operation is started.
i.e. this is likely to be a real corruption being seen, and it
happened some time in the distant past and so we probably won't ever
be able to pinpoint the cause of the problem.

That said, let's have a look at the broken superblock. Can you post
the output of the commands:

# xfs_db -r -c "sb 16" -c p <dev>

and

# xfs_db -r -c "sb 16" -c "type data" -c p <dev>

so we can see the exact contents of that superblock?

FWIW, how many times has this filesystem ben grown? Did it start
with only 32 AGs (i.e. 10TB in size)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
