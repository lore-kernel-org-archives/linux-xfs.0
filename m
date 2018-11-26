Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbeK0C1T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Nov 2018 21:27:19 -0500
Date: Mon, 26 Nov 2018 10:32:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20181126153249.GC14585@bfoster>
References: <1543238989.2507.33.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1543238989.2507.33.camel@pengutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <l.stach@pengutronix.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 26, 2018 at 02:29:49PM +0100, Lucas Stach wrote:
> Hi all,
> 
> we have a XFS filesystem which is used to backup data from others
> servers via rsync. While rsync is running the filesystem is regularly
> shutting itself down. Sometimes the FS will last for 3 days until the
> shutdown happens, sometimes it's after only 3 hours.
> 
> The issue was spotted on a 4.17 kernel, but I'm not sure that's the
> first version with this issue, as that was the kernel version used when
> setting up the backup system. We also checked that the issue is still
> present in a 4.19.4 vanilla kernel, backtrace from this kernel version
> is provided below.
> 
> The block stack below the XFS is a LVM on a software RAID10.
> 
> I can provide more information as needed, but I'm not sure at this
> point which information would be appropriate to further debug this
> issue. Any pointers appreciated.
> 
> Please keep me in CC, as I'm not subscribed to the XFS list.
> 
> Regards,
> Lucas
> 
> 
> 
> [50013.593883] XFS (dm-2): Internal error xfs_btree_check_sblock at line 179 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_lastrec+0x41/0x90 [xfs]
> [50013.594365] CPU: 4 PID: 31839 Comm: rsync Not tainted 4.19.4-holodeck10 #1
> [50013.594365] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 2.6.0 10/26/2017
> [50013.594366] Call Trace:
> [50013.594372]  dump_stack+0x5c/0x7b
> [50013.594391]  xfs_btree_check_sblock+0x5a/0xb0 [xfs]
> [50013.594409]  xfs_btree_lastrec+0x41/0x90 [xfs]
> [50013.594427]  xfs_btree_delrec+0xa48/0xdf0 [xfs]
> [50013.594446]  ? xfs_inobt_get_maxrecs+0x20/0x20 [xfs]
> [50013.594463]  ? xfs_lookup_get_search_key+0x49/0x60 [xfs]
> [50013.594480]  xfs_btree_delete+0x43/0x110 [xfs]
> [50013.594500]  xfs_dialloc_ag+0x16a/0x290 [xfs]
> [50013.594540]  xfs_dialloc+0x5b/0x270 [xfs]
> [50013.594562]  xfs_ialloc+0x6c/0x5b0 [xfs]
> [50013.594583]  xfs_dir_ialloc+0x68/0x1d0 [xfs]
> [50013.594615]  xfs_create+0x3df/0x5e0 [xfs]
> [50013.594633]  xfs_generic_create+0x241/0x2e0 [xfs]
> [50013.594636]  vfs_mkdir+0x10c/0x1a0
> [50013.594638]  do_mkdirat+0xd3/0x110
> [50013.594641]  do_syscall_64+0x55/0xf0
> [50013.594644]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [50013.594645] RIP: 0033:0x7fda0e896447
> [50013.594647] Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 49 da 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 da 2b 00 f7 d8 64 89 01 48
> [50013.594647] RSP: 002b:00007ffdedc1a118 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
> [50013.594649] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fda0e896447
> [50013.594649] RDX: 0000000000000008 RSI: 00000000000001c0 RDI: 00007ffdedc1c470
> [50013.594650] RBP: 0000560fd94b5c70 R08: 0000000000000080 R09: 00000000ffffffff
> [50013.594661] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [50013.594662] R13: 0000000000000000 R14: 00007ffdedc1c470 R15: 00000000ffffffff

This looks like a free inode btree corruption of some sort. The error
report doesn't tell us exactly what's wrong with the btree block, but we
can surmise finobt from the record deletion call via the inode
allocation path.

Can you provide xfs_info for the fs and details of your storage, CPU and
RAM configuration? Also, what typically happens after this crash? Can
the filesystem mount again or does log recovery fail and require a
repair? If the filesystem mounts, have you tried running a
non-destructive 'xfs_repair -n <dev>' after log recovery to check for
any latent problems? Would you be able to provide an xfs_metadump image
of this filesystem for closer inspection?

