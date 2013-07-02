Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 190D77F3F
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 12:17:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD38E8F808E
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 10:17:38 -0700 (PDT)
Received: from krypton.gent.grid-vfx.com (d5153058D.static.telenet.be
	[81.83.5.141]) by cuda.sgi.com with ESMTP id sBquZmYc5GrNyAwV
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Jul 2013 10:17:36 -0700 (PDT)
Received: from idefix.gent.grid-vfx.com ([200.0.0.92] helo=idefix.grid-vfx.com)
	by krypton.gent.grid-vfx.com with esmtp (Exim 4.72)
	(envelope-from <kbr@grid-vfx.com>) id 1Uu4Cs-0000JP-Py
	for xfs@oss.sgi.com; Tue, 02 Jul 2013 19:17:34 +0200
Received: from kbr by idefix.grid-vfx.com with local (Exim 4.72)
	(envelope-from <kbr@idefix.grid-vfx.com>) id 1Uu4Cs-0002v9-MT
	for xfs@oss.sgi.com; Tue, 02 Jul 2013 19:17:34 +0200
Date: Tue, 2 Jul 2013 19:17:34 +0200
From: Koen Breugelmans <koen.br@grid-vfx.com>
Subject: Internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20130702171734.GA6187@grid-vfx.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hey, 

last night on of our filesystems filled up (which is another problem ;), and
when that happened, i noticed the following error twice in the syslog: 

	XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1320 of file /build/buildd-linux_3.2.35-1-i386-9hA0hl/linux-3.2.35/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa03e9abd

more complete log excerpt + call trace attached. 

i reacted by mounting that filesystem read-only, running an 'xfs_repair -n'
on it. because the apparent lack of trouble there, i continued by unmounting
the filesystem in all, then running a normal 'xfs_repair' (both output of
dry-run and real thing attached).

can somebody explain what happened here?

the filesystem rides on top of an LVM logical volume here if that might be
of any relevance.  there were (some) free physical extents in the volume
group it was part of (used to extend the LV, and grow the FS -- none of
which happened until the xfs_repair was completed)

let me know if you want some other specific information.


kind regards, 
-- 
	/ Koen Breugelmans (koen.br@grid-vfx.com)
	/ systeembeheer GRID-VFX

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs-rushes-repair-info.txt"

