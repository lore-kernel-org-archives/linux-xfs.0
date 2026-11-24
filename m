Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795560604;
	b=g1MHfYHhdneRG/Es3kL5M9PHkCNnr8qeHkV75ge1pePQalIvqz+ZoXHioU39GJlN66Ns
	 XLjT05VaEETtY1fWqzJWfJTy0AdBQxAcN4TuX8XvMbHQVxzVFwYxOm+STlhsbhYn2GQTX
	 7spdol3pLMT1j0yeYfljRGhfQsabxoQP/b9ZbBn0SGVGf7eZP40EZ/iRujlEetAlfuuk3
	 TKXQ+6cMmTxNC7I8A0G8k5Ka6aA1vstwAH99oLf8vOGQTYp3hPGbHeyrZjjWT/GxRt0UO
	 4+O39gzKoESYR+xZcQshFnJ+Ry7n+9aAHguSKLXMHzAzedPYx+xin3nDBU1B26rQtXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560604;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9ZSMBSkSC7UsFqqyxHWE7YOZQ6W+nTg/+9Gf8n1t5Fg=;
	b=kJJoIgXlBvrtuum51yGq9ak8JUbtYnrmcEhYPU+ar8s0SP440n5+p8aBwTQ+4Cq1bLia
	 7HtNeg16lhFRO/wXiJd0RYNamuTv0XHHmySYNS47kiPj/7D065sTReWWLGvbrAT9zGZIf
	 NxH0I3dSWlAZWzSyOLImtSIk/42b9WZg9x0EX42q4qCBXjWrC3+y6cDoQgmUF1JDiQrwj
	 n2G4t2pt6JQarFoU+auZhqHDoOLQic2DYjX2zE4+toIyKSReqTdYLEQUMwt9Qeb7OI60v
	 3f9aIU3zWiDN3AeXwDnxZNa+eMSqcfvCEkNqvDiDjn1ga0WtHuX/obNmgN/JzBJHqYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I302fu4Y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68535606A323;
	Tue, 24 Nov 2026 22:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I302fu4Y
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795560603;
	b=i3gj6Dk5mXTdGsQ/xwO99NmWwzqPCpHr6IF3asn2DDWRUB/yYOClnGcxFCswXYTXtPXp
	 giDJr0F3JkWuxAZ4eK4Xb94s4UsowPjnIQ0D/OgCe5jtIEMKH7NPSXvvLNotCIqbVZyCA
	 TVLDB3c3PkOdWVIWOsEkY5awMTYN2DnTAEAJxoHFciq0auM049y8Hk6ZioH6QpBa6m63v
	 KqXI9gDGSMDlPmiymPckm/gLoL0inZg4MaHmFknAgrHduENirqB7Z8dHPW5edqKOS3f6r
	 66sXkFF5gmb5Yg1QgnDUqVIR4DHjbVmg+FFimkDLWUF968ZC3BWHQWVwwtgLfO/i2Nw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795560603;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9ZSMBSkSC7UsFqqyxHWE7YOZQ6W+nTg/+9Gf8n1t5Fg=;
	b=OlWHC/En4fjjYoJlwS2pi2aUjxpVB/lROxQCguPeOtcCuXxSxLe2gWh8WL6lVP0KzVFM
	 K0FfPakwWmTNn0eb81dhaGZDR9NS9s9oJBRX3MQfImZP/9zpPayw2FC3zqaPso+hGIE1n
	 dHU3ESWH6e/CYH/jyzuWp8EjQSb+WF1GON7uRblR6P/Lq44/GSNvsRNT0bqEMhjzSlnfY
	 L0XMNuTU2zonyUNdtrO3GKOR1IEoV43NtEzQKZYvC79Xe9XoopYBu//6lLCRnZJrVdlpp
	 mqfp9Rtv3NtXkvPE7VrtRlSmhuZ0cNI/zZeIzXvQ2PpDKeV2GBqyyTuyYnN1gydMi3w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9916B1F00A01;
	Tue, 24 Nov 2026 22:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560603;
	bh=9ZSMBSkSC7UsFqqyxHWE7YOZQ6W+nTg/+9Gf8n1t5Fg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=I302fu4YhrbTBXmfQpDmbA5V70DOv4o6lPQmziRoNEeByW0/QV1WSnIyZKFJHOefM
	 ta7DtB5zDT/CX1kkwuDB6qAFoCC3J2SQYSIz57IXwLAco9e1ngma3YnqGhnj2toM2b
	 Ou6/Ceuwc/QqaEXza06CJSdZbS9DJ9KVS77uO52mThbIpoupoWrbqZAXlNQooNduwV
	 cqU7x+BKAPZEIzjwh0thtLwBqM515qzWGOwLCGWRDrAChfnUDmFL+auXKQMPTh9yDU
	 FK2Ypzpz6ajJT8tWVlWR/ELlnFb5aVlaFB/kFRE3hjgt7BvowobqRgcTquxFN0Scd/
	 6M+yrTAUCjV4w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 427224CC3C;
	Tue, 24 Nov 2026 22:49:39 +0000 (UTC)
