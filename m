Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jul 2008 07:54:53 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6IEsm5d026219
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2008 07:54:49 -0700
Received: from smtprelay01.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41A2F18F63A9
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2008 07:55:54 -0700 (PDT)
Received: from smtprelay01.ispgateway.de (smtprelay01.ispgateway.de [80.67.18.13]) by cuda.sgi.com with ESMTP id G4XLEFkjgTOALKL1 for <xfs@oss.sgi.com>; Fri, 18 Jul 2008 07:55:54 -0700 (PDT)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <Richard.Ems@cape-horn-eng.com>)
	id 1KJrNA-0000ps-QO
	for xfs@oss.sgi.com; Fri, 18 Jul 2008 16:55:53 +0200
Message-ID: <4880AEF8.2080906@cape-horn-eng.com>
Date: Fri, 18 Jul 2008 16:55:52 +0200
From: Richard Ems <Richard.Ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: XFS internal error xfs_btree_check_lblock
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

this FS error occurred on an openSUSE 10.3 64 bit, with all openSUSE updates. xfsprogs is xfsprogs-2.9.4-17.1 .

The filesystem with the error is our /home, on an Areca ARC-1220 RAID Controller, 6 Hitachi 1TB disks on RAID 5.

The controller reports all disks are fine, no errors.

The system had an uptime of 74 days, and had no problems with any FS before.


First errors logged on /var/log/messages start at today 11:16 :

Jul 18 11:16:08 c3m kernel: Filesystem "sdc1": Access to block zero in inode 381260 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f
Jul 18 11:16:08 c3m syslog-ng[15627]: last message repeated 2 times
Jul 18 11:16:08 c3m kernel: Filesystem "sdc1": Access to block zero in inode 381260 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 10
Jul 18 11:16:08 c3m syslog-ng[15627]: last message repeated 3 times
Jul 18 11:16:08 c3m kernel: Filesystem "sdc1": Access to block zero in inode 381260 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 11
Jul 18 11:16:08 c3m syslog-ng[15627]: last message repeated 20 times
Jul 18 11:16:08 c3m kernel: Filesystem "sdc1": Access to block zero in inode 381260 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 12
Jul 18 11:16:08 c3m syslog-ng[15627]: last message repeated 3 times
Jul 18 11:16:08 c3m kernel: Filesystem "sdc1": Access to block zero in inode 381260 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 13
Jul 18 11:16:08 c3m kernel: Filesystem "sdc1": Access to block zero in inode 381260 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 13


and this continues up to 11:58 where we got


