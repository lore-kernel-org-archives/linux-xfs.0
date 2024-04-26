Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C976536B17
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168553; cv=none; b=d/MPlgSWXpYQbfZfe3meb3bOmm9fBa+bmqFC2oN9Mhw7T6LLPz3OY8ob8PgetM9QI+PpaAgAbFv0hLGlpkLJ2bzn/IVkwBh7fAXlzSLSkOBO1nAQxFchQGmL7nkL+ObdfNiw0t/5FVvsYX3IQQkG3S9xlUmJffeTmvYHhg2g9i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168553; c=relaxed/simple;
	bh=cDNw2h8szMqN7PSm6qK1SYjyz55Y/sBYfDPdI3fCI/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2DHdWVvh9SwEFXhJyuH6djdC4hwBIXZ5NUJY6b0PnUjfy7sAF6Z8YxgpiG65p4rKTzvoj0mun1JDUdiYli47RdBM5Fbvg0InHFb+FC0KUQpBi5Nj8K0JCWwZ0mB4H0wbNXllRRyWxCJfcpafP5xNF084ouoeY7wyNXfpWijyyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxV6JGVI; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxV6JGVI"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e2b137d666so20634755ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168551; x=1714773351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VtJ3Oh3BhUQkvJodkW44JivQtUo2FHxaKkBN3Bo12AU=;
        b=hxV6JGVIqaLuutDEglztSIYW/dmvMRsfvvA+1VgDtKOjefIXGUpoT2SBkGG6cd3orz
         NslA6BqFZdJX03+X0MTHDT157ELV/d653KTbSp3phfQad+SlUcgYSzgurcOIZp0iXWBC
         p5/g9jbIloUF6hXK/2hBWN1Kf2mUIrISdV/DeBlXMlcP036vEIJEjeyTl2H4TJDbg5rs
         V9IRPaLNjk9NosERgFHqJMH4INVwsPab5VMg8j2BqgdDp/dXRyAVbOT4UFlQro0adoXm
         bvOJ2MySVcsLvEXRiCOfgV8LHGPIqGXGe9Ei/6UcWMTADOkVmhoLUQLhAfNW3bQFQQqF
         Jc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168551; x=1714773351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VtJ3Oh3BhUQkvJodkW44JivQtUo2FHxaKkBN3Bo12AU=;
        b=poTwvURhG+N+CpxhbSB8zl6E541JDZP6f+mbJv5fIteNe2mnf/W911zfemKIh2cxV2
         74VyDTxQFi2w9m5SftVmAA/vcs1TX5J2cTQ94ppIBFoMUWfSXE96i1XfIGrRVSo7eWTQ
         JyjWtUVitBSGvvPdwRDeXBHZLy+zu/7Ct0Rr2xd/xD2vMEig5bCsHqnZIWyOy8O7ttmf
         uft/hEaf0lDY87DDwQzk58FfwXzFJLZjbUBjoFm/lr6YnkX1nJ0j8Jrau+NUtwKnnKBY
         aPLUWN8EOKewjC2cvY747uyoG9mR8MM8Q0T79lw8zuNi64WdqaWpTSmQuB5llj61YJU1
         gNPQ==
X-Gm-Message-State: AOJu0Yyvk7kRReIqear84pdh+H7zC5Ywd1eb6ZlUEMhLSUK5hJmbUDQh
	b9Q2tTn1yONGdMWzkgVkYEDlziVfU4HkoXrSNRgfwHrP206W519EFXnhT4AE
X-Google-Smtp-Source: AGHT+IFagpbB1I1gaQhTzOdILjDixhdgyQK1FHcJn6mcRTmvKwkJDZKjB286MLLO90DDYBJp5SeXqA==
X-Received: by 2002:a17:902:bb87:b0:1e2:688e:597d with SMTP id m7-20020a170902bb8700b001e2688e597dmr3407277pls.21.1714168550967;
        Fri, 26 Apr 2024 14:55:50 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:50 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 02/24] xfs: punching delalloc extents on write failure is racy
