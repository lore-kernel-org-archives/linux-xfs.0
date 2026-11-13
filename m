Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571215;
	b=IKIAHzMh5HNlCVWY/WV9n0ljZfy8k3DZX1cwXyhdhoE1kAOecNtKe0ezplQCcvHlTbF6
	 AVIK716VMlrKTkfLITK4rcFpUMdZBI39T0D1PQQKbaU2rAkq8N4jBmWQX1eM/qyfjJnla
	 Z4ay3RZhqZ9wiEXKFCTIqzAR6vA/TLQjVkGeQDux20Uc/HVoAJTymE1Q7b3Bo8Lj06U35
	 aaW8iFszxNvUd/NgEy6j9TAtnFxkIGemvBObnedFDzt0wvULd5U9haf3P4TtDLKugUahH
	 vi6g0ig8cw4Ja5eIVISQXY3jL+ICYZqKVlDrUL56i9YhcEJ7p5x1j84o6eRPYaUez5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571215;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=4p0sOEMxtmNsp3R1xDDsbPPEb7o4F3JVoC+2Af2rtpo=;
	b=kSQfpCY1aJlkY/CANSkcxDIoKGygujEM9JVUFzULRLioRz4/NpAYFG3i7PQeJBeWTg67
	 nTwfSNlmZCpqkcxBYGI4/WQQ7c/UxDRpUL9oalxNl3eRXdGERXrMRT9Aznt+SeWVrOOw6
	 xyqZLFXSUMUwTEWeZ+/GC41Xsnkd1s/NtPNPtPyVdBPfuO4LL/qTRikK7RL9U8JzxqvED
	 5Y4DLAzn4zf3vYAhc3U7qZoQaKHthBDItXH4arp8ttb+Gpu+BcBymIwKlf7ZSgbWWmmSq
	 9jptnGGT+2Rq5XsVDRNM69IK3Bf/jQhv/a3mPAMG45ut6Q/00v9Q9hxKgmAZC8r9vFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKvL3rwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4C0606A88A;
	Fri, 13 Nov 2026 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKvL3rwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92A21F000C5;
	Fri, 13 Nov 2026 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571214;
	bh=4p0sOEMxtmNsp3R1xDDsbPPEb7o4F3JVoC+2Af2rtpo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HKvL3rwazdcQCO3oa5t3kvt9qtirfGajlNUScRhrOlPzVrVS+WLbWgKCk5k9Gzjyg
	 J5rQjeEiCJ/5FZ+6mbJmOCsAP05MmskuKkJ5CnFSbXeuMGW+kicSyT0/o+Px28bfb4
	 khjvrmVjPr0pqO2GDZZAJIpgg27+hp74fJ9lfUxJVqm2lYB1I6fk24cjd0SnyH7iSX
	 wQ0mpHU0hFKNOQ2YfMiz7PU23jiCz8rltBdahrbyQBukM5DNNLscVp9GRZFLJ3UHKV
	 OBmOKLWNGoYsLZLWfX355kTpX1HMnF6bayA9fcMtBpCodubvnBDhluyjo7qZiY03Yg
	 OtLD/DSdy3vyQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:58:57 +0100
Subject: [PATCH v3 01/33] jfs: free uncommitted anonymous tlocks when
 evicting an inode
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-1-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5941; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fGd3mqwHefcvtPwiRiUST+AMp4oJuL6AE505Gk4ephw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z0r5fC6jrkPt0nVv3xdfdXsx357tc/O5/b2fr/B2
 7nYuqWJo6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi/4oY/krrCiydOuVYYlvK
 u6LLol/2xTKYX65Z+/T9rzNfJ0uqrmhlZNiUbs59sr8j4UVNOvvdYyWFyiWtlz6YvDgze9n8rot
 ayUwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

jfs doesn't log block allocations made through ->write_begin() and
->writepages() right away. extAlloc() records them in anonymous
transaction locks that hang off the inode and puts the inode on the
global anonymous list. They only get committed when a later transaction
includes the inode, usually writeback calling ->write_inode() which ends
up in jfs_commit_inode(). jfs_evict_inode() relies on that and BUG()s
when the inode is still on the anonymous list.

But nothing guarantees that writeback ran before eviction. With
errors=remount-ro, the default, an error sets SB_RDONLY and
sync_filesystem() skips read-only superblocks. So unmounting the
filesystem after an error evicts every inode that allocated blocks since
it was last written back without committing anything and the BUG_ON()
fires. Writing a file and hitting an error before the flusher got to the
inode is enough:

  kernel BUG at fs/jfs/inode.c:175!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:jfs_evict_inode+0x33c/0x440
  Call Trace:
   <TASK>
   evict+0x336/0x8b0
   evict_inodes+0x421/0x850
   generic_shutdown_super+0xaf/0x530
   kill_block_super+0x36/0xa0
   deactivate_locked_super+0x97/0xf0
   cleanup_mnt+0x9a/0x130
   task_work_run+0x135/0x230
   exit_to_user_mode_loop+0x171/0x560
   do_syscall_64+0x410/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

