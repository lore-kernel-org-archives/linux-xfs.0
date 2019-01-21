Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54605 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfAUKl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 05:41:59 -0500
Message-ID: <1548067317.2465.7.camel@pengutronix.de>
Subject: Re: Regular FS shutdown while rsync is running
From: Lucas Stach <l.stach@pengutronix.de>
Date: Mon, 21 Jan 2019 11:41:57 +0100
In-Reply-To: <20181126153249.GC14585@bfoster>
References: <1543238989.2507.33.camel@pengutronix.de>
         <20181126153249.GC14585@bfoster>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi Brian,

sorry for taking so long to respond. It's hard to gather some good
debug data here.

Am Montag, den 26.11.2018, 10:32 -0500 schrieb Brian Foster:
> On Mon, Nov 26, 2018 at 02:29:49PM +0100, Lucas Stach wrote:
> > Hi all,
> > 
> > we have a XFS filesystem which is used to backup data from others
> > servers via rsync. While rsync is running the filesystem is regularly
> > shutting itself down. Sometimes the FS will last for 3 days until the
> > shutdown happens, sometimes it's after only 3 hours.
> > 
> > The issue was spotted on a 4.17 kernel, but I'm not sure that's the
> > first version with this issue, as that was the kernel version used when
> > setting up the backup system. We also checked that the issue is still
> > present in a 4.19.4 vanilla kernel, backtrace from this kernel version
> > is provided below.
> > 
> > The block stack below the XFS is a LVM on a software RAID10.
> > 
> > I can provide more information as needed, but I'm not sure at this
> > point which information would be appropriate to further debug this
> > issue. Any pointers appreciated.
> > 
> > Please keep me in CC, as I'm not subscribed to the XFS list.
> > 
> > Regards,
> > Lucas
> > 
> > 
> > 
> > [50013.593883] XFS (dm-2): Internal error xfs_btree_check_sblock at line 179 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_lastrec+0x41/0x90 [xfs]
> > [50013.594365] CPU: 4 PID: 31839 Comm: rsync Not tainted 4.19.4-holodeck10 #1
> > [50013.594365] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 2.6.0 10/26/2017
> > [50013.594366] Call Trace:
> > [50013.594372]  dump_stack+0x5c/0x7b
> > [50013.594391]  xfs_btree_check_sblock+0x5a/0xb0 [xfs]
> > [50013.594409]  xfs_btree_lastrec+0x41/0x90 [xfs]
> > [50013.594427]  xfs_btree_delrec+0xa48/0xdf0 [xfs]
> > [50013.594446]  ? xfs_inobt_get_maxrecs+0x20/0x20 [xfs]
> > [50013.594463]  ? xfs_lookup_get_search_key+0x49/0x60 [xfs]
> > [50013.594480]  xfs_btree_delete+0x43/0x110 [xfs]
> > [50013.594500]  xfs_dialloc_ag+0x16a/0x290 [xfs]
> > [50013.594540]  xfs_dialloc+0x5b/0x270 [xfs]
> > [50013.594562]  xfs_ialloc+0x6c/0x5b0 [xfs]
> > [50013.594583]  xfs_dir_ialloc+0x68/0x1d0 [xfs]
> > [50013.594615]  xfs_create+0x3df/0x5e0 [xfs]
> > [50013.594633]  xfs_generic_create+0x241/0x2e0 [xfs]
> > [50013.594636]  vfs_mkdir+0x10c/0x1a0
> > [50013.594638]  do_mkdirat+0xd3/0x110
> > [50013.594641]  do_syscall_64+0x55/0xf0
> > [50013.594644]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [50013.594645] RIP: 0033:0x7fda0e896447
> > [50013.594647] Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 49 da 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 da 2b 00 f7 d8 64 89 01 48
> > [50013.594647] RSP: 002b:00007ffdedc1a118 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
> > [50013.594649] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fda0e896447
> > [50013.594649] RDX: 0000000000000008 RSI: 00000000000001c0 RDI: 00007ffdedc1c470
> > [50013.594650] RBP: 0000560fd94b5c70 R08: 0000000000000080 R09: 00000000ffffffff
> > [50013.594661] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> > [50013.594662] R13: 0000000000000000 R14: 00007ffdedc1c470 R15: 00000000ffffffff
> 
> This looks like a free inode btree corruption of some sort. The error
> report doesn't tell us exactly what's wrong with the btree block, but we
> can surmise finobt from the record deletion call via the inode
> allocation path.
> 
> Can you provide xfs_info for the fs and details of your storage, CPU and
> RAM configuration?

