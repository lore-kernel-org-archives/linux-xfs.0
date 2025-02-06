Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65455188722
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738868467; cv=none; b=MtXuG1MuaWO6Kg4r3ZgCyrH+zFlTkie4v4oL1plGenqiko55UwQ27hCuw2RmVX3PM+o5iyBn3dTiiRhs714BM4QmOYkSujV/dI6/4YFAVrQWYb+3AJQaXdgdjJDlcp9yRD44PMLgOTsY5FWSBcPyid/ZhL4MrmoXS0FXTj+QBUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738868467; c=relaxed/simple;
	bh=Wr0ax1DM1O4h+LHEUVuHcCqBZT/dg3zdcNNQzsF6+ww=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=BFcp2grm9pec2Nmonn+7qz+u3UbfsLd57iVHbP10H1KPCo5yiOts08+WUKN6FPBBdKWbUxzC8nju6xsMZ400fdfj54hUebYhzJYaMwyIrI4SUnrZ07rm/wLz/Q23B5uUvv6+DZrylrjkGZhvBXGtqJhas2ZOlTLoMjGL42UlIFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XzRBYD3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XzRBYD3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292B5C4CEDD;
	Thu,  6 Feb 2025 19:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738868466;
	bh=Wr0ax1DM1O4h+LHEUVuHcCqBZT/dg3zdcNNQzsF6+ww=;
	h=From:Date:Subject:To:Cc:From;
	b=XzRBYD3AGGGaVbpbwK6VdkExjElTK4aZZ5ifNWJ7NZkUT49OKQBjTBDosJQlXlz6k
	 Z8uHbsR7zh1hGnT5gt9Rvk0BNCyye/v4yzUs4jhhae/Gu5RH8RH0hMXxRKOsHHtuNz
	 xpO3Za6QHQ/4PzPvPs/d7OEkUS8Y+6BhnjJEKzJj64R6F7oPU5iOWgyWQM17Ag6jU3
	 tpc2REt2Cg9/QNRCxkx4/PPJknhzE8n2SAT7ygHGan8f+AxUh/5v64jKo0FqL1Y9G8
	 NQbruMkkrWFiagVJ+kpOLv/oiD9e8JcQUcMOepcr2yL8WPto1tVseuoRd3naysskF5
	 lnQ4Cr4KtNRFg==
From: da.gomez@kernel.org
Date: Thu, 06 Feb 2025 19:00:55 +0000
Subject: [PATCH] mkfs: use stx_blksize for dev block size by default
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
X-B4-Tracking: v=1; b=H4sIAOYGpWcC/x3MTQ5AMBBA4avIrE1SLYKriIWfKRO00iJC3F1j+
 S3ee8CTY/JQRQ84OtmzNQFJHEE/tWYk5CEYpJCZkCLHlQ2yxYF0eyw7dovtZ883YaKUSnWWFmV
 JEPLNkebrX9fN+34ewPLRagAAAA==
X-Change-ID: 20250206-min-io-default-blocksize-13334f54899e
To: linux-xfs@vger.kernel.org
Cc: Luis Chamberlain <mcgrof@kernel.org>, 
 Daniel Gomez <da.gomez@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>, 
 gost.dev@samsung.com
X-Mailer: b4 0.14.2

From: Daniel Gomez <da.gomez@samsung.com>

In patch [1] ("bdev: use bdev_io_min() for statx block size"), block
devices will now report their preferred minimum I/O size for optimal
performance in the stx_blksize field of the statx data structure. This
change updates the current default 4 KiB block size for all devices
reporting a minimum I/O larger than 4 KiB, opting instead to query for
its advertised minimum I/O value in the statx data struct.

[1]:
https://lore.kernel.org/all/20250204231209.429356-9-mcgrof@kernel.org/

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
Set MIN-IO from statx as the default filesystem fundamental block size.
This ensures that, for devices reporting values within the supported
XFS block size range, we do not incur in RMW. If the MIN-IO reported
value is lower than the current default of 4 KiB, then 4 KiB will be
used instead.
---
 mkfs/xfs_mkfs.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bbd0dbb6c80ab63ebf9edbe0a9a304149770f89d..e17389622682bc23f9b20c207db7e22181e2fe6f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2178,6 +2178,26 @@ _("block size %d cannot be smaller than sector size %d\n"),
 	}
 }
 
+void
+get_dev_blocksize(
+	struct cli_params	*cli,
+	struct mkfs_default_params *dft)
+{
+	struct statx stx;
+	int ret;
+
+	if (!cli->xi->data.name)
+		return;
+
+	ret = statx(AT_FDCWD, cli->xi->data.name,
+		    AT_STATX_DONT_SYNC | AT_NO_AUTOMOUNT,
+		    STATX_DIOALIGN | STATX_TYPE | STATX_MODE | STATX_INO, &stx);
+	if (!ret)
+		dft->blocksize =
+			min(max(1 << XFS_DFL_BLOCKSIZE_LOG, stx.stx_blksize),
+			    XFS_MAX_BLOCKSIZE);
+}
+
 static void
 validate_blocksize(
 	struct mkfs_params	*cfg,
@@ -2189,6 +2209,7 @@ validate_blocksize(
 	 * For RAID4/5/6 we want to align sector size and block size,
 	 * so we need to start with the device geometry extraction too.
 	 */
+	get_dev_blocksize(cli, dft);
 	if (!cli->blocksize)
 		cfg->blocksize = dft->blocksize;
 	else

---
base-commit: 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
change-id: 20250206-min-io-default-blocksize-13334f54899e

Best regards,
-- 
Daniel Gomez <da.gomez@samsung.com>

