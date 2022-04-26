Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06881C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 05:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244157AbiDZFRy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 01:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiDZFRx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 01:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C8A1291C7
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 22:14:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9499760DE6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 05:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5A3C385A4;
        Tue, 26 Apr 2022 05:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650950085;
        bh=73xNfEx8Y9GUv7fd7NGw8tQcXYXv5HBWSr7foaMaeH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bk4h5d40Z56zvISYa1/WEABKbs2dZ0l+mQd0ZXKwwK4YvqmZoj5MBPtg7+Ten8fWR
         BsyesotsOwPeu82+CJetWDdtC24ygVbcXJORxg8Ifj63SykAUp4mtjAGQtB0DoJNN5
         j7KVo541bVNp0KhAPmcwLnGci3roATiLW4Et9a73HeOpzYhQ37gUCTbl6nyADqBeM2
         2UkzFbR679VeFFCSlQ617czNpC5oXeEZvsgbFm31eBWh/7JRK/n6WCsEH6rR8SG7Tj
         kMIws0eJKATgW704cYr/rJy62HYYk5JBPMySjO5KleJg/Fpcd6Cg29nj1mRKDBc1+T
         tcNGg2OJi+2YQ==
Date:   Mon, 25 Apr 2022 22:14:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
Message-ID: <20220426051444.GT17025@magnolia>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
 <20220425222140.GI1544202@dread.disaster.area>
 <20220426024331.GR17025@magnolia>
 <20220426042927.GN1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426042927.GN1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 02:29:27PM +1000, Dave Chinner wrote:
