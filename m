Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD35C2C68A
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168552; cv=none; b=phAIKFXVDdDH4ek+J1H+TzXDcQZA0ItjbLyooEus8YfyjuiOe99Jbq1KR1psFMj34ON4Ol3HSjfKvStTwC8OoeOAg9HkkeotjdvNNJ240ezXRJfSpf8D3QbxPOOvoGNOTFYkuflBhzUevevpGSjsDbh6SJEi7YTMh8eXzDDrLR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168552; c=relaxed/simple;
	bh=W/RqA4penfSt2iR1R5P1X3duWqQqT2Rk2QKzYlngOV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aV11QNHJWUymdFUpKJiQhsEhYXL3sQOClA/v23+M8aFQv9w0H5lHbK8tC6YZ/ZGgE490wkC8Lm6ZQ5mbznDU7fVqTeBadtEcfElPhq8Phz7xTp9WfdqgX0sfMLdVkpzc+XYJ0KIP26h0LjV7K0rAt1no0aJUVvFrdNLWURWjGzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dks9Xrnx; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dks9Xrnx"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e8bbcbc2b7so24572535ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168550; x=1714773350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7UbSJnNLr2zr485iBx6ewge0tt/tQzvK4CN6pAWgtqA=;
        b=Dks9XrnxmahWoWLWTv9f1DOAkhrBH5poIcxnySu5In2fyYf3PY7mpE2WbryJF6e3TL
         SZP2K6IYVDzyNxJLv//PAuE1/+RQeQjK7/R4Z20miT/Qqu7w0LXFTaQ1nwgjS+yWr3IX
         xLhgg3yNwegTKwatQiSQOkiXAjaYBWOgBaUfO+k/wMW5WFJrgPd8UwD3/0BfrqnGfmBs
         vyi4+/wsNpj3AjZ1464NURVEQpcRK1QSk3/Y3K/ZAKMg8xtw7qmW5Uo1amwtn8tGJgiD
         TClgG4jFo6yBLbf4zdouy0NL0vpLhjkDdpgZr0DiZvOPVnV1TXmJdyXuH4nQ4emupAdW
         sU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168550; x=1714773350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7UbSJnNLr2zr485iBx6ewge0tt/tQzvK4CN6pAWgtqA=;
        b=CvbYzEJWMcollEf0jtCtg+PucZVLcwwHzJUIxcE4iqHhSlzQmNiJScApfEkdWV6Ik1
         OeMfhPQouyaNByfUTKbRbfuxQIJoMn5PLncGHBfi+ms6YTKgX1X5QT0r1/qNiQDE0hXu
         lBe7moEhOxbsymaRQwPHC+6AD2uWHJ9zULuCVxiakzr/RvR0Wb/zzzi7JadiJsuXTnkh
         w3+qgZFxw2L8867kYbQvHZJHUhGOc5vrQpHNyF9gIfqbCJANPcN5gjSB6E9Itd9ej4Qf
         S7TUR2j2AhlyBVVgImO2W+RcEyHpRZzBg6lGWJZCik+MwcVoI2gj1FBfGrDIih0rObXU
         2NDQ==
X-Gm-Message-State: AOJu0Yw2trgesZ/3+N/4FyaCORfBZoPkHXBUlnkbJ6cAiuYhcEapq/5H
	FnGoLE59CAfbo2IdW/7eiaq/M6vW1uHiBI30eBlI/U42onLWLqAl59vW5WWJ
X-Google-Smtp-Source: AGHT+IGrhAdm0cC7jpboPIEo9+fO6sqpZOpAwtwSL6fG8bp9IUe6M/GdJOlZNu+jly0WusgPUyCMhg==
X-Received: by 2002:a17:902:da8a:b0:1e4:a667:5528 with SMTP id j10-20020a170902da8a00b001e4a6675528mr5304051plx.3.1714168549820;
        Fri, 26 Apr 2024 14:55:49 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:33 -0700 (PDT)
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
Subject: [PATCH 6.1 CANDIDATE 01/24] xfs: write page faults in iomap are not buffered writes
Date: Fri, 26 Apr 2024 14:54:48 -0700
Message-ID: <20240426215512.2673806-2-leah.rumancik@gmail.com>
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
2.44.0.769.g3c40516874-goog

