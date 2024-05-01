Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11C71474A7;
	Wed,  1 May 2024 18:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588880; cv=none; b=pjiI1hp9ngjqVJprmIVLfjhA8nyTIHfm+ybblIERy36ttKQMg7YhW9mJGtZ0Z+wvhLz+mmkErL9suyo/S/rKGbGfYzLBfCS7sXYyyn0UQysIoTtxQcwVIfTeNKkJpqTs1HvjSDgjbMJHGyUEvo3PYq3huZhWBLg35PS54EjBd2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588880; c=relaxed/simple;
	bh=+Byl/kC7YkhhThMJwXk3oAfH+CDX2UsRQW2jyRPiqXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQxLssmPm0Js/VSAWLOIEw8b6ZPqJ12uo8hWTbMlqgwYaSahiJq6vUx+mRXUVx5qHE73646nlE05AKKoad3Wxkw9XZl+jqFDv5bTPCiFP6KJ3MMXfNPnXtE9mbOC6zVHwy6c7bhpGCyEkOXpzvojdaMUKNLkbqdJVJ1m16Mqnjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TDNMUKQj; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDNMUKQj"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6f30f69a958so6116730b3a.1;
        Wed, 01 May 2024 11:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588878; x=1715193678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNwegdNS/Egq2Foyfpvt5YUY/2x41IGXuPxMuob2vsY=;
        b=TDNMUKQjDOskZvAi8+6D5rZ8g+mnM3xo967ZrvlTuulXCfOq+ekJCrX2IA+lQZTZa0
         sFsVyhvjINFfoDdqrF82E/ywfudvQMuWAo+YqYe6fmQKCo6Wr7lCYFjY447O+zuN0GS+
         8004HuHXKTso9CT2xOTz4jTieMMrNK7SmOvHxMXM4lEYlm2sF0KkjzlQwmK6io+6lVR2
         YOu9xFSSKsDhpZk2ZdYcnIEcEhTmizQe03hMbwNjShl3vTwtqoHlO/QHzRnrjIj3sqVv
         Ui+4IQ/Pp3lLjEumnQBuloVQBOQVru2GiWYvUNxrDpymTnY4BQrKeVbdOKc32pHOZkMj
         0PFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588878; x=1715193678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNwegdNS/Egq2Foyfpvt5YUY/2x41IGXuPxMuob2vsY=;
        b=wsKtlqy3u4XbmiZTvtDrOXBXGdBZTL/4yM6/EBFzJo66mISTwguV+V9lFIClfwK+Xe
         mLO3FDINupCHCFmKX2nVq0VE4B28r5LsvnkDojM6V3YJ7sPwPeBEYgrgUqBhIi05VY1Z
         jS4yebXbqkkHs4/GcenhcS+UjinkpsNVR0jeI1ScSsrkcCgUlj4PBV+lRKklralA8+Qf
         7Iq5rCYtgd1Rk3VfQo0r8iv0qqd5gumVNpPO2+c/YBQz6E+mlt/qzUxOePgJ5BYRi+ad
         d6BtJUIBu3iIqKYmpPyjON+0WPkjjERWrqdk8VcbuOc0t9OceOIuKCIfK2mav5oa0iUX
         2DVg==
X-Gm-Message-State: AOJu0Yyeg+wb+GaRbjorAuuw/3nrlaO+cdhGt6+XVAx0ke2FUEQTtdm7
	slsF3TaemqcAUnySIB7ceXhUq8c719HFFBDLbDIcbDCh33vNIF0OoNQO3uTt
X-Google-Smtp-Source: AGHT+IH9a6AkvP9xNu82iQ00STZNjL3bEH9dFmDcUPo02FJ7yLqebhEd9LCz7CgEJSSux89nJOtCpw==
X-Received: by 2002:a05:6a20:dd93:b0:1af:667e:fe40 with SMTP id kw19-20020a056a20dd9300b001af667efe40mr2718856pzb.6.1714588877894;
        Wed, 01 May 2024 11:41:17 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:17 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 02/24] xfs: punching delalloc extents on write failure is racy
Date: Wed,  1 May 2024 11:40:50 -0700
Message-ID: <20240501184112.3799035-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

