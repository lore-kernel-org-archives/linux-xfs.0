Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TIAJoQ079788 for <xfs@oss.sgi.com>; Fri, 29 May 2009 13:10:19 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 99694304077
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 11:10:31 -0700 (PDT)
From: Felix Blyakher <felixb@sgi.com>
Subject: XFS: prevent deadlock in quota code when recursing into filesystem
Date: Fri, 29 May 2009 13:10:30 -0500
Message-Id: <1243620631-10749-1-git-send-email-felixb@sgi.com>
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


We experinced the hang in the quota code when the memory
allocation recursed into filesystem, and ended up in the
xfs_qm_shake(), which deadlocked itself on an already taken
lock.

STACK TRACE FOR TASK: 0xe00000306a0f8000 (pdflush)

0 schedule+0x26ec [0xa0000001005a32ac]
1 __mutex_lock_slowpath+0xfc [0xa0000001005a5b3c]
2 mutex_lock+0x4c [0xa0000001005a5c4c]
3 xfs_dqlock+0x1c [0xa000000207d8035c]
4 xfs_qm_shake_freelist+0x9c [0xa000000207d9061c]
5 xfs_qm_shake+0xfc [0xa000000207d90d7c]
6 shrink_slab+0x10c [0xa00000010012d78c]
7 zone_reclaim+0x51c [0xa00000010012df9c]
8 get_page_from_freelist+0x1bc [0xa00000010011f93c]
9 __alloc_pages+0x9c [0xa00000010012037c]
10 alloc_page_interleave+0xfc [0xa000000100159e9c]
11 alloc_pages_current+0x12c [0xa00000010015a34c]
12 find_or_create_page+0x5c [0xa00000010011425c]
13 _xfs_buf_lookup_pages+0x18c [0xa0000002062ecc0c]
14 xfs_buf_get_flags+0xac [0xa0000002062ee90c]
15 xfs_buf_read_flags+0x3c [0xa0000002062f0b9c]
16 xfs_trans_read_buf+0x5c [0xa0000002062cdddc]
17 xfs_qm_dqtobp+0x4bc [0xa000000207d826fc]
18 xfs_qm_dqflush+0x1ac [0xa000000207d82a0c]
19 xfs_qm_sync+0x27c [0xa000000207d8c8fc]
20 xfs_qm_syncall+0x9c [0xa000000207d8a11c]
21 vfs_sync+0x9c [0xa0000002063026bc]
22 dsvfs_sync+0x3c [0xa0000002082d65bc]
23 vfs_sync+0x9c [0xa0000002063026bc]
24 bhvlock_vfsop_sync+0xcc [0xa0000002082b244c]
25 vfs_sync+0x9c [0xa0000002063026bc]
26 xfs_fs_write_super+0x7c [0xa0000002062fef3c]
27 sync_supers+0x1dc [0xa0000001001896bc]
28 wb_kupdate+0x6c [0xa00000010012280c]
29 pdflush+0x3cc [0xa0000001001247cc]
30 kthread+0x23c [0xa0000001000d401c]
31 kernel_thread_helper+0xcc [0xa0000001000133ec]
32 start_kernel_thread+0x1c [0xa0000001000094bc]

The following patch (in a separate mail) addresses this problem.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
