Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 17:54:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m840sRhj026324
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 17:54:28 -0700
Message-ID: <48BF33EC.7080406@sgi.com>
Date: Thu, 04 Sep 2008 11:03:40 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Filesystem corruption writing out unlinked inodes
References: <48BCC5B1.7080300@sgi.com> <20080902051524.GC15962@disturbed> <48BCD622.1080406@sgi.com> <20080902062155.GE15962@disturbed>
In-Reply-To: <20080902062155.GE15962@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Sep 02, 2008 at 03:58:58PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Tue, Sep 02, 2008 at 02:48:49PM +1000, Lachlan McIlroy wrote:
>>> This is supposed to catch all the inodes in memory and mark them
>>> XFS_ISTALE to prevent them from being written back once the
>>> transaction is committed. The question is - how are dirty inodes
>>> slipping through this?
>>>
>>> If we are freeing the cluster buffer, then there can be no other
>>> active references to any of the inodes, so if they are dirty it
>>> has to be due to inactivation transactions and so should be in
>>> the log and attached to the buffer due to removal from the
>>> unlinked list.
>>>
>>> The question is - which bit of this is not working? i.e. what is the
>>> race condition that is allowing dirty inodes to slip through the
>>> locking here?
>>>
>>> Hmmm - I see that xfs_iflush() doesn't check for XFS_ISTALE when
>>> flushing out inodes. Perhaps you could check to see if we are
>>> writing an inode marked as such.....
>> That's what I was suggesting. 
> 
> I'm not suggesting that as a fix. I'm suggesting that you determine
> whether the inode being flushed has that flag set or not. If it is
> not set, then we need to determine how it slipped through
> xfs_ifree_cluster() without being marked XFS_ISTALE, and if it is
> set, why it was not marked clean by xfs_istale_done() when the
> buffer callbacks are made and the flush lock dropped....
> 
>> I'm just not sure about the assumption
>> that if the flush lock cannot be acquired in xfs_ifree_cluster() then
>> the inode must be in the process of being flushed. The flush could
>> be aborted due to the inode being pinned or some other case and the
>> inode never gets marked as stale.
> 
> Did that happen?
> 
> Basically I'm asking what the sequence of events is that leads up
> to this problem - we need to identify the actual race condition
> before speculating on potential fixes....
> 