Just taking the inode off the anonymous list isn't enough. The tlocks
come from TxLock which is shared by all jfs mounts, txLock() pointed
mp->lid at them and pinned the metapages with metapage_nohomeok(). Leak
them and every other jfs filesystem eventually blocks in txBeginAnon()
waiting for tlocks that never come back.

So free them the way txUnlock() frees the tlocks of a committed
transaction: drop the metapage_nohomeok() pin, reset mp->lid and free
the linelocks and the tlock itself. txAbort() isn't a good model here as
it only drops the pin for pages that are on the logsync list and leaves
the linelocks alone. A metapage that carries nothing but the uncommitted
change isn't written home. The superblock is marked dirty after an error
so fsck has to look at the filesystem anyway.

Note that jfs_sync() takes an inode it can't grab off the anonymous list
without freeing anything so check jfs_ip->atlhead instead of the list.

Fixes: 8a9cd6d67672 ("JFS: Fix race in txLock")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/inode.c      |  9 +++++++
 fs/jfs/jfs_txnmgr.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/jfs/jfs_txnmgr.h |  1 +
 3 files changed, 78 insertions(+)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index c7914dbc91ed9..6390d915c7f11 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -172,6 +172,15 @@ void jfs_evict_inode(struct inode *inode)
 	clear_inode(inode);
 	dquot_drop(inode);
 
+	/*
+	 * Writeback commits the anonymous transactions of allocations. If the
+	 * filesystem went read-only without a sync, e.g. after an error,
+	 * nothing did.
+	 */
+	if (ji->atlhead) {
+		WARN_ON_ONCE(!sb_rdonly(inode->i_sb));
+		txAbortAnon(inode);
+	}
 	BUG_ON(!list_empty(&ji->anon_inode_list));
 
 	spin_lock_irq(&ji->ag_lock);
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 083dbbb0c3268..85192dd4461a4 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2581,6 +2581,74 @@ void txFreelock(struct inode *ip)
 	TXN_UNLOCK();
 }
 
+/*
+ *	txAbortAnon()
+ *
+ * function:	free the anonymous tlocks of an inode that is evicted
+ *		before writeback committed them, e.g. because an error made
+ *		the filesystem read-only.
+ *
+ * A page that carries nothing but uncommitted changes isn't written home.
+ * A page that is also waiting to go home with committed changes (mp->lsn)
+ * goes home with both, after an error the superblock is marked dirty.
+ */
+void txAbortAnon(struct inode *ip)
+{
+	struct jfs_inode_info *jfs_ip = JFS_IP(ip);
+	struct linelock *linelock;
+	struct metapage *mp;
+	struct tlock *tlck;
+	lid_t lid, next, llid, k;
+
+	/* txQuiesce() and jfs_sync() commit under the commit_mutex */
+	mutex_lock(&jfs_ip->commit_mutex);
+
+	TXN_LOCK();
+	lid = jfs_ip->atlhead;
+	jfs_ip->atlhead = jfs_ip->atltail = 0;
+	list_del_init(&jfs_ip->anon_inode_list);
+	TXN_UNLOCK();
+
+	for (; lid; lid = next) {
+		tlck = lid_to_tlock(lid);
+		next = tlck->next;
+		mp = tlck->mp;
+
+		if (mp && (tlck->flag & tlckPAGELOCK)) {
+			/* undo txLock()'s metapage_nohomeok() */
+			hold_metapage(mp);
+			if (!mp->lsn)
+				clear_bit(META_dirty, &mp->flag);
+			TXN_LOCK();
+			mp->lid = 0;
+			TXN_UNLOCK();
+			_metapage_homeok(mp);
+			put_metapage(mp);
+		} else if (mp) {
+			/* the xtree root in the inode, it isn't written anymore */
+			TXN_LOCK();
+			if (jfs_ip->xtlid == lid)
+				jfs_ip->xtlid = 0;
+			else
+				mp->lid = 0;
+			TXN_UNLOCK();
+		}
+
+		TXN_LOCK();
+		llid = ((struct linelock *) &tlck->lock)->next;
+		while (llid) {
+			linelock = (struct linelock *) lid_to_tlock(llid);
+			k = linelock->next;
+			txLockFree(llid);
+			llid = k;
+		}
+		txLockFree(lid);
+		TXN_UNLOCK();
+	}
+
+	mutex_unlock(&jfs_ip->commit_mutex);
+}
+
 /*
  *	txAbort()
  *
diff --git a/fs/jfs/jfs_txnmgr.h b/fs/jfs/jfs_txnmgr.h
index ba71eb5ced567..e9a7547afd3f6 100644
--- a/fs/jfs/jfs_txnmgr.h
+++ b/fs/jfs/jfs_txnmgr.h
@@ -288,6 +288,7 @@ extern struct linelock *txLinelock(struct linelock *);
 extern void txFreeMap(struct inode *, struct maplock *, struct tblock *, int);
 extern void txEA(tid_t, struct inode *, dxd_t *, dxd_t *);
 extern void txFreelock(struct inode *);
+extern void txAbortAnon(struct inode *);
 extern int lmLog(struct jfs_log *, struct tblock *, struct lrd *,
 		 struct tlock *);
 extern void txQuiesce(struct super_block *);

-- 
2.53.0

