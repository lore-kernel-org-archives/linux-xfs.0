Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF63374DB
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168554; cv=none; b=tUBjzVOzcVYWXqfhJJIYvu5HULLFNzwk1FlQ8fnrE8RdyKasACKt2MhtcOho9lVQTPvInVSP9cqhO+Q+nWbDrNd3nwAjL1II2d08WB0fMfSW5qGq3W4rh/YLNXHL+0HcurUxd3Ec+tLswlbxbhZjhdTkyZVtQv9ZQ5+uKd7OULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168554; c=relaxed/simple;
	bh=tez9F/jujdvr48D79dYs09SvYZr4oVrQVffiPgZLFXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGysoqSV8IoqBhuO6fztMGZKhI9P7+0byQxf/Fiuoghe/+iRCP3icDzEvVwhBXkNcV3e8CHeUe8ZEK81PpA/dtv5KUmUcUksx1cWYcUXCFJiB32eEEfngzAP5uB1vOlSDMgrygjlj+Kf/QRCPZ6nvdVXAX1ffyIjNyeNSTFPYAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W6Mt+V16; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6Mt+V16"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e651a9f3ffso15748095ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168552; x=1714773352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNOd3IiNCRIxmQqevajUQqiwaxq0SEglp4nSdU0BE84=;
        b=W6Mt+V16b+F7k3KrBrA7Ab5eqNd57Ey4WvaYX27LTOzKdN4mCoz6QNf1JkoY6B1DfX
         daKBguRwQh99oafz3AcDCNV5YWU4Yn5Sz5YqatmQP4tSJC8OSjUnDXEmeAPTueUU03HF
         HQv6i6CnIm1aH0dE3i6StuYGMvUT3u6m58IPjdcAlPXMMp2ximVQ7NNIEiDlVzPSWzpP
         IKsa3SRrF/iaJlFR/fN3XWUzVw1bx0HMaSt7hPhJsvMvEaKNEH+70X4ol3poyS4odOdz
         CS9D3MClAHoT5e4px1UGgtEWiVLvVltxFbs3dwW8PlplZrK4hSZ2rckx8HYOLONEevP3
         csaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168552; x=1714773352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNOd3IiNCRIxmQqevajUQqiwaxq0SEglp4nSdU0BE84=;
        b=BIIY7wu99SOZPZ6oQrFaDJjE4eBMEts2IcmcgKUex8FtwvsE0tWJ5JgskWAaCgUFjp
         2wX3ZytCcYgYnSeGYUzGa9wkuAuy4ngW4amoJIV54ec7M5bLnrPdoGBBax4p2DT17Vo+
         p4GQfPK/K0Yc5MGk7Mgl/xs6RB0moGuX4P+1TuFhClr8pHoF/LKrTLIC1u3aLKhZ7eOo
         JoE7V2s+nNcGAl4plpdlnO0G8idT1EFk4Q2faFIix2NPvF+Mq9ZZ89X+v3NUSGp7DQC1
         m1cBSh8dqXG0cQYQtnNXOeHhVA8S6F8YTdQfEvLlB7rMo7KKVj3aHIs60QF6npxoN1VJ
         yfWw==
X-Gm-Message-State: AOJu0YwhkjXPCJwQDxH1CD+F7sqafIKM0GqNkhXobGBkIZsvfsGNQTSt
	Dtwa9LquzHNGUbqzvxnxdhPgd4q+QjYEUZJGTqmE4cw429qM6K6SoQPXQ307
X-Google-Smtp-Source: AGHT+IGWtJF6xdd099UUWchl3r2sEloAd1dq4OMPl08jETkhgXG1oLCeAvj0oNsWugtOpytFxHJEag==
X-Received: by 2002:a17:902:f70a:b0:1eb:3d68:fc38 with SMTP id h10-20020a170902f70a00b001eb3d68fc38mr1730406plo.6.1714168551925;
        Fri, 26 Apr 2024 14:55:51 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:51 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 03/24] xfs: use byte ranges for write cleanup ranges
Date: Fri, 26 Apr 2024 14:54:50 -0700
Message-ID: <20240426215512.2673806-4-leah.rumancik@gmail.com>
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

[ Upstream commit b71f889c18ada210a97aa3eb5e00c0de552234c6 ]

xfs_buffered_write_iomap_end() currently converts the byte ranges
passed to it to filesystem blocks to pass them to the bmap code to
punch out delalloc blocks, but then has to convert filesytem
blocks back to byte ranges for page cache truncate.

We're about to make the page cache truncate go away and replace it
with a page cache walk, so having to convert everything to/from/to
filesystem blocks is messy and error-prone. It is much easier to
pass around byte ranges and convert to page indexes and/or
filesystem blocks only where those units are needed.

In preparation for the page cache walk being added, add a helper
that converts byte ranges to filesystem blocks and calls
xfs_bmap_punch_delalloc_range() and convert
xfs_buffered_write_iomap_end() to calculate limits in byte ranges.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_iomap.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a2e45ea1b0cb..7bb55dbc19d3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1120,6 +1120,20 @@ xfs_buffered_write_iomap_begin(
 	return error;
 }
 
+static int
+xfs_buffered_write_delalloc_punch(
+	struct inode		*inode,
+	loff_t			start_byte,
+	loff_t			end_byte)
+{
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
+
+	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
+				end_fsb - start_fsb);
+}
+
 static int
 xfs_buffered_write_iomap_end(
 	struct inode		*inode,
@@ -1129,10 +1143,9 @@ xfs_buffered_write_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		start_fsb;
-	xfs_fileoff_t		end_fsb;
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+	loff_t			start_byte;
+	loff_t			end_byte;
 	int			error = 0;
 
 	if (iomap->type != IOMAP_DELALLOC)
@@ -1157,13 +1170,13 @@ xfs_buffered_write_iomap_end(
 	 * the range.
 	 */
 	if (unlikely(!written))
-		start_fsb = XFS_B_TO_FSBT(mp, offset);
+		start_byte = round_down(offset, mp->m_sb.sb_blocksize);
 	else
-		start_fsb = XFS_B_TO_FSB(mp, offset + written);
-	end_fsb = XFS_B_TO_FSB(mp, offset + length);
+		start_byte = round_up(offset + written, mp->m_sb.sb_blocksize);
+	end_byte = round_up(offset + length, mp->m_sb.sb_blocksize);
 
 	/* Nothing to do if we've written the entire delalloc extent */
-	if (start_fsb >= end_fsb)
+	if (start_byte >= end_byte)
 		return 0;
 
 	/*
@@ -1173,15 +1186,12 @@ xfs_buffered_write_iomap_end(
 	 * leave dirty pages with no space reservation in the cache.
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
-	truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
-				 XFS_FSB_TO_B(mp, end_fsb) - 1);
-
-	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-				       end_fsb - start_fsb);
+	truncate_pagecache_range(inode, start_byte, end_byte - 1);
+	error = xfs_buffered_write_delalloc_punch(inode, start_byte, end_byte);
 	filemap_invalidate_unlock(inode->i_mapping);
 	if (error && !xfs_is_shutdown(mp)) {
-		xfs_alert(mp, "%s: unable to clean up ino %lld",
-			__func__, ip->i_ino);
+		xfs_alert(mp, "%s: unable to clean up ino 0x%llx",
+			__func__, XFS_I(inode)->i_ino);
 		return error;
 	}
 	return 0;
-- 
2.44.0.769.g3c40516874-goog

