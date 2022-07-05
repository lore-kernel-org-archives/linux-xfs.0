Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFB8C43334
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 22:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiGEWJ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiGEWJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:09:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0CC1B78A
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 15:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 672C4B819A8
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 22:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DAEC341C7;
        Tue,  5 Jul 2022 22:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657058986;
        bh=4hfrEfED7dcwMeUbn+8Tfi5tBg7JbcPK6XgVSQAUbH8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dEkavO7OLnN6jU71lNbOaKroH3Uj/6wXAIPgiGRR8hdDdxtAi+ykihoCg4pxH3i2/
         tCSJFQfVB7oRMmefynZtptpDYNfwE2L4b7sNZ3EfkPWItIaOSnKib2fXq2CJBhB+Zf
         lQGjAiD/Eky197CntPr87aKsPziCXtkIq0chbx+6bb0bFL9bp0K1otGPTu2m/uVdeq
         FyQ3OleMdYLvJCgbOoZFVE0KuE0hppVnRX9ZD9L019B3+zpGj38lNnrfgoeagyX9xQ
         MVHN9gsK/vOv5BHwf/QF4yNm3OYUTr+M6JquEzMzyw3k2Rit1cIQXkztDdikyoExSV
         lAlr4OnkIdugA==
Subject: [PATCH 2/3] xfs: make inode attribute forks a permanent part of
 struct xfs_inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Tue, 05 Jul 2022 15:09:45 -0700
Message-ID: <165705898555.2826746.14913566803667615290.stgit@magnolia>
In-Reply-To: <165705897408.2826746.14673631830829415034.stgit@magnolia>
References: <165705897408.2826746.14673631830829415034.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Syzkaller reported a UAF bug a while back:

==================================================================
BUG: KASAN: use-after-free in xfs_ilock_attr_map_shared+0xe3/0xf6 fs/xfs/xfs_inode.c:127
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

Regrettably, the VFS is much more lax about i_rwsem and getxattr than
is immediately obvious -- not only does it not guarantee that we hold
i_rwsem, it actually doesn't guarantee that we *don't* hold it either.
The getxattr system call won't acquire the lock before calling XFS, but
the file capabilities code calls getxattr with and without i_rwsem held
to determine if the "security.capabilities" xattr is set on the file.

Fixing the VFS locking requires a treewide investigation into every code
path that could touch an xattr and what i_rwsem state it expects or sets
up.  That could take years or even prove impossible; fortunately, we
can fix this UAF problem inside XFS.

An earlier version of this patch used smp_wmb in xfs_attr_fork_remove to
ensure that i_forkoff is always zeroed before i_afp is set to null and
changed the read paths to use smp_rmb before accessing i_forkoff and
i_afp, which avoided these UAF problems.  However, the patch author was
too busy dealing with other problems in the meantime, and by the time he
came back to this issue, the situation had changed a bit.

On a modern system with selinux, each inode will always have at least
one xattr for the selinux label, so it doesn't make much sense to keep
incurring the extra pointer dereference.  Furthermore, Allison's
upcoming parent pointer patchset will also cause nearly every inode in
the filesystem to have extended attributes.  Therefore, make the inode
attribute fork structure part of struct xfs_inode, at a cost of 40 more
bytes.

