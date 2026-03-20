Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AC3361DA1
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 10:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774001069; cv=none; b=afMLuxh7Wsus6zivk0p4BhIAAloPJyq8vcU1qCwiR7Cjjw5XDmshzSh1bT28DiM5QcjiNvAIHhBWBKM0P6Ot9xeZk8KidwLTrDZ+fVnPUmveeI73XKNvYhKi3PFtfpGLJg4AmJ9KdRyeLxjUgIR2Gbdrdw15jGr79hDbnMoDYGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774001069; c=relaxed/simple;
	bh=LrE3VdXuj4apNadwjMfZBEz2hPA+Xav1W+ZZJiA4YVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiKQ6IuM7UseNx7sSkOeuQOjFuaqWzdWxljeOGleWhH8xq1INrJW1HyxsEjayoYiaENJFUQPnJdKIRHiqBD+k7j0pygpCh7oeu2LuD/5LlHYHCQZdGJs3AgdzZ0lgl3Ne37gMh/j8D9pkcYQ8JoTw+pzZuYhJikAIvw9HhCgcc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=KupjV9Y3; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="KupjV9Y3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1774001061;
	bh=f4rhwdBMMSENh9iJN8lnvUv3BJyV/LyEU1yg5HX+0Fw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=KupjV9Y3WwvPH4FHolQM2IEr/GPRguPN/oQSYCKiRa+GXlNrb85DiecbGVTyV5kFB
	 ztKjc3JVxDD+ouQWucFl2pEmaWmgt0WprW6vMcfY+XPM9jtf/N0eSiaLOWe6F/dZJZ
	 O+szenmwOXta0X2b485EaXpAKeq6fXFwxQfPkE0M=
X-QQ-mid: zesmtpip3t1774001039t2faba09a
X-QQ-Originating-IP: KZ9I7a0hPxUSq5m9yILcdUUrfKiu57vYkW0CuNsUI2g=
Received: from uos-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 20 Mar 2026 18:03:57 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17004956121788972465
EX-QQ-RecipientCnt: 14
From: Morduan Zang <zhangdandan@uniontech.com>
To: dgc@kernel.org
Cc: brauner@kernel.org,
	cem@kernel.org,
	dchinner@redhat.com,
	hch@lst.de,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com,
	tytso@mit.edu,
	viro@zeniv.linux.org.uk,
	zhangdandan@uniontech.com,
	zhanjun@uniontech.com
Subject: [PATCH] xfs: defer lazytime timestamp updates to inodegc during eviction
Date: Fri, 20 Mar 2026 18:03:53 +0800
Message-ID: <6EBD01CF561B83EC+20260320100353.220462-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <absSoRi8oxXSuSZ7@dread>
References: <absSoRi8oxXSuSZ7@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: M1uxScjX0AN0rFtX2VgcuPjUG1oxckhha+FdjrS3wCI7qLqNXG+NVWfr
	iCNaBfoee4/PNptcfE48Q2A3rFLClJGsjMYPeGkuL0phqAU+OJn4Go12B01JkypDjPTwab0
	4tTH9yVB0RDHVElfzPYJvVUd7YoQR44Y2Wmh58qNU3WjbA9jbmvmuJ23CYZUnx0kRae+igf
	Mdk/X+t+JjI9zdHs8Qbbs3XCA0/NGmycLeHuxPNuwFpE/dO/FQvBoLqHCA91Ld0JSxNPaE4
	w1FZXYqPgVwVlEYmqKtY3+OvUEy7sifSudJRjoCl+kIa2BeAq2L7ML1kALo0T771mHvgWgp
	D3oOSUH5GaMTyQN+hdivDU+uTAHfctMtuA1MjMSiAAAQ0216niE3sQxuDuzIJvXXu1NsMV5
	7rDC86mNlgB0425psSyc2DdxGhRmZ0sA1sYeY7koqCR8uummN0wwLzi6QhkXai5ygNvJECk
	anLfK2rX8yqbMlYKQBHHc0tVJfnaFeiQmK4lY0X7e3BD+ytoUrC/XOuMKWxorfNVeK42tMJ
	AzkxgsSpQoJ4O95PUgLq+FtxXQQ8tCZEoF9AeBHOnOLVwu64WtMXXAeyvBfQK/e/IWAjmQ/
	HnUiwQJBP1Oc+yszRIg9v2wY5aQNcb/KdfndxNqYXEf5kQXZ41OBhjDbslxxBGSwFF2M7d2
	V0PMRvaGaRx91bE9hD5/5i2mgV1dhuQqIuaLIg5lI2a49Mf75DAqNCB+M7xTBVv0Uey2mWF
	BE6NEqONn+OvhQQGcn8cxIh0ckiV92+JWNrRmSfnPvYsZJetIyZOZp98Bi7Kx0ACR6OCwMH
	OB04bBLuB6q9CEaZcqt+N4YHQBmjKSRj+EWenszt48w5o+fLFtYAqeNTMgZYc4dsdE6Ness
	eQbgIkNK4zfm14ZS10hQGoDcJUWk1A3TJNNDRPGD7Vl3puVaHCS7IaZFc2wfUIHPaFltSeT
	XGdr/4EbJl/LUQwO18LIC0i4DwMjmJ8MKi7VKS0fonH/FMgjbQJMAsquuGjredxvhpk9pJP
	Vor1HgLuLAwYUzegylkaluWQksrweFTOrNgRfnSKLdhTnfxmiw7BHiWbi3bT8=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