Jul 18 11:58:37 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_lblock at line 213 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff88306053
Jul 18 11:58:37 c3m kernel:
Jul 18 11:58:37 c3m kernel: Call Trace:
Jul 18 11:58:37 c3m kernel:  [<ffffffff88309c57>] :xfs:xfs_btree_check_lblock+0xf4/0xfe
Jul 18 11:58:37 c3m kernel:  [<ffffffff88306053>] :xfs:xfs_bmbt_lookup+0x16e/0x44b
Jul 18 11:58:37 c3m kernel:  [<ffffffff88301104>] :xfs:xfs_bmap_add_extent_delay_real+0x3f7/0xf16
Jul 18 11:58:37 c3m kernel:  [<ffffffff802f7fe5>] __up_read+0x13/0x8a
Jul 18 11:58:37 c3m kernel:  [<ffffffff8830018d>] :xfs:xfs_bmap_btalloc+0x5d7/0x693
Jul 18 11:58:37 c3m kernel:  [<ffffffff883023be>] :xfs:xfs_bmap_add_extent+0x21c/0x3ad
Jul 18 11:58:37 c3m kernel:  [<ffffffff8830952a>] :xfs:xfs_btree_init_cursor+0x37/0x168
Jul 18 11:58:37 c3m kernel:  [<ffffffff88303aeb>] :xfs:xfs_bmapi+0xa98/0x108f
Jul 18 11:58:37 c3m kernel:  [<ffffffff802f368d>] cfq_set_request+0x2e7/0x345
Jul 18 11:58:37 c3m kernel:  [<ffffffff8832e92f>] :xfs:xfs_trans_reserve+0xdd/0x1b0
Jul 18 11:58:37 c3m kernel:  [<ffffffff88321e7f>] :xfs:xfs_iomap_write_allocate+0x255/0x3ce
Jul 18 11:58:37 c3m kernel:  [<ffffffff802e8610>] elv_insert+0x153/0x221
Jul 18 11:58:37 c3m kernel:  [<ffffffff8832100c>] :xfs:xfs_iomap+0x2a3/0x33b
Jul 18 11:58:37 c3m kernel:  [<ffffffff88339ded>] :xfs:xfs_map_blocks+0x35/0x66
Jul 18 11:58:37 c3m kernel:  [<ffffffff8833a053>] :xfs:xfs_submit_ioend+0xb2/0xc4
Jul 18 11:58:37 c3m kernel:  [<ffffffff8833abee>] :xfs:xfs_page_state_convert+0x2b3/0x556
Jul 18 11:58:37 c3m kernel:  [<ffffffff8833afe3>] :xfs:xfs_vm_writepage+0xa7/0xe0
Jul 18 11:58:37 c3m kernel:  [<ffffffff802698e6>] __writepage+0xa/0x23
Jul 18 11:58:37 c3m kernel:  [<ffffffff80269d95>] write_cache_pages+0x184/0x2cd
Jul 18 11:58:37 c3m kernel:  [<ffffffff802698dc>] __writepage+0x0/0x23
Jul 18 11:58:37 c3m kernel:  [<ffffffff883ffd5e>] :nfsd:nfsd_acceptable+0x0/0xca
Jul 18 11:58:37 c3m kernel:  [<ffffffff80269f1a>] do_writepages+0x20/0x2d
Jul 18 11:58:37 c3m kernel:  [<ffffffff802657ea>] __filemap_fdatawrite_range+0x5b/0x6e
Jul 18 11:58:37 c3m kernel:  [<ffffffff802886ee>] __dentry_open+0x101/0x1aa
Jul 18 11:58:37 c3m kernel:  [<ffffffff88400c26>] :nfsd:nfsd_sync+0x5b/0xa5
Jul 18 11:58:37 c3m kernel:  [<ffffffff88401512>] :nfsd:nfsd_commit+0x57/0x7a
Jul 18 11:58:37 c3m kernel:  [<ffffffff88407f18>] :nfsd:nfsd3_proc_commit+0xc5/0xd2
Jul 18 11:58:37 c3m kernel:  [<ffffffff883fd248>] :nfsd:nfsd_dispatch+0xdd/0x19e
Jul 18 11:58:37 c3m kernel:  [<ffffffff883b025b>] :sunrpc:svc_process+0x3e1/0x726
Jul 18 11:58:37 c3m kernel:  [<ffffffff803fb8d6>] __down_read+0x12/0x9a
Jul 18 11:58:37 c3m kernel:  [<ffffffff883fd7fd>] :nfsd:nfsd+0x197/0x2b2
Jul 18 11:58:37 c3m kernel:  [<ffffffff8020aa48>] child_rip+0xa/0x12
Jul 18 11:58:37 c3m kernel:  [<ffffffff883fd666>] :nfsd:nfsd+0x0/0x2b2
Jul 18 11:58:37 c3m kernel:  [<ffffffff8020aa3e>] child_rip+0x0/0x12
Jul 18 11:58:37 c3m kernel:
Jul 18 11:58:37 c3m kernel: Filesystem "sdc1": XFS internal error xfs_trans_cancel at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff88321fd2
Jul 18 11:58:37 c3m kernel:
Jul 18 11:58:37 c3m kernel: Call Trace:
Jul 18 11:58:37 c3m kernel:  [<ffffffff8832ea5e>] :xfs:xfs_trans_cancel+0x5c/0xf2
Jul 18 11:58:37 c3m kernel:  [<ffffffff88321fd2>] :xfs:xfs_iomap_write_allocate+0x3a8/0x3ce
Jul 18 11:58:37 c3m kernel:  [<ffffffff802e8610>] elv_insert+0x153/0x221
Jul 18 11:58:37 c3m kernel:  [<ffffffff8832100c>] :xfs:xfs_iomap+0x2a3/0x33b
Jul 18 11:58:37 c3m kernel:  [<ffffffff88339ded>] :xfs:xfs_map_blocks+0x35/0x66
Jul 18 11:58:37 c3m kernel:  [<ffffffff8833a053>] :xfs:xfs_submit_ioend+0xb2/0xc4
Jul 18 11:58:37 c3m kernel:  [<ffffffff8833abee>] :xfs:xfs_page_state_convert+0x2b3/0x556
Jul 18 11:58:37 c3m kernel:  [<ffffffff8833afe3>] :xfs:xfs_vm_writepage+0xa7/0xe0
Jul 18 11:58:37 c3m kernel:  [<ffffffff802698e6>] __writepage+0xa/0x23
Jul 18 11:58:37 c3m kernel:  [<ffffffff80269d95>] write_cache_pages+0x184/0x2cd
Jul 18 11:58:37 c3m kernel:  [<ffffffff802698dc>] __writepage+0x0/0x23
Jul 18 11:58:37 c3m kernel:  [<ffffffff883ffd5e>] :nfsd:nfsd_acceptable+0x0/0xca
Jul 18 11:58:37 c3m kernel:  [<ffffffff80269f1a>] do_writepages+0x20/0x2d
Jul 18 11:58:37 c3m kernel:  [<ffffffff802657ea>] __filemap_fdatawrite_range+0x5b/0x6e
Jul 18 11:58:37 c3m kernel:  [<ffffffff802886ee>] __dentry_open+0x101/0x1aa
Jul 18 11:58:37 c3m kernel:  [<ffffffff88400c26>] :nfsd:nfsd_sync+0x5b/0xa5
Jul 18 11:58:37 c3m kernel:  [<ffffffff88401512>] :nfsd:nfsd_commit+0x57/0x7a
Jul 18 11:58:37 c3m kernel:  [<ffffffff88407f18>] :nfsd:nfsd3_proc_commit+0xc5/0xd2
Jul 18 11:58:37 c3m kernel:  [<ffffffff883fd248>] :nfsd:nfsd_dispatch+0xdd/0x19e
Jul 18 11:58:37 c3m kernel:  [<ffffffff883b025b>] :sunrpc:svc_process+0x3e1/0x726
Jul 18 11:58:37 c3m kernel:  [<ffffffff803fb8d6>] __down_read+0x12/0x9a
Jul 18 11:58:37 c3m kernel:  [<ffffffff883fd7fd>] :nfsd:nfsd+0x197/0x2b2
Jul 18 11:58:37 c3m kernel:  [<ffffffff8020aa48>] child_rip+0xa/0x12
Jul 18 11:58:37 c3m kernel:  [<ffffffff883fd666>] :nfsd:nfsd+0x0/0x2b2
Jul 18 11:58:37 c3m kernel:  [<ffffffff8020aa3e>] child_rip+0x0/0x12
Jul 18 11:58:37 c3m kernel:
Jul 18 11:58:37 c3m kernel: xfs_force_shutdown(sdc1,0x8) called from line 1133 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8832ea7c
Jul 18 11:58:37 c3m kernel: Filesystem "sdc1": Corruption of in-memory data detected.  Shutting down filesystem: sdc1
Jul 18 11:58:37 c3m kernel: Please umount the filesystem, and rectify the problem(s)
Jul 18 11:58:37 c3m kernel: nfsd: non-standard errno: -117