This patch adds a clunky if_present field where necessary to maintain
the existing logic of xattr fork null pointer testing in the existing
codebase.  The next patch switches the logic over to XFS_IFORK_Q and it
all goes away.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |   16 ++++++-------
 fs/xfs/libxfs/xfs_attr.h       |   10 ++++----
 fs/xfs/libxfs/xfs_attr_leaf.c  |   25 ++++++++++----------
 fs/xfs/libxfs/xfs_bmap.c       |    4 ++-
 fs/xfs/libxfs/xfs_inode_buf.c  |    8 +++---
 fs/xfs/libxfs/xfs_inode_fork.c |   44 ++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.h |    6 +++--
 fs/xfs/xfs_attr_inactive.c     |    9 +++----
 fs/xfs/xfs_attr_list.c         |   10 ++++----
 fs/xfs/xfs_bmap_util.c         |    8 +++---
 fs/xfs/xfs_icache.c            |   10 +++++---
 fs/xfs/xfs_inode.c             |   13 ++++++----
 fs/xfs/xfs_inode.h             |    6 +++--
 fs/xfs/xfs_inode_item.c        |   50 ++++++++++++++++++++--------------------
 fs/xfs/xfs_iomap.c             |    4 ++-
 fs/xfs/xfs_itable.c            |    2 +-
 16 files changed, 121 insertions(+), 104 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 224649a76cbb..6b0d744e5947 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -69,10 +69,10 @@ xfs_inode_hasattr(
 {
 	if (!XFS_IFORK_Q(ip))
 		return 0;
-	if (!ip->i_afp)
+	if (!ip->i_af.if_present)
 		return 0;
-	if (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
-	    ip->i_afp->if_nextents == 0)
+	if (ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS &&
+	    ip->i_af.if_nextents == 0)
 		return 0;
 	return 1;
 }
@@ -85,7 +85,7 @@ bool
 xfs_attr_is_leaf(
 	struct xfs_inode	*ip)
 {
-	struct xfs_ifork	*ifp = ip->i_afp;
+	struct xfs_ifork	*ifp = &ip->i_af;
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	imap;
 
@@ -231,7 +231,7 @@ xfs_attr_get_ilocked(
 	if (!xfs_inode_hasattr(args->dp))
 		return -ENOATTR;
 
-	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
+	if (args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_getvalue(args);
 	if (xfs_attr_is_leaf(args->dp))
 		return xfs_attr_leaf_get(args);
@@ -354,7 +354,7 @@ xfs_attr_try_sf_addname(
 	/*
 	 * Build initial attribute list (if required).
 	 */
-	if (dp->i_afp->if_format == XFS_DINODE_FMT_EXTENTS)
+	if (dp->i_af.if_format == XFS_DINODE_FMT_EXTENTS)
 		xfs_attr_shortform_create(args);
 
 	error = xfs_attr_shortform_addname(args);
@@ -864,7 +864,7 @@ xfs_attr_lookup(
 	if (!xfs_inode_hasattr(dp))
 		return -ENOATTR;
 
-	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
+	if (dp->i_af.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_sf_findname(args, NULL, NULL);
 
 	if (xfs_attr_is_leaf(dp)) {
@@ -1101,7 +1101,7 @@ static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
 {
 	struct xfs_attr_shortform *sf;
 
-	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	return be16_to_cpu(sf->hdr.totsize);
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index dfb47fa63c6d..0f100db504ee 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -560,9 +560,9 @@ static inline bool
 xfs_attr_is_shortform(
 	struct xfs_inode    *ip)
 {
-	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
-	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
-		ip->i_afp->if_nextents == 0);
+	return ip->i_af.if_format == XFS_DINODE_FMT_LOCAL ||
+	       (ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS &&
+		ip->i_af.if_nextents == 0);
 }
 
 static inline enum xfs_delattr_state
@@ -573,10 +573,10 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 	 * next state, the attribute fork may be null. This can occur only occur
 	 * on a pure remove, but we grab the next state before we check if a
 	 * replace operation is being performed. If we are called from any other
-	 * context, i_afp is guaranteed to exist. Hence if the attr fork is
+	 * context, i_af is guaranteed to exist. Hence if the attr fork is
 	 * null, we were called from a pure remove operation and so we are done.
 	 */
-	if (!args->dp->i_afp)
+	if (!args->dp->i_af.if_present)
 		return XFS_DAS_DONE;
 
 	args->op_flags |= XFS_DA_OP_ADDNAME;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d3670877143f..435c6cc485bf 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -682,7 +682,7 @@ xfs_attr_shortform_create(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_ifork	*ifp = dp->i_afp;
+	struct xfs_ifork	*ifp = &dp->i_af;
 	struct xfs_attr_sf_hdr	*hdr;
 
 	trace_xfs_attr_sf_create(args);
@@ -719,7 +719,7 @@ xfs_attr_sf_findname(
 	int			end;
 	int			i;
 
-	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)args->dp->i_af.if_u1.if_data;
 	sfe = &sf->list[0];
 	end = sf->hdr.count;
 	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
@@ -764,7 +764,7 @@ xfs_attr_shortform_add(
 	mp = dp->i_mount;
 	dp->i_forkoff = forkoff;
 
-	ifp = dp->i_afp;
+	ifp = &dp->i_af;
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
@@ -797,11 +797,10 @@ xfs_attr_fork_remove(
 	struct xfs_inode	*ip,
 	struct xfs_trans	*tp)
 {
-	ASSERT(ip->i_afp->if_nextents == 0);
+	ASSERT(ip->i_af.if_nextents == 0);
 
-	xfs_idestroy_fork(ip->i_afp);
-	kmem_cache_free(xfs_ifork_cache, ip->i_afp);
-	ip->i_afp = NULL;
+	xfs_idestroy_fork(&ip->i_af);
+	xfs_ifork_zap_attr(ip);
 	ip->i_forkoff = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
@@ -825,7 +824,7 @@ xfs_attr_sf_removename(
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 
 	error = xfs_attr_sf_findname(args, &sfe, &base);
 
@@ -889,7 +888,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 
 	trace_xfs_attr_sf_lookup(args);
 
-	ifp = args->dp->i_afp;
+	ifp = &args->dp->i_af;
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
@@ -917,8 +916,8 @@ xfs_attr_shortform_getvalue(
 	struct xfs_attr_sf_entry *sfe;
 	int			i;
 
-	ASSERT(args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL);
-	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
+	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
+	sf = (struct xfs_attr_shortform *)args->dp->i_af.if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
@@ -948,7 +947,7 @@ xfs_attr_shortform_to_leaf(
 	trace_xfs_attr_sf_to_leaf(args);
 
 	dp = args->dp;
-	ifp = dp->i_afp;
+	ifp = &dp->i_af;
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	size = be16_to_cpu(sf->hdr.totsize);
 	tmpbuffer = kmem_alloc(size, 0);
@@ -1055,7 +1054,7 @@ xfs_attr_shortform_verify(
 	int				i;
 	int64_t				size;
 
-	ASSERT(ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
 	ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
 	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	size = ifp->if_bytes;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 50d48c3b8e4e..4abb5b4cee0c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1041,9 +1041,9 @@ xfs_bmap_add_attrfork(
 	error = xfs_bmap_set_attrforkoff(ip, size, &version);
 	if (error)
 		goto trans_cancel;
-	ASSERT(ip->i_afp == NULL);
+	ASSERT(!ip->i_af.if_present);
 
-	ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
+	xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	logflags = 0;
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3b1b63f9d886..e203c80c1bf8 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -178,7 +178,7 @@ xfs_inode_from_disk(
 	xfs_failaddr_t		fa;
 
 	ASSERT(ip->i_cowfp == NULL);
-	ASSERT(ip->i_afp == NULL);
+	ASSERT(!ip->i_af.if_present);
 
 	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
 	if (fa) {
@@ -286,7 +286,7 @@ xfs_inode_to_disk_iext_counters(
 {
 	if (xfs_inode_has_large_extent_counts(ip)) {
 		to->di_big_nextents = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
-		to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_af));
 		/*
 		 * We might be upgrading the inode to use larger extent counters
 		 * than was previously used. Hence zero the unused field.
@@ -294,7 +294,7 @@ xfs_inode_to_disk_iext_counters(
 		to->di_nrext64_pad = cpu_to_be16(0);
 	} else {
 		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(&ip->i_af));
 	}
 }
 
@@ -326,7 +326,7 @@ xfs_inode_to_disk(
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
 	to->di_forkoff = ip->i_forkoff;
-	to->di_aformat = xfs_ifork_format(ip->i_afp);
+	to->di_aformat = xfs_ifork_format(&ip->i_af);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
 
 	if (xfs_has_v3inodes(ip->i_mount)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 40016b8b00ee..9d5141c21eee 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -276,17 +276,30 @@ xfs_dfork_attr_shortform_size(
 	return be16_to_cpu(atp->hdr.totsize);
 }
 
-struct xfs_ifork *
-xfs_ifork_alloc(
+void
+xfs_ifork_init_attr(
+	struct xfs_inode	*ip,
 	enum xfs_dinode_fmt	format,
 	xfs_extnum_t		nextents)
 {
-	struct xfs_ifork	*ifp;
+	ASSERT(!ip->i_af.if_present);
 
-	ifp = kmem_cache_zalloc(xfs_ifork_cache, GFP_NOFS | __GFP_NOFAIL);
-	ifp->if_format = format;
-	ifp->if_nextents = nextents;
-	return ifp;
+	ip->i_af.if_present = 1;
+	ip->i_af.if_format = format;
+	ip->i_af.if_nextents = nextents;
+}
+
+void
+xfs_ifork_zap_attr(
+	struct xfs_inode	*ip)
+{
+	ASSERT(ip->i_af.if_present);
+	ASSERT(ip->i_af.if_broot == NULL);
+	ASSERT(ip->i_af.if_u1.if_data == NULL);
+	ASSERT(ip->i_af.if_height == 0);
+
+	memset(&ip->i_af, 0, sizeof(struct xfs_ifork));
+	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 }
 
 int
@@ -301,9 +314,9 @@ xfs_iformat_attr_fork(
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
+	xfs_ifork_init_attr(ip, dip->di_aformat, naextents);
 
-	switch (ip->i_afp->if_format) {
+	switch (ip->i_af.if_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
 				xfs_dfork_attr_shortform_size(dip));
@@ -323,10 +336,8 @@ xfs_iformat_attr_fork(
 		break;
 	}
 
-	if (error) {
-		kmem_cache_free(xfs_ifork_cache, ip->i_afp);
-		ip->i_afp = NULL;
-	}
+	if (error)
+		xfs_ifork_zap_attr(ip);
 	return error;
 }
 
@@ -656,7 +667,7 @@ xfs_iext_state_to_fork(
 	if (state & BMAP_COWFORK)
 		return ip->i_cowfp;
 	else if (state & BMAP_ATTRFORK)
-		return ip->i_afp;
+		return &ip->i_af;
 	return &ip->i_df;
 }
 
@@ -672,6 +683,7 @@ xfs_ifork_init_cow(
 
 	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_cache,
 				       GFP_NOFS | __GFP_NOFAIL);
+	ip->i_cowfp->if_present = 1;
 	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
 }
 
@@ -707,10 +719,10 @@ int
 xfs_ifork_verify_local_attr(
 	struct xfs_inode	*ip)
 {
-	struct xfs_ifork	*ifp = ip->i_afp;
+	struct xfs_ifork	*ifp = &ip->i_af;
 	xfs_failaddr_t		fa;
 
-	if (!ifp)
+	if (!ifp->if_present)
 		fa = __this_address;
 	else
 		fa = xfs_attr_shortform_verify(ip);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 50c5fae4e35d..63015e9cee14 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -24,6 +24,7 @@ struct xfs_ifork {
 	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
+	int8_t			if_present;	/* 1 if present */
 };
 
 /*
@@ -173,8 +174,9 @@ xfs_dfork_nextents(
 	return 0;
 }
 
-struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
-				xfs_extnum_t nextents);
+void xfs_ifork_zap_attr(struct xfs_inode *ip);
+void xfs_ifork_init_attr(struct xfs_inode *ip, enum xfs_dinode_fmt format,
+		xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 
 int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 27265771f247..dbe715fe92ce 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -367,7 +367,7 @@ xfs_attr_inactive(
 	 * removal below.
 	 */
 	if (xfs_inode_hasattr(dp) &&
-	    dp->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
+	    dp->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_attr3_root_inactive(&trans, dp);
 		if (error)
 			goto out_cancel;
@@ -388,10 +388,9 @@ xfs_attr_inactive(
 	xfs_trans_cancel(trans);
 out_destroy_fork:
 	/* kill the in-core attr fork before we drop the inode lock */
-	if (dp->i_afp) {
-		xfs_idestroy_fork(dp->i_afp);
-		kmem_cache_free(xfs_ifork_cache, dp->i_afp);
-		dp->i_afp = NULL;
+	if (dp->i_af.if_present) {
+		xfs_idestroy_fork(&dp->i_af);
+		xfs_ifork_zap_attr(dp);
 	}
 	if (lock_mode)
 		xfs_iunlock(dp, lock_mode);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 90a14e85e76d..6a832ee07916 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -61,8 +61,8 @@ xfs_attr_shortform_list(
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
-	ASSERT(dp->i_afp != NULL);
-	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	ASSERT(dp->i_af.if_present);
+	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
 		return 0;
@@ -80,7 +80,7 @@ xfs_attr_shortform_list(
 	 */
 	if (context->bufsize == 0 ||
 	    (XFS_ISRESET_CURSOR(cursor) &&
-	     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
+	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
 					   !xfs_attr_namecheck(sfe->nameval,
@@ -121,7 +121,7 @@ xfs_attr_shortform_list(
 	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 		if (unlikely(
 		    ((char *)sfe < (char *)sf) ||
-		    ((char *)sfe >= ((char *)sf + dp->i_afp->if_bytes)))) {
+		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)))) {
 			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe,
@@ -513,7 +513,7 @@ xfs_attr_list_ilocked(
 	 */
 	if (!xfs_inode_hasattr(dp))
 		return 0;
-	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
+	if (dp->i_af.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_list(context);
 	if (xfs_attr_is_leaf(dp))
 		return xfs_attr_leaf_list(context);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1ffd5a780182..f317586d2f63 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1506,15 +1506,15 @@ xfs_swap_extent_forks(
 	/*
 	 * Count the number of extended attribute blocks
 	 */
-	if (XFS_IFORK_Q(ip) && ip->i_afp->if_nextents > 0 &&
-	    ip->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
+	if (XFS_IFORK_Q(ip) && ip->i_af.if_nextents > 0 &&
+	    ip->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
 				&aforkblks);
 		if (error)
 			return error;
 	}
-	if (XFS_IFORK_Q(tip) && tip->i_afp->if_nextents > 0 &&
-	    tip->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
+	if (XFS_IFORK_Q(tip) && tip->i_af.if_nextents > 0 &&
+	    tip->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
 				&taforkblks);
 		if (error)
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0d74d8eaff91..e08dedfb7f9d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -98,9 +98,11 @@ xfs_inode_alloc(
 	ip->i_ino = ino;
 	ip->i_mount = mp;
 	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
-	ip->i_afp = NULL;
 	ip->i_cowfp = NULL;
+	memset(&ip->i_af, 0, sizeof(ip->i_af));
+	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
+	ip->i_df.if_present = 1;
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
 	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
@@ -130,9 +132,9 @@ xfs_inode_free_callback(
 		break;
 	}
 
-	if (ip->i_afp) {
-		xfs_idestroy_fork(ip->i_afp);
-		kmem_cache_free(xfs_ifork_cache, ip->i_afp);
+	if (ip->i_af.if_present) {
+		xfs_idestroy_fork(&ip->i_af);
+		xfs_ifork_zap_attr(ip);
 	}
 	if (ip->i_cowfp) {
 		xfs_idestroy_fork(ip->i_cowfp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 308973cb4d7e..c9c26d782a38 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -125,7 +125,7 @@ xfs_ilock_attr_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (ip->i_afp && xfs_need_iread_extents(ip->i_afp))
+	if (ip->i_af.if_present && xfs_need_iread_extents(&ip->i_af))
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
 	return lock_mode;
@@ -893,7 +893,7 @@ xfs_init_new_inode(
 	 */
 	if (init_xattrs && xfs_has_attr(mp)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
-		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
+		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	}
 
 	/*
@@ -1768,7 +1768,7 @@ xfs_inactive(
 			goto out;
 	}
 
-	ASSERT(!ip->i_afp);
+	ASSERT(!ip->i_af.if_present);
 	ASSERT(ip->i_forkoff == 0);
 
 	/*
@@ -3452,13 +3452,13 @@ xfs_iflush(
 			goto flush_out;
 		}
 	}
-	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
+	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(&ip->i_af) >
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: detected corrupt incore inode %llu, "
 			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
-			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
+			ip->i_df.if_nextents + xfs_ifork_nextents(&ip->i_af),
 			ip->i_nblocks, ip);
 		goto flush_out;
 	}
@@ -3488,7 +3488,8 @@ xfs_iflush(
 	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL &&
 	    xfs_ifork_verify_local_data(ip))
 		goto flush_out;
-	if (ip->i_afp && ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL &&
+	if (ip->i_af.if_present &&
+	    ip->i_af.if_format == XFS_DINODE_FMT_LOCAL &&
 	    xfs_ifork_verify_local_attr(ip))
 		goto flush_out;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c22b01859051..045bad62ac25 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -33,9 +33,9 @@ typedef struct xfs_inode {
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 
 	/* Extent information. */
-	struct xfs_ifork	*i_afp;		/* attribute fork pointer */
 	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
+	struct xfs_ifork	i_af;		/* attribute fork */
 
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
@@ -86,7 +86,9 @@ xfs_ifork_ptr(
 	case XFS_DATA_FORK:
 		return &ip->i_df;
 	case XFS_ATTR_FORK:
-		return ip->i_afp;
+		if (!ip->i_af.if_present)
+			return NULL;
+		return &ip->i_af;
 	case XFS_COW_FORK:
 		return ip->i_cowfp;
 	default:
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 721def0639fd..77519e6f0b34 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -92,11 +92,11 @@ xfs_inode_item_attr_fork_size(
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 
-	switch (ip->i_afp->if_format) {
+	switch (ip->i_af.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
-		    ip->i_afp->if_nextents > 0 &&
-		    ip->i_afp->if_bytes > 0) {
+		    ip->i_af.if_nextents > 0 &&
+		    ip->i_af.if_bytes > 0) {
 			/* worst case, doesn't subtract unused space */
 			*nbytes += XFS_IFORK_ASIZE(ip);
 			*nvecs += 1;
@@ -104,15 +104,15 @@ xfs_inode_item_attr_fork_size(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if ((iip->ili_fields & XFS_ILOG_ABROOT) &&
-		    ip->i_afp->if_broot_bytes > 0) {
-			*nbytes += ip->i_afp->if_broot_bytes;
+		    ip->i_af.if_broot_bytes > 0) {
+			*nbytes += ip->i_af.if_broot_bytes;
 			*nvecs += 1;
 		}
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
-		    ip->i_afp->if_bytes > 0) {
-			*nbytes += xlog_calc_iovec_len(ip->i_afp->if_bytes);
+		    ip->i_af.if_bytes > 0) {
+			*nbytes += xlog_calc_iovec_len(ip->i_af.if_bytes);
 			*nvecs += 1;
 		}
 		break;
@@ -237,18 +237,18 @@ xfs_inode_item_format_attr_fork(
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
 
-	switch (ip->i_afp->if_format) {
+	switch (ip->i_af.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
 
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
-		    ip->i_afp->if_nextents > 0 &&
-		    ip->i_afp->if_bytes > 0) {
+		    ip->i_af.if_nextents > 0 &&
+		    ip->i_af.if_bytes > 0) {
 			struct xfs_bmbt_rec *p;
 
-			ASSERT(xfs_iext_count(ip->i_afp) ==
-				ip->i_afp->if_nextents);
+			ASSERT(xfs_iext_count(&ip->i_af) ==
+				ip->i_af.if_nextents);
 
 			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_EXT);
 			data_bytes = xfs_iextents_copy(ip, p, XFS_ATTR_FORK);
@@ -265,13 +265,13 @@ xfs_inode_item_format_attr_fork(
 			~(XFS_ILOG_ADATA | XFS_ILOG_AEXT);
 
 		if ((iip->ili_fields & XFS_ILOG_ABROOT) &&
-		    ip->i_afp->if_broot_bytes > 0) {
-			ASSERT(ip->i_afp->if_broot != NULL);
+		    ip->i_af.if_broot_bytes > 0) {
+			ASSERT(ip->i_af.if_broot != NULL);
 
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_BROOT,
-					ip->i_afp->if_broot,
-					ip->i_afp->if_broot_bytes);
-			ilf->ilf_asize = ip->i_afp->if_broot_bytes;
+					ip->i_af.if_broot,
+					ip->i_af.if_broot_bytes);
+			ilf->ilf_asize = ip->i_af.if_broot_bytes;
 			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ABROOT;
@@ -282,12 +282,12 @@ xfs_inode_item_format_attr_fork(
 			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
 
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
-		    ip->i_afp->if_bytes > 0) {
-			ASSERT(ip->i_afp->if_u1.if_data != NULL);
+		    ip->i_af.if_bytes > 0) {
+			ASSERT(ip->i_af.if_u1.if_data != NULL);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
-					ip->i_afp->if_u1.if_data,
-					ip->i_afp->if_bytes);
-			ilf->ilf_asize = (unsigned)ip->i_afp->if_bytes;
+					ip->i_af.if_u1.if_data,
+					ip->i_af.if_bytes);
+			ilf->ilf_asize = (unsigned)ip->i_af.if_bytes;
 			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ADATA;
@@ -355,11 +355,11 @@ xfs_inode_to_log_dinode_iext_counters(
 {
 	if (xfs_inode_has_large_extent_counts(ip)) {
 		to->di_big_nextents = xfs_ifork_nextents(&ip->i_df);
-		to->di_big_anextents = xfs_ifork_nextents(ip->i_afp);
+		to->di_big_anextents = xfs_ifork_nextents(&ip->i_af);
 		to->di_nrext64_pad = 0;
 	} else {
 		to->di_nextents = xfs_ifork_nextents(&ip->i_df);
-		to->di_anextents = xfs_ifork_nextents(ip->i_afp);
+		to->di_anextents = xfs_ifork_nextents(&ip->i_af);
 	}
 }
 
@@ -390,7 +390,7 @@ xfs_inode_to_log_dinode(
 	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = ip->i_extsize;
 	to->di_forkoff = ip->i_forkoff;
-	to->di_aformat = xfs_ifork_format(ip->i_afp);
+	to->di_aformat = xfs_ifork_format(&ip->i_af);
 	to->di_flags = ip->i_diflags;
 
 	xfs_copy_dm_fields_to_log_dinode(ip, to);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ccd97ccd74bf..eb54fd259d15 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1307,12 +1307,12 @@ xfs_xattr_iomap_begin(
 	lockmode = xfs_ilock_attr_map_shared(ip);
 
 	/* if there are no attribute fork or extents, return ENOENT */
-	if (!XFS_IFORK_Q(ip) || !ip->i_afp->if_nextents) {
+	if (!XFS_IFORK_Q(ip) || !ip->i_af.if_nextents) {
 		error = -ENOENT;
 		goto out_unlock;
 	}
 
-	ASSERT(ip->i_afp->if_format != XFS_DINODE_FMT_LOCAL);
+	ASSERT(ip->i_af.if_format != XFS_DINODE_FMT_LOCAL);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, XFS_BMAPI_ATTRFORK);
 out_unlock:
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f74c9fff72bb..7d1ff282953f 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -111,7 +111,7 @@ xfs_bulkstat_one_int(
 		buf->bs_extents64 = nextents;
 
 	xfs_bulkstat_health(ip, buf);
-	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
+	buf->bs_aextents = xfs_ifork_nextents(&ip->i_af);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 

