Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795560602;
	b=ookcsBMnKjAx4tDdHSU0Gnw/WQVK+N8qUazmi3mAFH/i5o4Z9SgQE87l+pyCsC7X9V6u
	 yeR6RZIgw4pufPvY/rnZ+Scv+jgYxC4GemRYjbFxxcj6Rmuyrx9WMURWqtfTbWmPvBNyI
	 6Vg7UUrrqXREhaYNtD9o5rTv71NnAqG39YC9jmScDqlsSDcCOs7b80KiUG6VaFyJRjBdZ
	 GexHBTgI7OjQ6VjhNnvnMQlCN7hMPw352n+47P73ifFOETp3yf/1TMn2lXVc3H4/nsLao
	 1o4Iiot5AQIbn+/bbhHdc6b0TLh+WUKSsu06m0lOjQqyIBb5ZJyMpvEibJKt8ATaq2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560602;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=a2Ffas3bLeeCGSUnr0XQ4vHOK5iuvqsq87RRMDoP0wk=;
	b=WxI9/9IhCpZT4jYwLxWKlN3fQtEI4xUMaX9bFWoTjV7IKF2lpfT7yJAlYP/KnDdKe5Ea
	 6uenCJSylCj1H4zPmOtL/Wfvm7UHQJi1KjlEa9gEYWxwDs7gxGtUck+CKT5hscw0NsXF7
	 DoFdunCx4gSPnpvnOQC/CDT0RFN6xTJoR3Y0AN4XCmrWNaNqkLXXoztWlKayDMYvbY+sX
	 0rkVFc2KZrT1Wpshb/dJEKvbvRRgSS1nChE7ZRyMOglIIXFGUEHWTfEChHpIclEkqsqSq
	 mfLoQI/E77lFmrLTkyMmYiTJJtt2yEWZa/sIeTBWZ0qIeRjsUsI7WG+SchVrFKlUMyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kVZYz7tj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F119560A260E;
	Tue, 24 Nov 2026 22:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kVZYz7tj
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795560601;
	b=OTjiw0obrMKdlYFxDoU7mWQt2di8kYIbUFLDvjjvFysX0g0GR+T12qtbuF0cACQEXKEK
	 3zMVH7oTP3AksVsLWboYKcd1v0FLu2gSEh4xqpSSw9Yo0xHITVkBIYY9IFnQt2NnB3R35
	 kMLAux9j9WzEZt9yraDb9S0bLlsT4LbP5kT2/82c59r9Gmb6jyRLqtnZtd+y0Kq/yTZIG
	 /oZv/AcMVCZVfwUx6BTOaEwkK90xnW+KCtCQbvLRrwFFZR+h5DbilO3m/9ktETQpXxC1Q
	 k1vpE6ml5WNH9011d+0JiEI/+NQURu8fi7Ry9YzPive4D2d/xb8qp1CZ/O8uFKNgstQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795560601;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=a2Ffas3bLeeCGSUnr0XQ4vHOK5iuvqsq87RRMDoP0wk=;
	b=EKbOHUoMc8TRCMfoAYodm12MTLRFUgPMbpNkwAC6uZ02M2XAKH2BUA6NrSboSPyGGD4v
	 4mKwJOfxs/3zDYIkDdJpNvj8tfTkHaR0ZyGhhere9Fxca25CGE6MnmLJXiHr5FFeHKT6x
	 vZ3am6TcI/MG1o/WUjPOM+4GlFxR6N//bLgNNa75MLOUBpmTmn+INIjY5nFdIWykll0Pv
	 34+C4TD9lv9BYHz24R5+ljWCM8+RjckN0zMawS4H3STGTl75YqnX+L1MvgoPnSQ/N04Ho
	 49fw51EgV3eY2gMjniQ5RGslmuvO4DZN2TCJ7/na+kQEmow4tahMGx/TI2AXcIPpyZw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 104721F000C6;
	Tue, 24 Nov 2026 22:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560601;
	bh=a2Ffas3bLeeCGSUnr0XQ4vHOK5iuvqsq87RRMDoP0wk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kVZYz7tj21VFLx0X8Br1rg83j6fLPJpSBiNS19hhkHHXNnLpZtEhS5OGHiRrcPG6G
	 WUEckJwxWc9/Z22rcIHzBHA9kRjopyqWVnC2MATKvHrWKz9B0zJJZRW9I6MpSYTnWG
	 39D9vzJrIdvvvhp74aOZIU0z8bhZ9zOtjs+pK4GO1dnk64Uba5SAdnufSgCwHlAEpG
	 GZA9v3c5Paye3bOEnezbc9AoS3j+a0Gq6p/92rwnLo87ZBRTMwFOufP2Q6h293AzWF
	 qzz8b/sqUex01ixk3LJF9sqQuvwvmpFSrG6PO4cX0pWi762UjTvsRInzJDdVH5zKsy
	 3t+z+mT4/rnGw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EC2374CC34;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
