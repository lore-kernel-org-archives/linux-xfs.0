Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8DD977F5D
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 16:39:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5937F8F8035
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 14:39:05 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	1qh30rzRQnNJ5usn for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 14:39:02 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 0E3371F00B14
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 17:39:02 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id WiW2i5pUjcxB for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 17:38:57 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 9AC661F001B0
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 17:38:57 -0400 (EDT)
Date: Sun, 18 Aug 2013 17:38:56 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <11558272.4016.1376861936621.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <21672216.3390.1376260599697.JavaMail.root@benjamin.baylink.com>
Subject: XFS recovery resumes...
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

I'm trying to dedupe the two large XFS filesystems on which I have DVR 
recordings, so that I can walk around amongst the available HDDs and create
new filesystems under everything.

Every time I rm a file, the filesystem blows up, and the driver shuts it
down.  

Some background:

At the moment, I have 2 devices, /dev/sdd1 mounted on /appl/media4, and
/dev/sda1 mounted on /appl/media5, and a large script, created by hand-
hacking the output of a perl dupe finder script.

The large script was mangled so that it would remove anything that was a 
dupe from media4, unless the file was an unlabeled lost+found on media5,
and had a name on media4.  In that case, I removed the file on media5, and
then moved it from media4 to media5.

After the hand-hacking on the script, I sorted it to do all the rm's first,
and then all the mv's, to make sure free space when up before it went down.

And, of course, when I ran the script, it caused the XFS driver to cough and
die, leading to error 5s and gnashing of teeth.

