Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o48CWtW7192226 for <xfs@oss.sgi.com>; Sat, 8 May 2010 07:32:56 -0500
Received: from smtp.stepping-stone.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02E5631DA24
	for <xfs@oss.sgi.com>; Sat,  8 May 2010 05:35:00 -0700 (PDT)
Received: from smtp.stepping-stone.ch (smtp.stepping-stone.ch
	[194.176.109.228]) by cuda.sgi.com with ESMTP id
	ISrQPXlexF69bwhM for <xfs@oss.sgi.com>;
	Sat, 08 May 2010 05:35:00 -0700 (PDT)
Message-ID: <4BE55A63.8070203@purplehaze.ch>
Date: Sat, 08 May 2010 14:34:43 +0200
From: Christian Affolter <christian.affolter@purplehaze.ch>
MIME-Version: 1.0
Subject: failed to read root inode
Content-Type: multipart/mixed; boundary="------------040805010700020206070201"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------040805010700020206070201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi

After a disk crash within a hardware RAID-6 controller and kernel
freeze, I'm unable to mount an XFS filesystem on top of an EVMS volume:

Filesystem "dm-13": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem dm-13
Starting XFS recovery on filesystem: dm-13 (logdev: internal)
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1599 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff8035c58d
Pid: 13473, comm: mount Not tainted 2.6.26-gentoo #1

Call Trace:
 [<ffffffff8035c58d>] xfs_free_extent+0xcd/0x110
 [<ffffffff8035aa03>] xfs_free_ag_extent+0x4e3/0x740
 [<ffffffff8035c58d>] xfs_free_extent+0xcd/0x110
 [<ffffffff80395e9d>] xlog_recover_process_efi+0x18d/0x1d0
 [<ffffffff80397400>] xlog_recover_process_efis+0x60/0xa0
 [<ffffffff80397463>] xlog_recover_finish+0x23/0xf0
 [<ffffffff8039d36a>] xfs_mountfs+0x4da/0x680
 [<ffffffff803a9ba8>] kmem_alloc+0x58/0x100
 [<ffffffff803a9cfb>] kmem_zalloc+0x2b/0x40
 [<ffffffff803a3dbd>] xfs_mount+0x36d/0x3a0
 [<ffffffff803b4bad>] xfs_fs_fill_super+0xbd/0x220
 [<ffffffff8028b551>] get_sb_bdev+0x141/0x180
 [<ffffffff803b4af0>] xfs_fs_fill_super+0x0/0x220
 [<ffffffff8028aeb6>] vfs_kern_mount+0x56/0xc0
 [<ffffffff8028af83>] do_kern_mount+0x53/0x110
 [<ffffffff802a343b>] do_new_mount+0x9b/0xe0
 [<ffffffff802a3666>] do_mount+0x1e6/0x220
 [<ffffffff802670f5>] __get_free_pages+0x15/0x60
 [<ffffffff802a373b>] sys_mount+0x9b/0x100
 [<ffffffff8020b49b>] system_call_after_swapgs+0x7b/0x80

Filesystem "dm-13": XFS internal error xfs_trans_cancel at line 1163 of
file fs/xfs/xfs_trans.c.  Caller 0xffffffff80395eb1
Pid: 13473, comm: mount Not tainted 2.6.26-gentoo #1

Call Trace:
 [<ffffffff80395eb1>] xlog_recover_process_efi+0x1a1/0x1d0
 [<ffffffff8039fd16>] xfs_trans_cancel+0x126/0x150
 [<ffffffff80395eb1>] xlog_recover_process_efi+0x1a1/0x1d0
 [<ffffffff80397400>] xlog_recover_process_efis+0x60/0xa0
 [<ffffffff80397463>] xlog_recover_finish+0x23/0xf0
 [<ffffffff8039d36a>] xfs_mountfs+0x4da/0x680
 [<ffffffff803a9ba8>] kmem_alloc+0x58/0x100
 [<ffffffff803a9cfb>] kmem_zalloc+0x2b/0x40
 [<ffffffff803a3dbd>] xfs_mount+0x36d/0x3a0
 [<ffffffff803b4bad>] xfs_fs_fill_super+0xbd/0x220
 [<ffffffff8028b551>] get_sb_bdev+0x141/0x180
 [<ffffffff803b4af0>] xfs_fs_fill_super+0x0/0x220
 [<ffffffff8028aeb6>] vfs_kern_mount+0x56/0xc0
 [<ffffffff8028af83>] do_kern_mount+0x53/0x110
 [<ffffffff802a343b>] do_new_mount+0x9b/0xe0
 [<ffffffff802a3666>] do_mount+0x1e6/0x220
 [<ffffffff802670f5>] __get_free_pages+0x15/0x60
 [<ffffffff802a373b>] sys_mount+0x9b/0x100
 [<ffffffff8020b49b>] system_call_after_swapgs+0x7b/0x80

xfs_force_shutdown(dm-13,0x8) called from line 1164 of file
fs/xfs/xfs_trans.c.  Return address = 0xffffffff8039fd2f
Filesystem "dm-13": Corruption of in-memory data detected.  Shutting
down filesystem: dm-13
Please umount the filesystem, and rectify the problem(s)
Failed to recover EFIs on filesystem: dm-13
XFS: log mount finish failed


I tried to repair the filesystem with the help of xfs_repair many times,
without any luck:
Filesystem "dm-13": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem dm-13
XFS: failed to read root inode

xfs_check output:
cache_node_purge: refcount was 1, not zero (node=0x820010)
xfs_check: cannot read root inode (117)
cache_node_purge: refcount was 1, not zero (node=0x8226b0)
xfs_check: cannot read realtime bitmap inode (117)
block 0/8 expected type unknown got log
block 0/9 expected type unknown got log
block 0/10 expected type unknown got log
block 0/11 expected type unknown got log
bad magic number 0xfeed for inode 128
[...]

Are there any other ways to fix the unreadable root inode or to restore
the remaining data?


Environment informations:
Linux Kernel: 2.6.26-gentoo (x86_64)
xfsprogs:     3.0.3

Attached you'll find the xfs_repair and xfs_check output.


Thanks in advance and kind regards
Christian

