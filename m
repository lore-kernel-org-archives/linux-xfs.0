Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D75309DC4
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 04:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760415794; cv=none; b=bejn+cKKeu3UkJKn8zygbXzSzHp6ETvVnfCTW40ojAvMezwQyK3pI80jFxhMNc3YwI09zIjpYwnXA4KrTfBcIa0FnhBAFWWUTE3Z2T1CVDTFr33uO4WHTnLytlXMfutQNLMamrsaOv3y9oXlhzwQb4wSm0IHn4RvOyteXot2cUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760415794; c=relaxed/simple;
	bh=J8k8X9PgL4Lr9Kg73IgGm+xhVbQ1/KEyTwS/MyI1Dp8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V2/JzB28BGgWR0SfoaXgiJrTcXkgxU/3mMpdlJYQ1vhYvW/E391BnigkVx9AWiXGt0E4h3OEdjJmNdj2bAjFybxVOIlLi1cDIrdKic05RJfeeBM/8CJ3Ni3H3y21QsWNHJgJNJEjcxsrqy+h2UO3hbMTxYRjhV7g/NKGqSqCxKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kl2K8Mma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kl2K8Mma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66943C4CEF1;
	Tue, 14 Oct 2025 04:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760415792;
	bh=J8k8X9PgL4Lr9Kg73IgGm+xhVbQ1/KEyTwS/MyI1Dp8=;
	h=From:To:Cc:Subject:Date:From;
	b=Kl2K8MmaRiEy7WW8e2F1InCddqn86RUFlA7eK2fJ6bpd3Qk5i3560OmTbWweWVXVi
	 LOY7Wwx416BZOkU1Sp6g+HIeOUG8iEicoJRIAaXImRrJ0JKvk8A1sYMte7dAxsk1D+
	 8LboPJNresUtCOEOihIc1MN2po1IpqpI9zxGgD9m8MEknf9ol2LcdU2DeRP8cQTTGO
	 TTu2lzcazBfmVwGIIC+XnG+blfdH26hH1HiFOKiIV/q9/9+H5AddCh6GSOUjzACYNB
	 OlIP9dV1WDv1jCdhHEifblu5EfgEd+xob+yNQK6yQk5sqeEEh7aLX2tGopxZBVSVXx
	 X4iFPdummNFYQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v4] xfs: do not tightly pack-write large files
Date: Tue, 14 Oct 2025 13:19:45 +0900
Message-ID: <20251014041945.760013-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using a zoned realtime device, tightly packing of data blocks
belonging to multiple closed files into the same realtime group (RTG)
is very efficient at improving write performance. This is especially
true with SMR HDDs as this can reduce, and even suppress, disk head
seeks.

However, such tight packing does not make sense for large files that
require at least a full RTG. If tight packing placement is applied for
such files, the VM writeback thread switching between inodes result in
the large files to be fragmented, thus increasing the garbage collection
penalty later when the RTG needs to be reclaimed.

This problem can be avoided with a simple heuristic: if the size of the
inode being written back is at least equal to the RTG size, do not use
tight-packing. Modify xfs_zoned_pack_tight() to always return false in
this case.

With this change, a multi-writer workload writing files of 256 MB on a
file system backed by an SMR HDD with 256 MB zone size as a realtime
device sees all files occupying exactly one RTG (i.e. one device zone),
thus completely removing the heavy fragmentation observed without this
change.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
Changes from v1:
 - Improved commit message
 - Improved code comments
Changes from v2:
 - Fixed typos in the commit message
Changes from v3:
 - Changed code comment as suggested by Christoph.

 fs/xfs/xfs_zone_alloc.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 1147bacb2da8..1b462cd5d8fa 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -614,14 +614,25 @@ static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
 }
 
 /*
- * Try to pack inodes that are written back after they were closed tight instead
- * of trying to open new zones for them or spread them to the least recently
- * used zone.  This optimizes the data layout for workloads that untar or copy
- * a lot of small files.  Right now this does not separate multiple such
+ * Try to tightly pack small files that are written back after they were closed
+ * instead of trying to open new zones for them or spread them to the least
+ * recently used zone. This optimizes the data layout for workloads that untar
+ * or copy a lot of small files. Right now this does not separate multiple such
  * streams.
  */
 static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
 {
+	struct xfs_mount *mp = ip->i_mount;
+	size_t zone_capacity =
+		XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].blocks);
+
+	/*
+	 * Do not pack write files that are already using a full zone to avoid
+	 * fragmentation.
+	 */
+	if (i_size_read(VFS_I(ip)) >= zone_capacity)
+		return false;
+
 	return !inode_is_open_for_write(VFS_I(ip)) &&
 		!(ip->i_diflags & XFS_DIFLAG_APPEND);
 }
-- 
2.51.0

