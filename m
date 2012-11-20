Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKMeDE9218895 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 16:40:13 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76FD2AC004
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 14:42:17 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qAKMgEom009252
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 16:42:14 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121120224120.224166649@sgi.com>
Date: Tue, 20 Nov 2012 16:41:20 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/2] discontiguous buffer patches
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Eric Sundeen's "userspace vs. fragmented multiblock dir2", xfstest 291
commit 2a4ed, causes a xfs_buf lock hang:

[<ffffffff81065d87>] down+0x47/0x50
[<ffffffffa03a25c6>] xfs_buf_lock+0x66/0xe0 [xfs]
[<ffffffffa03a33c9>] _xfs_buf_find+0x1f9/0x320 [xfs]
[<ffffffffa03a393f>] xfs_buf_get_map+0x2f/0x170 [xfs]
[<ffffffffa03a3f7a>] xfs_buf_read_map+0x2a/0x100 [xfs]
[<ffffffffa0411630>] xfs_trans_read_buf_map+0x3b0/0x590 [xfs]
[<ffffffffa03e1c5e>] xfs_da_read_buf+0xbe/0x230 [xfs]
[<ffffffffa03e78dc>] xfs_dir2_block_addname+0x7c/0x980 [xfs]
[<ffffffffa03f1468>] xfs_dir2_sf_addname+0x3e8/0x450 [xfs]
[<ffffffffa03e634c>] xfs_dir_createname+0x17c/0x1e0 [xfs]
[<ffffffffa03b9fe2>] xfs_create+0x4c2/0x5f0 [xfs]
[<ffffffffa03b0c8a>] xfs_vn_mknod+0x8a/0x1a0 [xfs]
[<ffffffffa03b0dce>] xfs_vn_create+0xe/0x10 [xfs]
[<ffffffff8115695c>] vfs_create+0xac/0xd0
[<ffffffff811587de>] do_last+0x8be/0x960
[<ffffffff8115940c>] path_openat+0xdc/0x410
[<ffffffff81159853>] do_filp_open+0x43/0xa0
[<ffffffff8114a502>] do_sys_open+0x152/0x1e0
[<ffffffff8114a5cc>] sys_open+0x1c/0x20
[<ffffffff81423df9>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

That bisect a problem to:

    commit 3605431fb9739a30ccd0c6380ae8e3c6f8e670a5
    Author: Dave Chinner <dchinner@redhat.com>
    Date:   Fri Jun 22 18:50:13 2012 +1000
    xfs: use discontiguous xfs_buf support in dabuf wrappers

xfs_trans_buf_item_match() is looking for the block number of the
buffer in the single segment map area.

Futhermore, there are a couple issue with multi-segment buffer log
format.

Patch 1 cleans up the buffer map so that XFS always uses b_maps[].

Patch 2 fixes the buffer log format issues.

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