--------------040805010700020206070201
Content-Type: text/plain;
 name="xfs_repair.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfs_repair.log"

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad magic number 0x0 on inode 128
bad version number 0x0 on inode 128
bad magic number 0x0 on inode 129
bad version number 0x0 on inode 129
bad magic number 0x0 on inode 130
bad version number 0x0 on inode 130
bad magic number 0x0 on inode 131
bad version number 0x0 on inode 131
bad magic number 0x0 on inode 132
bad version number 0x0 on inode 132
bad magic number 0x0 on inode 133
bad version number 0x0 on inode 133
bad magic number 0x0 on inode 134
bad version number 0x0 on inode 134
bad magic number 0x0 on inode 135
bad version number 0x0 on inode 135
bad magic number 0x0 on inode 136
bad version number 0x0 on inode 136
bad magic number 0x0 on inode 137
bad version number 0x0 on inode 137
bad magic number 0x0 on inode 138
bad version number 0x0 on inode 138
bad magic number 0x0 on inode 139
bad version number 0x0 on inode 139
bad magic number 0x0 on inode 140
bad version number 0x0 on inode 140
bad magic number 0x0 on inode 141
bad version number 0x0 on inode 141
bad magic number 0x0 on inode 142
bad version number 0x0 on inode 142
bad magic number 0x0 on inode 143
bad version number 0x0 on inode 143
bad magic number 0x0 on inode 144
bad version number 0x0 on inode 144
bad magic number 0x0 on inode 145
bad version number 0x0 on inode 145
bad magic number 0x0 on inode 146
bad version number 0x0 on inode 146
bad magic number 0x0 on inode 147
bad version number 0x0 on inode 147
bad magic number 0x0 on inode 148
bad version number 0x0 on inode 148
bad magic number 0x0 on inode 149
bad version number 0x0 on inode 149
bad magic number 0x0 on inode 150
bad version number 0x0 on inode 150
bad magic number 0x0 on inode 151
bad version number 0x0 on inode 151
bad magic number 0x0 on inode 152
bad version number 0x0 on inode 152
bad magic number 0x0 on inode 153
bad version number 0x0 on inode 153
bad magic number 0x0 on inode 154
bad version number 0x0 on inode 154
bad magic number 0x0 on inode 155
bad version number 0x0 on inode 155
bad magic number 0x0 on inode 156
bad version number 0x0 on inode 156
bad magic number 0x0 on inode 157
bad version number 0x0 on inode 157
bad magic number 0x0 on inode 158
bad version number 0x0 on inode 158
bad magic number 0x0 on inode 159
bad version number 0x0 on inode 159
bad magic number 0x0 on inode 160
bad version number 0x0 on inode 160
bad magic number 0x0 on inode 161
bad version number 0x0 on inode 161
bad magic number 0x0 on inode 162
bad version number 0x0 on inode 162
bad magic number 0x0 on inode 163
bad version number 0x0 on inode 163
bad magic number 0x0 on inode 164
bad version number 0x0 on inode 164
bad magic number 0x0 on inode 165
bad version number 0x0 on inode 165
bad magic number 0x0 on inode 166
bad version number 0x0 on inode 166
bad magic number 0x0 on inode 167
bad version number 0x0 on inode 167
bad magic number 0x0 on inode 168
bad version number 0x0 on inode 168
bad magic number 0x0 on inode 169
bad version number 0x0 on inode 169
bad magic number 0x0 on inode 170
bad version number 0x0 on inode 170
bad magic number 0x0 on inode 171
bad version number 0x0 on inode 171
bad magic number 0x0 on inode 172
bad version number 0x0 on inode 172
bad magic number 0x0 on inode 173
bad version number 0x0 on inode 173
bad magic number 0x0 on inode 174
bad version number 0x0 on inode 174
bad magic number 0x0 on inode 175
bad version number 0x0 on inode 175
bad magic number 0x0 on inode 176
bad version number 0x0 on inode 176
bad magic number 0x0 on inode 177
bad version number 0x0 on inode 177
bad magic number 0x0 on inode 178
bad version number 0x0 on inode 178
bad magic number 0x0 on inode 179
bad version number 0x0 on inode 179
bad magic number 0x0 on inode 180
bad version number 0x0 on inode 180
bad magic number 0x0 on inode 181
bad version number 0x0 on inode 181
bad magic number 0x0 on inode 182
bad version number 0x0 on inode 182
bad magic number 0x0 on inode 183
bad version number 0x0 on inode 183
bad magic number 0x0 on inode 184
bad version number 0x0 on inode 184
bad magic number 0x0 on inode 185
bad version number 0x0 on inode 185
bad magic number 0x0 on inode 186
bad version number 0x0 on inode 186
bad magic number 0x0 on inode 187
bad version number 0x0 on inode 187
bad magic number 0x0 on inode 188
bad version number 0x0 on inode 188
bad magic number 0x0 on inode 189
bad version number 0x0 on inode 189
bad magic number 0x0 on inode 190
bad version number 0x0 on inode 190
bad magic number 0x0 on inode 191
bad version number 0x0 on inode 191
bad magic number 0x0 on inode 128, resetting magic number
bad version number 0x0 on inode 128, resetting version number
imap claims a free inode 128 is in use, correcting imap and clearing inode
cleared root inode 128
bad magic number 0x0 on inode 129, resetting magic number
bad version number 0x0 on inode 129, resetting version number
imap claims a free inode 129 is in use, correcting imap and clearing inode
cleared realtime bitmap inode 129
bad magic number 0x0 on inode 130, resetting magic number
bad version number 0x0 on inode 130, resetting version number
imap claims a free inode 130 is in use, correcting imap and clearing inode
cleared realtime summary inode 130
bad magic number 0x0 on inode 131, resetting magic number
bad version number 0x0 on inode 131, resetting version number
imap claims a free inode 131 is in use, correcting imap and clearing inode
cleared inode 131
bad magic number 0x0 on inode 132, resetting magic number
bad version number 0x0 on inode 132, resetting version number
bad magic number 0x0 on inode 133, resetting magic number
bad version number 0x0 on inode 133, resetting version number
bad magic number 0x0 on inode 134, resetting magic number
bad version number 0x0 on inode 134, resetting version number
bad magic number 0x0 on inode 135, resetting magic number
bad version number 0x0 on inode 135, resetting version number
bad magic number 0x0 on inode 136, resetting magic number
bad version number 0x0 on inode 136, resetting version number
bad magic number 0x0 on inode 137, resetting magic number
bad version number 0x0 on inode 137, resetting version number
bad magic number 0x0 on inode 138, resetting magic number
bad version number 0x0 on inode 138, resetting version number
bad magic number 0x0 on inode 139, resetting magic number
bad version number 0x0 on inode 139, resetting version number
bad magic number 0x0 on inode 140, resetting magic number
bad version number 0x0 on inode 140, resetting version number
bad magic number 0x0 on inode 141, resetting magic number
bad version number 0x0 on inode 141, resetting version number
bad magic number 0x0 on inode 142, resetting magic number
bad version number 0x0 on inode 142, resetting version number
bad magic number 0x0 on inode 143, resetting magic number
bad version number 0x0 on inode 143, resetting version number
bad magic number 0x0 on inode 144, resetting magic number
bad version number 0x0 on inode 144, resetting version number
bad magic number 0x0 on inode 145, resetting magic number
bad version number 0x0 on inode 145, resetting version number
bad magic number 0x0 on inode 146, resetting magic number
bad version number 0x0 on inode 146, resetting version number
bad magic number 0x0 on inode 147, resetting magic number
bad version number 0x0 on inode 147, resetting version number
bad magic number 0x0 on inode 148, resetting magic number
bad version number 0x0 on inode 148, resetting version number
bad magic number 0x0 on inode 149, resetting magic number
bad version number 0x0 on inode 149, resetting version number
bad magic number 0x0 on inode 150, resetting magic number
bad version number 0x0 on inode 150, resetting version number
bad magic number 0x0 on inode 151, resetting magic number
bad version number 0x0 on inode 151, resetting version number
bad magic number 0x0 on inode 152, resetting magic number
bad version number 0x0 on inode 152, resetting version number
bad magic number 0x0 on inode 153, resetting magic number
bad version number 0x0 on inode 153, resetting version number
bad magic number 0x0 on inode 154, resetting magic number
bad version number 0x0 on inode 154, resetting version number
bad magic number 0x0 on inode 155, resetting magic number
bad version number 0x0 on inode 155, resetting version number
bad magic number 0x0 on inode 156, resetting magic number
bad version number 0x0 on inode 156, resetting version number
bad magic number 0x0 on inode 157, resetting magic number
bad version number 0x0 on inode 157, resetting version number
bad magic number 0x0 on inode 158, resetting magic number
bad version number 0x0 on inode 158, resetting version number
bad magic number 0x0 on inode 159, resetting magic number
bad version number 0x0 on inode 159, resetting version number
bad magic number 0x0 on inode 160, resetting magic number
bad version number 0x0 on inode 160, resetting version number
bad magic number 0x0 on inode 161, resetting magic number
bad version number 0x0 on inode 161, resetting version number
bad magic number 0x0 on inode 162, resetting magic number
bad version number 0x0 on inode 162, resetting version number
bad magic number 0x0 on inode 163, resetting magic number
bad version number 0x0 on inode 163, resetting version number
bad magic number 0x0 on inode 164, resetting magic number
bad version number 0x0 on inode 164, resetting version number
bad magic number 0x0 on inode 165, resetting magic number
bad version number 0x0 on inode 165, resetting version number
bad magic number 0x0 on inode 166, resetting magic number
bad version number 0x0 on inode 166, resetting version number
bad magic number 0x0 on inode 167, resetting magic number
bad version number 0x0 on inode 167, resetting version number
bad magic number 0x0 on inode 168, resetting magic number
bad version number 0x0 on inode 168, resetting version number
bad magic number 0x0 on inode 169, resetting magic number
bad version number 0x0 on inode 169, resetting version number
bad magic number 0x0 on inode 170, resetting magic number
bad version number 0x0 on inode 170, resetting version number
bad magic number 0x0 on inode 171, resetting magic number
bad version number 0x0 on inode 171, resetting version number
bad magic number 0x0 on inode 172, resetting magic number
bad version number 0x0 on inode 172, resetting version number
bad magic number 0x0 on inode 173, resetting magic number
bad version number 0x0 on inode 173, resetting version number
bad magic number 0x0 on inode 174, resetting magic number
bad version number 0x0 on inode 174, resetting version number
bad magic number 0x0 on inode 175, resetting magic number
bad version number 0x0 on inode 175, resetting version number
bad magic number 0x0 on inode 176, resetting magic number
bad version number 0x0 on inode 176, resetting version number
bad magic number 0x0 on inode 177, resetting magic number
bad version number 0x0 on inode 177, resetting version number
bad magic number 0x0 on inode 178, resetting magic number
bad version number 0x0 on inode 178, resetting version number
bad magic number 0x0 on inode 179, resetting magic number
bad version number 0x0 on inode 179, resetting version number
bad magic number 0x0 on inode 180, resetting magic number
bad version number 0x0 on inode 180, resetting version number
bad magic number 0x0 on inode 181, resetting magic number
bad version number 0x0 on inode 181, resetting version number
bad magic number 0x0 on inode 182, resetting magic number
bad version number 0x0 on inode 182, resetting version number
bad magic number 0x0 on inode 183, resetting magic number
bad version number 0x0 on inode 183, resetting version number
bad magic number 0x0 on inode 184, resetting magic number
bad version number 0x0 on inode 184, resetting version number
bad magic number 0x0 on inode 185, resetting magic number
bad version number 0x0 on inode 185, resetting version number
bad magic number 0x0 on inode 186, resetting magic number
bad version number 0x0 on inode 186, resetting version number
bad magic number 0x0 on inode 187, resetting magic number
bad version number 0x0 on inode 187, resetting version number
bad magic number 0x0 on inode 188, resetting magic number
bad version number 0x0 on inode 188, resetting version number
bad magic number 0x0 on inode 189, resetting magic number
bad version number 0x0 on inode 189, resetting version number
bad magic number 0x0 on inode 190, resetting magic number
bad version number 0x0 on inode 190, resetting version number
bad magic number 0x0 on inode 191, resetting magic number
bad version number 0x0 on inode 191, resetting version number
        - agno = 1
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
root inode lost
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 0
inode block 8 multiply claimed, state was 4
inode block 9 multiply claimed, state was 4
inode block 10 multiply claimed, state was 4
inode block 11 multiply claimed, state was 4
entry ".." at block 0 offset 32 in directory inode 424256 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 424256
entry ".." at block 0 offset 32 in directory inode 1075051913 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051913
entry ".." at block 0 offset 32 in directory inode 1075051915 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051915
entry ".." at block 0 offset 32 in directory inode 1075051918 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051918
entry ".." at block 0 offset 32 in directory inode 1075051920 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051920
entry ".." at block 0 offset 32 in directory inode 1075051921 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051921
entry ".." at block 0 offset 32 in directory inode 1075051923 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051923
entry ".." at block 0 offset 32 in directory inode 1075051930 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051930
entry ".." at block 0 offset 32 in directory inode 1075051931 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051931
entry ".." at block 0 offset 32 in directory inode 1075051932 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051932
entry ".." at block 0 offset 32 in directory inode 1075051934 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075051934
entry ".." at block 0 offset 32 in directory inode 1075117889 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075117889
entry ".." at block 0 offset 32 in directory inode 1075117896 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075117896
entry ".." at block 0 offset 32 in directory inode 1075117907 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075117907
entry ".." at block 0 offset 32 in directory inode 1075244397 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075244397
entry ".." at block 0 offset 32 in directory inode 1075244399 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075244399
entry ".." at block 0 offset 32 in directory inode 1075244401 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1075244401
entry ".." at block 0 offset 32 in directory inode 1076805266 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076805266
entry ".." at block 0 offset 32 in directory inode 1076811247 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076811247
entry ".." at block 0 offset 32 in directory inode 1076811248 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076811248
entry ".." at block 0 offset 32 in directory inode 1076811260 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076811260
entry ".." at block 0 offset 32 in directory inode 1076811261 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076811261
entry ".." at block 0 offset 32 in directory inode 1076811262 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076811262
entry ".." at block 0 offset 32 in directory inode 1076811263 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076811263
entry ".." at block 0 offset 32 in directory inode 1076818528 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818528
entry ".." at block 0 offset 32 in directory inode 1076818529 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818529
entry ".." at block 0 offset 32 in directory inode 1076818542 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818542
entry ".." at block 0 offset 32 in directory inode 1076818543 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818543
entry ".." at block 0 offset 32 in directory inode 1076818544 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818544
entry ".." at block 0 offset 32 in directory inode 1076818545 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818545
entry ".." at block 0 offset 32 in directory inode 1076818546 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818546
entry ".." at block 0 offset 32 in directory inode 1076818548 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818548
entry ".." at block 0 offset 32 in directory inode 1076818549 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818549
entry ".." at block 0 offset 32 in directory inode 1076818554 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818554
entry ".." at block 0 offset 32 in directory inode 1076818555 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818555
entry ".." at block 0 offset 32 in directory inode 1076818556 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818556
entry ".." at block 0 offset 32 in directory inode 1076818559 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818559
entry ".." at block 0 offset 32 in directory inode 1076818562 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818562
entry ".." at block 0 offset 32 in directory inode 1076818563 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818563
entry ".." at block 0 offset 32 in directory inode 1076818591 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076818591
entry ".." at block 0 offset 32 in directory inode 1076828546 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828546
entry ".." at block 0 offset 32 in directory inode 1076828549 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828549
entry ".." at block 0 offset 32 in directory inode 1076828554 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828554
entry ".." at block 0 offset 32 in directory inode 1076828555 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828555
entry ".." at block 0 offset 32 in directory inode 1076828571 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828571
entry ".." at block 0 offset 32 in directory inode 1076828573 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828573
entry ".." at block 0 offset 32 in directory inode 1076828594 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828594
entry ".." at block 0 offset 32 in directory inode 1076828599 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828599
entry ".." at block 0 offset 32 in directory inode 1076828607 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076828607
entry ".." at block 0 offset 32 in directory inode 1076839776 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839776
entry ".." at block 0 offset 32 in directory inode 1076839777 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839777
entry ".." at block 0 offset 32 in directory inode 1076839779 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839779
entry ".." at block 0 offset 32 in directory inode 1076839780 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839780
entry ".." at block 0 offset 32 in directory inode 1076839784 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839784
entry ".." at block 0 offset 32 in directory inode 1076839785 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839785
entry ".." at block 0 offset 32 in directory inode 1076839786 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839786
entry ".." at block 0 offset 32 in directory inode 1076839792 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839792
entry ".." at block 0 offset 32 in directory inode 1076839794 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839794
entry ".." at block 0 offset 32 in directory inode 1076839795 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839795
entry ".." at block 0 offset 32 in directory inode 1076839823 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839823
entry ".." at block 0 offset 32 in directory inode 1076839825 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839825
entry ".." at block 0 offset 32 in directory inode 1076839826 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839826
entry ".." at block 0 offset 32 in directory inode 1076839828 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839828
entry ".." at block 0 offset 32 in directory inode 1076839831 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839831
entry ".." at block 0 offset 32 in directory inode 1076839835 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839835
entry ".." at block 0 offset 32 in directory inode 1076839836 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839836
entry ".." at block 0 offset 32 in directory inode 1076839837 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839837
entry ".." at block 0 offset 32 in directory inode 1076839838 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076839838
entry ".." at block 0 offset 32 in directory inode 1076848162 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076848162
entry ".." at block 0 offset 32 in directory inode 1076848202 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076848202
entry ".." at block 0 offset 32 in directory inode 1076848204 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076848204
entry ".." at block 0 offset 32 in directory inode 1076848221 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076848221
entry ".." at block 0 offset 32 in directory inode 1076848222 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076848222
entry ".." at block 0 offset 32 in directory inode 1076853088 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853088
entry ".." at block 0 offset 32 in directory inode 1076853089 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853089
entry ".." at block 0 offset 32 in directory inode 1076853091 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853091
entry ".." at block 0 offset 32 in directory inode 1076853114 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853114
entry ".." at block 0 offset 32 in directory inode 1076853126 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853126
entry ".." at block 0 offset 32 in directory inode 1076853127 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853127
entry ".." at block 0 offset 32 in directory inode 1076853133 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853133
entry ".." at block 0 offset 32 in directory inode 1076853134 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853134
entry ".." at block 0 offset 32 in directory inode 1076853135 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853135
entry ".." at block 0 offset 32 in directory inode 1076853136 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853136
entry ".." at block 0 offset 32 in directory inode 1076853138 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853138
entry ".." at block 0 offset 32 in directory inode 1076853139 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076853139
entry ".." at block 0 offset 32 in directory inode 1076854593 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854593
entry ".." at block 0 offset 32 in directory inode 1076854603 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854603
entry ".." at block 0 offset 32 in directory inode 1076854604 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854604
entry ".." at block 0 offset 32 in directory inode 1076854610 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854610
entry ".." at block 0 offset 32 in directory inode 1076854621 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854621
entry ".." at block 0 offset 32 in directory inode 1076854628 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854628
entry ".." at block 0 offset 32 in directory inode 1076854639 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854639
entry ".." at block 0 offset 32 in directory inode 1076854640 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854640
entry ".." at block 0 offset 32 in directory inode 1076854643 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854643
entry ".." at block 0 offset 32 in directory inode 1076854644 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1076854644
entry ".." at block 0 offset 32 in directory inode 1077602230 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1077602230
entry ".." at block 0 offset 32 in directory inode 1077652948 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1077652948
entry ".." at block 0 offset 32 in directory inode 1098465511 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1098465511
entry ".." at block 0 offset 32 in directory inode 1098465515 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1098465515
entry ".." at block 0 offset 32 in directory inode 1098465519 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1098465519
entry ".." at block 0 offset 32 in directory inode 1098465523 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1098465523
entry ".." at block 0 offset 32 in directory inode 1098465524 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1098465524
entry ".." at block 0 offset 32 in directory inode 1098465528 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1098465528
entry ".." at block 0 offset 32 in directory inode 1098465529 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1098465529
entry ".." at block 0 offset 32 in directory inode 1098465537 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 1098465537
entry ".." at block 0 offset 32 in directory inode 125005222 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 125005222
entry ".." at block 0 offset 32 in directory inode 125005255 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 125005255
entry ".." at block 0 offset 32 in directory inode 125005256 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 125005256
entry ".." at block 0 offset 32 in directory inode 125005577 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 125005577
entry ".." at block 0 offset 32 in directory inode 125660420 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 125660420
entry ".." at block 0 offset 32 in directory inode 130503573 references free inode 131
	clearing inode number in entry at offset 32...
