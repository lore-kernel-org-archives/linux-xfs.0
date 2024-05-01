Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A0B13956C;
	Wed,  1 May 2024 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588881; cv=none; b=lAHY5EzoFrl/vU9IR1+uDVNvaZFb3kAhuic4Eickb+vlZWF7nIDOIuSfqB/RHQWcq1pADMhWE1DjprLSprBMiG5OnT/d0iFD52zICovzZFiBFyvSKZ2H8K6ldpKcRRIeZPQ0urzCa8jhf+ftzoDbeIr7dWKiJeqAdWlF28AgzJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588881; c=relaxed/simple;
	bh=TfUzvPUmwsVSPJjQ9btlFyurpAU9t9EGVAeVDaoGwHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3sdtA+s9OHwZV+W9K/L4MaEi+LpyEydVAWNmQL2b+k3C7HJcG/ZKRS8XHpjqld87QFTIEqG8ezPGMyv7Q0/OAQIub/8TWjBXzrW0EM70sSSxajc3MmIgO/428JzP43O9+MN/XAIpmkDloTcihDziGpaysmQLeuwoLs7OkxREoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5NUYr3S; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5NUYr3S"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f103b541aeso5999642b3a.3;
        Wed, 01 May 2024 11:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588879; x=1715193679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdiJLB+AHJzJajGofbLN7+MPNfuM+jLRwA8Qk8g/FBM=;
        b=c5NUYr3SkKdjKQvaMQKey0Oce37bcFBYiUR0PYGgPpPhH2UlP2n287ZPRyEHsP/Se9
         XPi2FFQBjbPoFXYAnBpSMB4yzlJ5NFN5NE2hct8oifJphB+6+YVoO4vn+1QYlznmNlLY
         BKe8H8GrDrFtG3vM99VZTo8Gnt2Ukd6PTRnc3+x6BxQDJLHybEpjxKeTmVa5Uw0FbOV2
         sfQbUSYmRhbZFP4L72HGHtHROXH/dgg4ai+TWgoPV+FUeBAdf3tVICmiNLZ77UeIWmbS
         ZEBQqRjy29bbA2mtSHlWwSSyXrHHIUml1Vy4K9avnRuQZ6h39BVy5wb9F3vp/1BwfGMX
         mkxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588879; x=1715193679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QdiJLB+AHJzJajGofbLN7+MPNfuM+jLRwA8Qk8g/FBM=;
        b=vA+8iF6tKlFkn95hKwbhGL9Aq0xHDpQHVpdNsfJg5uaxtqY9wadgU6oIx97DoWM6Zh
         QilX7zVohf8b5FCcxj8RyX2vhZg14qa37hsuthwAQdwvliQzq7+7LOfxGawJIZNWu5P2
         12BbaVFCJeLevtcZwFWac+NpDEdWOSDir4OigsyZYQ3iMv8MOuUXMNfJxOZeG4sq0Es3
         2vX1VFsyjZTXiBDyC8G9IAgaNym5q6NEa5B5o0Px8mBPlen4jw3MVcPemR9YMkPLsgnx
         hZTbpeyq/NsabkgJI4tBtZpC3PURYQKdYnYSqPeIkWtPVJIqgqe4N1eno4MWSSmXbqFP
         ZfYQ==
X-Gm-Message-State: AOJu0YzxdqLUl7BR6uhA4u/NVxPo9fjjhjuEHv/SLE+uIJ+Nmrvba1EJ
	F2L5B9jG9sP4sAgqT0ZUQ2PMQPDcqQJmwQN5ENiZFVXPwqoHNcHS3k9w9ArZ
X-Google-Smtp-Source: AGHT+IFn6bu90g8GOBb261J0bt7+MLcx12yKdh4eTYFTkiz7BhIxHmhlQ8iCU9mreh3vtKkgjjabQw==
X-Received: by 2002:a05:6a20:1588:b0:1ab:b369:7bd3 with SMTP id h8-20020a056a20158800b001abb3697bd3mr3759757pzj.38.1714588878845;
        Wed, 01 May 2024 11:41:18 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:18 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 03/24] xfs: use byte ranges for write cleanup ranges
Date: Wed,  1 May 2024 11:40:51 -0700
Message-ID: <20240501184112.3799035-3-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