[3016734.678367] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1320 of file /build/buildd-linux_3.2.35-1-i386-9hA0hl/linux-3.2.35/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa03e9abd
[3016734.678370] 
[3016734.678463] Pid: 13986, comm: kworker/0:0 Not tainted 3.2.0-4-amd64 #1 Debian 3.2.35-1
[3016734.678466] Call Trace:
[3016734.678489]  [<ffffffffa03e8f5f>] ? xfs_alloc_ag_vextent_size+0x3b1/0x566 [xfs]
[3016734.678505]  [<ffffffffa03e9abd>] ? xfs_alloc_ag_vextent+0x1f/0xbd [xfs]
[3016734.678521]  [<ffffffffa03ea2cf>] ? xfs_alloc_vextent+0x2c4/0x457 [xfs]
[3016734.678538]  [<ffffffffa03f45c3>] ? xfs_bmap_btalloc+0x418/0x571 [xfs]
[3016734.678555]  [<ffffffffa03f4a69>] ? xfs_bmapi_allocate+0x100/0x22c [xfs]
[3016734.678572]  [<ffffffffa03f6df9>] ? xfs_bmapi_write+0x2f1/0x59a [xfs]
[3016734.678585]  [<ffffffffa03dd89a>] ? xfs_iomap_write_allocate+0x1c8/0x2d8 [xfs]
[3016734.678596]  [<ffffffffa03d3dd7>] ? xfs_map_blocks+0x134/0x1d3 [xfs]
[3016734.678606]  [<ffffffffa03d471d>] ? xfs_vm_writepage+0x234/0x3e1 [xfs]
[3016734.678611]  [<ffffffff810baef2>] ? __writepage+0xa/0x21
[3016734.678615]  [<ffffffff810bad7a>] ? write_cache_pages+0x1f8/0x2e9
[3016734.678619]  [<ffffffff810baee8>] ? set_page_dirty_lock+0x2b/0x2b
[3016734.678623]  [<ffffffff810baea5>] ? generic_writepages+0x3a/0x52
[3016734.678628]  [<ffffffff810b4662>] ? __filemap_fdatawrite_range+0x4b/0x50
[3016734.678640]  [<ffffffffa03da670>] ? xfs_flush_pages+0x53/0x83 [xfs]
[3016734.678654]  [<ffffffffa03e2736>] ? xfs_sync_inode_data+0x62/0x7a [xfs]
[3016734.678668]  [<ffffffffa03e2a41>] ? xfs_inode_ag_walk.isra.6+0xe9/0x195 [xfs]
[3016734.678682]  [<ffffffffa03e26d4>] ? xfs_sync_worker+0x6a/0x6a [xfs]
[3016734.678700]  [<ffffffffa04121e3>] ? xfs_perag_get+0x38/0x84 [xfs]
[3016734.678714]  [<ffffffffa03e26d4>] ? xfs_sync_worker+0x6a/0x6a [xfs]
[3016734.678728]  [<ffffffffa03e2b2e>] ? xfs_inode_ag_iterator+0x41/0x88 [xfs]
[3016734.678742]  [<ffffffffa03e2bae>] ? xfs_sync_data+0x39/0x39 [xfs]
[3016734.678755]  [<ffffffffa03e2b8e>] ? xfs_sync_data+0x19/0x39 [xfs]
[3016734.678759]  [<ffffffff81059b77>] ? worker_set_flags+0x66/0x8f
[3016734.678773]  [<ffffffffa03e2bc3>] ? xfs_flush_worker+0x15/0x20 [xfs]
[3016734.678777]  [<ffffffff8105adf9>] ? process_one_work+0x163/0x284
[3016734.678781]  [<ffffffff8105af32>] ? process_scheduled_works+0x18/0x25
[3016734.678784]  [<ffffffff8105bdf2>] ? worker_thread+0xdc/0x145
[3016734.678788]  [<ffffffff8105bd16>] ? manage_workers.isra.25+0x15b/0x15b
[3016734.678792]  [<ffffffff8105ef0d>] ? kthread+0x76/0x7e
[3016734.678796]  [<ffffffff8134f2f4>] ? kernel_thread_helper+0x4/0x10
[3016734.678800]  [<ffffffff8105ee97>] ? kthread_worker_fn+0x139/0x139
[3016734.678804]  [<ffffffff8134f2f0>] ? gs_change+0x13/0x13
[3016734.678810] XFS (dm-3): page discard on page ffffea000a52c130, inode 0x5b80000088, offset 1559400448.
[3016735.644011] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1320 of file /build/buildd-linux_3.2.35-1-i386-9hA0hl/linux-3.2.35/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa03e9abd
[3016735.644013] 
[3016735.644107] Pid: 3451, comm: rsync Not tainted 3.2.0-4-amd64 #1 Debian 3.2.35-1
[3016735.644109] Call Trace:
[3016735.644128]  [<ffffffffa03e8f5f>] ? xfs_alloc_ag_vextent_size+0x3b1/0x566 [xfs]
[3016735.644139]  [<ffffffffa03e9abd>] ? xfs_alloc_ag_vextent+0x1f/0xbd [xfs]
[3016735.644149]  [<ffffffffa03ea2cf>] ? xfs_alloc_vextent+0x2c4/0x457 [xfs]
[3016735.644159]  [<ffffffffa03f45c3>] ? xfs_bmap_btalloc+0x418/0x571 [xfs]
[3016735.644170]  [<ffffffffa03f4a69>] ? xfs_bmapi_allocate+0x100/0x22c [xfs]
[3016735.644181]  [<ffffffffa03f6df9>] ? xfs_bmapi_write+0x2f1/0x59a [xfs]
[3016735.644190]  [<ffffffffa03dd89a>] ? xfs_iomap_write_allocate+0x1c8/0x2d8 [xfs]
[3016735.644197]  [<ffffffffa03d3dd7>] ? xfs_map_blocks+0x134/0x1d3 [xfs]
[3016735.644203]  [<ffffffffa03d471d>] ? xfs_vm_writepage+0x234/0x3e1 [xfs]
[3016735.644208]  [<ffffffff810baef2>] ? __writepage+0xa/0x21
[3016735.644210]  [<ffffffff810bad7a>] ? write_cache_pages+0x1f8/0x2e9
[3016735.644212]  [<ffffffff810baee8>] ? set_page_dirty_lock+0x2b/0x2b
[3016735.644215]  [<ffffffff810baea5>] ? generic_writepages+0x3a/0x52
[3016735.644218]  [<ffffffff810b4662>] ? __filemap_fdatawrite_range+0x4b/0x50
[3016735.644226]  [<ffffffffa03da670>] ? xfs_flush_pages+0x53/0x83 [xfs]
[3016735.644236]  [<ffffffffa03d8b9c>] ? xfs_file_buffered_aio_write+0x128/0x15c [xfs]
[3016735.644239]  [<ffffffff81036370>] ? should_resched+0x5/0x23
[3016735.644246]  [<ffffffffa03d8d40>] ? xfs_file_aio_write+0x170/0x20c [xfs]
[3016735.644249]  [<ffffffff810f89a8>] ? do_sync_write+0xb4/0xec
[3016735.644253]  [<ffffffff81162175>] ? security_file_permission+0x16/0x2d
[3016735.644255]  [<ffffffff810f9099>] ? vfs_write+0xa2/0xe9
[3016735.644257]  [<ffffffff810f9276>] ? sys_write+0x45/0x6b
[3016735.644260]  [<ffffffff8134f630>] ? sysenter_dispatch+0x7/0x2e
[3016735.644267] XFS (dm-3): page discard on page ffffea000a52c168, inode 0x5b80000088, offset 1559404544.
[3018799.264357] XFS (dm-3): Mounting Filesystem
[3018799.430348] XFS (dm-3): Ending clean mount

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs-rushes-repair-n.txt"

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
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
        - agno = 61
        - agno = 62
        - agno = 63
        - agno = 64
        - agno = 65
        - agno = 66
        - agno = 67
        - agno = 68
        - agno = 69
        - agno = 70
        - agno = 71
        - agno = 72
        - agno = 73
        - agno = 74
        - agno = 75
        - agno = 76
        - agno = 77
        - agno = 78
        - agno = 79
        - agno = 80
        - agno = 81
        - agno = 82
        - agno = 83
        - agno = 84
        - agno = 85
        - agno = 86
        - agno = 87
        - agno = 88
        - agno = 89
        - agno = 90
        - agno = 91
        - agno = 92
        - agno = 93
        - agno = 94
        - agno = 95
        - agno = 96
        - agno = 97
        - agno = 98
        - agno = 99
        - agno = 100
        - agno = 101
        - agno = 102
        - agno = 103
        - agno = 104
        - agno = 105
        - agno = 106
        - agno = 107
        - agno = 108
        - agno = 109
        - agno = 110
        - agno = 111
        - agno = 112
        - agno = 113
        - agno = 114
        - agno = 115
        - agno = 116
        - agno = 117
        - agno = 118
        - agno = 119
        - agno = 120
        - agno = 121
        - agno = 122
        - agno = 123
        - agno = 124
        - agno = 125
        - agno = 126
        - agno = 127
        - agno = 128
        - agno = 129
        - agno = 130
        - agno = 131
        - agno = 132
        - agno = 133
        - agno = 134
        - agno = 135
        - agno = 136
        - agno = 137
        - agno = 138
        - agno = 139
        - agno = 140
        - agno = 141
        - agno = 142
        - agno = 143
        - agno = 144
        - agno = 145
        - agno = 146
        - agno = 147
        - agno = 148
        - agno = 149
        - agno = 150
        - agno = 151
        - agno = 152
        - agno = 153
        - agno = 154
        - agno = 155
        - agno = 156
        - agno = 157
        - agno = 158
        - agno = 159
        - agno = 160
        - agno = 161
        - agno = 162
        - agno = 163
        - agno = 164
        - agno = 165
        - agno = 166
        - agno = 167
        - agno = 168
        - agno = 169
        - agno = 170
        - agno = 171
        - agno = 172
        - agno = 173
        - agno = 174
        - agno = 175
        - agno = 176
        - agno = 177
        - agno = 178
        - agno = 179
        - agno = 180
        - agno = 181
        - agno = 182
        - agno = 183
        - agno = 184
        - agno = 185
        - agno = 186
        - agno = 187
        - agno = 188
        - agno = 189
        - agno = 190
        - agno = 191
        - agno = 192
        - agno = 193
        - agno = 194
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
        - agno = 61
        - agno = 62
        - agno = 63
        - agno = 64
        - agno = 65
        - agno = 66
        - agno = 67
        - agno = 68
        - agno = 69
        - agno = 70
        - agno = 71
        - agno = 72
        - agno = 73
        - agno = 74
        - agno = 75
        - agno = 76
        - agno = 77
        - agno = 78
        - agno = 79
        - agno = 80
        - agno = 81
        - agno = 82
        - agno = 83
        - agno = 84
        - agno = 85
        - agno = 86
        - agno = 87
        - agno = 88
        - agno = 89
        - agno = 90
        - agno = 91
        - agno = 92
        - agno = 93
        - agno = 94
        - agno = 95
        - agno = 96
        - agno = 97
        - agno = 98
        - agno = 99
        - agno = 100
        - agno = 101
        - agno = 102
        - agno = 103
        - agno = 104
        - agno = 105
        - agno = 106
        - agno = 107
        - agno = 108
        - agno = 109
        - agno = 110
        - agno = 111
        - agno = 112
        - agno = 113
        - agno = 114
        - agno = 115
        - agno = 116
        - agno = 117
        - agno = 118
        - agno = 119
        - agno = 120
        - agno = 121
        - agno = 122
        - agno = 123
        - agno = 124
        - agno = 125
        - agno = 126
        - agno = 127
        - agno = 128
        - agno = 129
        - agno = 130
        - agno = 131
        - agno = 132
        - agno = 133
        - agno = 134
        - agno = 135
        - agno = 136
        - agno = 137
        - agno = 138
        - agno = 139
        - agno = 140
        - agno = 141
        - agno = 142
        - agno = 143
        - agno = 144
        - agno = 145
        - agno = 146
        - agno = 147
        - agno = 148
        - agno = 149
        - agno = 150
        - agno = 151
        - agno = 152
        - agno = 153
        - agno = 154
        - agno = 155
        - agno = 156
        - agno = 157
        - agno = 158
        - agno = 159
        - agno = 160
        - agno = 161
        - agno = 162
        - agno = 163
        - agno = 164
        - agno = 165
        - agno = 166
        - agno = 167
        - agno = 168
        - agno = 169
        - agno = 170
        - agno = 171
        - agno = 172
        - agno = 173
        - agno = 174
        - agno = 175
        - agno = 176
        - agno = 177
        - agno = 178
        - agno = 179
        - agno = 180
        - agno = 181
        - agno = 182
        - agno = 183
        - agno = 184
        - agno = 185
        - agno = 186
        - agno = 187
        - agno = 188
        - agno = 189
        - agno = 190
        - agno = 191
        - agno = 192
        - agno = 193
        - agno = 194
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs-rushes-repair.txt"

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
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
        - agno = 61
        - agno = 62
        - agno = 63
        - agno = 64
        - agno = 65
        - agno = 66
        - agno = 67
        - agno = 68
        - agno = 69
        - agno = 70
        - agno = 71
        - agno = 72
        - agno = 73
        - agno = 74
        - agno = 75
        - agno = 76
        - agno = 77
        - agno = 78
        - agno = 79
        - agno = 80
        - agno = 81
        - agno = 82
        - agno = 83
        - agno = 84
        - agno = 85
        - agno = 86
        - agno = 87
        - agno = 88
        - agno = 89
        - agno = 90
        - agno = 91
        - agno = 92
        - agno = 93
        - agno = 94
        - agno = 95
        - agno = 96
        - agno = 97
        - agno = 98
        - agno = 99
        - agno = 100
        - agno = 101
        - agno = 102
        - agno = 103
        - agno = 104
        - agno = 105
        - agno = 106
        - agno = 107
        - agno = 108
        - agno = 109
        - agno = 110
        - agno = 111
        - agno = 112
        - agno = 113
        - agno = 114
        - agno = 115
        - agno = 116
        - agno = 117
        - agno = 118
        - agno = 119
        - agno = 120
        - agno = 121
        - agno = 122
        - agno = 123
        - agno = 124
        - agno = 125
        - agno = 126
        - agno = 127
        - agno = 128
        - agno = 129
        - agno = 130
        - agno = 131
        - agno = 132
        - agno = 133
        - agno = 134
        - agno = 135
        - agno = 136
        - agno = 137
        - agno = 138
        - agno = 139
        - agno = 140
        - agno = 141
        - agno = 142
        - agno = 143
        - agno = 144
        - agno = 145
        - agno = 146
        - agno = 147
        - agno = 148
        - agno = 149
        - agno = 150
        - agno = 151
        - agno = 152
        - agno = 153
        - agno = 154
        - agno = 155
        - agno = 156
        - agno = 157
        - agno = 158
        - agno = 159
        - agno = 160
        - agno = 161
        - agno = 162
        - agno = 163
        - agno = 164
        - agno = 165
        - agno = 166
        - agno = 167
        - agno = 168
        - agno = 169
        - agno = 170
        - agno = 171
        - agno = 172
        - agno = 173
        - agno = 174
        - agno = 175
        - agno = 176
        - agno = 177
        - agno = 178
        - agno = 179
        - agno = 180
        - agno = 181
        - agno = 182
        - agno = 183
        - agno = 184
        - agno = 185
        - agno = 186
        - agno = 187
        - agno = 188
        - agno = 189
        - agno = 190
        - agno = 191
        - agno = 192
        - agno = 193
        - agno = 194
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
        - agno = 61
        - agno = 62
        - agno = 63
        - agno = 64
        - agno = 65
        - agno = 66
        - agno = 67
        - agno = 68
        - agno = 69
        - agno = 70
        - agno = 71
        - agno = 72
        - agno = 73
        - agno = 74
        - agno = 75
        - agno = 76
        - agno = 77
        - agno = 78
        - agno = 79
        - agno = 80
        - agno = 81
        - agno = 82
        - agno = 83
        - agno = 84
        - agno = 85
        - agno = 86
        - agno = 87
        - agno = 88
        - agno = 89
        - agno = 90
        - agno = 91
        - agno = 92
        - agno = 93
        - agno = 94
        - agno = 95
        - agno = 96
        - agno = 97
        - agno = 98
        - agno = 99
        - agno = 100
        - agno = 101
        - agno = 102
        - agno = 103
        - agno = 104
        - agno = 105
        - agno = 106
        - agno = 107
        - agno = 108
        - agno = 109
        - agno = 110
        - agno = 111
        - agno = 112
        - agno = 113
        - agno = 114
        - agno = 115
        - agno = 116
        - agno = 117
        - agno = 118
        - agno = 119
        - agno = 120
        - agno = 121
        - agno = 122
        - agno = 123
        - agno = 124
        - agno = 125
        - agno = 126
        - agno = 127
        - agno = 128
        - agno = 129
        - agno = 130
        - agno = 131
        - agno = 132
        - agno = 133
        - agno = 134
        - agno = 135
        - agno = 136
        - agno = 137
        - agno = 138
        - agno = 139
        - agno = 140
        - agno = 141
        - agno = 142
        - agno = 143
        - agno = 144
        - agno = 145
        - agno = 146
        - agno = 147
        - agno = 148
        - agno = 149
        - agno = 150
        - agno = 151
        - agno = 152
        - agno = 153
        - agno = 154
        - agno = 155
        - agno = 156
        - agno = 157
        - agno = 158
        - agno = 159
        - agno = 160
        - agno = 161
        - agno = 162
        - agno = 163
        - agno = 164
        - agno = 165
        - agno = 166
        - agno = 167
        - agno = 168
        - agno = 169
        - agno = 170
        - agno = 171
        - agno = 172
        - agno = 173
        - agno = 174
        - agno = 175
        - agno = 176
        - agno = 177
        - agno = 178
        - agno = 179
        - agno = 180
        - agno = 181
        - agno = 182
        - agno = 183
        - agno = 184
        - agno = 185
        - agno = 186
        - agno = 187
        - agno = 188
        - agno = 189
        - agno = 190
        - agno = 191
        - agno = 192
        - agno = 193
        - agno = 194
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--rwEMma7ioTxnRzrJ--
