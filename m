Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747213956C;
	Wed,  1 May 2024 18:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588879; cv=none; b=I8/QVbZCdlT2o27N3knFKpWVVSeR0CBqW1NGt9X1HpkhOPg6p9uQsyoQJVab3IEPm3c0+Cod24qJcvWLFZEZMYdtnZMGSg88iwnlJm7FoTmRJgdOVOK+BK6R5+XO7aNFACqUzpovzaHlLDWXrOcN950jECFBlgv9im6OFPmwftw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588879; c=relaxed/simple;
	bh=P9oBPSZD1hJEDtFcGa7E9BvsU6RnCgNHdc4tg/ZjzBE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SxDdiwpLiy3Nx76xsB/ZINJhZRluFl7suVTWSmxVezNrNQKsjKRnvrN3anLfybXPMLl1UzCyWDQBpESwNqz1LvcgINzzBVIHvQtoAkSKhWIXhWvKSz0t+RseCg8UavvpOc3Mlr/1fnRHOmirdrFuairVYXdAea5mlOWJOgXX9u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0ErP4jb; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0ErP4jb"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6ed9fc77bbfso5642802b3a.1;
        Wed, 01 May 2024 11:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588877; x=1715193677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wr/NfIgq+jbAMo1m7k0HVw1tQ3q4qnnBmvcKhG6lVKM=;
        b=a0ErP4jbTwDHQTvM84Ti0DtKARA82dcd3/j9rYjfDy8R/k0JSKe+WQAutCgLosB4X+
         ECJc2lierJduLB2+lFjuRGGOHOBBbfR+xJ7kTxTRbSm0wy8FHa2ThhWHYx/WWYUDWRm3
         NzhYhloKwl3EXhgXQqzwWNYnBaag3z54no/hN3wGqTr18mXxWQcLeskdQPQC0jY0pe+J
         PsNzU9QoNRMGHouKy1vHiunpXy3DJ2yhUROmvQliZ7vannQKZWGuaJbHs/ufoEibv12m
         N9v7Xw5qJVACBH5jcKxW/A2U7bZXSHjf/XgKzCMhfP46tohjglzjysffiNPxZGmQLZkm
         SkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588877; x=1715193677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wr/NfIgq+jbAMo1m7k0HVw1tQ3q4qnnBmvcKhG6lVKM=;
        b=GuJx18YhIiadFoYOMcH2OTnFghzt2J3eeTmCS2S8xVnPr6fSOsHUl1L10Px0vV458o
         +qzsv5BzPd3TwdHpm2C0jIGa7idmQRej6SQ3McXU2vn2m5o1PP58VuweNbRTSknslvU+
         hfwW/sHH3XkYL0W9yfGM65jTmEUraxHGX70sc3ZN71QD6+xYXFN4HdcZmORUmy9ZKwZj
         7laxgtrhTBvTtfeNIUZ0f+hLhXmgNWzGMZ4lDUY2hJrjGqtDdEZD3YzGjzRDCSfTRRWc
         GZYdv6P/g3UOpZNH6o340auF5Yvs6be0NqoEHsvBrf+dnHXZlwsePYU+gGuEGD7ujTyw
         SyZw==
X-Gm-Message-State: AOJu0Yzryy8Ihc/QgLlC/6svJfJhxM3Su7yR9bPOAC+JVIgQz+4xQ9sL
	UATJzHJUPL7labMbRx+pWr5tvMViRwU9LBf66KjczqbHdGAvJhG9NQvMDZhM
X-Google-Smtp-Source: AGHT+IG0spdxbAD2Z0uQJib3T/aGol3IQEzdWvHXLsPEXNPN+wxJVQSiYNQAhW+W0X0ABg3cUQ1Z2g==
X-Received: by 2002:a05:6a20:daa9:b0:1a9:5ba1:3713 with SMTP id iy41-20020a056a20daa900b001a95ba13713mr4981513pzb.19.1714588876890;
        Wed, 01 May 2024 11:41:16 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:16 -0700 (PDT)
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
Subject: [PATCH 6.1 01/24] xfs: write page faults in iomap are not buffered writes
Date: Wed,  1 May 2024 11:40:49 -0700
Message-ID: <20240501184112.3799035-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 118e021b4b66f758f8e8f21dc0e5e0a4c721e69e ]

When we reserve a delalloc region in xfs_buffered_write_iomap_begin,
we mark the iomap as IOMAP_F_NEW so that the the write context
understands that it allocated the delalloc region.

If we then fail that buffered write, xfs_buffered_write_iomap_end()
checks for the IOMAP_F_NEW flag and if it is set, it punches out
the unused delalloc region that was allocated for the write.

