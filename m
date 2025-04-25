Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF47D2405F8;
	Fri, 25 Apr 2025 10:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745578635; cv=none; b=KgdLw/cJWWiLtZdIqyzoNg8sGN1oj+LHbhtf/T9p29gQwHXkR3TVQBuZe8w9nmNMT9sWbJLMKfrIpaYNcFqtSLfyO9snW52Z+vrB0DE63N2A5gv8mqbr9dqygcqJEZyETKwu6aR4JDI7KvXYbnqYYP/BN2HLZ++The/Bqit60Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745578635; c=relaxed/simple;
	bh=YPTBCelIk0A8i2QhKhdm8JqpQG5uD+FpwDp+nUFc+Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPr6sOPNx59IQeIbyBQGtzHQAKKCukV4eUJZ/fACyURCT4Uj6zZ3fI4sVO1WZKeVWHPYMJdCH3h+3QFr/HlinaBf7z+yctf36zw/iSMb1WGEkSzPJ27NTnFkTtbm0YKKrA7hFxWGvXHFJ1gz0uWyObaLB5SAJGgYrdlJsLllslg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CelgIhzI; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CelgIhzI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=dfg4q
	eT5ji3cZsBk6SVgnJou8Q/FEs5TStRdhKywXVM=; b=CelgIhzI77LkubL3n83X2
	pUKvTCcXAYkGITJq9cqSWeCu1au7n0XrHwsi5pX1gYLV+ljbxPhsLnoA5E8BgcDY
	xsgjF5MtBsDLxcnienZpIbygtRt8YRx8ZIibURhb3b4lHBGXBo7UNpngSB1EBPHr
	5dpJvSYqORj6ShsxTjLclA=
Received: from chi-Redmi-Book.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAHVbB1agtoLX64Ag--.54305S3;
	Fri, 25 Apr 2025 18:56:56 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 1/2] xfs: Add i_direct_mode to indicate the IO mode of inode
Date: Fri, 25 Apr 2025 18:38:40 +0800
Message-ID: <20250425103841.3164087-2-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250425103841.3164087-1-chizhiling@163.com>
References: <20250425103841.3164087-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAHVbB1agtoLX64Ag--.54305S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxur47CF47tw1kGw1rKFWkCrg_yoWrGFyDpr
	saka90krs7tr9F9Fs7JF4UuwnxKay8Wr4UZF4I93W7uw45GrnI9r4IvF12qa1jqrsxZr4v
	vFs0kry5C3W7JFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeLvtUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiKQQ6nWgLY22ergAAsX

From: Chi Zhiling <chizhiling@kylinos.cn>

Direct IO already uses shared lock. If buffered write also uses
shared lock, we need to ensure mutual exclusion between DIO and
buffered IO. Therefore, Now introduce a flag `i_direct_mode` to
indicate the IO mode currently used by the file. In practical
scenarios, DIO and buffered IO are typically not used together,
so this flag is usually not modified.

Additionally, this flag is protected by the i_rwsem lock,
which avoids the need to introduce new lock. When reading this
flag, we need to hold a read lock, and when writing, a write lock
is required.

When a file that uses buffered IO starts using DIO, it needs to
acquire a write lock to modify i_direct_mode, which will force DIO
to wait for the previous IO to complete before starting. After
acquiring the write lock to modify `i_direct_mode`, subsequent
buffered IO will need to acquire the write lock again to modify
i_direct_mode, which will force those IOs to wait for the current
IO to complete.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/xfs/xfs_file.c  | 37 +++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_inode.h |  6 ++++++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 84f08c976ac4..a6f214f57238 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -206,7 +206,8 @@ xfs_ilock_iocb(
 static int
 xfs_ilock_iocb_for_write(
 	struct kiocb		*iocb,
-	unsigned int		*lock_mode)
+	unsigned int		*lock_mode,
+	bool			is_dio)
 {
 	ssize_t			ret;
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
@@ -226,6 +227,21 @@ xfs_ilock_iocb_for_write(
 		return xfs_ilock_iocb(iocb, *lock_mode);
 	}
 
+	/*
+	 * If the i_direct_mode need update, take the iolock exclusively to write
+	 * it.
+	 */
+	if (ip->i_direct_mode != is_dio) {
+		if (*lock_mode == XFS_IOLOCK_SHARED) {
+			xfs_iunlock(ip, *lock_mode);
+			*lock_mode = XFS_IOLOCK_EXCL;
+			ret = xfs_ilock_iocb(iocb, *lock_mode);
+			if (ret)
+				return ret;
+		}
+		ip->i_direct_mode = is_dio;
+	}
+
 	return 0;
 }
 
@@ -247,6 +263,19 @@ xfs_file_dio_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
+
+	if (!ip->i_direct_mode) {
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_EXCL);
+		if (ret)
+			return ret;
+
+		ip->i_direct_mode = 1;
+
+		/* Update finished, now downgrade to shared lock */
+		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+	}
+
 	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, NULL, 0);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
@@ -680,7 +709,7 @@ xfs_file_dio_write_aligned(
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
 
-	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock, true);
 	if (ret)
 		return ret;
 	ret = xfs_file_write_checks(iocb, from, &iolock, ac);
@@ -767,7 +796,7 @@ xfs_file_dio_write_unaligned(
 		flags = IOMAP_DIO_FORCE_WAIT;
 	}
 
-	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock, true);
 	if (ret)
 		return ret;
 
@@ -898,7 +927,7 @@ xfs_file_buffered_write(
 
 write_retry:
 	iolock = XFS_IOLOCK_EXCL;
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock, false);
 	if (ret)
 		return ret;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index eae0159983ca..04f6c4174fab 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -51,6 +51,12 @@ typedef struct xfs_inode {
 	uint16_t		i_checked;
 	uint16_t		i_sick;
 
+	/*
+	 * Indicates the current IO mode of this inode, (DIO/buffered IO)
+	 * protected by i_rwsem lock.
+	 */
+	uint32_t		i_direct_mode;
+
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
-- 
2.43.0

