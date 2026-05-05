Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41D034EF1C
	for <linux-xfs@vger.kernel.org>; Tue,  5 May 2026 12:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777985216; cv=none; b=uhkRQWAKxJ1S4auSqsJXPb3Ix2KrSagvmenNxmLMTaWe4zSu38ItQ3adhN/Wc6X0fSmDN5HzE180aZxQ+9JwrhD9DaO+Co8iETH/3jWeEtodMIS5/36Iz7yFAktwY0dge0ujKXbBhtbGOHh/JRJ5GyfIo4uBpgqiNGc2/Tq7TLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777985216; c=relaxed/simple;
	bh=WdLTUHQ4IK4gD4WmP/5C10CZKhgvSk2Zoahi5p0xF50=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M3zmWp8lknxa/IYqgdjrAIbn74lMEwK1KkfWPk4HZPV1iwmqOXaRs07Repj0eHNhX1OHXbO4bieQ8/LnZVz/53Dwilh6hQsu/91SOx4NSVwyygqVuM/Xg4qfdOPH+Zz0P5odOZYTHCeCNOSdrss+QQdvcx0HRFf1K+Vr1QlGbhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7/AraZP; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7/AraZP"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c7b9f54d3deso3254542a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2026 05:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777985212; x=1778590012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DyER5HkMLx02h4jPGr5WinKEOkBh5cJM3fYlZo/LlRk=;
        b=T7/AraZPleuemDEYkCUtpuIoTGkWBXFQHZF5vjLMdGyWackC+tihcH8gFzCi2O/7cL
         2EA/jTLBcojkIz+6s2CkMHxVdr2Rnh4Fif/cffkzfc6BI3qoLdsfF3Cra8jjwZuZl+X9
         0hfPsT9gL6JSj6u7U2w+dj3SmGZgxEBOoyV+EaHsRe4idcJsZBhoN4RwFSHMKB/F7tV9
         ++7Dc99rb51g8Mn23t2+ej28AILbaLYLAGrEKGqVGa5zO0D/FlMz07tV7JslVwoDpdY2
         nHzYqy52NdSw/Q/G7cGyE8FL+42qyCpj3O4SC0zLwtit4q3vMDaep5+SYuGuNkK5t5Dt
         7l4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777985212; x=1778590012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DyER5HkMLx02h4jPGr5WinKEOkBh5cJM3fYlZo/LlRk=;
        b=M8P/i8/pPhGoIBOH+wC0aCfBRXocHNJShvx9jtNu5+Sj7tE9uqSXUDvWWV/MlliFPQ
         x8+1h4+iEM5CssboqvgpZMr4/t2mScokPbVwcrfo872bgFe5Bls6YrbdWDBCHLk2iFVT
         +IGuXkpHjYbH79u/G6jTTTT/S4ECVE87zYCRgTktodNDsS/tvK1V3Y0FXTbBSyBPGIFI
         xs6/JjO3kqHY9Lw6KOqIxaeD1ZZh83yHxJyNfh9tvC3xWXyCsywmKZHEGrSO8e3LVx+n
         DaLEyy9poVDfchQft2qFm5KwRLgCJK+YzMXxlWfLbfzIPYe3Tny8RUQUE/WXiHkTjbzG
         HKgw==
X-Gm-Message-State: AOJu0Ywbc8B1Zg5KlhOLelZSQ3+0Spzmguf9SjSkIQYdmT9CiHXc8I8R
	eGZWinDUo667leA7KF5GaiVRfKB/boLFr8C2vES651Sm3aO1S0ftfy2u
X-Gm-Gg: AeBDietqTP2KJCs9qRmkL28nPWRmj9szETnTOUi1rocFk5oPWR/k3yB/DcMN4JdxycO
	Hb+UADQemga4c6dy5JWCddFDTLQw41ccFDsaA+D2sGS7eOTDvudjTH2X2dVeGp7w5jKKViRNs51
	+Si5IeUyuEUO370xCAWuT2+fvfdMSRPqX7QvA9I4+qbgwVcut3k0WdEff42wgvXf3rtnxdChmbm
	RjCyYNUfEw47oL6xex/n4Ftrep6QF+WWT21gZ7lzrSdiY4Cl3N2YEgAQETqydPU2HZ48oGyzkAW
	4ugit1bvrGA/a43lD8rtCZN41S+Yf+EVtYUKPAajLySFP008RM8vd1ld6kzN5cZeESdESs/2SvK
	5WxGG3ahxm92hf3+Sj0AY9RK3S1jnx3pMVBNf1404bDRPKJH2femLJcrREQoYzHzWu3PqmUlAM7
	RCqWmMvsmEE2/xCCzRTy20eJolGAVB
X-Received: by 2002:a05:6a21:3293:b0:39f:794f:94d8 with SMTP id adf61e73a8af0-3aa3b63574amr3326987637.29.1777985211486;
        Tue, 05 May 2026 05:46:51 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8025008cb9sm7678986a12.30.2026.05.05.05.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 05:46:51 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH] xfs: snapshot i_disk_size before truncate writeback
Date: Tue,  5 May 2026 20:46:39 +0800
Message-Id: <20260505124639.1346827-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_setattr_size() updates the in-core i_size and truncates the page
cache before it writes back the range between the on-disk EOF and the new
EOF.  The range calculation currently samples ip->i_disk_size without the
inode ILOCK.

Buffered unwritten-extent completion can advance ip->i_disk_size from
xfs_iomap_write_unwritten() under XFS_ILOCK_EXCL at the same time.  A
stale coherent value is harmless here because concurrent EOF advancement
only makes the pre-transaction writeback range conservative, but a
lockless 64-bit load can tear on 32-bit builds and create a bogus range
start or condition.  That can cause the null-files avoidance writeback to
be skipped or shortened before the size change is logged.

Snapshot ip->i_disk_size under XFS_ILOCK_SHARED after truncate_setsize()
and use that snapshot for the writeback decision and range start.

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/xfs/xfs_iops.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 208543e..a531715 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -915,6 +915,7 @@ xfs_setattr_size(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	xfs_off_t		oldsize, newsize;
+	xfs_fsize_t		ondisk_size;
 	struct xfs_trans	*tp;
 	int			error;
 	uint			lock_flags = 0;
@@ -1024,6 +1025,9 @@ xfs_setattr_size(
 	 * guaranteed not to write stale data past the new EOF on truncate down.
 	 */
 	truncate_setsize(inode, newsize);
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	ondisk_size = ip->i_disk_size;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	/*
 	 * We are going to log the inode size change in this transaction so
@@ -1034,9 +1038,9 @@ xfs_setattr_size(
 	 * otherwise those blocks may not be zeroed after a crash.
 	 */
 	if (did_zeroing ||
-	    (newsize > ip->i_disk_size && oldsize != ip->i_disk_size)) {
+	    (newsize > ondisk_size && oldsize != ondisk_size)) {
 		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-						ip->i_disk_size, newsize - 1);
+						ondisk_size, newsize - 1);
 		if (error)
 			return error;
 	}
-- 
2.43.0

