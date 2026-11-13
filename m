Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571332;
	b=JBxiDO4EXgzbOfnPVMSe782oXv69V4ZxnfWAis3261OWDNWGwFGBkfr1hqkk/hgg0Nsg
	 9w5Kt1xQZNNFJZ7p6f0jFqUFZn1KrF4CFtVi6nJGducKg78yCq9BzdWhejPdamBS8lX6B
	 6Beb0i03R8POFmTvw9hj61uWoRBJzevG/esWIK1b9ifQr//0jtenf/+erEixCNMrAa4Sb
	 39ivj7uh/9UDLFlfCgsG+njFVl0TBNDeUs9jIEAEyJBb30xgmbzsYHW0g8iDM0fBiaEsy
	 E3RMULQGF2qbqd9j6N4j6yzjTGF3qLsohjJTcawKUSWoA0I9K1C4eZvxEM3C87b1GKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571332;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=wvxqV6rBMhuwjgNvbm4HdYkiAl72akCQocg4irtd5xY=;
	b=wvO0KUrp4FAjxrbOqwQPlOxXVsx7XhYknN2+xmKkarOJeawOzhygo3Ih3EZAmz1Ttj59
	 s50zM5Mpi8/PrC4lGLVx3zpg0CwXl3JHuA5xFeR+NRtXAkPhm6mOGEI/aSup7Z96emZkJ
	 fYWYIuyJ4pjkLI4m8ZrX+FchOhwwLnKbpvgvrxyzB3Z9Lq/YeYmBDHg1iKRLn73Tp9ULB
	 dNckYiP72HRPYZZI8wyGviwQYlWQIPqSrSNqOrl7ad3xiTjVqnmUIUh7B9yiqjMODnr/k
	 cRG4uE/bSeawqIaCn2Ck5K3ywceWZGd9u7CojeLNiaqR9bU/dZ30XUS2+Bti4lUnNAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mupl0aGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24EB606A33B;
	Fri, 13 Nov 2026 12:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mupl0aGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662D81F000C9;
	Fri, 13 Nov 2026 12:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571332;
	bh=wvxqV6rBMhuwjgNvbm4HdYkiAl72akCQocg4irtd5xY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mupl0aGoCEKRrJxTZLqZbVpXPKIl7wKiL4i08LuH57sJaIGeQDbF3qDkf4HWkWkmF
	 IWp95SsS9DvzX0/D+DJNCRmp684iI/OAxb0prndGs1l2/wQhCGekwGqqqi8CLN+ht1
	 cQVYnj7KFusuXb7D1t9qrN9UHUXmPENkLkAi7v5FXFuJI89xcfjGM1Fy8ylnoZrzMB
	 y1/BW3gEa1gE33/+iuoRZkywUx1tuTbvfVLUF5HbHJBDK+3N+D5zqWGInn5SlBcj51
	 fDy6xfIOHlZyeIfMjNqMgrKLjLXFiXxKPf7mwrLl8uFS+BGgTA2EtF6AEDranfWg+Q
	 vFEoVZu64l2eA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:24 +0100
Subject: [PATCH v3 28/33] gfs2: don't set SB_RDONLY on withdraw
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-28-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4737; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4Z6USPkDhlKo3OfSZLyvVwhHh60YY76o8yAB54W4804=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+727L16KRXrVgZCrfyQ/3px6cJFhQfWXVzs2T/3BE
 soxaVZVQEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEWGQZGa6db35d9Nbo46Ne
 d6vFc3O11wqfKFsl3+Dia9Trf8rblJGR4eM202nmndteVuQbCTPcclgS4pGZOCNdJOR2MZfLhN2
 3+QE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

do_withdraw() sets SB_RDONLY from the withdraw work without holding
s_umount, also on a frozen filesystem. FITHAW then fails because a
withdrawn filesystem can't take the freeze glock. Emergency thaw and the
gfs2 "freeze" sysfs file see SB_RDONLY and leave the s_writers rwsems
locked. Writers hang and umount warns. And freezing after a withdraw
fails and leaves the superblock frozen.

SDF_WITHDRAWN already stops all modifications, so stop setting
SB_RDONLY. A few things have to come with that:

(1) gfs2_evict_inode() and gfs2_quota_sync() check gfs2_withdrawn()
    next to sb_rdonly().