root@XXX:~# xfs_info /srv/
meta-data=/dev/mapper/XXX-backup isize=512    agcount=33, agsize=183123968 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=5860389888, imaxpct=15
         =                       sunit=16     swidth=48 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The storage is LVM on top of md raid10 across 8 disks.

System is a Intel Xeon CPU E5-2630 with 64GB ECC RAM. The system
reports no errors about RAM.

>  Also, what typically happens after this crash? Can
> the filesystem mount again or does log recovery fail and require a
> repair? If the filesystem mounts, have you tried running a
> non-destructive 'xfs_repair -n <dev>' after log recovery to check for
> any latent problems?

We are able to umount and mount the filesystem again. I don't there was
a non-destructive run of xfs_repair yet, but just a regular one. Would
a non-destructive one make more sense?

root@XXX:/mnt/metadump# xfs_repair  /dev/XXX
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
bad magic # 0x49414233 in inobt block 5/7831662
        - 23:06:50: scanning filesystem freespace - 33 of 33 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 23:06:50: scanning agi unlinked lists - 33 of 33 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 0 
        - agno = 15
        - agno = 30                                                                              
        - agno = 31                         
        - agno = 32                                                                  
        - agno = 16                    
        - agno = 1                           
        - agno = 17                                                                   
        - agno = 2                                     
        - agno = 18
        - agno = 3 
        - agno = 19
        - agno = 4 
        - agno = 5 
        - agno = 20
        - agno = 21
        - agno = 6 
        - agno = 22
        - agno = 7 
        - agno = 23
        - agno = 8 
        - agno = 24
        - agno = 9
        - agno = 25
        - agno = 26
        - agno = 10
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - 05:28:46: process known inodes and inode discovery - 402627456 of 402627456 inodes done
        - process newly discovered inodes...
        - 05:28:46: process newly discovered inodes - 33 of 33 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 05:28:48: setting up duplicate extent list - 33 of 33 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0 
        - agno = 15
        - agno = 30                                                                                
        - agno = 31                      
        - agno = 32                                                               
        - agno = 1           
        - agno = 16                  
        - agno = 17                                               
        - agno = 2                 
        - agno = 18             
        - agno = 3                                    
        - agno = 19                        
        - agno = 4                                                                  
        - agno = 5
        - agno = 20
        - agno = 6  
        - agno = 21
        - agno = 7
        - agno = 22           
        - agno = 8
        - agno = 23
        - agno = 9
        - agno = 24
        - agno = 25
        - agno = 10
        - agno = 26
        - agno = 27
        - agno = 11
        - agno = 28
        - agno = 29
        - agno = 12
        - agno = 13
        - agno = 14
        - 17:57:31: check for inodes claiming duplicate blocks - 402627456 of 402627456 inodes done
Phase 5 - rebuild AG headers and trees...
        - 17:57:47: rebuild AG headers and trees - 33 of 33 allocation groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
        - 22:29:19: verify and correct link counts - 33 of 33 allocation groups done
done

>  Would you be able to provide an xfs_metadump image
> of this filesystem for closer inspection?

This filesystem is really metadata heavy, so an xfs_metadump ended up
being around 400GB of data. Not sure if this is something you would be
willing to look into?

> Can you characterize the rsync workload in any more detail? For example,
> are files added/removed across runs (perhaps whatever rsync flags are
> used would help)? Are files of consistent or varying size/content? Are
> many rsync processes running in parallel? Generally, anything you can
> describe that might help recreate this problem with a simulated workload
> is potentially useful.

There are typically about 2 or 3 rsync processes running in parallel.
The workload syncs a lot of small files and uses hardlinks to avoid
storing files that didn't change.

All the corruption issues we've seen so far have the same call trace
starting with a do_mkdirat syscall. We've never seen it happen in other
calls.

As a wild shot in aiding some debugging we've added the following patch
on top of 4.19.16:

------------------------------------->8--------------------------------
 fs/xfs/libxfs/xfs_btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 34c6d7bd4d18..5771df0db414 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -176,7 +176,8 @@ xfs_btree_check_sblock(
 			XFS_ERRTAG_BTREE_CHECK_SBLOCK))) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+				     mp, block, sizeof(*block));
 		return -EFSCORRUPTED;
 	}
 	return 0;
------------------------------------->8--------------------------------

With that applied we were able to collect the following dump:

[215922.475666] 00000000d471c70c: 49 41 42 33 00 01 01 0c 00 07 58 ab ff ff ff ff  IAB3......X.....
[215922.475954] 000000001be9cc59: 00 00 00 01 b5 db 40 b8 00 00 00 00 00 00 00 00  ......@.........
[215922.476241] 000000005b12f32e: 02 67 11 cc 25 c7 44 b9 89 aa 0a ac 49 6e df ec  .g..%.D.....In..
[215922.476556] 00000000e6e67a65: 00 00 00 05 2a bb 5c 47 36 85 a2 40 36 8e f9 00  ....*.\G6..@6...
[215922.476840] 00000000e4807aa6: 36 96 3e 80 36 a4 61 80                          6.>.6.a.
[215922.477172] XFS (dm-3): Internal error xfs_btree_check_sblock at line 180 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_lastrec+0x41/0x90 [xfs]
[215922.477617] CPU: 8 PID: 23979 Comm: rsync Not tainted 4.19.16-XXX+ #20190118.1
[215922.477619] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 2.6.0 10/26/2017
[215922.477620] Call Trace:
[215922.477628]  dump_stack+0x5c/0x7b
[215922.477685]  xfs_corruption_error+0x83/0x90 [xfs]
[215922.477731]  ? xfs_btree_lastrec+0x41/0x90 [xfs]
[215922.477776]  ? xfs_btree_lastrec+0x41/0x90 [xfs]
[215922.477819]  xfs_btree_check_sblock+0x68/0xd0 [xfs]
[215922.477864]  ? xfs_btree_lastrec+0x41/0x90 [xfs]
[215922.477909]  xfs_btree_lastrec+0x41/0x90 [xfs]
[215922.477954]  xfs_btree_delrec+0xb12/0xfd0 [xfs]
[215922.477998]  ? xfs_lookup_get_search_key+0x49/0x60 [xfs]
[215922.478043]  xfs_btree_delete+0x43/0x110 [xfs]
[215922.478092]  xfs_dialloc_ag+0x19b/0x320 [xfs]
[215922.478147]  xfs_dialloc+0x5b/0x290 [xfs]
[215922.478204]  xfs_ialloc+0x6c/0x650 [xfs]
[215922.478264]  ? xlog_grant_head_check+0x6c/0x170 [xfs]
[215922.478319]  xfs_dir_ialloc+0x87/0x250 [xfs]
[215922.478372]  xfs_create+0x3df/0x610 [xfs]
[215922.478424]  xfs_generic_create+0x241/0x2e0 [xfs]
[215922.478429]  ? lookup_dcache+0x17/0x60
[215922.478433]  vfs_mkdir+0x10c/0x1a0
[215922.478437]  do_mkdirat+0xd3/0x110
[215922.478443]  do_syscall_64+0x55/0xf0
[215922.478450]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[215922.478453] RIP: 0033:0x7f2a4ff4c447
[215922.478456] Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 49 da 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 da 2b 00 f7 d8 64 89 01 48
[215922.478458] RSP: 002b:00007fffd0f80048 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
[215922.478461] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2a4ff4c447
[215922.478463] RDX: 000000000000c818 RSI: 00000000000001c0 RDI: 00007fffd0f823a0
[215922.478465] RBP: 00007f2a509f4e70 R08: 0000000000000006 R09: 00000000ffffffff
[215922.478466] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
[215922.478468] R13: 0000000000000000 R14: 00007fffd0f823a0 R15: 00000000ffffffff
[215922.478472] XFS (dm-3): Corruption detected. Unmount and run xfs_repair

Does this make any sense to you? Aside from the xfs_metadump, is there
any other debug info we could provide to help you figure this out?

Regards,
Lucas