In the trace below pid 7731 is unlinking an inode and it's not the last
inode so it doesn't go through xfs_ifree_cluster() and mark the other
inodes as stale.  At the same time pid 12269 unlinks the final inode in
the cluster and calls xfs_ifree_cluster() but fails to lock the inode
held by pid 7731 so it skips it.  Pid 12269 deallocates the inode cluster
and the disk space is reallocated as user data (the data "temp28/file00006"
is what the test writes into it's files).  Meanwhile pid 7731 finally
continues and tries to flush the inode.

Looks like xfs_ifree_cluster() should do a blocking wait on the ilock and
maybe move the setting of XFS_ISTALE outside the flock.

<1>00000000: 74 65 6d 70 32 38 2f 66 69 6c 65 30 30 30 30 36  temp28/file00006
<1>Filesystem "dm-0": XFS internal error xfs_imap_to_bp at line 187 of file fs/xfs/xfs_inode.c.  Caller 0xffffffff8038e599
<4>Pid: 7723, comm: bulkstat_unlink Not tainted 2.6.26 #128
<4>
<4>Call Trace:
<4> [<ffffffff8038e599>] xfs_itobp+0xee/0x177
<4> [<ffffffff8038e3fa>] xfs_imap_to_bp+0x15d/0x20e
<4> [<ffffffff8038e599>] xfs_itobp+0xee/0x177
<4> [<ffffffff803bbef3>] _xfs_itrace_entry+0xa9/0xae
<4> [<ffffffff8038e599>] xfs_itobp+0xee/0x177
<4> [<ffffffff80391307>] xfs_iflush+0x25/0x3f2
<4> [<ffffffff8039157b>] xfs_iflush+0x299/0x3f2
<4> [<ffffffff803a9ff6>] xfs_finish_reclaim+0x43/0x1a9
<4> [<ffffffff803aa0f6>] xfs_finish_reclaim+0x143/0x1a9
<4> [<ffffffff803a834a>] xfs_sync_inodes+0x23a/0x929
<4> [<ffffffff803a8a95>] xfs_syncsub+0x5c/0x23b
<4> [<ffffffff803b9ee7>] xfs_fs_sync_super+0x33/0xdd
<4> [<ffffffff80656e1a>] _spin_unlock_irq+0x1f/0x22
<4> [<ffffffff806568b3>] __down_read+0x34/0x9e
<4> [<ffffffff8028573c>] sync_filesystems+0xb6/0x108
<4> [<ffffffff802a2aeb>] do_sync+0x25/0x50
<4> [<ffffffff802a2b24>] sys_sync+0xe/0x16
<4> [<ffffffff8020affb>] system_call_after_swapgs+0x7b/0x80
[5]more> 
<4>
<7>xfs_imap_to_bp: ip 0xffff811006853670, bp 0xffff810ff4ffc008
<0>Device dm-0 - bad inode magic/vsn daddr 645205376 #0 (magic=7465)
<0>------------[ cut here ]------------
<2>kernel BUG at fs/xfs/support/debug.c:54!
[5]kdb> 
[5]kdb> xnode 0xffff811006853670
mount 0xffff81102322e188 mnext 0xffff811025f01570 mprev 0xffff810ff788d360 vnode 0x0000000000000000 
dev fe00000 ino 1610663688[c:c70:8]
blkno 0x26750d80 len 0x10 boffset 0x800
transp 0x0000000000000000 &itemp 0xffff810ffc954be0
&lock 0xffff811006853720 &iolock 0xffff811006853788 &flush 0xffff8110068537f0 (0) pincount 0x0
udquotp 0x0000000000000000 gdquotp 0x0000000000000000
new_size 0
flags 0x28 <reclaim modified > 
update_core 0 update size 0
gen 0x0 delayed blks 0size 0
 trace 0xffff810fea462590
 bmap_trace 0xffff810fea462560
 bmbt trace 0xffff810fea462800
 rw trace 0xffff810fea462230
 ilock trace 0xffff810fea462200
 dir trace 0xffff810fea4621d0

data fork
 bytes 0x0 real_bytes 0x0 lastex 0x0 u1:extents 0x0000000000000000
 broot 0x0000000000000000 broot_bytes 0x0 ext_max 9 flags 0x2 <extents > 
 u2 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
attr fork empty
[5]more> 

magic 0x494e mode 00 (?------------) version 0x2 format 0x2 (extents)
nlink 0 uid 0 gid 0 projid 0 flushiter 0
atime 1220486941:196143812 mtime 1220486941d:196143812 ctime 1220486941:196143812
size 0 nblocks 0 extsize 0x0 nextents 0x0 anextents 0x0
forkoff 0 aformat 0x2 (extents) dmevmask 0x0 dmstate 0x0 flags 0x0 <> gen 0xd251038e
--> itrace @ 0xffff811006853670/0xffff810fea462590
entry to xfs_iput i_count = 3
  cpu = 6 pid = 7722   ra = xfs_trans_unlock_chunk+0x77
entry to xfs_iunlock i_count = 3
  cpu = 6 pid = 7722   ra = xfs_iput+0x29
rele @fs/xfs/xfs_iget.c:406(xfs_iput+0x42) i_count 3 => 2 
  cpu = 6 pid = 7722   ra = xfs_trans_unlock_chunk+0x77
exit from xfs_remove i_count = 2
  cpu = 6 pid = 7722   ra = xfs_vn_unlink+0x37
entry to xfs_ilock i_count = 1
  cpu = 1 pid = 7731   ra = xfs_iomap+0x14a
entry to xfs_iunlock i_count = 1
  cpu = 1 pid = 7731   ra = xfs_iomap+0x2eb
entry to xfs_ilock i_count = 1
  cpu = 1 pid = 7731   ra = xfs_iomap_write_allocate+0x179
entry to xfs_iunlock i_count = 1
  cpu = 1 pid = 7731   ra = xfs_iomap_write_allocate+0x302
entry to xfs_fs_write_inode i_count = 1
  cpu = 1 pid = 7731   ra = __writeback_single_inode+0x18b
entry to xfs_ilock_nowait i_count = 1
  cpu = 1 pid = 7731   ra = xfs_inode_flush+0x9b
exit from success i_count = 1
  cpu = 1 pid = 7731   ra = xfs_inode_flush+0x9b
entry to xfs_iunlock i_count = 1
  cpu = 1 pid = 7731   ra = xfs_inode_flush+0x132
entry to xfs_ilock i_count = 0
  cpu = 3 pid = 381   ra = xfs_setfilesize+0x7c
entry to xfs_iunlock i_count = 0
  cpu = 3 pid = 381   ra = xfs_end_bio_delalloc+0x10
entry to xfs_fs_clear_inode i_count = 0
  cpu = 1 pid = 7731   ra = clear_inode+0x9c
entry to xfs_inactive i_count = 0
  cpu = 1 pid = 7731   ra = xfs_fs_clear_inode+0xbd
entry to xfs_ilock i_count = 0
  cpu = 1 pid = 7731   ra = xfs_inactive+0x1c2
entry to xfs_ilock i_count = 0
  cpu = 1 pid = 7731   ra = xfs_inactive+0x23d
entry to xfs_ifree i_count = 0
  cpu = 1 pid = 7731   ra = xfs_inactive+0x3f8
entry to xfs_itobp i_count = 0
  cpu = 1 pid = 7731   ra = xfs_iunlink_remove+0x251
entry to xfs_itobp i_count = 0
  cpu = 1 pid = 7731   ra = xfs_ifree+0x1ce
entry to xfs_ilock_nowait i_count = 0
  cpu = 3 pid = 12269   ra = xfs_ifree_cluster+0x2ee
exit from fail i_count = 0
  cpu = 3 pid = 12269   ra = xfs_ifree_cluster+0x2ee
entry to xfs_iunlock i_count = 0
  cpu = 1 pid = 7731   ra = xfs_inactive+0x4ea
entry to xfs_reclaim i_count = 0
  cpu = 1 pid = 7731   ra = xfs_fs_clear_inode+0xde
entry to xfs_ilock_nowait i_count = -1
  cpu = 6 pid = 7723   ra = xfs_sync_inodes+0x161
exit from success i_count = 18446744073709551615
  cpu = 6 pid = 7723   ra = xfs_sync_inodes+0x161
entry to xfs_iflock_nowait i_count = -1
  cpu = 6 pid = 7723   ra = xfs_syncsub+0x5c
exit from success i_count = 18446744073709551615
  cpu = 6 pid = 7723   ra = xfs_syncsub+0x5c
entry to xfs_finish_reclaim i_count = -1
  cpu = 6 pid = 7723   ra = xfs_sync_inodes+0x23a
entry to xfs_iflush i_count = -1
  cpu = 6 pid = 7723   ra = xfs_finish_reclaim+0x143
entry to xfs_itobp i_count = -1
  cpu = 6 pid = 7723   ra = xfs_iflush+0x299