no .. entry for directory 130503573
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
reinitializing root directory
reinitializing realtime bitmap inode
reinitializing realtime summary inode
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 424256 (no data entry): rebuilding
rebuilding directory inode 424256
bad hash table for directory inode 125005222 (no data entry): rebuilding
rebuilding directory inode 125005222
bad hash table for directory inode 125005255 (no data entry): rebuilding
rebuilding directory inode 125005255
bad hash table for directory inode 125005256 (no data entry): rebuilding
rebuilding directory inode 125005256
bad hash table for directory inode 125005577 (no data entry): rebuilding
rebuilding directory inode 125005577
bad hash table for directory inode 125660420 (no data entry): rebuilding
rebuilding directory inode 125660420
bad hash table for directory inode 130503573 (no data entry): rebuilding
rebuilding directory inode 130503573
bad hash table for directory inode 1075051913 (no data entry): rebuilding
rebuilding directory inode 1075051913
bad hash table for directory inode 1075051915 (no data entry): rebuilding
rebuilding directory inode 1075051915
bad hash table for directory inode 1075051918 (no data entry): rebuilding
rebuilding directory inode 1075051918
bad hash table for directory inode 1075051920 (no data entry): rebuilding
rebuilding directory inode 1075051920
bad hash table for directory inode 1075051921 (no data entry): rebuilding
rebuilding directory inode 1075051921
bad hash table for directory inode 1075051923 (no data entry): rebuilding
rebuilding directory inode 1075051923
bad hash table for directory inode 1075051930 (no data entry): rebuilding
rebuilding directory inode 1075051930
bad hash table for directory inode 1075051931 (no data entry): rebuilding
rebuilding directory inode 1075051931
bad hash table for directory inode 1075051932 (no data entry): rebuilding
rebuilding directory inode 1075051932
bad hash table for directory inode 1075051934 (no data entry): rebuilding
rebuilding directory inode 1075051934
bad hash table for directory inode 1075117889 (no data entry): rebuilding
rebuilding directory inode 1075117889
bad hash table for directory inode 1075117896 (no data entry): rebuilding
rebuilding directory inode 1075117896
bad hash table for directory inode 1075117907 (no data entry): rebuilding
rebuilding directory inode 1075117907
bad hash table for directory inode 1075244397 (no data entry): rebuilding
rebuilding directory inode 1075244397
bad hash table for directory inode 1075244399 (no data entry): rebuilding
rebuilding directory inode 1075244399
bad hash table for directory inode 1075244401 (no data entry): rebuilding
rebuilding directory inode 1075244401
bad hash table for directory inode 1076805266 (no data entry): rebuilding
rebuilding directory inode 1076805266
bad hash table for directory inode 1076811247 (no data entry): rebuilding
rebuilding directory inode 1076811247
bad hash table for directory inode 1076811248 (no data entry): rebuilding
rebuilding directory inode 1076811248
bad hash table for directory inode 1076811260 (no data entry): rebuilding
rebuilding directory inode 1076811260
bad hash table for directory inode 1076811261 (no data entry): rebuilding
rebuilding directory inode 1076811261
bad hash table for directory inode 1076811262 (no data entry): rebuilding
rebuilding directory inode 1076811262
bad hash table for directory inode 1076811263 (no data entry): rebuilding
rebuilding directory inode 1076811263
bad hash table for directory inode 1076818528 (no data entry): rebuilding
rebuilding directory inode 1076818528
bad hash table for directory inode 1076818529 (no data entry): rebuilding
rebuilding directory inode 1076818529
bad hash table for directory inode 1076818542 (no data entry): rebuilding
rebuilding directory inode 1076818542
bad hash table for directory inode 1076818543 (no data entry): rebuilding
rebuilding directory inode 1076818543
bad hash table for directory inode 1076818544 (no data entry): rebuilding
rebuilding directory inode 1076818544
bad hash table for directory inode 1076818545 (no data entry): rebuilding
rebuilding directory inode 1076818545
bad hash table for directory inode 1076818546 (no data entry): rebuilding
rebuilding directory inode 1076818546
bad hash table for directory inode 1076818548 (no data entry): rebuilding
rebuilding directory inode 1076818548
bad hash table for directory inode 1076818549 (no data entry): rebuilding
rebuilding directory inode 1076818549
bad hash table for directory inode 1076818554 (no data entry): rebuilding
rebuilding directory inode 1076818554
bad hash table for directory inode 1076818555 (no data entry): rebuilding
rebuilding directory inode 1076818555
bad hash table for directory inode 1076818556 (no data entry): rebuilding
rebuilding directory inode 1076818556
bad hash table for directory inode 1076818559 (no data entry): rebuilding
rebuilding directory inode 1076818559
bad hash table for directory inode 1076818562 (no data entry): rebuilding
rebuilding directory inode 1076818562
bad hash table for directory inode 1076818563 (no data entry): rebuilding
rebuilding directory inode 1076818563
bad hash table for directory inode 1076818591 (no data entry): rebuilding
rebuilding directory inode 1076818591
bad hash table for directory inode 1076828546 (no data entry): rebuilding
rebuilding directory inode 1076828546
bad hash table for directory inode 1076828549 (no data entry): rebuilding
rebuilding directory inode 1076828549
bad hash table for directory inode 1076828554 (no data entry): rebuilding
rebuilding directory inode 1076828554
bad hash table for directory inode 1076828555 (no data entry): rebuilding
rebuilding directory inode 1076828555
bad hash table for directory inode 1076828571 (no data entry): rebuilding
rebuilding directory inode 1076828571
bad hash table for directory inode 1076828573 (no data entry): rebuilding
rebuilding directory inode 1076828573
bad hash table for directory inode 1076828594 (no data entry): rebuilding
rebuilding directory inode 1076828594
bad hash table for directory inode 1076828599 (no data entry): rebuilding
rebuilding directory inode 1076828599
bad hash table for directory inode 1076828607 (no data entry): rebuilding
rebuilding directory inode 1076828607
bad hash table for directory inode 1076839776 (no data entry): rebuilding
rebuilding directory inode 1076839776
bad hash table for directory inode 1076839777 (no data entry): rebuilding
rebuilding directory inode 1076839777
bad hash table for directory inode 1076839779 (no data entry): rebuilding
rebuilding directory inode 1076839779
bad hash table for directory inode 1076839780 (no data entry): rebuilding
rebuilding directory inode 1076839780
bad hash table for directory inode 1076839784 (no data entry): rebuilding
rebuilding directory inode 1076839784
bad hash table for directory inode 1076839785 (no data entry): rebuilding
rebuilding directory inode 1076839785
bad hash table for directory inode 1076839786 (no data entry): rebuilding
rebuilding directory inode 1076839786
bad hash table for directory inode 1076839792 (no data entry): rebuilding
rebuilding directory inode 1076839792
bad hash table for directory inode 1076839794 (no data entry): rebuilding
rebuilding directory inode 1076839794
bad hash table for directory inode 1076839795 (no data entry): rebuilding
rebuilding directory inode 1076839795
bad hash table for directory inode 1076839823 (no data entry): rebuilding
rebuilding directory inode 1076839823
bad hash table for directory inode 1076839825 (no data entry): rebuilding
rebuilding directory inode 1076839825
bad hash table for directory inode 1076839826 (no data entry): rebuilding
rebuilding directory inode 1076839826
bad hash table for directory inode 1076839828 (no data entry): rebuilding
rebuilding directory inode 1076839828
bad hash table for directory inode 1076839831 (no data entry): rebuilding
rebuilding directory inode 1076839831
bad hash table for directory inode 1076839835 (no data entry): rebuilding
rebuilding directory inode 1076839835
bad hash table for directory inode 1076839836 (no data entry): rebuilding
rebuilding directory inode 1076839836
bad hash table for directory inode 1076839837 (no data entry): rebuilding
rebuilding directory inode 1076839837
bad hash table for directory inode 1076839838 (no data entry): rebuilding
rebuilding directory inode 1076839838
bad hash table for directory inode 1076848162 (no data entry): rebuilding
rebuilding directory inode 1076848162
bad hash table for directory inode 1076848202 (no data entry): rebuilding
rebuilding directory inode 1076848202
bad hash table for directory inode 1076848204 (no data entry): rebuilding
rebuilding directory inode 1076848204
bad hash table for directory inode 1076848221 (no data entry): rebuilding
rebuilding directory inode 1076848221
bad hash table for directory inode 1076848222 (no data entry): rebuilding
rebuilding directory inode 1076848222
bad hash table for directory inode 1076853088 (no data entry): rebuilding
rebuilding directory inode 1076853088
bad hash table for directory inode 1076853089 (no data entry): rebuilding
rebuilding directory inode 1076853089
bad hash table for directory inode 1076853091 (no data entry): rebuilding
rebuilding directory inode 1076853091
bad hash table for directory inode 1076853114 (no data entry): rebuilding
rebuilding directory inode 1076853114
bad hash table for directory inode 1076853126 (no data entry): rebuilding
rebuilding directory inode 1076853126
bad hash table for directory inode 1076853127 (no data entry): rebuilding
rebuilding directory inode 1076853127
bad hash table for directory inode 1076853133 (no data entry): rebuilding
rebuilding directory inode 1076853133
bad hash table for directory inode 1076853134 (no data entry): rebuilding
rebuilding directory inode 1076853134
bad hash table for directory inode 1076853135 (no data entry): rebuilding
rebuilding directory inode 1076853135
bad hash table for directory inode 1076853136 (no data entry): rebuilding
rebuilding directory inode 1076853136
bad hash table for directory inode 1076853138 (no data entry): rebuilding
rebuilding directory inode 1076853138
bad hash table for directory inode 1076853139 (no data entry): rebuilding
rebuilding directory inode 1076853139
bad hash table for directory inode 1076854593 (no data entry): rebuilding
rebuilding directory inode 1076854593
bad hash table for directory inode 1076854603 (no data entry): rebuilding
rebuilding directory inode 1076854603
bad hash table for directory inode 1076854604 (no data entry): rebuilding
rebuilding directory inode 1076854604
bad hash table for directory inode 1076854610 (no data entry): rebuilding
rebuilding directory inode 1076854610
bad hash table for directory inode 1076854621 (no data entry): rebuilding
rebuilding directory inode 1076854621
bad hash table for directory inode 1076854628 (no data entry): rebuilding
rebuilding directory inode 1076854628
bad hash table for directory inode 1076854639 (no data entry): rebuilding
rebuilding directory inode 1076854639
bad hash table for directory inode 1076854640 (no data entry): rebuilding
rebuilding directory inode 1076854640
bad hash table for directory inode 1076854643 (no data entry): rebuilding
rebuilding directory inode 1076854643
bad hash table for directory inode 1076854644 (no data entry): rebuilding
rebuilding directory inode 1076854644
bad hash table for directory inode 1077602230 (no data entry): rebuilding
rebuilding directory inode 1077602230
bad hash table for directory inode 1077652948 (no data entry): rebuilding
rebuilding directory inode 1077652948
bad hash table for directory inode 1098465511 (no data entry): rebuilding
rebuilding directory inode 1098465511
bad hash table for directory inode 1098465515 (no data entry): rebuilding
rebuilding directory inode 1098465515
bad hash table for directory inode 1098465519 (no data entry): rebuilding
rebuilding directory inode 1098465519
bad hash table for directory inode 1098465523 (no data entry): rebuilding
rebuilding directory inode 1098465523
bad hash table for directory inode 1098465524 (no data entry): rebuilding
rebuilding directory inode 1098465524
bad hash table for directory inode 1098465528 (no data entry): rebuilding
rebuilding directory inode 1098465528
bad hash table for directory inode 1098465529 (no data entry): rebuilding
rebuilding directory inode 1098465529
bad hash table for directory inode 1098465537 (no data entry): rebuilding
rebuilding directory inode 1098465537
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 424256, moving to lost+found
disconnected inode 424257, moving to lost+found
disconnected inode 424258, moving to lost+found
disconnected inode 5667475, moving to lost+found
disconnected dir inode 125005217, moving to lost+found
disconnected dir inode 125005218, moving to lost+found
disconnected dir inode 125005219, moving to lost+found
disconnected dir inode 125005221, moving to lost+found
disconnected dir inode 125005222, moving to lost+found
disconnected dir inode 125005223, moving to lost+found
disconnected dir inode 125005224, moving to lost+found
disconnected dir inode 125005225, moving to lost+found
disconnected dir inode 125005226, moving to lost+found
disconnected dir inode 125005228, moving to lost+found
disconnected dir inode 125005229, moving to lost+found
disconnected dir inode 125005230, moving to lost+found
disconnected dir inode 125005231, moving to lost+found
disconnected dir inode 125005232, moving to lost+found
disconnected dir inode 125005233, moving to lost+found
disconnected dir inode 125005236, moving to lost+found
disconnected dir inode 125005237, moving to lost+found
disconnected dir inode 125005238, moving to lost+found
disconnected dir inode 125005239, moving to lost+found
disconnected dir inode 125005240, moving to lost+found
disconnected dir inode 125005241, moving to lost+found
disconnected dir inode 125005242, moving to lost+found
disconnected dir inode 125005243, moving to lost+found
disconnected dir inode 125005244, moving to lost+found
disconnected dir inode 125005245, moving to lost+found
disconnected dir inode 125005247, moving to lost+found
disconnected dir inode 125005248, moving to lost+found
disconnected dir inode 125005249, moving to lost+found
disconnected dir inode 125005250, moving to lost+found
disconnected dir inode 125005251, moving to lost+found
disconnected dir inode 125005252, moving to lost+found
disconnected dir inode 125005253, moving to lost+found
disconnected dir inode 125005254, moving to lost+found
disconnected dir inode 125005255, moving to lost+found
disconnected dir inode 125005256, moving to lost+found
disconnected dir inode 125005257, moving to lost+found
disconnected dir inode 125005259, moving to lost+found
disconnected dir inode 125005260, moving to lost+found
disconnected dir inode 125005262, moving to lost+found
disconnected dir inode 125005263, moving to lost+found
disconnected dir inode 125005264, moving to lost+found
disconnected dir inode 125005265, moving to lost+found
disconnected dir inode 125005266, moving to lost+found
disconnected dir inode 125005267, moving to lost+found
disconnected dir inode 125005268, moving to lost+found
disconnected dir inode 125005269, moving to lost+found
disconnected dir inode 125005270, moving to lost+found
disconnected dir inode 125005271, moving to lost+found
disconnected dir inode 125005272, moving to lost+found
disconnected dir inode 125005273, moving to lost+found
disconnected dir inode 125005274, moving to lost+found
disconnected dir inode 125005275, moving to lost+found
disconnected dir inode 125005276, moving to lost+found
disconnected dir inode 125005277, moving to lost+found
disconnected dir inode 125005278, moving to lost+found
disconnected dir inode 125005279, moving to lost+found
disconnected dir inode 125005568, moving to lost+found
disconnected dir inode 125005569, moving to lost+found
disconnected dir inode 125005571, moving to lost+found
disconnected dir inode 125005572, moving to lost+found
disconnected dir inode 125005573, moving to lost+found
disconnected dir inode 125005574, moving to lost+found
disconnected dir inode 125005575, moving to lost+found
disconnected dir inode 125005576, moving to lost+found
disconnected dir inode 125005577, moving to lost+found
disconnected dir inode 125016316, moving to lost+found
disconnected dir inode 125660420, moving to lost+found
disconnected dir inode 125685326, moving to lost+found
disconnected dir inode 125685351, moving to lost+found
disconnected inode 125908558, moving to lost+found
disconnected inode 125908559, moving to lost+found
disconnected inode 125908560, moving to lost+found
disconnected dir inode 126090218, moving to lost+found
disconnected dir inode 126090220, moving to lost+found
disconnected dir inode 126090224, moving to lost+found
disconnected dir inode 130503573, moving to lost+found
disconnected dir inode 164462811, moving to lost+found
disconnected dir inode 164462812, moving to lost+found
disconnected dir inode 164462813, moving to lost+found
disconnected dir inode 164462814, moving to lost+found
disconnected dir inode 164462815, moving to lost+found
disconnected dir inode 164462816, moving to lost+found
disconnected dir inode 164462817, moving to lost+found
disconnected dir inode 164462818, moving to lost+found
disconnected dir inode 164462819, moving to lost+found
disconnected dir inode 164462820, moving to lost+found
disconnected dir inode 164462821, moving to lost+found
disconnected dir inode 164462822, moving to lost+found
disconnected dir inode 164462823, moving to lost+found
disconnected dir inode 164462824, moving to lost+found
disconnected dir inode 164462825, moving to lost+found
disconnected dir inode 164462826, moving to lost+found
disconnected dir inode 190881713, moving to lost+found
disconnected dir inode 240441693, moving to lost+found
disconnected dir inode 1075051900, moving to lost+found
disconnected dir inode 1075051901, moving to lost+found
disconnected dir inode 1075051902, moving to lost+found
disconnected dir inode 1075051903, moving to lost+found
disconnected dir inode 1075051908, moving to lost+found
disconnected dir inode 1075051909, moving to lost+found
disconnected dir inode 1075051910, moving to lost+found
disconnected dir inode 1075051912, moving to lost+found
disconnected dir inode 1075051913, moving to lost+found
disconnected dir inode 1075051915, moving to lost+found
disconnected dir inode 1075051916, moving to lost+found
disconnected dir inode 1075051917, moving to lost+found
disconnected dir inode 1075051918, moving to lost+found
disconnected dir inode 1075051919, moving to lost+found
disconnected dir inode 1075051920, moving to lost+found
disconnected dir inode 1075051921, moving to lost+found
disconnected dir inode 1075051922, moving to lost+found
disconnected dir inode 1075051923, moving to lost+found
disconnected dir inode 1075051930, moving to lost+found
disconnected dir inode 1075051931, moving to lost+found
disconnected dir inode 1075051932, moving to lost+found
disconnected dir inode 1075051933, moving to lost+found
disconnected dir inode 1075051934, moving to lost+found
disconnected dir inode 1075117888, moving to lost+found
disconnected dir inode 1075117889, moving to lost+found
disconnected dir inode 1075117890, moving to lost+found
disconnected dir inode 1075117891, moving to lost+found
disconnected dir inode 1075117896, moving to lost+found
disconnected dir inode 1075117897, moving to lost+found
disconnected dir inode 1075117902, moving to lost+found
disconnected dir inode 1075117903, moving to lost+found
disconnected dir inode 1075117907, moving to lost+found
disconnected dir inode 1075117908, moving to lost+found
disconnected dir inode 1075117939, moving to lost+found
disconnected dir inode 1075244397, moving to lost+found
disconnected dir inode 1075244399, moving to lost+found
disconnected dir inode 1075244400, moving to lost+found
disconnected dir inode 1075244401, moving to lost+found
disconnected dir inode 1075244402, moving to lost+found
disconnected dir inode 1076383229, moving to lost+found
disconnected dir inode 1076383230, moving to lost+found
disconnected dir inode 1076797385, moving to lost+found
disconnected dir inode 1076797389, moving to lost+found
disconnected dir inode 1076797390, moving to lost+found
disconnected dir inode 1076797391, moving to lost+found
disconnected dir inode 1076797393, moving to lost+found
disconnected dir inode 1076797395, moving to lost+found
disconnected dir inode 1076797399, moving to lost+found
disconnected dir inode 1076797407, moving to lost+found
disconnected dir inode 1076797408, moving to lost+found
disconnected dir inode 1076797410, moving to lost+found
disconnected dir inode 1076797411, moving to lost+found
disconnected dir inode 1076797412, moving to lost+found
disconnected dir inode 1076797413, moving to lost+found
disconnected dir inode 1076797417, moving to lost+found
disconnected dir inode 1076797418, moving to lost+found
disconnected dir inode 1076797420, moving to lost+found
disconnected dir inode 1076797421, moving to lost+found
disconnected dir inode 1076797422, moving to lost+found
disconnected dir inode 1076797423, moving to lost+found
disconnected dir inode 1076797424, moving to lost+found
disconnected dir inode 1076797425, moving to lost+found
disconnected dir inode 1076797426, moving to lost+found
disconnected dir inode 1076797427, moving to lost+found
disconnected dir inode 1076797428, moving to lost+found
disconnected dir inode 1076797429, moving to lost+found
disconnected dir inode 1076797433, moving to lost+found
disconnected dir inode 1076797437, moving to lost+found
disconnected dir inode 1076797438, moving to lost+found
disconnected dir inode 1076797440, moving to lost+found
disconnected dir inode 1076797442, moving to lost+found
disconnected dir inode 1076797445, moving to lost+found
disconnected dir inode 1076797446, moving to lost+found
disconnected dir inode 1076797447, moving to lost+found
disconnected dir inode 1076797451, moving to lost+found
disconnected dir inode 1076797455, moving to lost+found
disconnected dir inode 1076797459, moving to lost+found
disconnected dir inode 1076797461, moving to lost+found
disconnected dir inode 1076797462, moving to lost+found
disconnected dir inode 1076797463, moving to lost+found
disconnected dir inode 1076797464, moving to lost+found
disconnected dir inode 1076797465, moving to lost+found
disconnected dir inode 1076797466, moving to lost+found
disconnected dir inode 1076797467, moving to lost+found
disconnected dir inode 1076797468, moving to lost+found
disconnected dir inode 1076797469, moving to lost+found
disconnected dir inode 1076797470, moving to lost+found
disconnected dir inode 1076797471, moving to lost+found
disconnected dir inode 1076797472, moving to lost+found
disconnected dir inode 1076797473, moving to lost+found
disconnected dir inode 1076797474, moving to lost+found
disconnected dir inode 1076797479, moving to lost+found
disconnected dir inode 1076797481, moving to lost+found
disconnected dir inode 1076797488, moving to lost+found
disconnected dir inode 1076797490, moving to lost+found
disconnected dir inode 1076797491, moving to lost+found
disconnected dir inode 1076797492, moving to lost+found
disconnected dir inode 1076797493, moving to lost+found
disconnected dir inode 1076797494, moving to lost+found
disconnected dir inode 1076797495, moving to lost+found
disconnected dir inode 1076797496, moving to lost+found
disconnected dir inode 1076797497, moving to lost+found
disconnected dir inode 1076797498, moving to lost+found
disconnected dir inode 1076797500, moving to lost+found
disconnected dir inode 1076797502, moving to lost+found
disconnected dir inode 1076797503, moving to lost+found
disconnected dir inode 1076805248, moving to lost+found
disconnected dir inode 1076805249, moving to lost+found
disconnected dir inode 1076805254, moving to lost+found
disconnected dir inode 1076805255, moving to lost+found
disconnected dir inode 1076805256, moving to lost+found
disconnected dir inode 1076805257, moving to lost+found
disconnected dir inode 1076805259, moving to lost+found
disconnected dir inode 1076805260, moving to lost+found
disconnected dir inode 1076805261, moving to lost+found
disconnected dir inode 1076805262, moving to lost+found
disconnected dir inode 1076805263, moving to lost+found
disconnected dir inode 1076805266, moving to lost+found
disconnected dir inode 1076805267, moving to lost+found
disconnected dir inode 1076805268, moving to lost+found
disconnected dir inode 1076805269, moving to lost+found
disconnected dir inode 1076805270, moving to lost+found
disconnected dir inode 1076805272, moving to lost+found
disconnected dir inode 1076805273, moving to lost+found
disconnected dir inode 1076805274, moving to lost+found
disconnected dir inode 1076805276, moving to lost+found
disconnected dir inode 1076805277, moving to lost+found
disconnected dir inode 1076805278, moving to lost+found
disconnected dir inode 1076805279, moving to lost+found
disconnected dir inode 1076805280, moving to lost+found
disconnected dir inode 1076805281, moving to lost+found
disconnected dir inode 1076805286, moving to lost+found
disconnected dir inode 1076805288, moving to lost+found
disconnected dir inode 1076805293, moving to lost+found
disconnected dir inode 1076805294, moving to lost+found
disconnected dir inode 1076805295, moving to lost+found
disconnected dir inode 1076805296, moving to lost+found
disconnected dir inode 1076805297, moving to lost+found
disconnected dir inode 1076805298, moving to lost+found
disconnected dir inode 1076805299, moving to lost+found
disconnected dir inode 1076805300, moving to lost+found
disconnected dir inode 1076805301, moving to lost+found
disconnected dir inode 1076805307, moving to lost+found
disconnected dir inode 1076805308, moving to lost+found
disconnected dir inode 1076809126, moving to lost+found
disconnected dir inode 1076809135, moving to lost+found
disconnected dir inode 1076809136, moving to lost+found
disconnected dir inode 1076809137, moving to lost+found
disconnected dir inode 1076809141, moving to lost+found
disconnected dir inode 1076809143, moving to lost+found
disconnected dir inode 1076809144, moving to lost+found
disconnected dir inode 1076809145, moving to lost+found
disconnected dir inode 1076809146, moving to lost+found
disconnected dir inode 1076809147, moving to lost+found
disconnected dir inode 1076809148, moving to lost+found
disconnected dir inode 1076809149, moving to lost+found
disconnected dir inode 1076809150, moving to lost+found
disconnected dir inode 1076809158, moving to lost+found
disconnected dir inode 1076809162, moving to lost+found
disconnected dir inode 1076809163, moving to lost+found
disconnected dir inode 1076809164, moving to lost+found
disconnected dir inode 1076809165, moving to lost+found
disconnected dir inode 1076809166, moving to lost+found
disconnected dir inode 1076809167, moving to lost+found
disconnected dir inode 1076809168, moving to lost+found
disconnected dir inode 1076809169, moving to lost+found
disconnected dir inode 1076809170, moving to lost+found
disconnected dir inode 1076809171, moving to lost+found
disconnected dir inode 1076809172, moving to lost+found
disconnected dir inode 1076809173, moving to lost+found
disconnected dir inode 1076809174, moving to lost+found
disconnected dir inode 1076809175, moving to lost+found
disconnected dir inode 1076809176, moving to lost+found
disconnected dir inode 1076809177, moving to lost+found
disconnected dir inode 1076809178, moving to lost+found
disconnected dir inode 1076809179, moving to lost+found
disconnected dir inode 1076809180, moving to lost+found
disconnected dir inode 1076809181, moving to lost+found
disconnected dir inode 1076809182, moving to lost+found
disconnected dir inode 1076809183, moving to lost+found
disconnected dir inode 1076811200, moving to lost+found
disconnected dir inode 1076811201, moving to lost+found
disconnected dir inode 1076811202, moving to lost+found
disconnected dir inode 1076811203, moving to lost+found
disconnected dir inode 1076811204, moving to lost+found
disconnected dir inode 1076811206, moving to lost+found
disconnected dir inode 1076811210, moving to lost+found
disconnected dir inode 1076811211, moving to lost+found
disconnected dir inode 1076811212, moving to lost+found
disconnected dir inode 1076811213, moving to lost+found
disconnected dir inode 1076811214, moving to lost+found
disconnected dir inode 1076811215, moving to lost+found
disconnected dir inode 1076811216, moving to lost+found
disconnected dir inode 1076811219, moving to lost+found
disconnected dir inode 1076811220, moving to lost+found
disconnected dir inode 1076811221, moving to lost+found
disconnected dir inode 1076811224, moving to lost+found
disconnected dir inode 1076811227, moving to lost+found
disconnected dir inode 1076811228, moving to lost+found
disconnected dir inode 1076811229, moving to lost+found
disconnected dir inode 1076811233, moving to lost+found
disconnected dir inode 1076811238, moving to lost+found
disconnected dir inode 1076811239, moving to lost+found
disconnected dir inode 1076811240, moving to lost+found
disconnected dir inode 1076811242, moving to lost+found
disconnected dir inode 1076811247, moving to lost+found
disconnected dir inode 1076811248, moving to lost+found
disconnected dir inode 1076811251, moving to lost+found
disconnected dir inode 1076811252, moving to lost+found
disconnected dir inode 1076811253, moving to lost+found
disconnected dir inode 1076811254, moving to lost+found
disconnected dir inode 1076811255, moving to lost+found
disconnected dir inode 1076811256, moving to lost+found
disconnected dir inode 1076811258, moving to lost+found
disconnected dir inode 1076811259, moving to lost+found
disconnected dir inode 1076811260, moving to lost+found
disconnected dir inode 1076811261, moving to lost+found
disconnected dir inode 1076811262, moving to lost+found
disconnected dir inode 1076811263, moving to lost+found
disconnected dir inode 1076818528, moving to lost+found
disconnected dir inode 1076818529, moving to lost+found
disconnected dir inode 1076818531, moving to lost+found
disconnected dir inode 1076818532, moving to lost+found
disconnected dir inode 1076818541, moving to lost+found
disconnected dir inode 1076818542, moving to lost+found
disconnected dir inode 1076818543, moving to lost+found
disconnected dir inode 1076818544, moving to lost+found
disconnected dir inode 1076818545, moving to lost+found
disconnected dir inode 1076818546, moving to lost+found
disconnected dir inode 1076818548, moving to lost+found
disconnected dir inode 1076818549, moving to lost+found
disconnected dir inode 1076818550, moving to lost+found
disconnected dir inode 1076818554, moving to lost+found
disconnected dir inode 1076818555, moving to lost+found
disconnected dir inode 1076818556, moving to lost+found
disconnected dir inode 1076818557, moving to lost+found
disconnected dir inode 1076818558, moving to lost+found
disconnected dir inode 1076818559, moving to lost+found
disconnected dir inode 1076818561, moving to lost+found
disconnected dir inode 1076818562, moving to lost+found
disconnected dir inode 1076818563, moving to lost+found
disconnected dir inode 1076818564, moving to lost+found
disconnected dir inode 1076818565, moving to lost+found
disconnected dir inode 1076818566, moving to lost+found
disconnected dir inode 1076818567, moving to lost+found
disconnected dir inode 1076818569, moving to lost+found
disconnected dir inode 1076818570, moving to lost+found
disconnected dir inode 1076818577, moving to lost+found
disconnected dir inode 1076818578, moving to lost+found
disconnected dir inode 1076818587, moving to lost+found
disconnected dir inode 1076818588, moving to lost+found
disconnected dir inode 1076818589, moving to lost+found
disconnected dir inode 1076818590, moving to lost+found
disconnected dir inode 1076818591, moving to lost+found
disconnected dir inode 1076828510, moving to lost+found
disconnected dir inode 1076828544, moving to lost+found
disconnected dir inode 1076828545, moving to lost+found
disconnected dir inode 1076828546, moving to lost+found
disconnected dir inode 1076828547, moving to lost+found
disconnected dir inode 1076828548, moving to lost+found
disconnected dir inode 1076828549, moving to lost+found
disconnected dir inode 1076828550, moving to lost+found
disconnected dir inode 1076828551, moving to lost+found
disconnected dir inode 1076828554, moving to lost+found
disconnected dir inode 1076828555, moving to lost+found
disconnected dir inode 1076828562, moving to lost+found
disconnected dir inode 1076828563, moving to lost+found
disconnected dir inode 1076828564, moving to lost+found
disconnected dir inode 1076828565, moving to lost+found
disconnected dir inode 1076828570, moving to lost+found
disconnected dir inode 1076828571, moving to lost+found
disconnected dir inode 1076828572, moving to lost+found
disconnected dir inode 1076828573, moving to lost+found
disconnected dir inode 1076828574, moving to lost+found
disconnected dir inode 1076828575, moving to lost+found
disconnected dir inode 1076828576, moving to lost+found
disconnected dir inode 1076828577, moving to lost+found
disconnected dir inode 1076828578, moving to lost+found
disconnected dir inode 1076828579, moving to lost+found
disconnected dir inode 1076828594, moving to lost+found
disconnected dir inode 1076828595, moving to lost+found
disconnected dir inode 1076828596, moving to lost+found
disconnected dir inode 1076828597, moving to lost+found
disconnected dir inode 1076828598, moving to lost+found
disconnected dir inode 1076828599, moving to lost+found
disconnected dir inode 1076828600, moving to lost+found
disconnected dir inode 1076828601, moving to lost+found
disconnected dir inode 1076828602, moving to lost+found
disconnected dir inode 1076828603, moving to lost+found
disconnected dir inode 1076828604, moving to lost+found
disconnected dir inode 1076828605, moving to lost+found
disconnected dir inode 1076828606, moving to lost+found
disconnected dir inode 1076828607, moving to lost+found
disconnected dir inode 1076839776, moving to lost+found
disconnected dir inode 1076839777, moving to lost+found
disconnected dir inode 1076839778, moving to lost+found
disconnected dir inode 1076839779, moving to lost+found
disconnected dir inode 1076839780, moving to lost+found
disconnected dir inode 1076839782, moving to lost+found
disconnected dir inode 1076839783, moving to lost+found
disconnected dir inode 1076839784, moving to lost+found
disconnected dir inode 1076839785, moving to lost+found
disconnected dir inode 1076839786, moving to lost+found
disconnected dir inode 1076839790, moving to lost+found
disconnected dir inode 1076839791, moving to lost+found
disconnected dir inode 1076839792, moving to lost+found
disconnected dir inode 1076839793, moving to lost+found
disconnected dir inode 1076839794, moving to lost+found
disconnected dir inode 1076839795, moving to lost+found
disconnected dir inode 1076839796, moving to lost+found
disconnected dir inode 1076839797, moving to lost+found
disconnected dir inode 1076839798, moving to lost+found
disconnected dir inode 1076839799, moving to lost+found
disconnected dir inode 1076839800, moving to lost+found
disconnected dir inode 1076839801, moving to lost+found
disconnected dir inode 1076839802, moving to lost+found
disconnected dir inode 1076839803, moving to lost+found
disconnected dir inode 1076839804, moving to lost+found
disconnected dir inode 1076839805, moving to lost+found
disconnected dir inode 1076839806, moving to lost+found
disconnected dir inode 1076839807, moving to lost+found
disconnected dir inode 1076839808, moving to lost+found
disconnected dir inode 1076839809, moving to lost+found
disconnected dir inode 1076839810, moving to lost+found
disconnected dir inode 1076839812, moving to lost+found
disconnected dir inode 1076839817, moving to lost+found
disconnected dir inode 1076839818, moving to lost+found
disconnected dir inode 1076839819, moving to lost+found
disconnected dir inode 1076839823, moving to lost+found
disconnected dir inode 1076839825, moving to lost+found
disconnected dir inode 1076839826, moving to lost+found
disconnected dir inode 1076839827, moving to lost+found
disconnected dir inode 1076839828, moving to lost+found
disconnected dir inode 1076839831, moving to lost+found
disconnected dir inode 1076839833, moving to lost+found
disconnected dir inode 1076839834, moving to lost+found
disconnected dir inode 1076839835, moving to lost+found
disconnected dir inode 1076839836, moving to lost+found
disconnected dir inode 1076839837, moving to lost+found
disconnected dir inode 1076839838, moving to lost+found
disconnected dir inode 1076848162, moving to lost+found
disconnected dir inode 1076848164, moving to lost+found
disconnected dir inode 1076848169, moving to lost+found
disconnected dir inode 1076848170, moving to lost+found
disconnected dir inode 1076848171, moving to lost+found
disconnected dir inode 1076848173, moving to lost+found
disconnected dir inode 1076848174, moving to lost+found
disconnected dir inode 1076848175, moving to lost+found
disconnected dir inode 1076848176, moving to lost+found
disconnected dir inode 1076848177, moving to lost+found
disconnected dir inode 1076848178, moving to lost+found
disconnected dir inode 1076848179, moving to lost+found
disconnected dir inode 1076848182, moving to lost+found
disconnected dir inode 1076848183, moving to lost+found
disconnected dir inode 1076848184, moving to lost+found
disconnected dir inode 1076848185, moving to lost+found
disconnected dir inode 1076848186, moving to lost+found
disconnected dir inode 1076848187, moving to lost+found
disconnected dir inode 1076848194, moving to lost+found
disconnected dir inode 1076848195, moving to lost+found
disconnected dir inode 1076848196, moving to lost+found
disconnected dir inode 1076848197, moving to lost+found
disconnected dir inode 1076848198, moving to lost+found
disconnected dir inode 1076848199, moving to lost+found
disconnected dir inode 1076848200, moving to lost+found
disconnected dir inode 1076848201, moving to lost+found
disconnected dir inode 1076848202, moving to lost+found
disconnected dir inode 1076848203, moving to lost+found
disconnected dir inode 1076848204, moving to lost+found
disconnected dir inode 1076848205, moving to lost+found
disconnected dir inode 1076848206, moving to lost+found
disconnected dir inode 1076848207, moving to lost+found
disconnected dir inode 1076848208, moving to lost+found
disconnected dir inode 1076848209, moving to lost+found
disconnected dir inode 1076848210, moving to lost+found
disconnected dir inode 1076848211, moving to lost+found
disconnected dir inode 1076848212, moving to lost+found
disconnected dir inode 1076848213, moving to lost+found
disconnected dir inode 1076848214, moving to lost+found
disconnected dir inode 1076848219, moving to lost+found
disconnected dir inode 1076848221, moving to lost+found
disconnected dir inode 1076848222, moving to lost+found
disconnected dir inode 1076853088, moving to lost+found
disconnected dir inode 1076853089, moving to lost+found
disconnected dir inode 1076853091, moving to lost+found
disconnected dir inode 1076853104, moving to lost+found
disconnected dir inode 1076853105, moving to lost+found
disconnected dir inode 1076853106, moving to lost+found
disconnected dir inode 1076853107, moving to lost+found
disconnected dir inode 1076853109, moving to lost+found
disconnected dir inode 1076853110, moving to lost+found
disconnected dir inode 1076853111, moving to lost+found
disconnected dir inode 1076853114, moving to lost+found
disconnected dir inode 1076853119, moving to lost+found
disconnected dir inode 1076853126, moving to lost+found
disconnected dir inode 1076853127, moving to lost+found
disconnected dir inode 1076853128, moving to lost+found
disconnected dir inode 1076853129, moving to lost+found
disconnected dir inode 1076853130, moving to lost+found
disconnected dir inode 1076853131, moving to lost+found
disconnected dir inode 1076853132, moving to lost+found
disconnected dir inode 1076853133, moving to lost+found
disconnected dir inode 1076853134, moving to lost+found
disconnected dir inode 1076853135, moving to lost+found
disconnected dir inode 1076853136, moving to lost+found
disconnected dir inode 1076853137, moving to lost+found
disconnected dir inode 1076853138, moving to lost+found
disconnected dir inode 1076853139, moving to lost+found
disconnected dir inode 1076853140, moving to lost+found
disconnected dir inode 1076853143, moving to lost+found
disconnected dir inode 1076853144, moving to lost+found
disconnected dir inode 1076853145, moving to lost+found
disconnected dir inode 1076853146, moving to lost+found
disconnected dir inode 1076853147, moving to lost+found
disconnected dir inode 1076853148, moving to lost+found
disconnected dir inode 1076853149, moving to lost+found
disconnected dir inode 1076853150, moving to lost+found
disconnected dir inode 1076853151, moving to lost+found
disconnected dir inode 1076854592, moving to lost+found
disconnected dir inode 1076854593, moving to lost+found
disconnected dir inode 1076854594, moving to lost+found
disconnected dir inode 1076854595, moving to lost+found
disconnected dir inode 1076854596, moving to lost+found
disconnected dir inode 1076854597, moving to lost+found
disconnected dir inode 1076854598, moving to lost+found
disconnected dir inode 1076854599, moving to lost+found
disconnected dir inode 1076854600, moving to lost+found
disconnected dir inode 1076854601, moving to lost+found
disconnected dir inode 1076854602, moving to lost+found
disconnected dir inode 1076854603, moving to lost+found
disconnected dir inode 1076854604, moving to lost+found
disconnected dir inode 1076854605, moving to lost+found
disconnected dir inode 1076854606, moving to lost+found
disconnected dir inode 1076854607, moving to lost+found
disconnected dir inode 1076854608, moving to lost+found
disconnected dir inode 1076854609, moving to lost+found
disconnected dir inode 1076854610, moving to lost+found
disconnected dir inode 1076854611, moving to lost+found
disconnected dir inode 1076854612, moving to lost+found
disconnected dir inode 1076854613, moving to lost+found
disconnected dir inode 1076854614, moving to lost+found
disconnected dir inode 1076854615, moving to lost+found
disconnected dir inode 1076854616, moving to lost+found
disconnected dir inode 1076854617, moving to lost+found
disconnected dir inode 1076854619, moving to lost+found
disconnected dir inode 1076854620, moving to lost+found
disconnected dir inode 1076854621, moving to lost+found
disconnected dir inode 1076854622, moving to lost+found
disconnected dir inode 1076854623, moving to lost+found
disconnected dir inode 1076854624, moving to lost+found
disconnected dir inode 1076854625, moving to lost+found
disconnected dir inode 1076854626, moving to lost+found
disconnected dir inode 1076854627, moving to lost+found
disconnected dir inode 1076854628, moving to lost+found
disconnected dir inode 1076854630, moving to lost+found
disconnected dir inode 1076854631, moving to lost+found
disconnected dir inode 1076854632, moving to lost+found
disconnected dir inode 1076854633, moving to lost+found
disconnected dir inode 1076854634, moving to lost+found
disconnected dir inode 1076854635, moving to lost+found
disconnected dir inode 1076854636, moving to lost+found
disconnected dir inode 1076854637, moving to lost+found
disconnected dir inode 1076854638, moving to lost+found
disconnected dir inode 1076854639, moving to lost+found
disconnected dir inode 1076854640, moving to lost+found
disconnected dir inode 1076854641, moving to lost+found
disconnected dir inode 1076854642, moving to lost+found
disconnected dir inode 1076854643, moving to lost+found
disconnected dir inode 1076854644, moving to lost+found
disconnected dir inode 1076854645, moving to lost+found
disconnected dir inode 1076854646, moving to lost+found
disconnected dir inode 1076854647, moving to lost+found
disconnected dir inode 1076854648, moving to lost+found
disconnected dir inode 1076854649, moving to lost+found
disconnected dir inode 1076854650, moving to lost+found
disconnected dir inode 1076854651, moving to lost+found
disconnected dir inode 1076854652, moving to lost+found
disconnected dir inode 1076854653, moving to lost+found
disconnected dir inode 1076854654, moving to lost+found
disconnected dir inode 1076854655, moving to lost+found
disconnected dir inode 1076860256, moving to lost+found
disconnected dir inode 1076860257, moving to lost+found
disconnected dir inode 1076860258, moving to lost+found
disconnected dir inode 1076860259, moving to lost+found
disconnected dir inode 1076860260, moving to lost+found
disconnected dir inode 1076860261, moving to lost+found
disconnected dir inode 1076860262, moving to lost+found
disconnected dir inode 1076860263, moving to lost+found
disconnected dir inode 1076860264, moving to lost+found
disconnected dir inode 1076860265, moving to lost+found
disconnected dir inode 1076860266, moving to lost+found
disconnected dir inode 1076860267, moving to lost+found
disconnected dir inode 1076860268, moving to lost+found
disconnected dir inode 1076860269, moving to lost+found
disconnected dir inode 1076860270, moving to lost+found
disconnected dir inode 1077602207, moving to lost+found
disconnected dir inode 1077602228, moving to lost+found
disconnected dir inode 1077602230, moving to lost+found
disconnected dir inode 1077652948, moving to lost+found
disconnected dir inode 1077652957, moving to lost+found
disconnected dir inode 1077652960, moving to lost+found
disconnected dir inode 1080545558, moving to lost+found
disconnected dir inode 1092459354, moving to lost+found
disconnected dir inode 1092503224, moving to lost+found
disconnected dir inode 1092503243, moving to lost+found
disconnected dir inode 1098129057, moving to lost+found
disconnected dir inode 1098129058, moving to lost+found
disconnected dir inode 1098129059, moving to lost+found
disconnected dir inode 1098129060, moving to lost+found
disconnected dir inode 1098129061, moving to lost+found
disconnected dir inode 1098129062, moving to lost+found
disconnected dir inode 1098129063, moving to lost+found
disconnected dir inode 1098129064, moving to lost+found
disconnected dir inode 1098129065, moving to lost+found
disconnected dir inode 1098129066, moving to lost+found
disconnected dir inode 1098129067, moving to lost+found
disconnected dir inode 1098129068, moving to lost+found
disconnected dir inode 1098129069, moving to lost+found
disconnected dir inode 1098129070, moving to lost+found
disconnected dir inode 1098129071, moving to lost+found
disconnected dir inode 1098129072, moving to lost+found
disconnected dir inode 1098465506, moving to lost+found
disconnected dir inode 1098465507, moving to lost+found
disconnected dir inode 1098465510, moving to lost+found
disconnected dir inode 1098465511, moving to lost+found
disconnected dir inode 1098465515, moving to lost+found
disconnected dir inode 1098465519, moving to lost+found
disconnected dir inode 1098465523, moving to lost+found
disconnected dir inode 1098465524, moving to lost+found
disconnected dir inode 1098465528, moving to lost+found
disconnected dir inode 1098465529, moving to lost+found
disconnected dir inode 1098465530, moving to lost+found
disconnected dir inode 1098465536, moving to lost+found
disconnected dir inode 1098465537, moving to lost+found
disconnected dir inode 1098465543, moving to lost+found
disconnected dir inode 1098465544, moving to lost+found
disconnected dir inode 1098465545, moving to lost+found
disconnected dir inode 1098465547, moving to lost+found
disconnected dir inode 1098465548, moving to lost+found
disconnected dir inode 1098465549, moving to lost+found
disconnected dir inode 1098465550, moving to lost+found
disconnected dir inode 1098465552, moving to lost+found
disconnected dir inode 1147256007, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 128 nlinks from 2 to 3
Note - quota info will be regenerated on next quota mount.
done

