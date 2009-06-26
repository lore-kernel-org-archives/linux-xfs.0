Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5QJvUmQ222650 for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 14:57:32 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FE12128C4DD
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 13:06:34 -0700 (PDT)
Received: from linta.de (isilmar.linta.de [213.133.102.198]) by cuda.sgi.com
	with ESMTP id LIMZvMQmyAL2lm8B for <xfs@oss.sgi.com>;
	Fri, 26 Jun 2009 13:06:34 -0700 (PDT)
Date: Fri, 26 Jun 2009 21:58:04 +0200
From: Hendrik Hoeth <hendrik.hoeth@cern.ch>
Subject: corrupt file system -- "Structure needs cleaning"
Message-ID: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi,

I'm running linux-2.6.29.3 on a VIA Esther CPU. The harddisk is fully
encrypted using dm-crypt, and inside the encryption I have LVM with my
actual partitions. The file system is XFS, I have xfsprogs-2.9.4-1.

I was copying some large files when I got these errors (and yes, I own
that music CD ;-)):

-------------------8<---------------------
cp: cannot create regular file `maria/Mendelssohn, Felix - Klavierkonzerte (Jean-Yves Thibaudet, Gewandhausorchester)/03 Piano Concerto no. 1 in G minor op. 25 III. Presto.mp3': Structure needs cleaning
cp: cannot stat `Mendelssohn, Felix - Klavierkonzerte (Jean-Yves Thibaudet, Gewandhausorchester)/04 Variations serieuses op. 54.mp3': Input/output error
cp: cannot stat `Mendelssohn, Felix - Klavierkonzerte (Jean-Yves Thibaudet, Gewandhausorchester)/05 Rondo capriccioso op. 14.mp3': Input/output error
cp: cannot stat `Mendelssohn, Felix - Klavierkonzerte (Jean-Yves Thibaudet, Gewandhausorchester)/06 Piano Concerto no. 2 in D minor op. 40 I. Allegro appassionato.mp3': Input/output error
cp: cannot stat `Mendelssohn, Felix - Klavierkonzerte (Jean-Yves Thibaudet, Gewandhausorchester)/07 Piano Concerto no. 2 in D minor op. 40 II. Adagio.mp3': Input/output error
cp: cannot stat `Mendelssohn, Felix - Klavierkonzerte (Jean-Yves Thibaudet, Gewandhausorchester)/08 Piano Concerto no. 2 in D minor op. 40 III. Presto scherzando.mp3': Input/output error
cp: cannot stat `Mendelssohn, Felix - Klavierkonzerte (Jean-Yves Thibaudet, Gewandhausorchester)/mendelssohn.png': Input/output error
[14:35] hoeth@jetway:~/Musik/DONE $ df -h .
df: `.'
df: no file systems processed
[14:36] hoeth@jetway:~/Musik/DONE $ ls
ls: cannot open directory .: Input/output error
[14:36] hoeth@jetway:~/Musik/DONE $ 
-------------------8<---------------------

So at this point I realised that the filesystem was shut down.
Here's what I see in the logfiles:

-------------------8<---------------------
Jun 26 14:35:44 jetway kernel: Filesystem "dm-5": XFS internal error xfs_btree_check_sblock at line 124 of file fs/xfs/xfs_btree.c.  Caller 0xc02201ac
Jun 26 14:35:44 jetway kernel: 
Jun 26 14:35:44 jetway kernel: Pid: 290, comm: pdflush Not tainted 2.6.29.3 #1
Jun 26 14:35:44 jetway kernel: Call Trace:
Jun 26 14:35:44 jetway kernel:  [<c023117e>] xfs_error_report+0x4e/0x50
Jun 26 14:35:44 jetway kernel:  [<c02201ac>] ? xfs_btree_check_block+0x2c/0x40
Jun 26 14:35:44 jetway kernel:  [<c021fae6>] xfs_btree_check_sblock+0x56/0xe0
Jun 26 14:35:44 jetway kernel:  [<c02201ac>] ? xfs_btree_check_block+0x2c/0x40
Jun 26 14:35:44 jetway kernel:  [<c02201ac>] xfs_btree_check_block+0x2c/0x40
Jun 26 14:35:44 jetway kernel:  [<c022023f>] xfs_btree_read_buf_block+0x7f/0xa0
Jun 26 14:35:44 jetway kernel:  [<c02202d2>] xfs_btree_lookup_get_block+0x72/0xc0
Jun 26 14:35:44 jetway kernel:  [<c0221a2f>] xfs_btree_lookup+0x7f/0x3c0
Jun 26 14:35:44 jetway kernel:  [<c0253c17>] ? kmem_zone_zalloc+0x27/0x60
Jun 26 14:35:44 jetway kernel:  [<c020ad46>] xfs_alloc_lookup_ge+0x16/0x20
Jun 26 14:35:44 jetway kernel:  [<c020beda>] xfs_alloc_ag_vextent_near+0x4a/0x940
Jun 26 14:35:44 jetway kernel:  [<c024d920>] ? xfs_trans_read_buf+0x200/0x310
Jun 26 14:35:44 jetway kernel:  [<c020ced7>] xfs_alloc_ag_vextent+0xa7/0x100
Jun 26 14:35:44 jetway kernel:  [<c020d677>] xfs_alloc_vextent+0x227/0x410
Jun 26 14:35:44 jetway kernel:  [<c021c917>] xfs_bmap_btalloc+0x4f7/0x950
Jun 26 14:35:44 jetway kernel:  [<c021cd78>] xfs_bmap_alloc+0x8/0x10
Jun 26 14:35:44 jetway kernel:  [<c021d9f0>] xfs_bmapi+0xc70/0x1250
Jun 26 14:35:44 jetway kernel:  [<c0253b94>] ? kmem_zone_alloc+0x54/0xb0
Jun 26 14:35:44 jetway kernel:  [<c02413de>] ? xfs_log_reserve+0x7e/0xb0
Jun 26 14:35:44 jetway kernel:  [<c023bf2b>] xfs_iomap_write_allocate+0x24b/0x3c0
Jun 26 14:35:44 jetway kernel:  [<c023ce1e>] xfs_iomap+0x2ce/0x370
Jun 26 14:35:44 jetway kernel:  [<c0254803>] xfs_map_blocks+0x33/0x40
Jun 26 14:35:44 jetway kernel:  [<c02557eb>] xfs_page_state_convert+0x2db/0x6f0
Jun 26 14:35:44 jetway kernel:  [<c0255d18>] xfs_vm_writepage+0x58/0xe0
Jun 26 14:35:44 jetway kernel:  [<c014425b>] __writepage+0xb/0x30
Jun 26 14:35:44 jetway kernel:  [<c014448c>] write_cache_pages+0x1bc/0x360
Jun 26 14:35:44 jetway kernel:  [<c0144250>] ? __writepage+0x0/0x30
Jun 26 14:35:44 jetway kernel:  [<c0144653>] generic_writepages+0x23/0x30
Jun 26 14:35:44 jetway kernel:  [<c0254878>] xfs_vm_writepages+0x18/0x20
Jun 26 14:35:44 jetway kernel:  [<c014468e>] do_writepages+0x2e/0x50
Jun 26 14:35:44 jetway kernel:  [<c0176b70>] __writeback_single_inode+0x80/0x320
Jun 26 14:35:44 jetway kernel:  [<c01771ea>] generic_sync_sb_inodes+0x22a/0x2e0
Jun 26 14:35:44 jetway kernel:  [<c0253634>] ? xfs_bwrite+0x54/0xc0
Jun 26 14:35:44 jetway kernel:  [<c025ec84>] ? xfs_sync_fsdata+0x84/0xd0
Jun 26 14:35:44 jetway kernel:  [<c01772a8>] sync_sb_inodes+0x8/0x10
Jun 26 14:35:44 jetway kernel:  [<c0177432>] writeback_inodes+0x72/0x90
Jun 26 14:35:44 jetway kernel:  [<c0145222>] wb_kupdate+0x72/0xe0
Jun 26 14:35:44 jetway kernel:  [<c01455e0>] ? pdflush+0x0/0x180
Jun 26 14:35:44 jetway kernel:  [<c01456b2>] pdflush+0xd2/0x180
Jun 26 14:35:44 jetway kernel:  [<c01451b0>] ? wb_kupdate+0x0/0xe0
Jun 26 14:35:44 jetway kernel:  [<c012d422>] kthread+0x42/0x70
Jun 26 14:35:44 jetway kernel:  [<c012d3e0>] ? kthread+0x0/0x70
Jun 26 14:35:44 jetway kernel:  [<c010379f>] kernel_thread_helper+0x7/0x18
Jun 26 14:35:45 jetway kernel: Filesystem "dm-5": XFS internal error xfs_btree_check_sblock at line 124 of file fs/xfs/xfs_btree.c.  Caller 0xc02201ac
Jun 26 14:35:45 jetway kernel: 
Jun 26 14:35:45 jetway kernel: Pid: 2618, comm: cp Not tainted 2.6.29.3 #1
Jun 26 14:35:45 jetway kernel: Call Trace:
Jun 26 14:35:45 jetway kernel:  [<c023117e>] xfs_error_report+0x4e/0x50
Jun 26 14:35:45 jetway kernel:  [<c02201ac>] ? xfs_btree_check_block+0x2c/0x40
Jun 26 14:35:45 jetway kernel:  [<c021fae6>] xfs_btree_check_sblock+0x56/0xe0
Jun 26 14:35:45 jetway kernel:  [<c02201ac>] ? xfs_btree_check_block+0x2c/0x40
Jun 26 14:35:45 jetway kernel:  [<c02201ac>] xfs_btree_check_block+0x2c/0x40
Jun 26 14:35:45 jetway kernel:  [<c022023f>] xfs_btree_read_buf_block+0x7f/0xa0
Jun 26 14:35:45 jetway kernel:  [<c02202d2>] xfs_btree_lookup_get_block+0x72/0xc0
Jun 26 14:35:45 jetway kernel:  [<c0221a2f>] xfs_btree_lookup+0x7f/0x3c0
Jun 26 14:35:45 jetway kernel:  [<c0253c17>] ? kmem_zone_zalloc+0x27/0x60
Jun 26 14:35:45 jetway kernel:  [<c020ad46>] xfs_alloc_lookup_ge+0x16/0x20
Jun 26 14:35:45 jetway kernel:  [<c020beda>] xfs_alloc_ag_vextent_near+0x4a/0x940
Jun 26 14:35:45 jetway kernel:  [<c020ced7>] xfs_alloc_ag_vextent+0xa7/0x100
Jun 26 14:35:45 jetway kernel:  [<c020d677>] xfs_alloc_vextent+0x227/0x410
Jun 26 14:35:45 jetway kernel:  [<c021c917>] xfs_bmap_btalloc+0x4f7/0x950
Jun 26 14:35:45 jetway kernel:  [<c023b99b>] ? xfs_iomap_eof_want_preallocate+0x12b/0x1c0
Jun 26 14:35:45 jetway kernel:  [<c021cd78>] xfs_bmap_alloc+0x8/0x10
Jun 26 14:35:45 jetway kernel:  [<c021d9f0>] xfs_bmapi+0xc70/0x1250
Jun 26 14:35:45 jetway kernel:  [<c01405cd>] ? find_or_create_page+0x2d/0x90
Jun 26 14:35:45 jetway kernel:  [<c0228125>] xfs_dir2_grow_inode+0x115/0x3d0
Jun 26 14:35:45 jetway kernel:  [<c0253b94>] ? kmem_zone_alloc+0x54/0xb0
Jun 26 14:35:45 jetway kernel:  [<c0253c17>] ? kmem_zone_zalloc+0x27/0x60
Jun 26 14:35:45 jetway kernel:  [<c0253c82>] ? kmem_free+0x32/0x50
Jun 26 14:35:45 jetway kernel:  [<c0238b95>] ? xfs_idata_realloc+0x35/0x150
Jun 26 14:35:45 jetway kernel:  [<c0229177>] xfs_dir2_sf_to_block+0x97/0x580
Jun 26 14:35:45 jetway kernel:  [<c02563d1>] ? xfs_buf_rele+0x51/0x70
Jun 26 14:35:45 jetway kernel:  [<c024dad9>] ? xfs_trans_brelse+0xa9/0xe0
Jun 26 14:35:45 jetway kernel:  [<c0253b94>] ? kmem_zone_alloc+0x54/0xb0
Jun 26 14:35:45 jetway kernel:  [<c0253c17>] ? kmem_zone_zalloc+0x27/0x60
Jun 26 14:35:45 jetway kernel:  [<c023000d>] xfs_dir2_sf_addname+0xad/0x5b0
Jun 26 14:35:45 jetway kernel:  [<c016eefc>] ? unlock_new_inode+0x2c/0x50
Jun 26 14:35:45 jetway kernel:  [<c0170171>] ? inode_add_to_lists+0x11/0x70
Jun 26 14:35:45 jetway kernel:  [<c025a5bf>] ? xfs_setup_inode+0x14f/0x200
Jun 26 14:35:45 jetway kernel:  [<c0228908>] xfs_dir_createname+0x108/0x120
Jun 26 14:35:45 jetway kernel:  [<c0250b7a>] xfs_create+0x31a/0x430
Jun 26 14:35:45 jetway kernel:  [<c025b248>] xfs_vn_mknod+0x118/0x210
Jun 26 14:35:45 jetway kernel:  [<c025b372>] xfs_vn_create+0x12/0x20
Jun 26 14:35:45 jetway kernel:  [<c0167070>] vfs_create+0x80/0xc0
Jun 26 14:35:45 jetway kernel:  [<c025b360>] ? xfs_vn_create+0x0/0x20
Jun 26 14:35:45 jetway kernel:  [<c01699de>] do_filp_open+0x60e/0x6e0
Jun 26 14:35:45 jetway kernel:  [<c015debb>] do_sys_open+0x4b/0xe0
Jun 26 14:35:45 jetway kernel:  [<c015dfb9>] sys_open+0x29/0x40
Jun 26 14:35:45 jetway kernel:  [<c0103145>] sysenter_do_call+0x12/0x25
Jun 26 14:35:45 jetway kernel: Filesystem "dm-5": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xc02509c3
Jun 26 14:35:45 jetway kernel: 
Jun 26 14:35:45 jetway kernel: Pid: 2618, comm: cp Not tainted 2.6.29.3 #1
Jun 26 14:35:45 jetway kernel: Call Trace:
Jun 26 14:35:45 jetway kernel:  [<c023117e>] xfs_error_report+0x4e/0x50
Jun 26 14:35:45 jetway kernel:  [<c02509c3>] ? xfs_create+0x163/0x430
Jun 26 14:35:45 jetway kernel:  [<c024c101>] xfs_trans_cancel+0xd1/0xf0
Jun 26 14:35:45 jetway kernel:  [<c02509c3>] ? xfs_create+0x163/0x430
Jun 26 14:35:45 jetway kernel:  [<c02509c3>] xfs_create+0x163/0x430
Jun 26 14:35:45 jetway kernel:  [<c025b248>] xfs_vn_mknod+0x118/0x210
Jun 26 14:35:45 jetway kernel:  [<c025b372>] xfs_vn_create+0x12/0x20
Jun 26 14:35:45 jetway kernel:  [<c0167070>] vfs_create+0x80/0xc0
Jun 26 14:35:45 jetway kernel:  [<c025b360>] ? xfs_vn_create+0x0/0x20
Jun 26 14:35:45 jetway kernel:  [<c01699de>] do_filp_open+0x60e/0x6e0
Jun 26 14:35:45 jetway kernel:  [<c015debb>] do_sys_open+0x4b/0xe0
Jun 26 14:35:45 jetway kernel:  [<c015dfb9>] sys_open+0x29/0x40
Jun 26 14:35:45 jetway kernel:  [<c0103145>] sysenter_do_call+0x12/0x25
Jun 26 14:35:45 jetway kernel: xfs_force_shutdown(dm-5,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xc024c119
Jun 26 14:35:45 jetway kernel: Filesystem "dm-5": Corruption of in-memory data detected.  Shutting down filesystem: dm-5
Jun 26 14:35:45 jetway kernel: Please umount the filesystem, and rectify the problem(s)
Jun 26 14:35:48 jetway kernel: Filesystem "dm-5": xfs_log_force: error 5 returned.
Jun 26 14:36:18 jetway kernel: Filesystem "dm-5": xfs_log_force: error 5 returned.
Jun 26 14:37:18 jetway last message repeated 2 times
Jun 26 14:38:18 jetway last message repeated 2 times
Jun 26 14:39:18 jetway last message repeated 2 times
Jun 26 14:40:18 jetway last message repeated 2 times
Jun 26 14:41:18 jetway last message repeated 2 times
Jun 26 14:41:55 jetway last message repeated 6 times
Jun 26 14:43:56 jetway kernel: Filesystem "dm-5": Disabling barriers, trial barrier write failed
Jun 26 14:43:56 jetway kernel: XFS mounting filesystem dm-5
Jun 26 14:43:57 jetway kernel: Starting XFS recovery on filesystem: dm-5 (logdev: internal)
Jun 26 14:43:57 jetway kernel: Ending XFS recovery on filesystem: dm-5 (logdev: internal)
Jun 26 14:44:18 jetway kernel: Filesystem "dm-5": Disabling barriers, trial barrier write failed
Jun 26 14:44:18 jetway kernel: XFS mounting filesystem dm-5
Jun 26 14:44:18 jetway kernel: Ending clean XFS mount for filesystem: dm-5
-------------------8<---------------------

This is how I recovered (well, most of the data I had copied is
corrupt at the target location):

-------------------8<---------------------
[14:40] root@jetway:/var/log # umount /home 
[14:43] root@jetway:/var/log # xfs_check /dev/mapper/hda_crypt_vg-home
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
[14:43] root@jetway:/var/log # mount /home/
[14:43] root@jetway:/var/log # umount /home/
[14:44] root@jetway:/var/log # xfs_check /dev/mapper/hda_crypt_vg-home
[14:44] root@jetway:/var/log # mount /home/
-------------------8<---------------------

Please let me know if you want to have any further information.
I'm not on the mailing list, so Cc me directly.

Cheers,

    Hendrik

-- 
"You have to take the most direct road to go instead of your 
 meeting, you have to, this one ended, leave at once the CERN
 domain."         (imprint on the CERN visitor ID cards)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