I unmounted media5, remounted it (which worked), and unmounted it again to
run xfs_repair -n.  That found one inode that was pointing somewhere bogus 
(and I apologize that I can't copy that in; I was running under screen, and
it doesn't cooperate with scrollback well).  I ran an xfs_repair without -n,
and it found and fixed the one error without complaint.

I mounted and unmounted it successfully (nothing notable in dmesg), and reran
xfs_repair -n, which, this time, ran without any problems reported.

So I remounted the filesystem, and again tried to run the script.

And again, it tripped something, and the filesystem unmounted, and here's the
dmesg output from the first and second trips:

First time:
[169324.654803] XFS (sdd1): Ending clean mount
[1278872.471310] ccbc0000: 41 42 54 42 00 00 00 04 df ff ff ff ff ff ff ff  ABTB............
[1278872.471324] XFS (sda1): Internal error xfs_btree_check_sblock at line 119 of file /home/abuild/rpmbuild/BUI
LD/kernel-default-3.4.47/linux-3.4/fs/xfs/xfs_btree.c.  Caller 0xe3caf3a5
[1278872.471328]
[1278872.471334] Pid: 16696, comm: rm Not tainted 3.4.47-2.38-default #1
[1278872.471338] Call Trace:
[1278872.471368]  [<c0205349>] try_stack_unwind+0x199/0x1b0
[1278872.471382]  [<c02041c7>] dump_trace+0x47/0xf0
[1278872.471391]  [<c02053ab>] show_trace_log_lvl+0x4b/0x60
[1278872.471398]  [<c02053d8>] show_trace+0x18/0x20
[1278872.471409]  [<c06825ba>] dump_stack+0x6d/0x72
[1278872.471534]  [<e3c826ed>] xfs_corruption_error+0x5d/0x90 [xfs]
[1278872.471650]  [<e3cae9f4>] xfs_btree_check_sblock+0x74/0x100 [xfs]
[1278872.471834]  [<e3caf3a5>] xfs_btree_read_buf_block.constprop.24+0x95/0xb0 [xfs]
[1278872.472007]  [<e3caf423>] xfs_btree_lookup_get_block+0x63/0xc0 [xfs]
[1278872.472207]  [<e3cb251a>] xfs_btree_lookup+0x9a/0x460 [xfs]
[1278872.472379]  [<e3c9576a>] xfs_alloc_fixup_trees+0x27a/0x370 [xfs]
[1278872.472510]  [<e3c97b63>] xfs_alloc_ag_vextent_size+0x523/0x670 [xfs]
[1278872.472647]  [<e3c9874f>] xfs_alloc_ag_vextent+0x9f/0x100 [xfs]
[1278872.472781]  [<e3c9899a>] xfs_alloc_fix_freelist+0x1ea/0x450 [xfs]
[1278872.472915]  [<e3c98cd5>] xfs_free_extent+0xd5/0x160 [xfs]
[1278872.473052]  [<e3ca9f4e>] xfs_bmap_finish+0x15e/0x1b0 [xfs]
[1278872.473214]  [<e3cc47e9>] xfs_itruncate_extents+0x159/0x2f0 [xfs]
[1278872.473422]  [<e3c92ff5>] xfs_inactive+0x335/0x4a0 [xfs]
[1278872.473516]  [<c0337e84>] evict+0x84/0x150
[1278872.473530]  [<c032ea22>] do_unlinkat+0x102/0x160
[1278872.473546]  [<c069331c>] sysenter_do_call+0x12/0x28
[1278872.473578]  [<b779b430>] 0xb779b42f
[1278872.473583] XFS (sda1): Corruption detected. Unmount and run xfs_repair
[1278872.473599] XFS (sda1): xfs_do_force_shutdown(0x8) called from line 3732 of file /home/abuild/rpmbuild/BUIL
D/kernel-default-3.4.47/linux-3.4/fs/xfs/xfs_bmap.c.  Return address = 0xe3ca9f8c
[1278872.584543] XFS (sda1): Corruption of in-memory data detected.  Shutting down filesystem
[1278872.584555] XFS (sda1): Please umount the filesystem and rectify the problem(s)
[1278881.888038] XFS (sda1): xfs_log_force: error 5 returned.
[1278911.968046] XFS (sda1): xfs_log_force: error 5 returned.
[1278942.048037] XFS (sda1): xfs_log_force: error 5 returned.
[1278972.128049] XFS (sda1): xfs_log_force: error 5 returned.
[1279002.208042] XFS (sda1): xfs_log_force: error 5 returned.
[1279028.046331] XFS (sda1): xfs_log_force: error 5 returned.
[1279028.046349] XFS (sda1): xfs_do_force_shutdown(0x1) called from line 1031 of file /home/abuild/rpmbuild/BUIL
D/kernel-default-3.4.47/linux-3.4/fs/xfs/xfs_buf.c.  Return address = 0xe3c813c0
[1279028.060676] XFS (sda1): xfs_log_force: error 5 returned.
[1279028.067532] XFS (sda1): xfs_log_force: error 5 returned.

Here's me mounting and umounting, with the xfs_repair runs in the middle:
[1279032.147391] XFS (sda1): Mounting Filesystem
[1279032.305924] XFS (sda1): Starting recovery (logdev: internal)
[1279035.263630] XFS (sda1): Ending recovery (logdev: internal)
[1279238.566041] XFS (sda1): Mounting Filesystem
[1279238.713051] XFS (sda1): Ending clean mount
[1279286.829764] XFS (sda1): Mounting Filesystem
[1279286.982409] XFS (sda1): Ending clean mount
[1279368.607644] XFS (sda1): Mounting Filesystem
[1279368.755048] XFS (sda1): Ending clean mount

Second time:
[1279388.664986] c1516000: 41 42 54 43 00 00 00 04 df ff ff ff ff ff ff ff  ABTC............
[1279388.665000] XFS (sda1): Internal error xfs_btree_check_sblock at line 119 of file /home/abuild/rpmbuild/BUI
LD/kernel-default-3.4.47/linux-3.4/fs/xfs/xfs_btree.c.  Caller 0xe3caf3a5
[1279388.665004]
[1279388.665010] Pid: 18452, comm: rm Not tainted 3.4.47-2.38-default #1
[1279388.665015] Call Trace:
[1279388.665045]  [<c0205349>] try_stack_unwind+0x199/0x1b0
[1279388.665058]  [<c02041c7>] dump_trace+0x47/0xf0
[1279388.665067]  [<c02053ab>] show_trace_log_lvl+0x4b/0x60
[1279388.665075]  [<c02053d8>] show_trace+0x18/0x20
[1279388.665086]  [<c06825ba>] dump_stack+0x6d/0x72
[1279388.665211]  [<e3c826ed>] xfs_corruption_error+0x5d/0x90 [xfs]
[1279388.665327]  [<e3cae9f4>] xfs_btree_check_sblock+0x74/0x100 [xfs]
[1279388.665511]  [<e3caf3a5>] xfs_btree_read_buf_block.constprop.24+0x95/0xb0 [xfs]
[1279388.665684]  [<e3caf423>] xfs_btree_lookup_get_block+0x63/0xc0 [xfs]
[1279388.665856]  [<e3cb251a>] xfs_btree_lookup+0x9a/0x460 [xfs]
[1279388.666029]  [<e3c97691>] xfs_alloc_ag_vextent_size+0x51/0x670 [xfs]
[1279388.666163]  [<e3c9874f>] xfs_alloc_ag_vextent+0x9f/0x100 [xfs]
[1279388.666298]  [<e3c9899a>] xfs_alloc_fix_freelist+0x1ea/0x450 [xfs]
[1279388.666433]  [<e3c98cd5>] xfs_free_extent+0xd5/0x160 [xfs]
[1279388.666571]  [<e3ca9f4e>] xfs_bmap_finish+0x15e/0x1b0 [xfs]
[1279388.666734]  [<e3cc47e9>] xfs_itruncate_extents+0x159/0x2f0 [xfs]
[1279388.666944]  [<e3c92ff5>] xfs_inactive+0x335/0x4a0 [xfs]
[1279388.667039]  [<c0337e84>] evict+0x84/0x150
[1279388.667053]  [<c032ea22>] do_unlinkat+0x102/0x160
[1279388.667069]  [<c069331c>] sysenter_do_call+0x12/0x28
[1279388.667100]  [<b772f430>] 0xb772f42f
[1279388.667105] XFS (sda1): Corruption detected. Unmount and run xfs_repair
[1279388.667120] XFS (sda1): xfs_do_force_shutdown(0x8) called from line 3732 of file /home/abuild/rpmbuild/BUIL
D/kernel-default-3.4.47/linux-3.4/fs/xfs/xfs_bmap.c.  Return address = 0xe3ca9f8c
[1279388.690497] XFS (sda1): Corruption of in-memory data detected.  Shutting down filesystem
[1279388.690506] XFS (sda1): Please umount the filesystem and rectify the problem(s)
[1279398.816060] XFS (sda1): xfs_log_force: error 5 returned.
[1279428.832065] XFS (sda1): xfs_log_force: error 5 returned.
[ ... ]

It's not entirely clear to me whether this problem is specific inodes that
are corrupt or not, or just something in the filesystem header.

Kernel:
Linux duckling 3.4.47-2.38-default #1 SMP Fri May 31 20:17:40 UTC 2013 (3961086) i686 athlon i386 GNU/Linux

progs:
xfsprogs-3.1.6-9.1.2.i586

Worst case, if I can't get these to behave, I'll just beg, borrow or steal 
a spare 3T and copy everything to it, and then redo the FSs on these 2 
drives, but it would a bit easier if I could get them to settle down a 
bit...

Anyone have any suggestions as to which mole I should whack next?

[ ... ]

Built xfsprogs 3.1.11 from GIT, and ran it, and on /appl/media4, /dev/sda1:

============
duckling:/appl/downloads/xfsprogs # xfs_repair /dev/sda1
Phase 1 - find and verify superblock...
Not enough RAM available for repair to enable prefetching.
This will be _slow_.
You need at least 497MB RAM to run with prefetching enabled.
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
ir_freecount/free mismatch, inode chunk 2/128, freecount 62 nfree 61
ir_freecount/free mismatch, inode chunk 3/128, freecount 36 nfree 35
xfs_allocbt_read_verify: XFS_CORRUPTION_ERROR
xfs_allocbt_read_verify: XFS_CORRUPTION_ERROR
xfs_allocbt_read_verify: XFS_CORRUPTION_ERROR
xfs_allocbt_read_verify: XFS_CORRUPTION_ERROR
xfs_allocbt_read_verify: XFS_CORRUPTION_ERROR
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
imap claims a free inode 1073742013 is in use, correcting imap and clearing inode
cleared inode 1073742013
        - agno = 3
imap claims a free inode 1610612893 is in use, correcting imap and clearing inode
cleared inode 1610612893
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
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
__read_verify: XFS_CORRUPTION_ERROR
can't read leaf block 8388608 for directory inode 128
rebuilding directory inode 128
name create failed in ino 128 (117), filesystem may be out of space
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
============

It's not clear to me whether that actually fixed anything or not, but
I think I'm going to put off a second run, or a run on the other FS
which threw more CORRUPTION errors in a later stage, until I have a
better idea what's going on...

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