syzbot reported a warning from memory reclaim when iput() dropped the
last reference to a linked XFS inode with I_DIRTY_TIME set. In this
case VFS can call ->sync_lazytime() from the inode eviction path, and
XFS handles that by starting a timestamp transaction directly:

current->flags & PF_MEMALLOC
WARNING: mm/page_alloc.c:4741 at __alloc_pages_slowpath+0xd0a/0xd40 mm/page_alloc.c:4741, CPU#0: kswapd0/70
Modules linked in:
CPU: 0 UID: 0 PID: 70 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_pages_slowpath+0xd0a/0xd40 mm/page_alloc.c:4741
Code: 48 8b 1d 31 3b f9 10 48 83 c3 2c 48 89 d8 48 c1 e8 03 0f b6 04 08 84 c0 75 23 f6 43 01 08 48 8b 54 24 08 0f 84 41 f3 ff ff 90 <0f> 0b 90 e9 38 f3 ff ff e8 59 7c 8c 09 90 0f 0b 90 eb c2 89 d9 80
RSP: 0018:ffffc90000b1ec98 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff888000e3c9ac RCX: dffffc0000000000
RDX: ffffc90000b1edc0 RSI: 0000000000000000 RDI: 00000000000cacc0
RBP: 00000000000cacc0 R08: ffff88802fffd9b0 R09: 1ffff1100bffae52
R10: dffffc0000000000 R11: ffffed100bffae53 R12: ffffc90000b1edc0
R13: 1ffff92000163db4 R14: 00000000000cacc0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88808ca56000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc9045ff000 CR3: 00000000121ca000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __alloc_frozen_pages_noprof+0x322/0x380 mm/page_alloc.c:5263
 alloc_slab_page mm/slub.c:3296 [inline]
 allocate_slab+0x11f/0x660 mm/slub.c:3493
 new_slab mm/slub.c:3543 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7178
 __pcs_replace_empty_main+0x2f9/0x5e0 mm/slub.c:-1
 alloc_from_pcs mm/slub.c:4720 [inline]
 slab_alloc_node mm/slub.c:4854 [inline]
 kmem_cache_alloc_noprof+0x37d/0x650 mm/slub.c:4876
 __xfs_trans_alloc+0x26/0x410 fs/xfs/xfs_trans.c:220
 xfs_trans_alloc+0xd7/0x9b0 fs/xfs/xfs_trans.c:254
 xfs_vn_sync_lazytime+0xaf/0x150 fs/xfs/xfs_iops.c:1238
 sync_lazytime+0x12d/0x2d0 fs/fs-writeback.c:1721
 iput+0x230/0xe80 fs/inode.c:1997
 __dentry_kill+0x1a2/0x5e0 fs/dcache.c:670
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1147
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1174
 prune_dcache_sb+0x119/0x180 fs/dcache.c:1256
 super_cache_scan+0x369/0x4b0 fs/super.c:223
 do_shrink_slab+0x6df/0x1170 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x830/0x1150 mm/shrinker.c:628
 shrink_one+0x2d9/0x710 mm/vmscan.c:4928
 shrink_many mm/vmscan.c:4989 [inline]
 lru_gen_shrink_node mm/vmscan.c:5067 [inline]
 shrink_node+0x3197/0x3a90 mm/vmscan.c:6047
 kswapd_shrink_node mm/vmscan.c:6894 [inline]
 balance_pgdat mm/vmscan.c:7070 [inline]
 kswapd+0x1742/0x2e10 mm/vmscan.c:7343
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Avoid running the lazytime timestamp transaction directly from the
final iput path for unhashed linked inodes. If iput() is dropping the
last reference to such an inode and dirtytime is still pending, expose
I_WILL_FREE before ->sync_lazytime() so that xfs_vn_sync_lazytime() can
detect this case, clear I_DIRTY_TIME, and defer the timestamp update to
inodegc instead.

