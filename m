Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E18A3264DA;
	Sat,  5 Sep 2026 01:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788570667; cv=none; b=SFwYDtEKyN7r032feVGZvPIBcnXPR6yvCCVq/8sJiMInPofc63JUpSIQlNsV7hj8SDfAb7iCHBtAW8U3xrt37G8v/6I+fhEyBQOccJED24e0pfSPCqVqFi3P1vvH6AUE06YtlOlLqZqADHXTBxH5AThjqtkjZUJSaJtiGcG6rDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788570667; c=relaxed/simple;
	bh=RICrcWzmCBx47rH4egIBI2UPURYwBDwPG5ZXc7l8hj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R//1BCa8WJE838x0+Jj8lh3e3tDVf/1cMl6h2ZNhwu+YE3GZRJOy+E/3W4EE0BCq2JM1vdwKpHgWR+15b4TtRvSKIi8D4S2MLdLqKu1uYd0UV+lF+/SzoqjOgN3XVwbonMWLYO05Z9efLhvUL3sW3xRHe6a5qJLtk4auRsHcxEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hcFcX1k4lzKHMRm;
	Sat,  5 Sep 2026 09:10:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 600194058D;
	Sat,  5 Sep 2026 09:11:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HgkibJtqoQUnAw--.57899S4;
	Sat, 05 Sep 2026 09:11:00 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: cem@kernel.org,
	dgc@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH V2] xfs: remove several unused and never-implemented declarations
Date: Sat,  5 Sep 2026 09:03:54 +0800
Message-ID: <20260905010354.142327-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3HgkibJtqoQUnAw--.57899S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCrW5XFyktF1kGF18ZFWUArb_yoWruw17pa
	n7Kw1UK3yDJr15ua4kAF4Yv347Kwn3Cr48Crs5GwsIv3s8Gr1fKF17tr1kAw1jga1Fgry3
	ur1jk348XwnxCFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28I
	cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
	IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
	42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
	IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280
	aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Over time a number of function declarations in various headers have become
stale: either their implementations were removed when their last callers
went away, or they were never implemented in the first place. None of them
refer to anything anymore.

Remove the following dead declarations and the unused stub:

- xlog_assign_tail_lsn() and xlog_assign_tail_lsn_locked()
- xfs_iext_realloc()
- xfs_buf_iodone()
- xfs_scrub_tester() and xfs_scrub_setup_inode_bmap_data() (never
  implemented placeholders)
- the !CONFIG_XFS_ONLINE_REPAIR stub of xrep_tempfile_iolock_both()

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
v2:
 - Squash the individual cleanup patches into a single patch, as suggested
   by Carlos.
 - Drop the former patch 4, since an equivalent change has already been
   merged upstream.
 - Remove the "Assisted-by:" tag.

v1: https://lore.kernel.org/all/20260904060648.1966130-1-wozizhi@huaweicloud.com/

 fs/xfs/scrub/common.h   | 1 -
 fs/xfs/scrub/scrub.h    | 1 -
 fs/xfs/scrub/tempfile.h | 4 ----
 fs/xfs/xfs_buf_item.h   | 1 -
 fs/xfs/xfs_inode.h      | 1 -
 fs/xfs/xfs_log.h        | 2 --
 6 files changed, 10 deletions(-)

diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 9d627fd50687..f0f073a93413 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -74,7 +74,6 @@ int xchk_setup_ag_rmapbt(struct xfs_scrub *sc);
 int xchk_setup_ag_refcountbt(struct xfs_scrub *sc);
 int xchk_setup_inode(struct xfs_scrub *sc);
 int xchk_setup_inode_bmap(struct xfs_scrub *sc);
-int xchk_setup_inode_bmap_data(struct xfs_scrub *sc);
 int xchk_setup_directory(struct xfs_scrub *sc);
 int xchk_setup_xattr(struct xfs_scrub *sc);
 int xchk_setup_symlink(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 6d7d3523b71f..737a5d6db15f 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -261,7 +261,6 @@ static inline int xchk_nothing(struct xfs_scrub *sc)
 }
 
 /* Metadata scrubbers */
-int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
 int xchk_agf(struct xfs_scrub *sc);
 int xchk_agfl(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index 71c1b54599c3..d44ed43bafe0 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -39,10 +39,6 @@ int xrep_tempfile_roll_trans(struct xfs_scrub *sc);
 void xrep_tempfile_copyout_local(struct xfs_scrub *sc, int whichfork);
 bool xrep_is_tempfile(const struct xfs_inode *ip);
 #else
-static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
-{
-	xchk_ilock(sc, XFS_IOLOCK_EXCL);
-}
 # define xrep_is_tempfile(ip)		(false)
 # define xrep_tempfile_adjust_directory_tree(sc)	(0)
 # define xrep_tempfile_rele(sc)
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 3159325dd17b..28c79989d725 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -60,7 +60,6 @@ static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
 {
 }
 #endif /* CONFIG_XFS_QUOTA */
-void	xfs_buf_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct kvec *iovec);
 
 unsigned int xfs_buf_inval_log_space(unsigned int map_count,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 34c1038ebfcd..1602027cd0aa 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -585,7 +585,6 @@ uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
 int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
-void		xfs_iext_realloc(xfs_inode_t *, int, int);
 
 int		xfs_log_force_inode(struct xfs_inode *ip);
 void		xfs_iunpin_wait(xfs_inode_t *);
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index ca66429bf6c9..f715695e8fcb 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -105,8 +105,6 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
 void	xfs_log_mount_cancel(struct xfs_mount *);
-xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	xfs_log_space_wake(struct xfs_mount *mp);
 int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
 			struct xlog_ticket **ticket, bool permanent);
-- 
2.52.0

