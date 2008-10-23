Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 01:07:27 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N87KpR023819
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 01:07:20 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id 3E38E908C2
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 01:09:01 -0700 (PDT)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA20721 for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 19:09:00 +1100
Message-ID: <49003EFF.4090404@sgi.com>
Date: Thu, 23 Oct 2008 19:08:15 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: assertion failure with latest xfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Just encountered this after pulling in the latest changes.  We are trying to
initialise an inode that should have an i_count of 1 but instead it is 2.  I
was running XFSQA test 167 when it happened.

Stack traceback for pid 25318
0xffff88004201ddc0    25318    25228  1    3   R  0xffff88004201e228 *fsstress
sp                ip                Function (args)
0xffff88000f409ab8 0xffffffff811c9265 assfail+0x1a (invalid, invalid, invalid)
0xffff88000f409af0 0xffffffff811c3cd5 xfs_setup_inode+0x56 (0xffff88006e1fbc00)
0xffff88000f409b20 0xffffffff8119d7a7 xfs_ialloc+0x53a (0xffff88006c8fd880, 0xffff880069990780, invalid, invalid, 0x100000000, invalid, 0xffff880000000000, 0x1, 0xffff88000f409c28)
0xffff88000f409bb0 0xffffffff811b4952 xfs_dir_ialloc+0xa0 (0xffff88000f409d00, 0xffff880069990780, invalid, invalid, 0x100000000, 0x0, 0xffff880000000000, 0xffff880000000001, 0xffff88000f409d08)
0xffff88000f409c70 0xffffffff811b8a87 xfs_create+0x325 (0xffff880069990780, 0xffff88000f409d68, invalid, invalid, 0xffff88000f409d80, 0x0)
0xffff88000f409d50 0xffffffff811c36eb xfs_vn_mknod+0x14f (0xffff880069990a20, 0xffff88007f564000, invalid, invalid)
0xffff88000f409dc0 0xffffffff811c37db xfs_vn_create+0xb
0xffff88000f409dd0 0xffffffff810b27fe vfs_create+0xdf (0xffff880069990a20, 0xffff88007f564000, invalid, 0xffff88000f409e48)
0xffff88000f409e10 0xffffffff810b4a21 do_filp_open+0x214 (invalid, 0xffff880076003180, invalid, invalid)
0xffff88000f409f30 0xffffffff810a7e9a do_sys_open+0x53 (invalid, invalid, invalid, invalid)
0xffff88000f409f70 0xffffffff810a7f43 sys_open+0x1b (invalid, invalid, invalid)
   not matched: from 0xffffffff8100bfb2 to 0xffffffff8100c02a drop_through 0 bb_jmp[7]
bb_special_case: Invalid bb_reg_state.memory, missing trailing entries
bb_special_case: on transfer to int_with_check
   system_call_fastpath has memory parameters but no register parameters.
   Assuming it is a 'pass through' function that does not refer to its register
   parameters and setting 6 register parameters
kdb_bb: 0xffffffff8100bf3b [kernel]system_call_fastpath failed at 0xffffffff8100bfcd