> On Mon, Apr 25, 2022 at 07:43:31PM -0700, Darrick J. Wong wrote:
> 
> [snip yukky stuff that makes Darrick's life hell :(]
> 
> > That attr fork UAF thing -- adding smp_wmb/rmb made the symptoms go
> > away, but as I was writing up the commit message I realized that the
> > race window is still there.  Maybe I'll come up with a way to make the
> > incore attr fork stick around, though both attempts so far have exploded
> > on impact.
> 
> Can you post the patch so I can have a look at it?

Sure thing!

--D

From: Darrick J. Wong <djwong@kernel.org>
xfs: ensure ordering between i_forkoff and freeing i_afp

Syzkaller hit this nasty bug a while back:

==================================================================
BUG: KASAN: use-after-free in xfs_ilock_attr_map_shared+0xe3/0xf6
fs/xfs/xfs_inode.c:127
Read of size 4 at addr ffff88802cec919c by task syz-executor262/2958

CPU: 2 PID: 2958 Comm: syz-executor262 Not tainted
5.15.0-0.30.3-20220406_1406 #3
Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29
04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x82/0xa9 lib/dump_stack.c:106
 print_address_description.constprop.9+0x21/0x2d5 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold.14+0x7f/0x11b mm/kasan/report.c:459
 xfs_ilock_attr_map_shared+0xe3/0xf6 fs/xfs/xfs_inode.c:127
 xfs_attr_get+0x378/0x4c2 fs/xfs/libxfs/xfs_attr.c:159
 xfs_xattr_get+0xe3/0x150 fs/xfs/xfs_xattr.c:36
 __vfs_getxattr+0xdf/0x13d fs/xattr.c:399
 cap_inode_need_killpriv+0x41/0x5d security/commoncap.c:300
 security_inode_need_killpriv+0x4c/0x97 security/security.c:1408
 dentry_needs_remove_privs.part.28+0x21/0x63 fs/inode.c:1912
 dentry_needs_remove_privs+0x80/0x9e fs/inode.c:1908
 do_truncate+0xc3/0x1e0 fs/open.c:56
 handle_truncate fs/namei.c:3084 [inline]
 do_open fs/namei.c:3432 [inline]
 path_openat+0x30ab/0x396d fs/namei.c:3561
 do_filp_open+0x1c4/0x290 fs/namei.c:3588
 do_sys_openat2+0x60d/0x98c fs/open.c:1212
 do_sys_open+0xcf/0x13c fs/open.c:1228
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3a/0x7e arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0x0
RIP: 0033:0x7f7ef4bb753d
Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48
89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73
01 c3 48 8b 0d 1b 79 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007f7ef52c2ed8 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 0000000000404148 RCX: 00007f7ef4bb753d
RDX: 00007f7ef4bb753d RSI: 0000000000000000 RDI: 0000000020004fc0
RBP: 0000000000404140 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0030656c69662f2e
R13: 00007ffd794db37f R14: 00007ffd794db470 R15: 00007f7ef52c2fc0
 </TASK>

Allocated by task 2953:
 kasan_save_stack+0x19/0x38 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x68/0x7c mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:3213 [inline]
 slab_alloc mm/slub.c:3221 [inline]
 kmem_cache_alloc+0x11b/0x3eb mm/slub.c:3226
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 xfs_ifork_alloc+0x25/0xa2 fs/xfs/libxfs/xfs_inode_fork.c:287
 xfs_bmap_add_attrfork+0x3f2/0x9b1 fs/xfs/libxfs/xfs_bmap.c:1098
 xfs_attr_set+0xe38/0x12a7 fs/xfs/libxfs/xfs_attr.c:746
 xfs_xattr_set+0xeb/0x1a9 fs/xfs/xfs_xattr.c:59
 __vfs_setxattr+0x11b/0x177 fs/xattr.c:180
 __vfs_setxattr_noperm+0x128/0x5e0 fs/xattr.c:214
 __vfs_setxattr_locked+0x1d4/0x258 fs/xattr.c:275
 vfs_setxattr+0x154/0x33d fs/xattr.c:301
 setxattr+0x216/0x29f fs/xattr.c:575
 __do_sys_fsetxattr fs/xattr.c:632 [inline]
 __se_sys_fsetxattr fs/xattr.c:621 [inline]
 __x64_sys_fsetxattr+0x243/0x2fe fs/xattr.c:621
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3a/0x7e arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0x0

Freed by task 2949:
 kasan_save_stack+0x19/0x38 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x21 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xe2/0x10e mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook mm/slub.c:1726 [inline]
 slab_free mm/slub.c:3492 [inline]
 kmem_cache_free+0xdc/0x3ce mm/slub.c:3508
 xfs_attr_fork_remove+0x8d/0x132 fs/xfs/libxfs/xfs_attr_leaf.c:773
 xfs_attr_sf_removename+0x5dd/0x6cb fs/xfs/libxfs/xfs_attr_leaf.c:822
 xfs_attr_remove_iter+0x68c/0x805 fs/xfs/libxfs/xfs_attr.c:1413
 xfs_attr_remove_args+0xb1/0x10d fs/xfs/libxfs/xfs_attr.c:684
 xfs_attr_set+0xf1e/0x12a7 fs/xfs/libxfs/xfs_attr.c:802
 xfs_xattr_set+0xeb/0x1a9 fs/xfs/xfs_xattr.c:59
 __vfs_removexattr+0x106/0x16a fs/xattr.c:468
 cap_inode_killpriv+0x24/0x47 security/commoncap.c:324
 security_inode_killpriv+0x54/0xa1 security/security.c:1414
 setattr_prepare+0x1a6/0x897 fs/attr.c:146
 xfs_vn_change_ok+0x111/0x15e fs/xfs/xfs_iops.c:682
 xfs_vn_setattr_size+0x5f/0x15a fs/xfs/xfs_iops.c:1065
 xfs_vn_setattr+0x125/0x2ad fs/xfs/xfs_iops.c:1093
 notify_change+0xae5/0x10a1 fs/attr.c:410
 do_truncate+0x134/0x1e0 fs/open.c:64
 handle_truncate fs/namei.c:3084 [inline]
 do_open fs/namei.c:3432 [inline]
 path_openat+0x30ab/0x396d fs/namei.c:3561
 do_filp_open+0x1c4/0x290 fs/namei.c:3588
 do_sys_openat2+0x60d/0x98c fs/open.c:1212
 do_sys_open+0xcf/0x13c fs/open.c:1228
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3a/0x7e arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0x0

The buggy address belongs to the object at ffff88802cec9188
 which belongs to the cache xfs_ifork of size 40
The buggy address is located 20 bytes inside of
 40-byte region [ffff88802cec9188, ffff88802cec91b0)
The buggy address belongs to the page:
page:00000000c3af36a1 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x2cec9
flags: 0xfffffc0000200(slab|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0000200 ffffea00009d2580 0000000600000006 ffff88801a9ffc80
raw: 0000000000000000 0000000080490049 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88802cec9080: fb fb fb fc fc fa fb fb fb fb fc fc fb fb fb fb
 ffff88802cec9100: fb fc fc fb fb fb fb fb fc fc fb fb fb fb fb fc
>ffff88802cec9180: fc fa fb fb fb fb fc fc fa fb fb fb fb fc fc fb
                            ^
 ffff88802cec9200: fb fb fb fb fc fc fb fb fb fb fb fc fc fb fb fb
 ffff88802cec9280: fb fb fc fc fa fb fb fb fb fc fc fa fb fb fb fb
==================================================================

The root cause of this bug is the unlocked access to xfs_inode.i_afp
from the getxattr code paths while trying to determine which ILOCK mode
to use to stabilize the xattr data.  Unfortunately, the VFS does not
acquire i_rwsem when vfs_getxattr (or listxattr) call into the
filesystem, which means that getxattr can race with a removexattr that's
tearing down the attr fork and crash:

xfs_attr_set:                          xfs_attr_get:
xfs_attr_fork_remove:                  xfs_ilock_attr_map_shared:

xfs_idestroy_fork(ip->i_afp);
kmem_cache_free(xfs_ifork_cache, ip->i_afp);

                                       if (ip->i_afp &&

ip->i_afp = NULL;

                                       xfs_need_iread_extents(ip->i_afp))
                                       <KABOOM>

ip->i_forkoff = 0;

Unfortunately, the VFS is even more lax about i_rwsem and getxattr than
is immediately obvious -- not only does it not guarantee that we hold
i_rwsem, it actually doesn't guarantee that we *don't* hold it either.
The getxattr system call won't acquire the lock before calling XFS, but
the file capabilities code calls getxattr with and without i_rwsem held
to determine if the "security.capabilities" xattr is set on the file.
Hence even the "fix the VFS locking" option looks like an ugly fight
even for a treewide change.

We can easily fix this in XFS, however.  The xattr code paths generally
employ this sequence:

if (XFS_IFORK_Q(ip))
	/* access ip->i_afp */

Which means that we can use smp_wmb in xfs_attr_fork_remove to ensure
that i_forkoff is always zeroed before i_afp is set to null.  As long as
the read paths are careful to use smp_rmb before accessing i_forkoff and
i_afp, this should avoid these UAF problems.

The longer term solution here is to study making the attr fork a part of
xfs_inode, but that's more involved.

FWIW the reproducer spawns a bunch of threads that all open the same
file in O_TRUNC mode, write a single byte, set security.capability on
the file, and close it.  If KASAN is enabled, this will trip pretty
quickly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |    7 ++++-
 fs/xfs/libxfs/xfs_bmap.c       |   55 +++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_format.h     |    3 +-
 fs/xfs/libxfs/xfs_inode_fork.c |   16 ++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |    4 +--
 fs/xfs/xfs_xattr.c             |   16 ++++++++++++
 6 files changed, 73 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5f9342a5864b..a2092c687495 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -767,12 +767,15 @@ xfs_attr_fork_remove(
 	struct xfs_inode	*ip,
 	struct xfs_trans	*tp)
 {
+	struct xfs_ifork	*ifp = ip->i_afp;
+
 	ASSERT(ip->i_afp->if_nextents == 0);
 
 	xfs_idestroy_fork(ip->i_afp);
-	kmem_cache_free(xfs_ifork_cache, ip->i_afp);
-	ip->i_afp = NULL;
 	ip->i_forkoff = 0;
+	smp_wmb();
+	ip->i_afp = NULL;
+	kmem_cache_free(xfs_ifork_cache, ifp);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0778a8a393f1..644fb09c1aca 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -873,6 +873,7 @@ STATIC int					/* error */
 xfs_bmap_add_attrfork_btree(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
+	uint8_t			new_forkoff,
 	int			*flags)		/* inode logging flags */
 {
 	struct xfs_btree_block	*block = ip->i_df.if_broot;
@@ -883,7 +884,7 @@ xfs_bmap_add_attrfork_btree(
 
 	mp = ip->i_mount;
 
-	if (xfs_bmap_bmdr_space(block) <= XFS_IFORK_DSIZE(ip))
+	if (xfs_bmap_bmdr_space(block) <= XFS_FORKOFF_TO_B(new_forkoff))
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
@@ -918,13 +919,14 @@ STATIC int					/* error */
 xfs_bmap_add_attrfork_extents(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode pointer */
+	uint8_t			new_forkoff,
 	int			*flags)		/* inode logging flags */
 {
 	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
 	int			error;		/* error return value */
 
 	if (ip->i_df.if_nextents * sizeof(struct xfs_bmbt_rec) <=
-	    XFS_IFORK_DSIZE(ip))
+	    XFS_FORKOFF_TO_B(new_forkoff))
 		return 0;
 	cur = NULL;
 	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
@@ -951,11 +953,12 @@ STATIC int					/* error */
 xfs_bmap_add_attrfork_local(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode pointer */
+	uint8_t			new_forkoff,
 	int			*flags)		/* inode logging flags */
 {
 	struct xfs_da_args	dargs;		/* args for dir/attr code */
 
-	if (ip->i_df.if_bytes <= XFS_IFORK_DSIZE(ip))
+	if (ip->i_df.if_bytes <= XFS_FORKOFF_TO_B(new_forkoff))
 		return 0;
 
 	if (S_ISDIR(VFS_I(ip)->i_mode)) {
@@ -980,35 +983,33 @@ xfs_bmap_add_attrfork_local(
 }
 
 /*
- * Set an inode attr fork offset based on the format of the data fork.
+ * Compute the new inode attr fork offset based on the format of the data fork.
  */
 static int
-xfs_bmap_set_attrforkoff(
+xfs_bmap_new_attrforkoff(
 	struct xfs_inode	*ip,
 	int			size,
 	int			*version)
 {
+	int			new_forkoff;
 	int			default_size = xfs_default_attroffset(ip) >> 3;
 
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_DEV:
-		ip->i_forkoff = default_size;
-		break;
+		return default_size;
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
-		ip->i_forkoff = xfs_attr_shortform_bytesfit(ip, size);
-		if (!ip->i_forkoff)
-			ip->i_forkoff = default_size;
+		new_forkoff = xfs_attr_shortform_bytesfit(ip, size);
+		if (!new_forkoff)
+			new_forkoff = default_size;
 		else if (xfs_has_attr2(ip->i_mount) && version)
 			*version = 2;
-		break;
-	default:
-		ASSERT(0);
-		return -EINVAL;
+		return new_forkoff;
 	}
 
-	return 0;
+	ASSERT(0);
+	return -EINVAL;
 }
 
 /*
@@ -1026,6 +1027,7 @@ xfs_bmap_add_attrfork(
 	int			blks;		/* space reservation */
 	int			version = 1;	/* superblock attr version */
 	int			logflags;	/* logging flags */
+	int			new_forkoff;
 	int			error;		/* error return value */
 
 	ASSERT(XFS_IFORK_Q(ip) == 0);
@@ -1043,31 +1045,38 @@ xfs_bmap_add_attrfork(
 		goto trans_cancel;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_bmap_set_attrforkoff(ip, size, &version);
-	if (error)
+	new_forkoff = xfs_bmap_new_attrforkoff(ip, size, &version);
+	if (new_forkoff < 0) {
+		error = new_forkoff;
 		goto trans_cancel;
+	}
 	ASSERT(ip->i_afp == NULL);
 
-	ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
 	logflags = 0;
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_LOCAL:
-		error = xfs_bmap_add_attrfork_local(tp, ip, &logflags);
+		error = xfs_bmap_add_attrfork_local(tp, ip, new_forkoff,
+				&logflags);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		error = xfs_bmap_add_attrfork_extents(tp, ip, &logflags);
+		error = xfs_bmap_add_attrfork_extents(tp, ip, new_forkoff,
+				&logflags);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		error = xfs_bmap_add_attrfork_btree(tp, ip, &logflags);
+		error = xfs_bmap_add_attrfork_btree(tp, ip, new_forkoff,
+				&logflags);
 		break;
 	default:
 		error = 0;
 		break;
 	}
-	if (logflags)
-		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
 		goto trans_cancel;
+	ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
+	smp_wmb();
+	ip->i_forkoff = new_forkoff;
+	if (logflags)
+		xfs_trans_log_inode(tp, ip, logflags);
 	if (!xfs_has_attr(mp) ||
 	   (!xfs_has_attr2(mp) && version == 2)) {
 		bool log_sb = false;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 6c989c88c707..75f5cb043fe4 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -897,7 +897,8 @@ enum xfs_dinode_fmt {
 /*
  * Inode data & attribute fork sizes, per inode.
  */
-#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
+#define XFS_FORKOFF_TO_B(forkoff)	((int)(forkoff) << 3)
+#define XFS_DFORK_BOFF(dip)		XFS_FORKOFF_TO_B((dip)->di_forkoff)
 
 #define XFS_DFORK_DSIZE(dip,mp) \
 	((dip)->di_forkoff ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index b1f04ea8a325..40596c2b32fc 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -783,3 +783,19 @@ xfs_ifork_is_realtime(
 {
 	return XFS_IS_REALTIME_INODE(ip) && whichfork != XFS_ATTR_FORK;
 }
+
+bool
+XFS_IFORK_Q(
+	struct xfs_inode	*ip)
+{
+	smp_rmb();
+	return ip->i_forkoff != 0;
+}
+
+int
+XFS_IFORK_BOFF(
+	struct xfs_inode	*ip)
+{
+	smp_rmb();
+	return XFS_FORKOFF_TO_B(ip->i_forkoff);
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 8e4bea9a7094..7fbe5e17e0d2 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -91,8 +91,8 @@ struct xfs_ifork {
  * Fork handling.
  */
 
-#define XFS_IFORK_Q(ip)			((ip)->i_forkoff != 0)
-#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_forkoff << 3))
+bool XFS_IFORK_Q(struct xfs_inode *ip);
+int XFS_IFORK_BOFF(struct xfs_inode *ip);
 
 #define XFS_IFORK_PTR(ip,w)		\
 	((w) == XFS_DATA_FORK ? \
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0d050f8829ef..de44ca251731 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -33,6 +33,14 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 	};
 	int			error;
 
+	/*
+	 * Always check i_forkoff before we start accessing the attr fork.
+	 * Attr fork removal uses write memory barriers to ensure that zeroing
+	 * i_forkoff always happens before nulling i_afp.
+	 */
+	if (!XFS_IFORK_Q(XFS_I(inode)))
+		return -ENODATA;
+
 	error = xfs_attr_get(&args);
 	if (error)
 		return error;
@@ -206,6 +214,14 @@ xfs_vn_listxattr(
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_xattr_put_listent;
 
+	/*
+	 * Always check i_forkoff before we start accessing the attr fork.
+	 * Attr fork removal uses write memory barriers to ensure that zeroing
+	 * i_forkoff always happens before nulling i_afp.
+	 */
+	if (!XFS_IFORK_Q(XFS_I(inode)))
+		return -ENODATA;
+
 	error = xfs_attr_list(&context);
 	if (error)
 		return error;
