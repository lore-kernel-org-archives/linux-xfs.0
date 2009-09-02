Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82JYV4C040501 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 14:34:41 -0500
Received: from nexus.dynaweb.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9A2841E369
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 12:35:17 -0700 (PDT)
Received: from nexus.dynaweb.hu (nexus.dynaweb.hu [195.70.37.87]) by
	cuda.sgi.com with ESMTP id lE7xJlBgALz4shYf for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 12:35:17 -0700 (PDT)
Date: Wed, 2 Sep 2009 21:34:41 +0200
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
Subject: Re: Structure needs cleaning? (take #2)
Message-Id: <20090902213441.470b439c.rumi_ml@rtfm.hu>
In-Reply-To: <4A9E81AD.70003@sandeen.net>
References: <20090902152245.b2969883.rumi_ml@rtfm.hu>
	<4A9E81AD.70003@sandeen.net>
Mime-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi!

Well, what could be the reason? I mean, there was no hardware failure,
no crash, no reboot, no errors in the disk's SMART error log, no nothing.
What I did was that I've extracted and deleted the rather huge OpenOffice
source tree several times (sometimes with overwriting) and finally it
ended up with these undeletable files and xfs errors. Is it considered
normal for xfs to get messed up like that under such load?

Thanks,
Sab



The xfs_repair output and xfs_info output is included below:

# xfs_repair -v /dev/sda10
Phase 1 - find and verify superblock...
        - block cache size set to 255664 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 37688 tail block 37688
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
        - agno = 49
        - agno = 50
        - agno = 51
        - agno = 52
        - agno = 53
        - agno = 54
        - agno = 55
        - agno = 56
        - agno = 57
        - agno = 58
        - agno = 59
        - agno = 60
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
        - agno = 49
        - agno = 50
        - agno = 51
        - agno = 52
        - agno = 53
        - agno = 54
        - agno = 55
        - agno = 56
        - agno = 57
        - agno = 58
        - agno = 59
        - agno = 60
Phase 5 - rebuild AG headers and trees...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
        - agno = 49
        - agno = 50
        - agno = 51
        - agno = 52
        - agno = 53
        - agno = 54
        - agno = 55
        - agno = 56
        - agno = 57
        - agno = 58
        - agno = 59
        - agno = 60
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
leaf block 8388608 for directory inode 4051737 bad header
rebuilding directory inode 4051737
leaf block 8388608 for directory inode 4053318 bad header
rebuilding directory inode 4053318
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
        - agno = 49
        - agno = 50
        - agno = 51
        - agno = 52
        - agno = 53
        - agno = 54
        - agno = 55
        - agno = 56
        - agno = 57
        - agno = 58
        - agno = 59
        - agno = 60
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...

        XFS_REPAIR Summary    Wed Sep  2 21:23:53 2009

Phase           Start           End             Duration
Phase 1:        09/02 21:23:33  09/02 21:23:33  
Phase 2:        09/02 21:23:33  09/02 21:23:35  2 seconds
Phase 3:        09/02 21:23:35  09/02 21:23:49  14 seconds
Phase 4:        09/02 21:23:49  09/02 21:23:50  1 second
Phase 5:        09/02 21:23:50  09/02 21:23:50  
Phase 6:        09/02 21:23:50  09/02 21:23:50  
Phase 7:        09/02 21:23:50  09/02 21:23:50  

Total run time: 17 seconds
done

# xfs_info /dev/sda10
meta-data=/dev/sda10             isize=256    agcount=61, agsize=32768 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1998848, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0



On Wed, 02 Sep 2009 09:31:09 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> RUMI Szabolcs wrote:
> > Hi!
> > 
> > Sorry but my previous post was missing the important first two lines: 
> 
> Yes, thanks.  :)
> 
> > d62c8000: 2c 30 78 41 41 41 41 30 30 30 30 2c 36 2c 30 78  ,0xAAAA0000,6,0x
> > Filesystem "sda10": XFS internal error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xc02cc790
> 
> This is on-disk corruption, it found bad magic on something it expected 
> to be metadata.  You should run xfs_repair.  run with -n, or on a 
> restored xfs_metadump image as a dry-run first, if you prefer.
> 
> -Eric
> 
> > Pid: 29510, comm: mc Tainted: P           2.6.29-gentoo-r5-PAE #1
> > Call Trace:
> >  [<c02cc6c4>] xfs_da_do_buf+0x8c4/0x900
> >  [<c02cc790>] xfs_da_read_buf+0x30/0x40
> >  [<c02cc790>] xfs_da_read_buf+0x30/0x40
> >  [<c0191ef0>] pollwake+0x0/0x50
> >  [<c0191ef0>] pollwake+0x0/0x50
> >  [<c02cc790>] xfs_da_read_buf+0x30/0x40
> >  [<c02d2943>] xfs_dir2_leaf_lookup_int+0x63/0x2f0
> >  [<c02d2943>] xfs_dir2_leaf_lookup_int+0x63/0x2f0
> >  [<c02d3667>] xfs_dir2_leaf_lookup+0x27/0xc0
> >  [<c02cf32f>] xfs_dir2_isleaf+0x1f/0x60
> >  [<c02cfc78>] xfs_dir_lookup+0xd8/0x180
> >  [<c02fedab>] xfs_lookup+0x6b/0xf0
> >  [<c0309165>] xfs_vn_lookup+0x55/0xa0
> >  [<c018adda>] do_lookup+0x1ba/0x1e0
> >  [<c018ca1d>] __link_path_walk+0x6cd/0xd60
> >  [<c02d3def>] xfs_dir2_leaf_getdents+0x5ff/0xad0
> >  [<c018d264>] path_walk+0x54/0xc0
> >  [<c018d3a3>] do_path_lookup+0x83/0x170
> >  [<c018c30b>] getname+0x9b/0xe0
> >  [<c018e03a>] user_path_at+0x5a/0x90
> >  [<c018633f>] vfs_lstat_fd+0x1f/0x50
> >  [<c01863bf>] sys_lstat64+0xf/0x30
> >  [<c0194fd4>] touch_atime+0x14/0x130
> >  [<c01907b8>] vfs_readdir+0x78/0xb0
> >  [<c0190891>] sys_getdents64+0xa1/0xd0
> >  [<c01032f1>] sysenter_do_call+0x12/0x25
> > 
> > Thanks,
> > Sab
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