--------------040805010700020206070201
Content-Type: text/plain;
 name="xfs_check.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfs_check.log"

cache_node_purge: refcount was 1, not zero (node=0x820010)
xfs_check: cannot read root inode (117)
cache_node_purge: refcount was 1, not zero (node=0x8226b0)
xfs_check: cannot read realtime bitmap inode (117)
block 0/8 expected type unknown got log
block 0/9 expected type unknown got log
block 0/10 expected type unknown got log
block 0/11 expected type unknown got log
bad magic number 0xfeed for inode 128
bad magic number 0 for inode 129
bad magic number 0xfeed for inode 130
bad magic number 0 for inode 131
bad magic number 0xfeed for inode 132
bad magic number 0 for inode 133
bad magic number 0xfeed for inode 134
bad magic number 0 for inode 135
bad magic number 0xfeed for inode 136
bad magic number 0 for inode 137
bad magic number 0xfeed for inode 138
bad magic number 0 for inode 139
bad magic number 0xfeed for inode 140
bad magic number 0 for inode 141
bad magic number 0xfeed for inode 142
bad magic number 0 for inode 143
bad magic number 0xfeed for inode 144
bad magic number 0 for inode 145
bad magic number 0xfeed for inode 146
bad magic number 0 for inode 147
bad magic number 0xfeed for inode 148
bad magic number 0 for inode 149
bad magic number 0xfeed for inode 150
bad magic number 0 for inode 151
bad magic number 0xfeed for inode 152
bad magic number 0 for inode 153
bad magic number 0xfeed for inode 154
bad magic number 0 for inode 155
bad magic number 0xfeed for inode 156
bad magic number 0 for inode 157
bad magic number 0xfeed for inode 158
bad magic number 0 for inode 159
bad magic number 0xfeed for inode 160
bad magic number 0 for inode 161
bad magic number 0xfeed for inode 162
bad magic number 0 for inode 163
bad magic number 0xfeed for inode 164
bad magic number 0 for inode 165
bad magic number 0xfeed for inode 166
bad magic number 0 for inode 167
bad magic number 0xfeed for inode 168
bad magic number 0 for inode 169
bad magic number 0xfeed for inode 170
bad magic number 0 for inode 171
bad magic number 0xfeed for inode 172
bad magic number 0 for inode 173
bad magic number 0xfeed for inode 174
bad magic number 0 for inode 175
bad magic number 0xfeed for inode 176
bad magic number 0 for inode 177
bad magic number 0xfeed for inode 178
bad magic number 0 for inode 179
bad magic number 0xfeed for inode 180
bad magic number 0 for inode 181
bad magic number 0xfeed for inode 182
bad magic number 0 for inode 183
bad magic number 0xfeed for inode 184
bad magic number 0 for inode 185
bad magic number 0xfeed for inode 186
bad magic number 0 for inode 187
bad magic number 0xfeed for inode 188
bad magic number 0 for inode 189
bad magic number 0xfeed for inode 190
bad magic number 0 for inode 191
root inode 128 is not a directory
block 0/389453 type unknown not expected
block 0/389457 type unknown not expected
block 0/389458 type unknown not expected
block 0/481472 type unknown not expected
block 0/8778188 type unknown not expected
block 0/8778189 type unknown not expected
block 0/8778190 type unknown not expected
block 0/17162349 type unknown not expected
allocated inode 128 has 0 link count
allocated inode 129 has 0 link count
allocated inode 130 has 0 link count
link count mismatch for inode 131 (name ?), nlink 0, counted 635
link count mismatch for inode 190881713 (name ?), nlink 2, counted 1
disconnected inode 5667475, nlink 1
link count mismatch for inode 240441693 (name ?), nlink 2, counted 1
disconnected inode 125908558, nlink 1
disconnected inode 125908559, nlink 1
disconnected inode 125908560, nlink 1
link count mismatch for inode 125005217 (name ?), nlink 2, counted 1
link count mismatch for inode 125005218 (name ?), nlink 2, counted 1
link count mismatch for inode 125005219 (name ?), nlink 2, counted 1
link count mismatch for inode 125005221 (name ?), nlink 2, counted 1
link count mismatch for inode 125005222 (name ?), nlink 2, counted 1
link count mismatch for inode 125005223 (name ?), nlink 2, counted 1
link count mismatch for inode 125005224 (name ?), nlink 2, counted 1
link count mismatch for inode 125005225 (name ?), nlink 2, counted 1
link count mismatch for inode 125005226 (name ?), nlink 2, counted 1
link count mismatch for inode 125005228 (name ?), nlink 2, counted 1
link count mismatch for inode 125005229 (name ?), nlink 2, counted 1
link count mismatch for inode 125005230 (name ?), nlink 2, counted 1
link count mismatch for inode 125005231 (name ?), nlink 2, counted 1
link count mismatch for inode 125005232 (name ?), nlink 2, counted 1
link count mismatch for inode 125005233 (name ?), nlink 2, counted 1
link count mismatch for inode 125005236 (name ?), nlink 2, counted 1
link count mismatch for inode 125005237 (name ?), nlink 2, counted 1
link count mismatch for inode 125005238 (name ?), nlink 2, counted 1
link count mismatch for inode 125005239 (name ?), nlink 2, counted 1
link count mismatch for inode 125005240 (name ?), nlink 2, counted 1
link count mismatch for inode 125005241 (name ?), nlink 3, counted 2
link count mismatch for inode 125005242 (name ?), nlink 2, counted 1
link count mismatch for inode 125005243 (name ?), nlink 2, counted 1
link count mismatch for inode 125005244 (name ?), nlink 2, counted 1
link count mismatch for inode 125005245 (name ?), nlink 2, counted 1
link count mismatch for inode 125005247 (name ?), nlink 2, counted 1
link count mismatch for inode 125005248 (name ?), nlink 2, counted 1
link count mismatch for inode 125005249 (name ?), nlink 2, counted 1
link count mismatch for inode 125005250 (name ?), nlink 2, counted 1
link count mismatch for inode 125005251 (name ?), nlink 2, counted 1
link count mismatch for inode 125005252 (name ?), nlink 2, counted 1
link count mismatch for inode 125005253 (name ?), nlink 2, counted 1
link count mismatch for inode 125005254 (name ?), nlink 2, counted 1
link count mismatch for inode 125005255 (name ?), nlink 2, counted 1
link count mismatch for inode 125005256 (name ?), nlink 2, counted 1
link count mismatch for inode 125005257 (name ?), nlink 2, counted 1
link count mismatch for inode 125005259 (name ?), nlink 2, counted 1
link count mismatch for inode 125005260 (name ?), nlink 2, counted 1
link count mismatch for inode 125005262 (name ?), nlink 2, counted 1
link count mismatch for inode 125005263 (name ?), nlink 2, counted 1
link count mismatch for inode 125005264 (name ?), nlink 2, counted 1
link count mismatch for inode 125005265 (name ?), nlink 2, counted 1
link count mismatch for inode 125005266 (name ?), nlink 2, counted 1
link count mismatch for inode 125005267 (name ?), nlink 2, counted 1
link count mismatch for inode 125005268 (name ?), nlink 2, counted 1
link count mismatch for inode 125005269 (name ?), nlink 2, counted 1
link count mismatch for inode 125005270 (name ?), nlink 2, counted 1
link count mismatch for inode 125005271 (name ?), nlink 2, counted 1
link count mismatch for inode 125005272 (name ?), nlink 2, counted 1
link count mismatch for inode 125005273 (name ?), nlink 2, counted 1
link count mismatch for inode 125005274 (name ?), nlink 2, counted 1
link count mismatch for inode 125005275 (name ?), nlink 2, counted 1
link count mismatch for inode 125005276 (name ?), nlink 2, counted 1
link count mismatch for inode 125005277 (name ?), nlink 2, counted 1
link count mismatch for inode 125005278 (name ?), nlink 2, counted 1
link count mismatch for inode 125005279 (name ?), nlink 2, counted 1
link count mismatch for inode 125005568 (name ?), nlink 2, counted 1
link count mismatch for inode 125005569 (name ?), nlink 2, counted 1
link count mismatch for inode 125005571 (name ?), nlink 2, counted 1
link count mismatch for inode 125005572 (name ?), nlink 2, counted 1
link count mismatch for inode 125005573 (name ?), nlink 2, counted 1
link count mismatch for inode 125005574 (name ?), nlink 2, counted 1
link count mismatch for inode 125005575 (name ?), nlink 2, counted 1
link count mismatch for inode 125005576 (name ?), nlink 2, counted 1
link count mismatch for inode 125005577 (name ?), nlink 13, counted 12
link count mismatch for inode 125685326 (name ?), nlink 2, counted 1
link count mismatch for inode 125685351 (name ?), nlink 8, counted 7
link count mismatch for inode 424256 (name ?), nlink 21, counted 20
disconnected inode 424257, nlink 1
disconnected inode 424258, nlink 1
link count mismatch for inode 125016316 (name ?), nlink 6, counted 5
link count mismatch for inode 126090218 (name ?), nlink 2, counted 1
link count mismatch for inode 126090220 (name ?), nlink 4, counted 3
link count mismatch for inode 126090224 (name ?), nlink 3, counted 2
link count mismatch for inode 130503573 (name ?), nlink 5, counted 4
link count mismatch for inode 164462811 (name ?), nlink 2, counted 1
link count mismatch for inode 164462812 (name ?), nlink 3, counted 2
link count mismatch for inode 164462813 (name ?), nlink 2, counted 1
link count mismatch for inode 164462814 (name ?), nlink 2, counted 1
link count mismatch for inode 164462815 (name ?), nlink 2, counted 1
link count mismatch for inode 164462816 (name ?), nlink 2, counted 1
link count mismatch for inode 164462817 (name ?), nlink 2, counted 1
link count mismatch for inode 164462818 (name ?), nlink 5, counted 4
link count mismatch for inode 164462819 (name ?), nlink 2, counted 1
link count mismatch for inode 164462820 (name ?), nlink 2, counted 1
link count mismatch for inode 164462821 (name ?), nlink 2, counted 1
link count mismatch for inode 164462822 (name ?), nlink 2, counted 1
link count mismatch for inode 164462823 (name ?), nlink 2, counted 1
link count mismatch for inode 164462824 (name ?), nlink 2, counted 1
link count mismatch for inode 164462825 (name ?), nlink 2, counted 1
link count mismatch for inode 164462826 (name ?), nlink 2, counted 1
link count mismatch for inode 125660420 (name ?), nlink 2, counted 1
link count mismatch for inode 1092503224 (name ?), nlink 2, counted 1
link count mismatch for inode 1092503243 (name ?), nlink 5, counted 4
link count mismatch for inode 1147256007 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853088 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853089 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853091 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853104 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853105 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853106 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853107 (name ?), nlink 3, counted 2
link count mismatch for inode 1076853109 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853110 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853111 (name ?), nlink 3, counted 2
link count mismatch for inode 1076853114 (name ?), nlink 6, counted 5
link count mismatch for inode 1076853119 (name ?), nlink 8, counted 7
link count mismatch for inode 1076853126 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853127 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853128 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853129 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853130 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853131 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853132 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853133 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853134 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853135 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853136 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853137 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853138 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853139 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853140 (name ?), nlink 4, counted 3
link count mismatch for inode 1076853143 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853144 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853145 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853146 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853147 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853148 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853149 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853150 (name ?), nlink 2, counted 1
link count mismatch for inode 1076853151 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797385 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797389 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797390 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797391 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797393 (name ?), nlink 3, counted 2
link count mismatch for inode 1076797395 (name ?), nlink 5, counted 4
link count mismatch for inode 1076797399 (name ?), nlink 3, counted 2
link count mismatch for inode 1076797407 (name ?), nlink 5, counted 4
link count mismatch for inode 1076797408 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797410 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797411 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797412 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797413 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797417 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797418 (name ?), nlink 3, counted 2
link count mismatch for inode 1076797420 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797421 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797422 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797423 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797424 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797425 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797426 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797427 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797428 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797429 (name ?), nlink 5, counted 4
link count mismatch for inode 1076797433 (name ?), nlink 5, counted 4
link count mismatch for inode 1076797437 (name ?), nlink 3, counted 2
link count mismatch for inode 1076797438 (name ?), nlink 3, counted 2
link count mismatch for inode 1076797440 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797442 (name ?), nlink 4, counted 3
link count mismatch for inode 1076797445 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797446 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797447 (name ?), nlink 5, counted 4
link count mismatch for inode 1076797451 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797455 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797459 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797461 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797462 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797463 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797464 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797465 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797466 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797467 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797468 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797469 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797470 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797471 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797472 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797473 (name ?), nlink 6, counted 5
link count mismatch for inode 1076797474 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797479 (name ?), nlink 3, counted 2
link count mismatch for inode 1076797481 (name ?), nlink 7, counted 6
link count mismatch for inode 1076797488 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797490 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797491 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797492 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797493 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797494 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797495 (name ?), nlink 7, counted 6
link count mismatch for inode 1076797496 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797497 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797498 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797500 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797502 (name ?), nlink 2, counted 1
link count mismatch for inode 1076797503 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854592 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854593 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854594 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854595 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854596 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854597 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854598 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854599 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854600 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854601 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854602 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854603 (name ?), nlink 3, counted 2
link count mismatch for inode 1076854604 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854605 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854606 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854607 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854608 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854609 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854610 (name ?), nlink 3, counted 2
link count mismatch for inode 1076854611 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854612 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854613 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854614 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854615 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854616 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854617 (name ?), nlink 5, counted 4
link count mismatch for inode 1076854619 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854620 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854621 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854622 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854623 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854624 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854625 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854626 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854627 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854628 (name ?), nlink 4, counted 3
link count mismatch for inode 1076854630 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854631 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854632 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854633 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854634 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854635 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854636 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854637 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854638 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854639 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854640 (name ?), nlink 3, counted 2
link count mismatch for inode 1076854641 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854642 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854643 (name ?), nlink 3, counted 2
link count mismatch for inode 1076854644 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854645 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854646 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854647 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854648 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854649 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854650 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854651 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854652 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854653 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854654 (name ?), nlink 2, counted 1
link count mismatch for inode 1076854655 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051900 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051901 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051902 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051903 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051908 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051909 (name ?), nlink 3, counted 2
link count mismatch for inode 1075051910 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051912 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051913 (name ?), nlink 3, counted 2
link count mismatch for inode 1075051915 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051916 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051917 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051918 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051919 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051920 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051921 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051922 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051923 (name ?), nlink 14, counted 13
link count mismatch for inode 1075051930 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051931 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051932 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051933 (name ?), nlink 2, counted 1
link count mismatch for inode 1075051934 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860256 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860257 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860258 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860259 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860260 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860261 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860262 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860263 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860264 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860265 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860266 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860267 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860268 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860269 (name ?), nlink 2, counted 1
link count mismatch for inode 1076860270 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805248 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805249 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805254 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805255 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805256 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805257 (name ?), nlink 3, counted 2
link count mismatch for inode 1076805259 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805260 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805261 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805262 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805263 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805266 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805267 (name ?), nlink 3, counted 2
link count mismatch for inode 1076805268 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805269 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805270 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805272 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805273 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805274 (name ?), nlink 5, counted 4
link count mismatch for inode 1076805276 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805277 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805278 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805279 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805280 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805281 (name ?), nlink 5, counted 4
link count mismatch for inode 1076805286 (name ?), nlink 3, counted 2
link count mismatch for inode 1076805288 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805293 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805294 (name ?), nlink 6, counted 5
link count mismatch for inode 1076805295 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805296 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805297 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805298 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805299 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805300 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805301 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805307 (name ?), nlink 2, counted 1
link count mismatch for inode 1076805308 (name ?), nlink 2, counted 1
link count mismatch for inode 1077652948 (name ?), nlink 8, counted 7
link count mismatch for inode 1077652957 (name ?), nlink 3, counted 2
link count mismatch for inode 1077652960 (name ?), nlink 5, counted 4
link count mismatch for inode 1092459354 (name ?), nlink 4, counted 3
link count mismatch for inode 1076809126 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809135 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809136 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809137 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809141 (name ?), nlink 3, counted 2
link count mismatch for inode 1076809143 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809144 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809145 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809146 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809147 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809148 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809149 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809150 (name ?), nlink 9, counted 8
link count mismatch for inode 1076809158 (name ?), nlink 5, counted 4
link count mismatch for inode 1076809162 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809163 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809164 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809165 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809166 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809167 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809168 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809169 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809170 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809171 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809172 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809173 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809174 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809175 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809176 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809177 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809178 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809179 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809180 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809181 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809182 (name ?), nlink 2, counted 1
link count mismatch for inode 1076809183 (name ?), nlink 2, counted 1
link count mismatch for inode 1077602207 (name ?), nlink 10, counted 9
link count mismatch for inode 1077602228 (name ?), nlink 5, counted 4
link count mismatch for inode 1077602230 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811200 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811201 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811202 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811203 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811204 (name ?), nlink 6, counted 5
link count mismatch for inode 1076811206 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811210 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811211 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811212 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811213 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811214 (name ?), nlink 5, counted 4
link count mismatch for inode 1076811215 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811216 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811219 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811220 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811221 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811224 (name ?), nlink 4, counted 3
link count mismatch for inode 1076811227 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811228 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811229 (name ?), nlink 5, counted 4
link count mismatch for inode 1076811233 (name ?), nlink 6, counted 5
link count mismatch for inode 1076811238 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811239 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811240 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811242 (name ?), nlink 5, counted 4
link count mismatch for inode 1076811247 (name ?), nlink 10, counted 9
link count mismatch for inode 1076811248 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811251 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811252 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811253 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811254 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811255 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811256 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811258 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811259 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811260 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811261 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811262 (name ?), nlink 2, counted 1
link count mismatch for inode 1076811263 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117888 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117889 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117890 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117891 (name ?), nlink 5, counted 4
link count mismatch for inode 1075117896 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117897 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117902 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117903 (name ?), nlink 4, counted 3
link count mismatch for inode 1075117907 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117908 (name ?), nlink 2, counted 1
link count mismatch for inode 1075117939 (name ?), nlink 2, counted 1
link count mismatch for inode 1080545558 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818528 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818529 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818531 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818532 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818541 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818542 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818543 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818544 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818545 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818546 (name ?), nlink 7, counted 6
link count mismatch for inode 1076818548 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818549 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818550 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818554 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818555 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818556 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818557 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818558 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818559 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818561 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818562 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818563 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818564 (name ?), nlink 5, counted 4
link count mismatch for inode 1076818565 (name ?), nlink 4, counted 3
link count mismatch for inode 1076818566 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818567 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818569 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818570 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818577 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818578 (name ?), nlink 6, counted 5
link count mismatch for inode 1076818587 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818588 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818589 (name ?), nlink 3, counted 2
link count mismatch for inode 1076818590 (name ?), nlink 2, counted 1
link count mismatch for inode 1076818591 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465506 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465507 (name ?), nlink 4, counted 3
link count mismatch for inode 1098465510 (name ?), nlink 6, counted 5
link count mismatch for inode 1098465511 (name ?), nlink 5, counted 4
link count mismatch for inode 1098465515 (name ?), nlink 5, counted 4
link count mismatch for inode 1098465519 (name ?), nlink 5, counted 4
link count mismatch for inode 1098465523 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465524 (name ?), nlink 5, counted 4
link count mismatch for inode 1098465528 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465529 (name ?), nlink 5, counted 4
link count mismatch for inode 1098465530 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465536 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465537 (name ?), nlink 6, counted 5
link count mismatch for inode 1098465543 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465544 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465545 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465547 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465548 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465549 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465550 (name ?), nlink 2, counted 1
link count mismatch for inode 1098465552 (name ?), nlink 2, counted 1
link count mismatch for inode 1075244397 (name ?), nlink 3, counted 2
link count mismatch for inode 1075244399 (name ?), nlink 2, counted 1
link count mismatch for inode 1075244400 (name ?), nlink 2, counted 1
link count mismatch for inode 1075244401 (name ?), nlink 2, counted 1
link count mismatch for inode 1075244402 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129057 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129058 (name ?), nlink 3, counted 2
link count mismatch for inode 1098129059 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129060 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129061 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129062 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129063 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129064 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129065 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129066 (name ?), nlink 3, counted 2
link count mismatch for inode 1098129067 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129068 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129069 (name ?), nlink 2, counted 1
link count mismatch for inode 1098129070 (name ?), nlink 3, counted 2
link count mismatch for inode 1098129071 (name ?), nlink 3, counted 2
link count mismatch for inode 1098129072 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828510 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828544 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828545 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828546 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828547 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828548 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828549 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828550 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828551 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828554 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828555 (name ?), nlink 8, counted 7
link count mismatch for inode 1076828562 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828563 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828564 (name ?), nlink 3, counted 2
link count mismatch for inode 1076828565 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828570 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828571 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828572 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828573 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828574 (name ?), nlink 3, counted 2
link count mismatch for inode 1076828575 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828576 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828577 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828578 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828579 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828594 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828595 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828596 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828597 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828598 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828599 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828600 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828601 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828602 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828603 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828604 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828605 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828606 (name ?), nlink 2, counted 1
link count mismatch for inode 1076828607 (name ?), nlink 2, counted 1
link count mismatch for inode 1076383229 (name ?), nlink 2, counted 1
link count mismatch for inode 1076383230 (name ?), nlink 6, counted 5
link count mismatch for inode 1076839776 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839777 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839778 (name ?), nlink 3, counted 2
link count mismatch for inode 1076839779 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839780 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839782 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839783 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839784 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839785 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839786 (name ?), nlink 5, counted 4
link count mismatch for inode 1076839790 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839791 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839792 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839793 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839794 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839795 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839796 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839797 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839798 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839799 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839800 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839801 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839802 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839803 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839804 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839805 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839806 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839807 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839808 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839809 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839810 (name ?), nlink 7, counted 6
link count mismatch for inode 1076839812 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839817 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839818 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839819 (name ?), nlink 5, counted 4
link count mismatch for inode 1076839823 (name ?), nlink 3, counted 2
link count mismatch for inode 1076839825 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839826 (name ?), nlink 5, counted 4
link count mismatch for inode 1076839827 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839828 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839831 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839833 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839834 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839835 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839836 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839837 (name ?), nlink 2, counted 1
link count mismatch for inode 1076839838 (name ?), nlink 5, counted 4
link count mismatch for inode 1076848162 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848164 (name ?), nlink 6, counted 5
link count mismatch for inode 1076848169 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848170 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848171 (name ?), nlink 3, counted 2
link count mismatch for inode 1076848173 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848174 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848175 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848176 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848177 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848178 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848179 (name ?), nlink 4, counted 3
link count mismatch for inode 1076848182 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848183 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848184 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848185 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848186 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848187 (name ?), nlink 7, counted 6
link count mismatch for inode 1076848194 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848195 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848196 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848197 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848198 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848199 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848200 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848201 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848202 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848203 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848204 (name ?), nlink 6, counted 5
link count mismatch for inode 1076848205 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848206 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848207 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848208 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848209 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848210 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848211 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848212 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848213 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848214 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848219 (name ?), nlink 6, counted 5
link count mismatch for inode 1076848221 (name ?), nlink 2, counted 1
link count mismatch for inode 1076848222 (name ?), nlink 3, counted 2

--------------040805010700020206070201
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------040805010700020206070201--