Using old style backtrace, unreliable with no arguments
sp                ip                Function (args)
0xffff88000f409a70 0xffffffff8104bffe up+0xf
[3]more>
0xffff88000f409ab8 0xffffffff811c9265 assfail+0x1a
0xffff88000f409ae0 0xffffffff811c9265 assfail+0x1a
0xffff88000f409af0 0xffffffff811c3cd5 xfs_setup_inode+0x56
0xffff88000f409b20 0xffffffff8119d7a7 xfs_ialloc+0x53a
0xffff88000f409bb0 0xffffffff811b4952 xfs_dir_ialloc+0xa0
0xffff88000f409c70 0xffffffff811b8a87 xfs_create+0x325
0xffff88000f409d50 0xffffffff811c36eb xfs_vn_mknod+0x14f
0xffff88000f409dc0 0xffffffff811c37db xfs_vn_create+0xb
0xffff88000f409dd0 0xffffffff810b27fe vfs_create+0xdf
0xffff88000f409e10 0xffffffff810b4a21 do_filp_open+0x214
0xffff88000f409e40 0xffffffff810a3581 init_object+0x6e
0xffff88000f409ed0 0xffffffff8155fb01 _spin_unlock+0x26
0xffff88000f409f30 0xffffffff810a7e9a do_sys_open+0x53
0xffff88000f409f38 0xffffffff811f2fc9 selinux_file_free_security+0x1e
0xffff88000f409f70 0xffffffff810a7f43 sys_open+0x1b
[3]kdb>
[3]kdb> dmesg 20
<4>[ 4349.936786] XFS: correcting sb_features alignment problem
<5>[ 4349.947784] XFS mounting filesystem sda4
<7>[ 4350.022280] Ending clean XFS mount for filesystem: sda4
<5>[ 4351.670370] XFS mounting filesystem sda3
<7>[ 4351.795964] Ending clean XFS mount for filesystem: sda3
<5>[ 4353.889829] XFS mounting filesystem sda3
<7>[ 4354.016496] Ending clean XFS mount for filesystem: sda3
<5>[ 4356.163284] XFS mounting filesystem sda3
<7>[ 4356.283840] Ending clean XFS mount for filesystem: sda3
<4>[ 4357.884887] XFS: correcting sb_features alignment problem
<5>[ 4357.895876] XFS mounting filesystem sda4
<7>[ 4357.970481] Ending clean XFS mount for filesystem: sda4
<5>[ 4359.714421] XFS mounting filesystem sda3
<7>[ 4359.835486] Ending clean XFS mount for filesystem: sda3
<4>[ 4361.442033] XFS: correcting sb_features alignment problem
<5>[ 4361.453021] XFS mounting filesystem sda4
<7>[ 4361.527472] Ending clean XFS mount for filesystem: sda4
<4>[ 4460.233979] Assertion failed: atomic_read(&inode->i_count) == 1, file: fs/xfs/linux-2.6/xfs_iops.c, line: 783
<0>[ 4460.253826] ------------[ cut here ]------------
<2>[ 4460.254764] kernel BUG at fs/xfs/support/debug.c:81!
[3]kdb>
[3]kdb> xnode 0xffff88006e1fbc00
mount 0xffff88007748f3f0 vnode 0xffff88006e1fbea0
dev 800004 ino 134342909[2:1e8f:d]
blkno 0x399cb80 len 0x10 boffset 0x1d00
transp 0xffff88006c8fd880 &itemp 0xffff88002f4ee690
&lock 0xffff88006e1fbc88 &iolock 0xffff88006e1fbcf0 &flush 0xffff88006e1fbd58 (1) pincount 0x0
udquotp 0x0000000000000000 gdquotp 0x0000000000000000
new_size 0
flags 0x140 <truncated >
update_core 0 update size 0
gen 0x0 delayed blks 0size 0
  trace 0xffff88007449a000
  bmap_trace 0xffff88007449a060
  bmbt trace 0xffff88007449a0c0
  rw trace 0xffff88007449a120
  ilock trace 0xffff88007449a180
  dir trace 0xffff88007449a1e0

data fork
  bytes 0x0 real_bytes 0x0 lastex 0x0 u1:extents 0x0000000000000000
  broot 0x0000000000000000 broot_bytes 0x0 ext_max 9 flags 0x2 <extents >
  u2 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
attr fork empty
[3]more>

magic 0x494e mode 0100666 (r---rw-rw-rw-) version 0x2 format 0x2 (extents)
nlink 1 uid 0 gid 0 projid 0 flushiter 0
atime 1224743591:233524184 mtime 1224743591d:233524184 ctime 1224743591:233524184
size 0 nblocks 0 extsize 0x0 nextents 0x0 anextents 0x0
forkoff 0 aformat 0x2 (extents) dmevmask 0x0 dmstate 0x0 flags 0x0 <> gen 0x47f454b
--> itrace @ 0xffff88006e1fbc00/0xffff88007449a000
exit from xfs_iget.alloc i_count = 1
   cpu = 3 pid = 25318   ra = xfs_trans_iget+0x205
[3]kdb>
[3]kdb> inode 0xffff88006e1fbea0
struct inode at  0xffff88006e1fbea0
  i_ino = 134342909 i_count = 2 i_size 0
  i_mode = 00  i_nlink = 1  i_rdev = 0x0
  i_hash.nxt = 0x0000000000000000 i_hash.pprev = 0xffffc200002f9328
  i_list.nxt = 0xffff880069990a20 i_list.prv = 0xffffffff817c3810
  i_dentry.nxt = 0xffff88006e1fbe38 i_dentry.prv = 0xffff88006e1fbe38
  i_sb = 0xffff88007748b1b0 i_op = 0xffffffff81eeab80 i_data = 0xffff88006e1fc088 nrpages = 0
  i_fop= 0xffffffff81eeaaa0 i_flock = 0x0000000000000000 i_mapping = 0xffff88006e1fc088
  i_flags 0x0 i_state 0x88 [I_NEW I_LOCK]  fs specific info @ 0xffff88006e1fc288