From: Ernest Borowski via B4 Relay <devnull+ernest.borowski.git.proton.me@kernel.org>
Date: Tue, 24 Nov 2026 23:49:45 +0100
Subject: [PATCH v2 11/11] ntfs: revalidate a buffered write's mapping after
 its clusters were allocated
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
Message-Id: <20261124-b4-ntfs-delalloc-fixes-v2-11-f394c800ec03@proton.me>
References: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
In-Reply-To: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
To: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
 Baolin Liu <liubaolin12138@163.com>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 "Darrick J. Wong" <djwong@kernel.org>, ntfs@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng1024@gmail.com>, 
 stable@vger.kernel.org, Ernest Borowski <ernest.borowski.git@proton.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5793;
 i=ernest.borowski.git@proton.me; s=default; h=from:subject:message-id;
 bh=f2wotSxMN9uyJz+Y54H9BK5AnjHdsoo22xRtTQu7BLA=;
 b=owGbwMvMwCVWzJ65uCpJ5D/jabUkhmw2kYYzWnVpM/a9/LSZo+RiUPibxcdr0pce8GidknnRJ
 2RCfN3ejlIWBjEuBlkxRZaO/zdCfEK+fVoWp9UHM4eVCWQIAxenAExEZyMjwwWWdRqai5cnn/R5
 LnsgfqHwaoervqX98QHTXpzYcDDafB7DX4kXhxfn2xXpT+C7+qD3OHf0EZb+TYZsP7rm/VW02v5
 pIjMA
X-Developer-Key: i=ernest.borowski.git@proton.me; a=openpgp;
 fpr=88FFD8544C54F6F2A65E2A8E730769A37A6214FF
X-Endpoint-Received: by B4 Relay for ernest.borowski.git@proton.me/default
 with auth_id=1589
X-Original-From: Ernest Borowski <ernest.borowski.git@proton.me>
Reply-To: ernest.borowski.git@proton.me
Content-Transfer-Encoding: 7bit

From: Ernest Borowski <ernest.borowski.git@proton.me>

A buffered write turns a hole into an LCN_DELALLOC run in
->iomap_begin() and copies into the page cache afterwards, with only
the inode lock held.  A write fault or writeback does not take that
lock and can allocate the clusters in the meantime.  If the folio the
write has not reached yet is then written back and reclaimed,
__iomap_write_begin() still sees IOMAP_DELALLOC and zeroes the parts of
the block that the write does not cover instead of reading them, and
data that a write through a shared mapping put there is lost.

Reproducer: block the copy of a write into a hole on a userfaultfd page
before its second page, store a byte through a shared mapping next to
where the write ends, sync_file_range() the file and drop the page with
POSIX_FADV_DONTNEED, then let the copy go on.  The byte reads back as
zero.

Give the delalloc mapping of a buffered write a validity cookie.
ntfs_attr_map_cluster() bumps a per-inode count whenever it allocates
clusters, and ->iomap_valid() calls the mapping stale when the count
moved and its clusters are no longer all delalloc.  ->iomap_end() then
releases what was not copied, as for a short write, and the rest of the
write is mapped again.

Fixes: b041ca562526 ("ntfs: update iomap and address space operations")
Cc: stable@vger.kernel.org
Signed-off-by: Ernest Borowski <ernest.borowski.git@proton.me>
---
 fs/ntfs/attrib.c |  2 ++
 fs/ntfs/inode.c  |  1 +
 fs/ntfs/inode.h  |  3 +++
 fs/ntfs/iomap.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index cc24259fb6..4ec4ca3d87 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5643,6 +5643,8 @@ int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 	}
 	ni->runlist.rl = rl;
 	ni->runlist.count = new_rl_count;