(2) gfs2_write_inode() returns EIO once withdrawn because sync and
    umount don't skip writeback for a read-only superblock anymore.
(3) gfs2_do_thaw() thaws even if the freeze glock can't be taken again.
(4) gfs2_freeze_super() refuses a withdrawn filesystem with EIO and
    thaws the superblock itself if the withdraw happens while it tries
    to freeze.

This can't be split up. With only (3) FITHAW leaks the rwsems of the
read-only superblock. With only the SB_RDONLY change FITHAW can't
release the rwsems a freeze took after a withdraw.

A remount to read-only writes nothing once do_withdraw() ran and waits
for it since the previous patch, so sysrq u works on a withdrawn gfs2.
Going read-write still fails with EIO. A withdrawn filesystem stays "rw"
in /proc/mounts and statfs() doesn't report ST_RDONLY anymore. The
withdraw file in sysfs still shows it.

Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait for it to finish")
Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/gfs2/quota.c |  2 +-
 fs/gfs2/super.c | 20 ++++++++++++++++++--
 fs/gfs2/util.c  |  5 +++--
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index b2984fb7b35c3..affe4c3451f5b 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1335,7 +1335,7 @@ int gfs2_quota_sync(struct super_block *sb, int type)
 	u64 sync_gen;
 	int error = 0;
 
-	if (sb_rdonly(sdp->sd_vfs))
+	if (sb_rdonly(sdp->sd_vfs) || gfs2_withdrawn(sdp))
 		return 0;
 
 	qda = kzalloc_objs(struct gfs2_quota_data *, max_qd);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f61c309368ef1..82f9d90f35788 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -455,6 +455,9 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int ret = 0;
 	bool flush_all = (wbc->sync_mode == WB_SYNC_ALL || gfs2_is_jdata(ip));
 
+	if (gfs2_withdrawn(sdp))
+		return -EIO;
+
 	if (flush_all)
 		gfs2_log_flush(GFS2_SB(inode), gl,
 			       GFS2_LOG_HEAD_FLUSH_NORMAL |
@@ -686,7 +689,8 @@ static int gfs2_do_thaw(struct gfs2_sbd *sdp, enum freeze_holder who, const void
 	int error;
 
 	error = gfs2_freeze_lock_shared(sdp);
-	if (error)
+	/* A withdrawn filesystem can't get the freeze glock back, thaw anyway. */
+	if (error && !gfs2_withdrawn(sdp))
 		goto fail;
 	error = thaw_super(sb, who, freeze_owner);
 	if (!error)
@@ -751,6 +755,11 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who,
 		mutex_unlock(&sdp->sd_freeze_mutex);
 		return -EBUSY;
 	}
+	/* A withdrawn filesystem can't take the freeze glock anymore. */
+	if (gfs2_withdrawn(sdp)) {
+		mutex_unlock(&sdp->sd_freeze_mutex);
+		return -EIO;
+	}
 
 	for (;;) {
 		error = freeze_super(sb, who, freeze_owner);
@@ -767,6 +776,13 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who,
 			break;
 		}
 
+		/* Withdrawn meanwhile, don't take the freeze glock again. */
+		if (gfs2_withdrawn(sdp)) {
+			(void)thaw_super(sb, who, freeze_owner);
+			error = -EIO;
+			goto out;
+		}
+
 		(void)gfs2_do_thaw(sdp, who, freeze_owner);
 
 		if (error == -EBUSY)
@@ -1488,7 +1504,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	int ret;
 
 	gfs2_holder_mark_uninitialized(&gh);
-	if (sb_rdonly(sb) || !ip->i_no_addr || !gl)
+	if (sb_rdonly(sb) || gfs2_withdrawn(sdp) || !ip->i_no_addr || !gl)
 		goto out;
 
 	/*
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 888e0d6bf5122..e720f73b7b24e 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -132,9 +132,10 @@ static void do_withdraw(struct gfs2_sbd *sdp)
 			   gfs2_log_is_empty(sdp),
 			   HZ * 5);
 
-	sdp->sd_vfs->s_flags |= SB_RDONLY;
-
 	/*
+	 * No SB_RDONLY, that needs s_umount. SDF_WITHDRAWN already stops all
+	 * modifications.
+	 *
 	 * Dequeue any pending non-system glock holders that can no
 	 * longer be granted because the file system is withdrawn.
 	 */

-- 
2.53.0

