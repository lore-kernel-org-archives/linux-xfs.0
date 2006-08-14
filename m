Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Aug 2006 07:18:37 -0700 (PDT)
Received: from mx.wurtel.net (xs.wurtel.net [83.68.3.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7EEIODW007628
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 07:18:26 -0700
Received: from wurtel ([192.168.1.1] helo=wurtel-ws.wurtel.net)
	by mx.wurtel.net with esmtp (Exim 3.36 #1 (Debian))
	id 1GCdFz-0004w0-00
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 16:17:31 +0200
Received: from paul by wurtel-ws.wurtel.net with local (Exim 4.62)
	(envelope-from <paul@wurtel-ws.wurtel.net>)
	id 1GCdFz-0008Uv-AR
	for xfs@oss.sgi.com; Mon, 14 Aug 2006 16:17:31 +0200
Date: Mon, 14 Aug 2006 16:17:31 +0200
From: Paul Slootman <paul@wurtel.net>
Subject: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20060814141731.GA9098@wurtel.net>
References: <20060810164222.GA16332@wurtel.net> <200608110125.LAA18091@larry.melbourne.sgi.com> <20060811090218.GB22934@wurtel.net> <20060812091451.GA16661@wurtel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060812091451.GA16661@wurtel.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Sat 12 Aug 2006, Paul Slootman wrote:
> 
> I've now zapped that directory with xfs_db, and am running the (daily?!)
> xfs_repair at this moment. As the filesystem is 1.1TB, it takes a couple
> of hours :(

That showed the following message in phase 3 because of the xfs_db action:

    imap claims a free inode 261 is in use, correcting imap and clearing inode

and then in phase 4:

    entry "lost+found.x" at block 0 offset 584 in directory inode 256 references free inode 261
            clearing inode number in entry at offset 584...

and in phase 6:

    rebuilding directory inode 256

and phase 7:

    resetting inode 256 nlinks from 17 to 16

but nothing beyond that.


However, that night:

Aug 13 08:28:00 boes kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 874 of file fs/xfs/xfs_ialloc.c.  Caller 0xffffffff8803be2f
Aug 13 08:28:00 boes kernel: 
Aug 13 08:28:00 boes kernel: Call Trace: <ffffffff880366d6>{:xfs:xfs_dialloc+1958}
Aug 13 08:28:00 boes kernel:        <ffffffff8805d8e7>{:xfs:_xfs_buf_lookup_pages+711} <ffffffff88045858>{:xfs:xlog_state_get_iclog_space+56}
Aug 13 08:28:00 boes kernel:        <ffffffff8803be2f>{:xfs:xfs_ialloc+95} <ffffffff8805b83b>{:xfs:kmem_zone_alloc+91}
Aug 13 08:28:00 boes kernel:        <ffffffff88052116>{:xfs:xfs_dir_ialloc+134} <ffffffff88043913>{:xfs:xfs_log_reserve+195}
Aug 13 08:28:00 boes kernel:        <ffffffff8805867b>{:xfs:xfs_mkdir+923} <ffffffff88007f1b>{:xfs:xfs_acl_get_attr+91}
Aug 13 08:28:00 boes kernel:        <ffffffff880623a1>{:xfs:xfs_vn_mknod+465} <ffffffff80292ab0>{d_rehash+112}
Aug 13 08:28:00 boes kernel:        <ffffffff804a136f>{__mutex_unlock_slowpath+415} <ffffffff80287f9d>{real_lookup+157}
Aug 13 08:28:00 boes kernel:        <ffffffff8033fac1>{_atomic_dec_and_lock+65} <ffffffff80296544>{mntput_no_expire+36}
Aug 13 08:28:00 boes kernel:        <ffffffff80289138>{__link_path_walk+3576} <ffffffff80342cd1>{__up_read+33}
Aug 13 08:28:00 boes kernel:        <ffffffff8803a816>{:xfs:xfs_iunlock+102} <ffffffff880560aa>{:xfs:xfs_access+74}
Aug 13 08:28:00 boes kernel:        <ffffffff88062b44>{:xfs:xfs_vn_permission+20} <ffffffff80287c48>{permission+104}
Aug 13 08:28:00 boes kernel:        <ffffffff802883ea>{__link_path_walk+170} <ffffffff880560aa>{:xfs:xfs_access+74}
Aug 13 08:28:00 boes kernel:        <ffffffff8028ab02>{vfs_mkdir+130} <ffffffff8028abf5>{sys_mkdirat+165}
Aug 13 08:28:00 boes kernel:        <ffffffff80209b5a>{system_call+126}
Aug 13 08:28:00 boes kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 874 of file fs/xfs/xfs_ialloc.c.  Caller 0xffffffff8803be2f
Aug 13 08:28:00 boes kernel: 
Aug 13 08:28:00 boes kernel: Call Trace: <ffffffff880366d6>{:xfs:xfs_dialloc+1958}
Aug 13 08:28:00 boes kernel:        <ffffffff80331a11>{__generic_unplug_device+33} <ffffffff80340aa0>{kobject_release+0}
Aug 13 08:28:00 boes kernel:        <ffffffff88045858>{:xfs:xlog_state_get_iclog_space+56}
Aug 13 08:28:00 boes kernel:        <ffffffff8803be2f>{:xfs:xfs_ialloc+95} <ffffffff8805b83b>{:xfs:kmem_zone_alloc+91}
Aug 13 08:28:00 boes kernel:        <ffffffff88052116>{:xfs:xfs_dir_ialloc+134} <ffffffff88043913>{:xfs:xfs_log_reserve+195}
Aug 13 08:28:00 boes kernel:        <ffffffff8805867b>{:xfs:xfs_mkdir+923} <ffffffff88007f1b>{:xfs:xfs_acl_get_attr+91}
Aug 13 08:28:00 boes kernel:        <ffffffff880623a1>{:xfs:xfs_vn_mknod+465} <ffffffff80292ab0>{d_rehash+112}
Aug 13 08:28:00 boes kernel:        <ffffffff804a136f>{__mutex_unlock_slowpath+415} <ffffffff80287f9d>{real_lookup+157}
Aug 13 08:28:00 boes kernel:        <ffffffff8033fac1>{_atomic_dec_and_lock+65} <ffffffff80296544>{mntput_no_expire+36}
Aug 13 08:28:00 boes kernel:        <ffffffff80289138>{__link_path_walk+3576} <ffffffff80342cd1>{__up_read+33}
Aug 13 08:28:00 boes kernel:        <ffffffff8803a816>{:xfs:xfs_iunlock+102} <ffffffff880560aa>{:xfs:xfs_access+74}
Aug 13 08:28:00 boes kernel:        <ffffffff88062b44>{:xfs:xfs_vn_permission+20} <ffffffff80287c48>{permission+104}
Aug 13 08:28:00 boes kernel:        <ffffffff802883ea>{__link_path_walk+170} <ffffffff880560aa>{:xfs:xfs_access+74}
Aug 13 08:28:00 boes kernel:        <ffffffff8028ab02>{vfs_mkdir+130} <ffffffff8028abf5>{sys_mkdirat+165}
Aug 13 08:28:00 boes kernel:        <ffffffff80209b5a>{system_call+126}

Variations of this trace repeat a number of times, and then:

Aug 13 08:31:09 boes kernel: xfs_force_shutdown(md6,0x8) called from line 1151 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff88065ba8
Aug 13 08:31:09 boes kernel: Filesystem "md6": Corruption of in-memory data detected.  Shutting down filesystem: md6
Aug 13 08:31:09 boes kernel: Please umount the filesystem, and rectify the problem(s)


The repair after this gave the following messages:

Phase 3: correcting nblocks for inode 3080162495, was 2034 - counted 4
Phase 7: resetting inode 256 nlinks from 17 to 16
         resetting inode 3080162495 nlinks from 1 to 10

That's all.

Needless to say, the night after that repair it all went pear-shaped again:

Aug 14 01:00:03 boes kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 874 of file fs/xfs/xfs_ialloc.c.  Caller 0xffffffff8803be2f
Aug 14 01:00:03 boes kernel: 
Aug 14 01:00:03 boes kernel: Call Trace: <ffffffff880366d6>{:xfs:xfs_dialloc+1958}
Aug 14 01:00:03 boes kernel:        <ffffffff8805d8e7>{:xfs:_xfs_buf_lookup_pages+711} <ffffffff88045858>{:xfs:xlog_state_get_iclog_space+56}
Aug 14 01:00:03 boes kernel:        <ffffffff8803be2f>{:xfs:xfs_ialloc+95} <ffffffff8805b83b>{:xfs:kmem_zone_alloc+91}
Aug 14 01:00:03 boes kernel:        <ffffffff88052116>{:xfs:xfs_dir_ialloc+134} <ffffffff88043913>{:xfs:xfs_log_reserve+195}
Aug 14 01:00:03 boes kernel:        <ffffffff8805867b>{:xfs:xfs_mkdir+923} <ffffffff88007f1b>{:xfs:xfs_acl_get_attr+91}
Aug 14 01:00:03 boes kernel:        <ffffffff880623a1>{:xfs:xfs_vn_mknod+465} <ffffffff80292ab0>{d_rehash+112}
Aug 14 01:00:03 boes kernel:        <ffffffff804a136f>{__mutex_unlock_slowpath+415} <ffffffff80287f9d>{real_lookup+157}
Aug 14 01:00:03 boes kernel:        <ffffffff8033fac1>{_atomic_dec_and_lock+65} <ffffffff80296544>{mntput_no_expire+36}
Aug 14 01:00:03 boes kernel:        <ffffffff80289138>{__link_path_walk+3576} <ffffffff80342cd1>{__up_read+33}
Aug 14 01:00:03 boes kernel:        <ffffffff8803a816>{:xfs:xfs_iunlock+102} <ffffffff880560aa>{:xfs:xfs_access+74}
Aug 14 01:00:03 boes kernel:        <ffffffff88062b44>{:xfs:xfs_vn_permission+20} <ffffffff80287c48>{permission+104}
Aug 14 01:00:03 boes kernel:        <ffffffff802883ea>{__link_path_walk+170} <ffffffff880560aa>{:xfs:xfs_access+74}
Aug 14 01:00:03 boes kernel:        <ffffffff8028ab02>{vfs_mkdir+130} <ffffffff8028abf5>{sys_mkdirat+165}
Aug 14 01:00:03 boes kernel:        <ffffffff80209b5a>{system_call+126}
Aug 14 01:00:03 boes kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 874 of file fs/xfs/xfs_ialloc.c.  Caller 0xffffffff8803be2f
Aug 14 01:00:03 boes kernel: 
Aug 14 01:00:03 boes kernel: Call Trace: <ffffffff880366d6>{:xfs:xfs_dialloc+1958}
Aug 14 01:00:03 boes kernel:        <ffffffff8803be2f>{:xfs:xfs_ialloc+95} <ffffffff8805b83b>{:xfs:kmem_zone_alloc+91}
Aug 14 01:00:03 boes kernel:        <ffffffff88052116>{:xfs:xfs_dir_ialloc+134} <ffffffff88043913>{:xfs:xfs_log_reserve+195}
Aug 14 01:00:03 boes kernel:        <ffffffff8805867b>{:xfs:xfs_mkdir+923} <ffffffff88007f1b>{:xfs:xfs_acl_get_attr+91}
Aug 14 01:00:04 boes kernel:        <ffffffff880623a1>{:xfs:xfs_vn_mknod+465} <ffffffff80292ab0>{d_rehash+112}
Aug 14 01:00:04 boes kernel:        <ffffffff804a136f>{__mutex_unlock_slowpath+415} <ffffffff80287f9d>{real_lookup+157}
Aug 14 01:00:04 boes kernel:        <ffffffff8033fac1>{_atomic_dec_and_lock+65} <ffffffff80296544>{mntput_no_expire+36}
Aug 14 01:00:04 boes kernel:        <ffffffff80289138>{__link_path_walk+3576} <ffffffff80342cd1>{__up_read+33}
Aug 14 01:00:04 boes kernel:        <ffffffff8805076c>{:xfs:xfs_trans_unlocked_item+44}
Aug 14 01:00:04 boes kernel:        <ffffffff880560aa>{:xfs:xfs_access+74} <ffffffff88062b44>{:xfs:xfs_vn_permission+20}
Aug 14 01:00:04 boes kernel:        <ffffffff80287c48>{permission+104} <ffffffff802883ea>{__link_path_walk+170}
Aug 14 01:00:04 boes kernel:        <ffffffff880560aa>{:xfs:xfs_access+74} <ffffffff8028ab02>{vfs_mkdir+130}
Aug 14 01:00:04 boes kernel:        <ffffffff8028abf5>{sys_mkdirat+165} <ffffffff80209b5a>{system_call+126}

etc.


I had umounted and mounted the filesystem after that. I tried removing
a couple of junk directories at this point (probably a bad idea in retrospect)
and when I tried to umount the directory again in preparation of the repair,
the system stopped responding. The kernel was spewing these messages:

Aug 14 12:23:45 boes kernel: BUG: soft lockup detected on CPU#0!
Aug 14 12:23:45 boes kernel: 
Aug 14 12:23:45 boes kernel: Call Trace: <IRQ> <ffffffff802511a9>{softlockup_tick+233}
Aug 14 12:23:45 boes kernel:        <ffffffff802367e0>{update_process_times+80} <ffffffff802163e3>{smp_local_timer_interrupt+35}
Aug 14 12:23:45 boes kernel:        <ffffffff80216451>{smp_apic_timer_interrupt+65} <ffffffff8020a69a>{apic_timer_interrupt+98} <EOI>
Aug 14 12:23:45 boes kernel:        <ffffffff8803a578>{:xfs:xfs_iextract+264} <ffffffff80245591>{debug_mutex_add_waiter+161}
Aug 14 12:23:45 boes kernel:        <ffffffff8803e226>{:xfs:xfs_iflush_all+22} <ffffffff804a10df>{__mutex_lock_slowpath+767}
Aug 14 12:23:45 boes kernel:        <ffffffff804a10b4>{__mutex_lock_slowpath+724} <ffffffff8803e226>{:xfs:xfs_iflush_all+22}
Aug 14 12:23:45 boes kernel:        <ffffffff8804c733>{:xfs:xfs_unmountfs+19} <ffffffff8805368d>{:xfs:xfs_unmount+301}
Aug 14 12:23:45 boes kernel:        <ffffffff880659f8>{:xfs:vfs_unmount+40} <ffffffff88065342>{:xfs:xfs_fs_put_super+50}
Aug 14 12:23:45 boes kernel:        <ffffffff802805ff>{generic_shutdown_super+159} <ffffffff802811dd>{kill_block_super+45}
Aug 14 12:23:45 boes kernel:        <ffffffff8028048f>{deactivate_super+79} <ffffffff80296d79>{sys_umount+137}
Aug 14 12:23:45 boes kernel:        <ffffffff80342d82>{__up_write+34} <ffffffff8020a7ed>{error_exit+0}
Aug 14 12:23:45 boes kernel:        <ffffffff80209b5a>{system_call+126}
Aug 14 12:23:55 boes kernel: BUG: soft lockup detected on CPU#0!
Aug 14 12:23:55 boes kernel: 
Aug 14 12:23:55 boes kernel: Call Trace: <IRQ> <ffffffff802511a9>{softlockup_tick+233}
Aug 14 12:23:55 boes kernel:        <ffffffff802367e0>{update_process_times+80} <ffffffff802163e3>{smp_local_timer_interrupt+35}
Aug 14 12:23:55 boes kernel:        <ffffffff80216451>{smp_apic_timer_interrupt+65} <ffffffff8020a69a>{apic_timer_interrupt+98} <EOI>
Aug 14 12:23:56 boes kernel:        <ffffffff8803e226>{:xfs:xfs_iflush_all+22} <ffffffff80245591>{debug_mutex_add_waiter+161}
Aug 14 12:23:56 boes kernel:        <ffffffff804a10df>{__mutex_lock_slowpath+767} <ffffffff8803e261>{:xfs:xfs_iflush_all+81}
Aug 14 12:23:56 boes kernel:        <ffffffff804a13b8>{__mutex_unlock_slowpath+488} <ffffffff8803e261>{:xfs:xfs_iflush_all+81}
Aug 14 12:23:56 boes kernel:        <ffffffff8804c733>{:xfs:xfs_unmountfs+19} <ffffffff8805368d>{:xfs:xfs_unmount+301}
Aug 14 12:23:56 boes kernel:        <ffffffff880659f8>{:xfs:vfs_unmount+40} <ffffffff88065342>{:xfs:xfs_fs_put_super+50}
Aug 14 12:23:56 boes kernel:        <ffffffff802805ff>{generic_shutdown_super+159} <ffffffff802811dd>{kill_block_super+45}
Aug 14 12:23:56 boes kernel:        <ffffffff8028048f>{deactivate_super+79} <ffffffff80296d79>{sys_umount+137}
Aug 14 12:23:56 boes kernel:        <ffffffff80342d82>{__up_write+34} <ffffffff8020a7ed>{error_exit+0}
Aug 14 12:23:56 boes kernel:        <ffffffff80209b5a>{system_call+126}

Dumping the locks held via magic-sysreq showed:

Aug 14 12:26:46 boes kernel: #009:             [ffff81013020d488] {alloc_super}
Aug 14 12:26:46 boes kernel: .. held by:            umount:18733 [ffff810154498340, 117]
Aug 14 12:26:46 boes kernel: ... acquired at:               generic_shutdown_super+0x63/0x150
 


kernel: 2.6.17.7 x86_64
xfstools: 2.8.11 from CVS last week

I'm now running the "standard" debian xfs_repair (version 2.6.20) for kicks,
as the 2.8.11 version didn't really seem to help much. I'm now getting
plenty of these errors:

entry "img-050806-090_onlin_81895f.jpg" at block 4 offset 2752 in directory inode 1343503044 references free inode 2511243327
        clearing inode number in entry at offset 2752...
entry "img-050806-090_onlin_81895f.jpg" at block 4 offset 2704 in directory inode 2160247870 references free inode 2511243327
        clearing inode number in entry at offset 2704...
entry "xbase-clients" at block 1 offset 1248 in directory inode 2457926717 references free inode 2511243327
        clearing inode number in entry at offset 1248...
entry "img-050806-090_onlin_81895f.jpg" at block 5 offset 592 in directory inode 2508332587 references free inode 2511243327
        clearing inode number in entry at offset 592...

Phase 6:
rebuilding directory inode 256
rebuilding directory inode 1343503044
rebuilding directory inode 2508332587
rebuilding directory inode 2160247870
rebuilding directory inode 2457926717

Phase 7:
resetting inode 256 nlinks from 17 to 16
resetting inode 2457926717 nlinks from 12 to 2
resetting inode 3080162495 nlinks from 1 to 10

Note the recurring them of "resetting inode 256 nlinks from 17 to 16".
It seems like xfs_repair 2.8.11 doesn't, in fact, reset the nlinks.
(Or it's the deletion and recreation of lost+found as 256 is the root dir,
but that doesn't explain the other two inode nlinks.)

Help! :-(


Paul Slootman