Inodegc already provides the asynchronous context used for XFS
inactivation and reclaim work, which avoids running the transaction
from direct reclaim. If the deferred timestamp update fails in inodegc,
requeue the inode so that the update is retried instead of silently
dropping the dirtytime state. Flush inodegc before forcing the log in
xfs_fs_sync_fs() so that syncfs still waits for deferred dirtytime
updates to reach the log.

Reported-by: syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d78ace33ad4ee69329d5
Signed-off-by: Zhan Jun <zhanjun@uniontech.com>
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
---
 fs/inode.c          | 19 ++++++++++++++++++-
 fs/xfs/xfs_icache.c | 12 ++++++++++++
 fs/xfs/xfs_inode.c  | 29 ++++++++++++++++++++++++++---
 fs/xfs/xfs_inode.h  |  6 +++++-
 fs/xfs/xfs_iops.c   | 21 ++++++++++++++-------
 fs/xfs/xfs_super.c  |  4 ++++
 6 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b..dcd091cc1567 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1948,7 +1948,10 @@ static void iput_final(struct inode *inode)
 	VFS_BUG_ON_INODE(atomic_read(&inode->i_count) != 0, inode);
 
 	if (drop) {
-		inode_state_set(inode, I_FREEING);
+		if (inode_state_read(inode) & I_WILL_FREE)
+			inode_state_replace(inode, I_WILL_FREE, I_FREEING);
+		else
+			inode_state_set(inode, I_FREEING);
 	} else {
 		inode_state_set(inode, I_WILL_FREE);
 		spin_unlock(&inode->i_lock);
@@ -1994,6 +1997,20 @@ void iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
+	/*
+	 * If the final iput is tearing down an unhashed inode with lazytime
+	 * updates pending, expose I_WILL_FREE before ->sync_lazytime() so that
+	 * filesystems can defer expensive work out of the reclaim path.
+	 */
+	if (inode->i_nlink && inode_unhashed(inode) &&
+	    (inode_state_read_once(inode) & I_DIRTY_TIME)) {
+		spin_lock(&inode->i_lock);
+		if (inode_unhashed(inode) &&
+		    (inode_state_read(inode) & I_DIRTY_TIME))
+			inode_state_set(inode, I_WILL_FREE);
+		spin_unlock(&inode->i_lock);
+	}
+
 	if (inode->i_nlink && sync_lazytime(inode))
 		goto retry;
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a7a09e7eec81..8ddbe16633f2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -52,6 +52,7 @@ static int xfs_icwalk(struct xfs_mount *mp,
 		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
 static int xfs_icwalk_ag(struct xfs_perag *pag,
 		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
+static void xfs_inodegc_queue(struct xfs_inode *ip);
 
 /*
  * Private inode cache walk flags for struct xfs_icwalk.  Must not
@@ -1944,6 +1945,17 @@ xfs_inodegc_inactivate(
 	int			error;
 
 	trace_xfs_inode_inactivating(ip);
+	if (xfs_iflags_test_and_clear(ip, XFS_IDIRTY_TIME) &&
+	    VFS_I(ip)->i_nlink != 0) {
+		error = xfs_inode_sync_dirtytime(ip);
+		if (error) {
+			xfs_iflags_set(ip, XFS_IDIRTY_TIME);
+			xfs_iflags_clear(ip, XFS_INACTIVATING);
+			xfs_inodegc_queue(ip);
+			return error;
+		}
+	}
+
 	error = xfs_inactive(ip);
 	xfs_inodegc_set_reclaimable(ip);
 	return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 50c0404f9064..22b4f4e4c09e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1288,9 +1288,10 @@ xfs_inactive_ifree(
 
 /*
  * Returns true if we need to update the on-disk metadata before we can free
- * the memory used by this inode.  Updates include freeing post-eof
- * preallocations; freeing COW staging extents; and marking the inode free in
- * the inobt if it is on the unlinked list.
+ * the memory used by this inode.  Updates include flushing deferred lazytime
+ * timestamp updates; freeing post-eof preallocations; freeing COW staging
+ * extents; and marking the inode free in the inobt if it is on the unlinked
+ * list.
  */
 bool
 xfs_inode_needs_inactive(
@@ -1321,6 +1322,10 @@ xfs_inode_needs_inactive(
 	if (xfs_is_internal_inode(ip))
 		return false;
 
+	/* Linked inodes can defer lazytime updates to inodegc. */
+	if (xfs_iflags_test(ip, XFS_IDIRTY_TIME))
+		return true;
+
 	/* Want to clean out the cow blocks if there are any. */
 	if (cow_ifp && cow_ifp->if_bytes > 0)
 		return true;
@@ -1340,6 +1345,24 @@ xfs_inode_needs_inactive(
 	return xfs_can_free_eofblocks(ip);
 }
 
+int
+xfs_inode_sync_dirtytime(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
+	return xfs_trans_commit(tp);
+}
+
 /*
  * Save health status somewhere, if we're dumping an inode with uncorrected
  * errors and online repair isn't running.
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d33557194..61d7e7559de3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -415,6 +415,9 @@ static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
  */
 #define XFS_IREMAPPING		(1U << 15)
 
+/* Flush dirty timestamps from inodegc before reclaiming the inode. */
+#define XFS_IDIRTY_TIME		(1U << 16)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -429,7 +432,7 @@ static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
 	 XFS_EOFBLOCKS_RELEASED | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
-	 XFS_INACTIVATING | XFS_IQUOTAUNCHECKED)
+	 XFS_INACTIVATING | XFS_IQUOTAUNCHECKED | XFS_IDIRTY_TIME)
 
 /*
  * Flags for inode locking.
@@ -645,6 +648,7 @@ extern struct kmem_cache	*xfs_inode_cache;
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
+int xfs_inode_sync_dirtytime(struct xfs_inode *ip);
 
 struct xfs_inode *xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino);
 int xfs_iunlink_reload_next(struct xfs_trans *tp, struct xfs_buf *agibp,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 208543e57eda..7ed81616625f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1232,15 +1232,22 @@ xfs_vn_sync_lazytime(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
 
-	if (xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp))
+	/*
+	 * VFS sets I_WILL_FREE before write_inode_now() when eviction is about
+	 * to tear down the inode, so defer the timestamp transaction to inodegc.
+	 */
+	if (inode_state_read_once(inode) & I_WILL_FREE) {
+		spin_lock(&inode->i_lock);
+		inode_state_clear(inode, I_DIRTY_TIME);
+		spin_unlock(&inode->i_lock);
+		if (inode->i_nlink != 0)
+			xfs_iflags_set(ip, XFS_IDIRTY_TIME);
+		return;
+	}
+
+	if (xfs_inode_sync_dirtytime(ip))
 		return;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
-	xfs_trans_commit(tp);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f8de44443e81..f7d2edc07ef8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -821,6 +821,10 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
+	error = xfs_inodegc_flush(mp);
+	if (error)
+		return error;
+
 	error = xfs_log_force(mp, XFS_LOG_SYNC);
 	if (error)
 		return error;
-- 
2.50.1