It was impossible for me to xfs_check (out of memory) or repair without rebooting.
After rebooting only "xfs_repair -L" worked and repaired the FS, but short time
later it failed again and it continues failing after each repair.

What's happening here?

Any help would be very appreciated!

Many thanks, Richard



# grep -i "xfs internal error" /var/log/messages | wc -l
182

# grep -i "xfs internal error" /var/log/messages
Jul 18 11:58:37 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_lblock at line 213 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff88306053
Jul 18 11:58:37 c3m kernel: Filesystem "sdc1": XFS internal error xfs_trans_cancel at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff88321fd2
Jul 18 12:39:51 c3m kernel: Filesystem "sdc1": XFS internal error xlog_recover_do_inode_trans(1) at line 2310 of file fs/xfs/xfs_log_recover.c.  Caller 0xffffffff8830be0e
Jul 18 12:41:32 c3m kernel: Filesystem "sdc1": XFS internal error xlog_recover_do_inode_trans(1) at line 2310 of file fs/xfs/xfs_log_recover.c.  Caller 0xffffffff8830be0e
Jul 18 12:44:15 c3m kernel: Filesystem "sdc1": XFS internal error xlog_recover_do_inode_trans(1) at line 2310 of file fs/xfs/xfs_log_recover.c.  Caller 0xffffffff8830be0e
Jul 18 12:57:35 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:35 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:36 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:36 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:36 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:36 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:37 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:37 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:37 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:37 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:37 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:37 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:38 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:38 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:38 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:38 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:39 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:39 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:39 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:39 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:40 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:40 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:40 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:40 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:40 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:40 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:42 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:42 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:42 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:43 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:43 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:45 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:46 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:47 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:47 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:48 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:49 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:50 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:50 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:51 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:51 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:51 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:51 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:51 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:51 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:51 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:51 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:52 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:52 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:52 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:52 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:52 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:52 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:53 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:53 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:53 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:54 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:54 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:54 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:54 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:54 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:54 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:54 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:54 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:57:54 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:57:54 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:15 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d7451
Jul 18 12:58:16 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:16 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:16 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 12:58:16 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:43 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:44 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:45 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:02:46 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882ff9bc
Jul 18 13:09:31 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:09:31 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:09:31 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:09:31 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:09:31 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:09:31 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:09:32 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:09:32 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:18:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 13:18:06 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff882fc9bc
Jul 18 16:21:48 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:48 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:49 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:50 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:51 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:51 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:51 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:52 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:52 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:52 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:52 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:52 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:53 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:53 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:53 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:53 c3m kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4522 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff883009bc
Jul 18 16:21:53 c3m kernel: Filesystem "sdc1": XFS internal error xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff882d8451
Jul 18 16:21:53 c3m kernel: Filesystem "sdc1": XFS internal error xfs_trans_cancel at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff88304f9e



-- 
Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. Dómine 1, 5º piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924

-- 
Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. Dómine 1, 5º piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
