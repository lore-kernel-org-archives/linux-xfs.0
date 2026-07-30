Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E643B3D34B1;
	Thu, 30 Jul 2026 08:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400972; cv=none; b=BfGTOsK+n5m+VoBhygyAvj4qqDVErLUQKCoDcAuZElCxapoK2S0byrvfIIX53zmeMnT3CZcdpnU2QZqeJPeaKgfxNN6xFmimmb4Z1HGzzV7Noo7X/8cysbchfot35Pbu4F9BhTDR8jMdNl6n9WQPOZuXd5RaWXHWMNeQeS0UvSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400972; c=relaxed/simple;
	bh=laLbNZ2dDhW5HGLMFL/aQP5GhmVx5iJb+/AjG9qu35A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LO1axb5byUr7S7v0PokNGYNg/08Q3HRfK594P1PFmau9s8szQtWSoKAvGm4jvO+l3aRLX3ae3KW2haXHGTC4XHaVCISTCNMrsmzjGf+6YhshxEnnxJac8296WtdeMCEU95XMwpZN6E/pSv1Zp73lDQDnlnH3oWs7j6bYISyXRvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9f88b1d28bf211f1aa26b74ffac11d73-20260730
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:38a58e94-dc1c-4ae3-b10f-ba363620ce35,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:6d3b3b476f71ad6e95a5a13416f1cadd,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9f88b1d28bf211f1aa26b74ffac11d73-20260730
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1379345488; Thu, 30 Jul 2026 16:42:40 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: hch@infradead.org,
	cem@kernel.org,
	dchinner@redhat.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH v3] xfs: use file target for post-log fsync fallback flush
Date: Thu, 30 Jul 2026 16:42:36 +0800
Message-Id: <20260730084236.173288-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_file_fsync() has a fallback flush for the case where the log force
was a no-op, for example fdatasync/O_DSYNC writes that do not require
metadata updates. The current fallback path is expressed in terms of the
main data device and explicitly excludes realtime inodes.

Realtime files with a separate realtime device are flushed before the log
force, because their data must reach stable storage before the log commit.
For the internal realtime device used by the zoned allocator, writes are
out-of-place and update inode and bmap metadata from I/O completion, so
the overwrite-without-metadata-update case does not apply in the same way.

Even so, the current fallback condition is inconsistent because it is
expressed as "non-realtime inode on the main data device" rather than in
terms of the inode's actual file data target.

Use xfs_inode_buftarg() to obtain the target that stores this file's
data, and issue the fallback flush when the log force did not flush
anything and the log target is the same as that file target.

This preserves existing behavior for regular files while making the
fallback logic consistent for files whose data target is selected by the
inode.

Fixes: bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: Christoph Hellwig <hch@infradead.org>

---
Change in v3:
- Correct the fix tag.
---
Change in v2:
- Update commit log based on Christoph Hellwig's explanation about realtime
  device flushing and the internal realtime device used by the zoned allocator.
- Rename data_targp to file_targp to avoid confusion with the main data
  device.
---
 fs/xfs/xfs_file.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0ade13b31335..4745f047193c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -166,17 +166,23 @@ xfs_file_fsync(
 	}
 
 	/*
-	 * If we only have a single device, and the log force about was
-	 * a no-op we might have to flush the data device cache here.
-	 * This can only happen for fdatasync/O_DSYNC if we were overwriting
-	 * an already allocated file and thus do not have any metadata to
-	 * commit.
+	 * If the log force was a no-op, we may still need to flush the
+	 * file data target cache here. This can happen for fdatasync/O_DSYNC
+	 * when no metadata needed to be committed.
+	 *
+	 * Use the inode's actual file data target rather than assuming the
+	 * main data device. Realtime inodes with a separate realtime device
+	 * are flushed before the log force, so this fallback only applies
+	 * when the file data target is the same as the log target.
 	 */
-	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
-	    mp->m_logdev_targp == mp->m_ddev_targp) {
-		err2 = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
-		if (err2 && !error)
-			error = err2;
+	if (!log_flushed) {
+		struct xfs_buftarg *file_targp = xfs_inode_buftarg(ip);
+
+		if (mp->m_logdev_targp == file_targp) {
+			err2 = blkdev_issue_flush(file_targp->bt_bdev);
+			if (err2 && !error)
+				error = err2;
+		}
 	}
 
 	return error;
-- 
2.25.1