Date: Fri, 26 Apr 2024 14:54:49 -0700
Message-ID: <20240426215512.2673806-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 198dd8aedee6a7d2de0dfa739f9a008a938f6848 ]

xfs_buffered_write_iomap_end() has a comment about the safety of
punching delalloc extents based holding the IOLOCK_EXCL. This
comment is wrong, and punching delalloc extents is not race free.

When we punch out a delalloc extent after a write failure in
xfs_buffered_write_iomap_end(), we punch out the page cache with
truncate_pagecache_range() before we punch out the delalloc extents.
At this point, we only hold the IOLOCK_EXCL, so there is nothing
stopping mmap() write faults racing with this cleanup operation,
reinstantiating a folio over the range we are about to punch and
hence requiring the delalloc extent to be kept.

If this race condition is hit, we can end up with a dirty page in
the page cache that has no delalloc extent or space reservation
backing it. This leads to bad things happening at writeback time.

To avoid this race condition, we need the page cache truncation to
be atomic w.r.t. the extent manipulation. We can do this by holding
the mapping->invalidate_lock exclusively across this operation -
this will prevent new pages from being inserted into the page cache
whilst we are removing the pages and the backing extent and space
reservation.

Taking the mapping->invalidate_lock exclusively in the buffered
write IO path is safe - it naturally nests inside the IOLOCK (see
truncate and fallocate paths). iomap_zero_range() can be called from
under the mapping->invalidate_lock (from the truncate path via
either xfs_zero_eof() or xfs_truncate_page(), but iomap_zero_iter()
will not instantiate new delalloc pages (because it skips holes) and
hence will not ever need to punch out delalloc extents on failure.

Fix the locking issue, and clean up the code logic a little to avoid
unnecessary work if we didn't allocate the delalloc extent or wrote
the entire region we allocated.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_iomap.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 5cea069a38b4..a2e45ea1b0cb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1147,6 +1147,10 @@ xfs_buffered_write_iomap_end(
 		written = 0;
 	}
 
+	/* If we didn't reserve the blocks, we're not allowed to punch them. */
+	if (!(iomap->flags & IOMAP_F_NEW))
+		return 0;
+
 	/*
 	 * start_fsb refers to the first unused block after a short write. If
 	 * nothing was written, round offset down to point at the first block in
@@ -1158,27 +1162,28 @@ xfs_buffered_write_iomap_end(
 		start_fsb = XFS_B_TO_FSB(mp, offset + written);
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
+	/* Nothing to do if we've written the entire delalloc extent */
+	if (start_fsb >= end_fsb)
+		return 0;
+
 	/*
-	 * Trim delalloc blocks if they were allocated by this write and we
-	 * didn't manage to write the whole range.
-	 *
-	 * We don't need to care about racing delalloc as we hold i_mutex
-	 * across the reserve/allocate/unreserve calls. If there are delalloc
-	 * blocks in the range, they are ours.
+	 * Lock the mapping to avoid races with page faults re-instantiating
+	 * folios and dirtying them via ->page_mkwrite between the page cache
+	 * truncation and the delalloc extent removal. Failing to do this can
+	 * leave dirty pages with no space reservation in the cache.
 	 */
-	if ((iomap->flags & IOMAP_F_NEW) && start_fsb < end_fsb) {
-		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
-					 XFS_FSB_TO_B(mp, end_fsb) - 1);
-
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-					       end_fsb - start_fsb);
-		if (error && !xfs_is_shutdown(mp)) {
-			xfs_alert(mp, "%s: unable to clean up ino %lld",
-				__func__, ip->i_ino);
-			return error;
-		}
+	filemap_invalidate_lock(inode->i_mapping);
+	truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
+				 XFS_FSB_TO_B(mp, end_fsb) - 1);
+
+	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+				       end_fsb - start_fsb);
+	filemap_invalidate_unlock(inode->i_mapping);
+	if (error && !xfs_is_shutdown(mp)) {
+		xfs_alert(mp, "%s: unable to clean up ino %lld",
+			__func__, ip->i_ino);
+		return error;
 	}
-
 	return 0;
 }
 
-- 
2.44.0.769.g3c40516874-goog