+	/* Delalloc mappings of buffered writes in flight go stale. */
+	WRITE_ONCE(ni->alloc_seq, ni->alloc_seq + 1);
 
 	if (!update_mp) {
 		u64 free = atomic64_read(&vol->free_clusters) * 100;
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 911e68fa91..231f2799eb 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -557,6 +557,7 @@ void __ntfs_init_inode(struct super_block *sb, struct ntfs_inode *ni)
 	ni->target = NULL;
 	ni->linuxflags = 0;
 	ni->i_dealloc_clusters = 0;
+	ni->alloc_seq = 0;
 }
 
 /*
diff --git a/fs/ntfs/inode.h b/fs/ntfs/inode.h
index 7ea52c59c0..136062c9fb 100644
--- a/fs/ntfs/inode.h
+++ b/fs/ntfs/inode.h
@@ -94,6 +94,8 @@ enum ntfs_inode_mutex_lock_class {
  *   record. For fake inodes, the real (base) inode to which the attribute
  *   belongs.
  * @i_dealloc_clusters: delayed allocated clusters.
+ * @alloc_seq: bumped under the runlist lock whenever clusters are allocated
+ *   for a hole or delalloc run; a buffered write's ->iomap_valid() uses it.
  * @target: symlink buffer.
  * @linuxflags: Linux-specific file attributes loaded from the $LINUXFLAGS EA.
  */
@@ -144,6 +146,7 @@ struct ntfs_inode {
 		struct ntfs_inode *base_ntfs_ino;
 	} ext;
 	unsigned int i_dealloc_clusters;
+	unsigned int alloc_seq;
 	__le32 reparse_tag;
 	__le32 reparse_flags;
 	char *target;
diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index 928ccb685a..bdb176fdd4 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -80,8 +80,55 @@ static void ntfs_iomap_put_folio(struct inode *inode, loff_t pos,
 	folio_put(folio);
 }
 
+/* Never 0: a mapping with no cookie is not checked. */
+static u64 ntfs_alloc_cookie(struct ntfs_inode *ni)
+{
+	return (u64)READ_ONCE(ni->alloc_seq) + 1;
+}
+
+/*
+ * A buffered write maps a hole or delalloc run as delalloc and copies into
+ * the page cache afterwards, without the locks a write fault or writeback
+ * takes to allocate the clusters.  If one of them allocates them meanwhile
+ * and the folio is written back and reclaimed, __iomap_write_begin() would
+ * zero the parts of a block that the write does not cover instead of
+ * reading what a write through a mapping put there.  Every allocation
+ * bumps ni->alloc_seq; when it moved since the mapping was made, the
+ * mapping is still good only if its clusters are all still delalloc.
+ * A stale mapping ends like a short write (->iomap_end() releases what was
+ * not copied) and the rest of the write is mapped again.
+ */
+static bool ntfs_iomap_valid(struct inode *inode, const struct iomap *iomap)
+{
+	struct ntfs_inode *ni = NTFS_I(inode);
+	struct ntfs_volume *vol = ni->vol;
+	struct runlist_element *rl;
+	s64 vcn, end;
+	bool valid = true;
+
+	if (!iomap->validity_cookie ||
+	    iomap->validity_cookie == ntfs_alloc_cookie(ni))
+		return true;
+
+	vcn = ntfs_bytes_to_cluster(vol, iomap->offset);
+	end = ntfs_bytes_to_cluster(vol, round_up(iomap->offset + iomap->length,
+						  vol->cluster_size));
+	down_read(&ni->runlist.lock);
+	rl = __ntfs_attr_find_vcn_nolock(&ni->runlist, vcn);
+	if (IS_ERR(rl))
+		valid = false;
+	for (; valid && vcn < end; rl++) {
+		if (!rl->length || rl->lcn != LCN_DELALLOC)
+			valid = false;
+		vcn = rl->vcn + rl->length;
+	}
+	up_read(&ni->runlist.lock);
+	return valid;
+}
+
 const struct iomap_write_ops ntfs_iomap_folio_ops = {
 	.put_folio = ntfs_iomap_put_folio,
+	.iomap_valid = ntfs_iomap_valid,
 };
 
 static int ntfs_read_iomap_begin_resident(struct inode *inode, loff_t offset, loff_t length,
@@ -469,6 +516,7 @@ static int ntfs_write_simple_iomap_begin_non_resident(struct inode *inode, loff_
 			ni->runlist.count = new_rl_count;
 			ni->i_dealloc_clusters += max_clu_count;
 		}
+		iomap->validity_cookie = ntfs_alloc_cookie(ni);
 		up_write(&ni->runlist.lock);
 		mutex_unlock(&mrec_ni->mrec_lock);
 

-- 
2.56.1


