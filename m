Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240588;
	b=c+hnk2YJ1ZGy+UN8+msjVp5UACeJF21XCPTRavJXEDM84jNSrSxLkWTkij+KU+HZQyi2
	 wPSqR6nm2ULsmToaEuNprdAbnphNpV5iMYYS06bNxSXjCfHO/fNzXzTcUEAZParxpOVY9
	 xvgmErOfb5BuFfolGbA2HslF0x88HO/mrh0pe4MKFXcXFs8q+SAjTsBegCn6lWudTJhV7
	 0xNJIl4htudYZWF6YIH8kvzaD5GwG7ERkOYfcH2ydGJorTQ6KEjT0RM6yjyuXgkNRug6f
	 N56aj1Hb8iUXpMO1SzF7T/B/Lmr6YFOjYEgs358Lijv3LfZmu0RIaxxGXvVYw2m0E1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240588;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=W9Tx2kIB+Aezdt2yzBnqXshcGhW6TzBPq48QeS4a9mM=;
	b=etMKXd4ob660lrFgYtmVgvkyIg9Nn+ng+zDhJ/ZdgOtFrAoS/NonspcB6SVlvjrCXi8Q
	 1iOj3sGsrgdYPaSi/6hVHb/TvDVlq4HZUZ6VdR62nfFw0r82+whI+290K1nhRNWtegAmq
	 Y9zqYgozTBtIl+rYbttOn969RSZ0O4DPFiLASsDEDytmOdmbox2ksuL/A+MmBqqy4dpfO
	 kwH0NYcGVvZOxxcm6U0hUnlk6VlKEaaEdZ6Z84EOIAV4KvmlDP/XQDmlSVFtGeTq80vOi
	 NYCoOF0dvo6INknu1gq4tfnVz9k8+WIglrcaJtlAw9rTu3ZgL8FKZsNkyiO01nHuNDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFmFm7nu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6151A60A2621;
	Thu, 29 Oct 2026 02:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFmFm7nu
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240583;
	b=Thun6a/uThWd4QkWD94nIPeis3fcZbFmkINjJfduTxpDDKGlO29vdNXwsdmOSOuikW6N
	 F/GGF7wSNqP7vdA3V0R1HzTB6zfbi6ZE+eVet5ngdxfg7MAtR79CUN3yMQHoB/EzPbPV2
	 L6cHIsKHYLGoj+8bhD/v2iLkKzHKFaH1+DaJD3QhACK9RsAQWvhBaxFi2JhhfBVxVM+gn
	 q/pfVHpPb7KVViyZo/2pN2z8P7bu6UADXN+5XJmnNNejFGoRcwD8fMcLiKnt3LyhO9DBt
	 qgZ5ZJU3gk2YDHpm+ISspUWqksUK7vXdd7iEIUCDzVEtywheU7rPe8tjys8mPzeMUbQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240583;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=W9Tx2kIB+Aezdt2yzBnqXshcGhW6TzBPq48QeS4a9mM=;
	b=HdFjfBJEBwx69RBGgu37wdVo6+97Mc0r7dcoX9Z4U62evZE689aZJ7JeT3DWsaVh/kaK
	 hGfhr7KjFyFA4Ds9ZdYtBJVUpOsfoYx1JY+UPsVqp52aFtaLcsX8Shi2zVSyWA1zN6rUT
	 aRbmNY4vnBK/zJt2GNllNniZZv7MngP6p2BXMmOOG5L32hTPMLbi/s3KTWvuAufKSkVSZ
	 cl8DXFgnkATpnhJ8JvEoPOaSxOVDByVfSis2uqwBfmZwbPk/ZbId/qbCFMTU/dJvNZZkT
	 9XINSVqqEbqDm68P6iJRYq38YR00oh0SexpcO3rnoOQRrmTi4zu/ZrlJr0YJX849rnw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 499001F01825;
	Thu, 29 Oct 2026 02:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240583;
	bh=W9Tx2kIB+Aezdt2yzBnqXshcGhW6TzBPq48QeS4a9mM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PFmFm7nuTHQTyaWazFmi5nLrLMxqg0+rynvJMXlwux6jEkQR1o9EyQupLF5ooxa3Y
	 wIFkeE6ObUj36dkrywKPo0XS+r2OBxSofaSzMcDWEsu2sN3k4nas/lT/SB4efUZbD3
	 2ztzEX+bJ3OSKBKnlSp46b/iWO+f8msrDhMN4WG8fQRTym2dXfnQNAhviRJ2HrFyTO
	 tfDIgLNXHmTXq45FtD2k7eiEB4DDrvy29E9Kg7gfS8Vjl2QDHEUFHbXH3ZJdIWj90v
	 ty7b5bre82koe1W9e1xyVKMJFJaepbhNIbahLZCk/fO9W9MVotM0diJm1XTL4c5FwD
	 X+dQrlQjGy2Hw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1CF4E456A6;
	Thu, 29 Oct 2026 02:22:59 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:23:06 +0900