Can you characterize the rsync workload in any more detail? For example,
are files added/removed across runs (perhaps whatever rsync flags are
used would help)? Are files of consistent or varying size/content? Are
many rsync processes running in parallel? Generally, anything you can
describe that might help recreate this problem with a simulated workload
is potentially useful.

Brian

> [50013.594681] XFS (dm-2): Internal error XFS_WANT_CORRUPTED_GOTO at line 3889 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_delete+0x43/0x110 [xfs]
> [50013.595138] CPU: 4 PID: 31839 Comm: rsync Not tainted 4.19.4-holodeck10 #1
> [50013.595138] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 2.6.0 10/26/2017
> [50013.595138] Call Trace:
> [50013.595141]  dump_stack+0x5c/0x7b
> [50013.595157]  xfs_btree_delrec+0xc1c/0xdf0 [xfs]
> [50013.595174]  ? xfs_inobt_get_maxrecs+0x20/0x20 [xfs]
> [50013.595188]  ? xfs_lookup_get_search_key+0x49/0x60 [xfs]
> [50013.595203]  xfs_btree_delete+0x43/0x110 [xfs]
> [50013.595220]  xfs_dialloc_ag+0x16a/0x290 [xfs]
> [50013.595236]  xfs_dialloc+0x5b/0x270 [xfs]
> [50013.595255]  xfs_ialloc+0x6c/0x5b0 [xfs]
> [50013.595274]  xfs_dir_ialloc+0x68/0x1d0 [xfs]
> [50013.595291]  xfs_create+0x3df/0x5e0 [xfs]
> [50013.595309]  xfs_generic_create+0x241/0x2e0 [xfs]
> [50013.595311]  vfs_mkdir+0x10c/0x1a0
> [50013.595313]  do_mkdirat+0xd3/0x110
> [50013.595314]  do_syscall_64+0x55/0xf0
> [50013.595316]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [50013.595317] RIP: 0033:0x7fda0e896447
> [50013.595318] Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 49 da 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 da 2b 00 f7 d8 64 89 01 48
> [50013.595319] RSP: 002b:00007ffdedc1a118 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
> [50013.595320] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fda0e896447
> [50013.595320] RDX: 0000000000000008 RSI: 00000000000001c0 RDI: 00007ffdedc1c470
> [50013.595321] RBP: 0000560fd94b5c70 R08: 0000000000000080 R09: 00000000ffffffff
> [50013.595322] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [50013.595322] R13: 0000000000000000 R14: 00007ffdedc1c470 R15: 00000000ffffffff
> [50013.595365] XFS (dm-2): Internal error xfs_trans_cancel at line 1041 of file fs/xfs/xfs_trans.c.  Caller xfs_create+0x3f1/0x5e0 [xfs]
> [50013.595750] CPU: 4 PID: 31839 Comm: rsync Not tainted 4.19.4-holodeck10 #1
> [50013.595751] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 2.6.0 10/26/2017
> [50013.595751] Call Trace:
> [50013.595753]  dump_stack+0x5c/0x7b
> [50013.595774]  xfs_trans_cancel+0x133/0x160 [xfs]
> [50013.595793]  xfs_create+0x3f1/0x5e0 [xfs]
> [50013.595812]  xfs_generic_create+0x241/0x2e0 [xfs]
> [50013.595814]  vfs_mkdir+0x10c/0x1a0
> [50013.595815]  do_mkdirat+0xd3/0x110
> [50013.595817]  do_syscall_64+0x55/0xf0
> [50013.595819]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [50013.595820] RIP: 0033:0x7fda0e896447
> [50013.595820] Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 49 da 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 da 2b 00 f7 d8 64 89 01 48
> [50013.595821] RSP: 002b:00007ffdedc1a118 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
> [50013.595822] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fda0e896447
> [50013.595823] RDX: 0000000000000008 RSI: 00000000000001c0 RDI: 00007ffdedc1c470
> [50013.595824] RBP: 0000560fd94b5c70 R08: 0000000000000080 R09: 00000000ffffffff
> [50013.595824] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [50013.595825] R13: 0000000000000000 R14: 00007ffdedc1c470 R15: 00000000ffffffff
> [50013.595827] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1042 of file fs/xfs/xfs_trans.c.  Return address = 00000000fd4adc21
> [50013.667040] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
> [50013.667303] XFS (dm-2): Please umount the filesystem and rectify the problem(s)
> [50013.671838] XFS (dm-2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [50013.671842] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 3403 of file fs/xfs/xfs_inode.c.  Return address = 0000000062cd5dba
