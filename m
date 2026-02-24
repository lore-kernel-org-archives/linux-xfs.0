Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9759F39E194
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 13:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771941592; cv=none; b=rHgKH7CWkdd8Dpm9o23H8ZwMl6fIgLqmdiLtRP5FixheAUP34XWLKPCaesduXESgLLhuH/b1rxEXKHaQal6oIkzOOAzEMkCOlFndP4Poyr6PdWqF/SVDqsGXjqucKBHoNBSKBZaiR13auBNdD77gs6wByZ0vksgWRXf2d1LJF6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771941592; c=relaxed/simple;
	bh=90IGV3yzq5sMBiIOOmjMy1yyxw0778eEePLVtS4GeLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfyBYgHGS0YkuLQm0VUBnc104g0K4ROjg132mfQszUKdE0s+5dqnk2qw0NwOh28rhZc+dGuF8b5EBXLx9K4bMomeZvjmfCmNvsU+YcpmhEQkkdNR8sV0ChLOSf3ArIN+hO1th08et2FFfzdeZQqcJO0tyuYC6G36PeBcjfaLqmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o3z6/Skd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o3z6/Skd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NnbfZ1NWNxJfHLx7ZVnEC3FsLQO0RnLRPpJYzV5kIto=; b=o3z6/Skdiir04ekHL7Rvpeg294
	FKSlHGisIwusojWviF0Bspl2Daj/8gBrv/CRYZzx3qdp8YnV7afdySEVedvDYLnm8Hsz+qZAK1m2y
	FF8I9UUbavIAjxlXTHdrciQ+oOhLnSHAsjmxMe7fnu2z8oLKoLvVlfnGb6HJW6DcxWKWvD6O8LDLC
	S8qbb6oIQa+2xBjyKoH2rXbn/2aCNtpFLjLbRLSLMIqNfv5a1rzlXuWZgVnstIpybLnrl/NqqonYp
	ZyeBrVoycTNGkhWLu7kwlY3Jpn2F3AEUhvoTfYeQB8E3WRkTt+XMxoRTC8PRlxPvA9Br3hc2zdAK7
	pJauVQAA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuswx-00000002Alh-16IW;
	Tue, 24 Feb 2026 13:59:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: remove metafile inodes from the active inode stat
Date: Tue, 24 Feb 2026 05:59:36 -0800
Message-ID: <20260224135942.364932-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224135942.364932-1-hch@lst.de>
References: <20260224135942.364932-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The active inode (or active vnode until recently) stat can get much larger
than expected on file systems with a lot of metafile inodes like zoned
file systems on SMR hard disks with 10.000s of rtg rmap inodes.

Remove all metafile inodes from the active counter to make it more useful
to track actual workloads and add a separate counter for active metafile
inodes.

This fixes xfs/177 on SMR hard drives.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  4 ++++
 fs/xfs/libxfs/xfs_metafile.c  |  5 +++++
 fs/xfs/xfs_icache.c           |  5 ++++-
 fs/xfs/xfs_stats.c            | 11 ++++++++---
 fs/xfs/xfs_stats.h            |  3 ++-
 5 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a017016e9075..3794e5412eba 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -268,6 +268,10 @@ xfs_inode_from_disk(
 	}
 	if (xfs_is_reflink_inode(ip))
 		xfs_ifork_init_cow(ip);
+	if (xfs_is_metadir_inode(ip)) {
+		XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
+		XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
+	}
 	return 0;
 
 out_destroy_data_fork:
diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index cf239f862212..71f004e9dc64 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -61,6 +61,9 @@ xfs_metafile_set_iflag(
 	ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
 	ip->i_metatype = metafile_type;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
+	XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
 }
 
 /* Clear the metadata directory inode flag. */
@@ -74,6 +77,8 @@ xfs_metafile_clear_iflag(
 
 	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	XFS_STATS_INC(ip->i_mount, xs_inodes_active);
+	XFS_STATS_DEC(ip->i_mount, xs_inodes_meta);
 }
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f76c6decdaa3..f2d4294efd37 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -172,7 +172,10 @@ __xfs_inode_free(
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list));
-	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
+	if (xfs_is_metadir_inode(ip))
+		XFS_STATS_DEC(ip->i_mount, xs_inodes_meta);
+	else
+		XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
 
 	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
 }
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index bc4a5d6dc795..c13d600732c9 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -59,7 +59,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "rtrefcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
 		{ "qm",			xfsstats_offset(xs_gc_read_calls)},
-		{ "zoned",		xfsstats_offset(__pad1)},
+		{ "zoned",		xfsstats_offset(xs_inodes_meta)},
+		{ "metafile",		xfsstats_offset(xs_xstrat_bytes)},
 	};
 
 	/* Loop over all stats groups */
@@ -99,16 +100,20 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 
 void xfs_stats_clearall(struct xfsstats __percpu *stats)
 {
+	uint32_t	xs_inodes_active, xs_inodes_meta;
 	int		c;
-	uint32_t	xs_inodes_active;
 
 	xfs_notice(NULL, "Clearing xfsstats");
 	for_each_possible_cpu(c) {
 		preempt_disable();
-		/* save xs_inodes_active, it's a universal truth! */
+		/*
+		 * Save the active / meta inode counters, as they are stateful.
+		 */
 		xs_inodes_active = per_cpu_ptr(stats, c)->s.xs_inodes_active;
+		xs_inodes_meta = per_cpu_ptr(stats, c)->s.xs_inodes_meta;
 		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
 		per_cpu_ptr(stats, c)->s.xs_inodes_active = xs_inodes_active;
+		per_cpu_ptr(stats, c)->s.xs_inodes_meta = xs_inodes_meta;
 		preempt_enable();
 	}
 }
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 64bc0cc18126..57c32b86c358 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -142,7 +142,8 @@ struct __xfsstats {
 	uint32_t		xs_gc_read_calls;
 	uint32_t		xs_gc_write_calls;
 	uint32_t		xs_gc_zone_reset_calls;
-	uint32_t		__pad1;
+/* Metafile counters */
+	uint32_t		xs_inodes_meta;
 /* Extra precision counters */
 	uint64_t		xs_xstrat_bytes;
 	uint64_t		xs_write_bytes;
-- 
2.47.3