From: Ernest Borowski via B4 Relay <devnull+ernest.borowski.git.proton.me@kernel.org>
Date: Tue, 24 Nov 2026 23:49:43 +0100
Subject: [PATCH v2 09/11] ntfs: zero new delalloc clusters even when
 writeback allocates them
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
Message-Id: <20261124-b4-ntfs-delalloc-fixes-v2-9-f394c800ec03@proton.me>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9573;
 i=ernest.borowski.git@proton.me; s=default; h=from:subject:message-id;
 bh=XEJQKTLIixRNBY3im1HoKIxgT03eHpIBNJyLu/JSGrU=;
 b=owGbwMvMwCVWzJ65uCpJ5D/jabUkhmw2kQaXA9JXLVMTjt9eGHZRse3a21sSYTHO52c7/BHti
 ZLTFXzRUcrCIMbFICumyNLx/0aIT8i3T8vitPpg5rAygQxh4OIUgImkrWP47xl5Un2Zwof+p68Y
 n8k3N9X+2WnFe+5IvLlG3+V9P10+LmD4H8+zZ76ObseHzqCNL0uZp+9Z8KI2MnE+90Ze4z6l7Dt
 7WQA=
X-Developer-Key: i=ernest.borowski.git@proton.me; a=openpgp;
 fpr=88FFD8544C54F6F2A65E2A8E730769A37A6214FF
X-Endpoint-Received: by B4 Relay for ernest.borowski.git@proton.me/default
 with auth_id=1589
X-Original-From: Ernest Borowski <ernest.borowski.git@proton.me>
Reply-To: ernest.borowski.git@proton.me
Content-Transfer-Encoding: 7bit

From: Ernest Borowski <ernest.borowski.git@proton.me>

When a buffered write starts or ends inside a cluster that is a hole,
ntfs_write_simple_iomap_begin_non_resident() turns the hole into an
LCN_DELALLOC run and then zeroes the part of the first and last cluster
that the write does not cover, in the page cache, so that writeback
writes whole clusters.  initialized_size already covers that part, and
the clusters writeback allocates are not zeroed on disk.

The zeroing runs after mrec_lock and the runlist lock are dropped, and
its ->iomap_valid() check, ntfs_iomap_valid(), calls the mapping stale
as soon as the run is no longer delalloc.  Writeback that runs meanwhile
(the background flusher, or FIEMAP_FLAG_SYNC and sync_file_range(),
which do not take the inode lock) picks up the folios that were zeroed
first, and ntfs_attr_map_cluster() allocates the whole delalloc run for
them.  iomap_zero_range() then stops with -EPERM from
ntfs_zero_read_iomap_end(), which the caller ignores.  The rest of the
cluster is neither in the page cache nor on disk, so reads return what
the reallocated clusters held before: data of deleted or truncated files.

Reproducer: fill a file, fsync, truncate it to 0 and back up, then write
small pieces at unaligned offsets into the holes while other threads
call FIEMAP with FIEMAP_FLAG_SYNC.  With 4 KiB and 64 KiB clusters the
old contents show up within seconds, also without the FIEMAP threads.

The validity check was there to keep the zeroing from overwriting data
that an mmap write put into the new cluster in that window.  Hold the
invalidate lock across ->iomap_begin() of a buffered write instead,
which keeps page faults out from the moment the hole becomes delalloc
until it is zeroed, and zero with the plain seek mapping, which zeroes
delalloc and mapped ranges alike, so that writeback allocating the run
no longer matters.  The error path of ->iomap_begin() now runs with the
invalidate lock held.

Fixes: b041ca562526 ("ntfs: update iomap and address space operations")
Cc: stable@vger.kernel.org
Signed-off-by: Ernest Borowski <ernest.borowski.git@proton.me>
---
 fs/ntfs/iomap.c | 127 ++++++++++++++++++++++++--------------------------------
 1 file changed, 55 insertions(+), 72 deletions(-)

diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index 1909824c30..fd94d4b34f 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -297,39 +297,6 @@ static int ntfs_read_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 DEFINE_IOMAP_ITER_NEXT_END(ntfs_read_iomap_next, ntfs_read_iomap_begin,
 		ntfs_read_iomap_end);
 
-/*
- * Check that the cached iomap still matches the NTFS runlist before
- * iomap_zero_range() is called. if the runlist changes while iomap is
- * iterating a cached iomap, iomap_zero_range() may overwrite folios
- * that have been already written with valid data.
- */
-static bool ntfs_iomap_valid(struct inode *inode, const struct iomap *iomap)
-{
-	struct ntfs_inode *ni = NTFS_I(inode);
-	struct runlist_element *rl;
-	s64 vcn, lcn;
-
-	if (!NInoNonResident(ni))
-		return false;
-
-	vcn = iomap->offset >> ni->vol->cluster_size_bits;
-
-	down_read(&ni->runlist.lock);
-	rl = __ntfs_attr_find_vcn_nolock(&ni->runlist, vcn);
-	if (IS_ERR(rl)) {
-		up_read(&ni->runlist.lock);
-		return false;
-	}
-	lcn = ntfs_rl_vcn_to_lcn(rl, vcn);
-	up_read(&ni->runlist.lock);
-	return lcn == LCN_DELALLOC;
-}
-
-static const struct iomap_write_ops ntfs_zero_iomap_folio_ops = {
-	.put_folio = ntfs_iomap_put_folio,
-	.iomap_valid = ntfs_iomap_valid,
-};
-
 static int ntfs_seek_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
@@ -337,17 +304,6 @@ static int ntfs_seek_iomap_begin(struct inode *inode, loff_t offset, loff_t leng
 			srcmap, false, false);
 }
 
-static int ntfs_zero_read_iomap_end(struct inode *inode, loff_t pos, loff_t length,
-		ssize_t written, unsigned int flags, struct iomap *iomap)
-{
-	if ((flags & IOMAP_ZERO) && (iomap->flags & IOMAP_F_STALE))
-		return -EPERM;
-	return written;
-}
-
-static DEFINE_IOMAP_ITER_NEXT_END(ntfs_zero_read_iomap_next,
-		ntfs_seek_iomap_begin, ntfs_zero_read_iomap_end);
-
 DEFINE_IOMAP_ITER_NEXT(ntfs_seek_iomap_next, ntfs_seek_iomap_begin);
 
 int ntfs_dio_zero_range(struct inode *inode, loff_t offset, loff_t length)
@@ -362,19 +318,28 @@ int ntfs_dio_zero_range(struct inode *inode, loff_t offset, loff_t length)
 				     BLKDEV_ZERO_NOUNMAP);
 }
 
+/*
+ * Zero the part of a new delalloc cluster that the buffered write does not
+ * cover, in the page cache, so that writeback writes the whole cluster.
+ * Writeback can allocate the delalloc run while this runs (the folios
+ * zeroed first are dirty), so the zeroing must not depend on the mapping
+ * staying delalloc: iomap_zero_range() zeroes delalloc and mapped ranges
+ * alike.  The caller holds the invalidate lock, which keeps page faults
+ * from putting data into the cluster meanwhile.
+ */
 static int ntfs_zero_range(struct inode *inode, loff_t offset, loff_t length)
 {
-	return iomap_zero_range(inode,
-				offset, length,
-				NULL,
-				ntfs_zero_read_iomap_next,
-				&ntfs_zero_iomap_folio_ops,
+	lockdep_assert_held_write(&inode->i_mapping->invalidate_lock);
+
+	return iomap_zero_range(inode, offset, length, NULL,
+				ntfs_seek_iomap_next, &ntfs_iomap_folio_ops,
 				NULL);
 }
 
-static void ntfs_write_delalloc_release(struct inode *inode, loff_t pos,
-					loff_t length, ssize_t written,
-					unsigned int flags, struct iomap *iomap);
+static void __ntfs_write_delalloc_release(struct inode *inode, loff_t pos,
+					  loff_t length, ssize_t written,
+					  unsigned int flags,
+					  struct iomap *iomap);
 
 static int ntfs_write_simple_iomap_begin_non_resident(struct inode *inode, loff_t offset,
 						      loff_t length, struct iomap *iomap)
@@ -528,8 +493,7 @@ static int ntfs_write_simple_iomap_begin_non_resident(struct inode *inode, loff_
 							      z_start,
 							      z_end - z_start);
 			}