Subject: [PATCH v5 9/9] xfs: make pNFS LAYOUTCOMMIT stable the way
 fdatasync does
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-xfs-pnfs-batch-v5-9-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=2939;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=zMi4+NHyFoBXkEeHRNMf+DhfmCMGbT+Omkai4dVCPZE=;
 b=XQiXgVbPqOBEnmTpohI/2RUmK8qOZUVnuVG24MMLoXHI6r22vHlaz3Gpkpzv/usBuvQ485iA5
 X+PVx9AXZG7AIGZvl74JDNG/Hpv2LSFgDcA7yUn07lT9Qo5RyJeDuFp
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Every LAYOUTCOMMIT commits a synchronous transaction and forces the
log. fdatasync after the same overwrite does not, because timestamps
alone do not set ili_datasync_seq.

Do what fdatasync does. Commit without XFS_TRANS_SYNC, force the log up
to ili_datasync_seq, and flush the data device cache if that wrote no
iclog. Conversions and size changes still force the log. As with
fdatasync, a crash before the next log write can lose the new
timestamps and the change attribute that nfsd derives from the ctime.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
With the block layout on NVMe/TCP in QEMU, 64 KiB overwrites of a
16 MiB file with fsync each took 473 ms instead of 800 ms. With 4
writers, one file each, 1011 ms instead of 1083 ms (medians of 5 runs).
---
 fs/xfs/xfs_pnfs.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f4c4a02e5c..065875c8b7 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -295,10 +295,12 @@ xfs_pnfs_validate_isize(
  * converting any unwritten extents, flushing the disk cache and updating the
  * time stamps.
  *
- * Note that we rely on the caller to always send us a timestamp update so that
- * we always commit a transaction here.  If that stops being true we will have
- * to manually flush the cache here similar to what the fsync code path does
- * for datasyncs on files that have no dirty metadata.
+ * Like fdatasync, a commit that only updates the timestamps does not force the
+ * log: they are logged as XFS_ILOG_TIMESTAMP and reach the disk with a later
+ * log write. The log is forced up to the last change that a datasync needs,
+ * such as the unwritten extent conversions or a new size, and the cache of the
+ * device holding the file data is flushed if that log force did not write an
+ * iclog itself.
  */
 static int
 xfs_fs_commit_blocks(
@@ -312,6 +314,7 @@ xfs_fs_commit_blocks(
 	struct xfs_trans	*tp;
 	struct timespec64	now;
 	bool			update_isize = false;
+	int			log_flushed = 0;
 	int			error, i;
 	loff_t			size;
 
@@ -368,7 +371,8 @@ xfs_fs_commit_blocks(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, ip,
+			update_isize ? XFS_ILOG_CORE : XFS_ILOG_TIMESTAMP);
 
 	now = inode_set_ctime_current(inode);
 	inode_set_atime_to_ts(inode, now);
@@ -379,8 +383,13 @@ xfs_fs_commit_blocks(
 		ip->i_disk_size = new_size;
 	}
 
-	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_drop_iolock;
+
+	error = xfs_log_force_inode(ip, true, &log_flushed);
+	if (!error && !log_flushed)
+		error = blkdev_issue_flush(xfs_inode_buftarg(ip)->bt_bdev);
 
 out_drop_iolock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);

-- 
2.43.0


