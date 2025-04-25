Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA4BE4438B;
	Fri, 25 Apr 2025 10:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745578638; cv=none; b=jX4qx/5WVoiKYJHnaOgArdcYN6Qq5c4eQo0e3S5s4VRa9ypgg0WSaeaAMwQhCMYbssalIMqHouA/JmnrRiK/9Sq/Dz6LJqh961b8PghrPqB06VmlUzsgosb7SA7IFIj49jOSs1mKnGZmHZ4WAZY3D12+CisUxXrTQZ4lGfVz/dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745578638; c=relaxed/simple;
	bh=Aq2C9REd9eMerPjlM2bo4vOa8FLEpQfONHKutZ31pdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIQvXLRbHkBr2IGZNlaX+TZWyilNE65SrtE0Hpo1aTYla9ygox5WKmdf33T1CPgjqvbIu06pUlbwErWbco/jmTYK9Xsih3ogrzM2dT/19FsE/RF7fDiP8g5VJ6sQhwNZ40UxzP/Z7I5xta7FAGqUTEif6cc5ABXaG03nwGycfyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ekS6cHyE; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ekS6cHyE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=pTVkQ
	MCUkaTY+UzZ0K9jTS+tVIl0x6eYM6tigXiHKaU=; b=ekS6cHyEcxrOoyiB7YO6r
	KD31sbTcIzBa0LcSP45QFFFPh/Y7JoOwaZfy0ZwmfgmAFtHoMZYRZLS7TdXr0g+Q
	SaBvk1lTwonUJa0BYIXOY1KOu6Ct3iGPPCfXnxHdwZ6vN/PWSdJcxpnPce9gslmy
	aK3x3vzC3gs3QJBmTv+vq8=
Received: from chi-Redmi-Book.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAHVbB1agtoLX64Ag--.54305S4;
	Fri, 25 Apr 2025 18:56:59 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 2/2] xfs: Enable concurrency when writing within single block
Date: Fri, 25 Apr 2025 18:38:41 +0800
Message-ID: <20250425103841.3164087-3-chizhiling@163.com>
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
X-CM-TRANSID:PygvCgAHVbB1agtoLX64Ag--.54305S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF47GF1DXrWxtF4Dtry8Grg_yoW8uryxpr
	ZakayY9rZ2qw1xArn3JF15u343Kas7XFW2qryxur1xZ3WUGwsI93WSvr1Y9a1UtrZ7ZrW0
	gF4vkry8Cw1jyr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j7wIDUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBgBU6nWgLZlla6wAAsf

From: Chi Zhiling <chizhiling@kylinos.cn>

For unextending writes, we will only update the pagecache and extent.
In this case, if our write occurs within a single block, that is,
within a single folio, we don't need an exclusive lock to ensure the
atomicity of the write, because we already have the folio lock.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/xfs/xfs_file.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a6f214f57238..8eaa98464328 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -914,6 +914,27 @@ xfs_file_dax_write(
 	return ret;
 }
 
+#define offset_in_block(inode, p) ((unsigned long)(p) & (i_blocksize(inode) - 1))
+
+static inline bool xfs_allow_concurrent(
+	struct kiocb		*iocb,
+	struct iov_iter		*from)
+{
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+
+	/* Extending write? */
+	if (iocb->ki_flags & IOCB_APPEND ||
+	    iocb->ki_pos >= i_size_read(inode))
+		return false;
+
+	/* Exceeds a block range? */
+	if (iov_iter_count(from) > i_blocksize(inode) ||
+	    offset_in_block(inode, iocb->ki_pos) + iov_iter_count(from) > i_blocksize(inode))
+		return false;
+
+	return true;
+}
+
 STATIC ssize_t
 xfs_file_buffered_write(
 	struct kiocb		*iocb,
@@ -925,8 +946,12 @@ xfs_file_buffered_write(
 	bool			cleared_space = false;
 	unsigned int		iolock;
 
+	if (xfs_allow_concurrent(iocb, from))
+		iolock = XFS_IOLOCK_SHARED;
+	else
+		iolock = XFS_IOLOCK_EXCL;
+
 write_retry:
-	iolock = XFS_IOLOCK_EXCL;
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock, false);
 	if (ret)
 		return ret;
@@ -935,6 +960,13 @@ xfs_file_buffered_write(
 	if (ret)
 		goto out;
 
+	if (iolock == XFS_IOLOCK_SHARED &&
+	    iocb->ki_pos + iov_iter_count(from) > i_size_read(inode)) {
+		xfs_iunlock(ip, iolock);
+		iolock = XFS_IOLOCK_EXCL;
+		goto write_retry;
+	}
+
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
 			&xfs_buffered_write_iomap_ops, NULL);
-- 
2.43.0