The assumption this code makes is that all buffered write operations
that can allocate space are run under an exclusive lock (i_rwsem).
This is an invalid assumption: page faults in mmap()d regions call
through this same function pair to map the file range being faulted
and this runs only holding the inode->i_mapping->invalidate_lock in
shared mode.

IOWs, we can have races between page faults and write() calls that
fail the nested page cache write operation that result in data loss.
That is, the failing iomap_end call will punch out the data that
the other racing iomap iteration brought into the page cache. This
can be reproduced with generic/34[46] if we arbitrarily fail page
cache copy-in operations from write() syscalls.

Code analysis tells us that the iomap_page_mkwrite() function holds
the already instantiated and uptodate folio locked across the iomap
mapping iterations. Hence the folio cannot be removed from memory
whilst we are mapping the range it covers, and as such we do not
care if the mapping changes state underneath the iomap iteration
loop:

1. if the folio is not already dirty, there is no writeback races
   possible.
2. if we allocated the mapping (delalloc or unwritten), the folio
   cannot already be dirty. See #1.
3. If the folio is already dirty, it must be up to date. As we hold
   it locked, it cannot be reclaimed from memory. Hence we always
   have valid data in the page cache while iterating the mapping.
4. Valid data in the page cache can exist when the underlying
   mapping is DELALLOC, UNWRITTEN or WRITTEN. Having the mapping
   change from DELALLOC->UNWRITTEN or UNWRITTEN->WRITTEN does not
   change the data in the page - it only affects actions if we are
   initialising a new page. Hence #3 applies  and we don't care
   about these extent map transitions racing with
   iomap_page_mkwrite().
5. iomap_page_mkwrite() checks for page invalidation races
   (truncate, hole punch, etc) after it locks the folio. We also
   hold the mapping->invalidation_lock here, and hence the mapping
   cannot change due to extent removal operations while we are
   iterating the folio.

As such, filesystems that don't use bufferheads will never fail
the iomap_folio_mkwrite_iter() operation on the current mapping,
regardless of whether the iomap should be considered stale.

Further, the range we are asked to iterate is limited to the range
inside EOF that the folio spans. Hence, for XFS, we will only map
the exact range we are asked for, and we will only do speculative
preallocation with delalloc if we are mapping a hole at the EOF
page. The iterator will consume the entire range of the folio that
is within EOF, and anything beyond the EOF block cannot be accessed.
We never need to truncate this post-EOF speculative prealloc away in
the context of the iomap_page_mkwrite() iterator because if it
remains unused we'll remove it when the last reference to the inode
goes away.

Hence we don't actually need an .iomap_end() cleanup/error handling
path at all for iomap_page_mkwrite() for XFS. This means we can
separate the page fault processing from the complexity of the
.iomap_end() processing in the buffered write path. This also means
that the buffered write path will also be able to take the
mapping->invalidate_lock as necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  | 2 +-
 fs/xfs/xfs_iomap.c | 9 +++++++++
 fs/xfs/xfs_iomap.h | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e462d39c840e..595a5bcf46b9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1325,7 +1325,7 @@ __xfs_filemap_fault(
 		if (write_fault) {
 			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 			ret = iomap_page_mkwrite(vmf,
-					&xfs_buffered_write_iomap_ops);
+					&xfs_page_mkwrite_iomap_ops);
 			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 		} else {
 			ret = filemap_fault(vmf);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 07da03976ec1..5cea069a38b4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1187,6 +1187,15 @@ const struct iomap_ops xfs_buffered_write_iomap_ops = {
 	.iomap_end		= xfs_buffered_write_iomap_end,
 };
 
+/*
+ * iomap_page_mkwrite() will never fail in a way that requires delalloc extents
+ * that it allocated to be revoked. Hence we do not need an .iomap_end method
+ * for this operation.
+ */
+const struct iomap_ops xfs_page_mkwrite_iomap_ops = {
+	.iomap_begin		= xfs_buffered_write_iomap_begin,
+};
+
 static int
 xfs_read_iomap_begin(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index c782e8c0479c..0f62ab633040 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -47,6 +47,7 @@ xfs_aligned_fsb_count(
 }
 
 extern const struct iomap_ops xfs_buffered_write_iomap_ops;
+extern const struct iomap_ops xfs_page_mkwrite_iomap_ops;
 extern const struct iomap_ops xfs_direct_write_iomap_ops;
 extern const struct iomap_ops xfs_read_iomap_ops;
 extern const struct iomap_ops xfs_seek_iomap_ops;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