-			if ((!err || err == -EPERM) &&
-			    max_clu_count > 1 &&
+			if (!err && max_clu_count > 1 &&
 			    (iomap->length & vol->cluster_size_mask &&
 			     end < ni->initialized_size)) {
 				loff_t z_start, z_end;
@@ -544,16 +508,15 @@ static int ntfs_write_simple_iomap_begin_non_resident(struct inode *inode, loff_
 							      z_end - z_start);
 			}
 
-			if (err == -EPERM)
-				err = 0;
 			if (err) {
 				/*
 				 * Nothing will be copied: drop the delalloc
 				 * clusters that no zeroed folio covers.
 				 */
-				ntfs_write_delalloc_release(inode, offset,
-							    iomap->length, 0,
-							    IOMAP_WRITE, iomap);
+				__ntfs_write_delalloc_release(inode, offset,
+							      iomap->length, 0,
+							      IOMAP_WRITE,
+							      iomap);
 				return err;
 			}
 		}
@@ -721,16 +684,27 @@ static int ntfs_write_iomap_begin_non_resident(struct inode *inode, loff_t offse
 	struct ntfs_inode *mrec_ni = ntfs_inode_is_named_stream(ni) ?
 			ntfs_base_inode(ni) : ni;
 
-	mutex_lock(&mrec_ni->mrec_lock);
+	if (ntfs_iomap_flags & NTFS_IOMAP_FLAGS_BEGIN) {
+		int err;
 
-	if (ntfs_iomap_flags & NTFS_IOMAP_FLAGS_BEGIN)
-		return  ntfs_write_simple_iomap_begin_non_resident(inode, offset,
-								   length, iomap);
-	else
-		return ntfs_write_da_iomap_begin_non_resident(inode,
-							      offset, length,
-							      flags, iomap,
-							      ntfs_iomap_flags);
+		/*
+		 * A hole becomes delalloc here and the rest of its partial
+		 * clusters is zeroed after the locks below are dropped: keep
+		 * page faults, which could write into those clusters, out
+		 * until then.
+		 */
+		filemap_invalidate_lock(inode->i_mapping);
+		mutex_lock(&mrec_ni->mrec_lock);
+		err = ntfs_write_simple_iomap_begin_non_resident(inode, offset,
+								 length, iomap);
+		filemap_invalidate_unlock(inode->i_mapping);
+		return err;
+	}
+
+	mutex_lock(&mrec_ni->mrec_lock);
+	return ntfs_write_da_iomap_begin_non_resident(inode, offset, length,
+						      flags, iomap,
+						      ntfs_iomap_flags);
 }
 
 static int __ntfs_write_iomap_begin(struct inode *inode, loff_t offset,
@@ -802,9 +776,10 @@ static void ntfs_write_delalloc_punch(struct inode *inode, loff_t offset,
  * Punch them out again, keeping every cluster that has dirty data in the
  * page cache.
  */
-static void ntfs_write_delalloc_release(struct inode *inode, loff_t pos,
-					loff_t length, ssize_t written,
-					unsigned int flags, struct iomap *iomap)
+static void __ntfs_write_delalloc_release(struct inode *inode, loff_t pos,
+					  loff_t length, ssize_t written,
+					  unsigned int flags,
+					  struct iomap *iomap)
 {
 	struct ntfs_volume *vol = NTFS_I(inode)->vol;
 	loff_t start_byte, end_byte;
@@ -821,9 +796,17 @@ static void ntfs_write_delalloc_release(struct inode *inode, loff_t pos,
 	if (start_byte >= end_byte)
 		return;
 
-	filemap_invalidate_lock(inode->i_mapping);
 	iomap_write_delalloc_release(inode, start_byte, end_byte, flags, iomap,
 				     ntfs_write_delalloc_punch);
+}
+
+static void ntfs_write_delalloc_release(struct inode *inode, loff_t pos,
+					loff_t length, ssize_t written,
+					unsigned int flags, struct iomap *iomap)
+{
+	filemap_invalidate_lock(inode->i_mapping);
+	__ntfs_write_delalloc_release(inode, pos, length, written, flags,
+				      iomap);
 	filemap_invalidate_unlock(inode->i_mapping);
 }
 

-- 
2.56.1


