Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9DB3B27FF;
	Wed, 29 Jul 2026 07:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785310889; cv=none; b=ZRT9yHKg/GJ4o0VuCVgDBbbCU43a8iTLEzeWPQTLK3PIQmJtZmevZ71w7Rts8OglxPTHGIvUP6Wlqxvu7vpDfzExbZP0i1tziiaj+UiXiLmocz0UYOuCApTIYxGt2Kqyu4+9QP70O1zi4P6Rnjp3xhhmbvo4awXhkYuHvisN4hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785310889; c=relaxed/simple;
	bh=xKedype/WqR22VEEuxto1prx3+8p9hVjAmfnoDOyWuU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EJm4IedHegulnj/NGbG7TZdaawWZjQHYFSxxxe+UR68jqJ8c8/NR1IJG5tJmjRoA5iXay0ISKwpr/Eg8acagJUXzWMSRO9oUPxtGjnXC3tKTxuCCwBPjO51Hqtf5DsknFs55JgwtAVK1tbrUIrJFuJ2pvL8pGEalMzoT4qxCENI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e0f293b88b2011f1aa26b74ffac11d73-20260729
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1920449d-c422-47ea-abd9-e0e47754b40d,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:c9c9293e4833fbb6f15f69faa6f774cd,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e0f293b88b2011f1aa26b74ffac11d73-20260729
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 358575867; Wed, 29 Jul 2026 15:41:15 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: cem@kernel.org,
	dchinner@redhat.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix fallback data device flush for realtime inodes
Date: Wed, 29 Jul 2026 15:39:18 +0800
Message-Id: <20260729073918.64505-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_file_fsync() has a fallback flush for the case where the log force
was a no-op, for example fdatasync/O_DSYNC overwrites of already
allocated file data with no metadata updates.

The current fallback path is limited to non-realtime inodes and always
flushes mp->m_ddev_targp. This misses realtime inodes whose data target
is selected by the inode and may be mp->m_rtdev_targp.

Use xfs_inode_buftarg(ip) to obtain the actual data target for the inode,
and perform the fallback flush when the log force did not flush anything
and the log target is the same as that data target.

This preserves the existing behavior for regular inodes while allowing
the fallback flush to cover realtime inodes whose data target shares the
log device.

Fixes: 2291dab2c9d1 ("xfs: Always flush caches when integrity is required")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/xfs/xfs_file.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0ade13b31335..2a6186f67979 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -166,17 +166,22 @@ xfs_file_fsync(
 	}
 
 	/*
-	 * If we only have a single device, and the log force about was
-	 * a no-op we might have to flush the data device cache here.
-	 * This can only happen for fdatasync/O_DSYNC if we were overwriting
-	 * an already allocated file and thus do not have any metadata to
-	 * commit.
+	 * If the log force was a no-op, we may still need to flush the
+	 * data device cache for fdatasync/O_DSYNC overwrites of already
+	 * allocated file data with no metadata updates.
+	 *
+	 * Use the inode's actual data target (which may be the RT device
+	 * for realtime inodes) and flush only if it shares the device
+	 * with the log target.
 	 */
-	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
-	    mp->m_logdev_targp == mp->m_ddev_targp) {
-		err2 = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
-		if (err2 && !error)
-			error = err2;
+	if (!log_flushed) {
+		struct xfs_buftarg *data_targp = xfs_inode_buftarg(ip);
+
+		if (mp->m_logdev_targp == data_targp) {
+			err2 = blkdev_issue_flush(data_targp->bt_bdev);
+			if (err2 && !error)
+				error = err2;
+		}
 	}
 
 	return error;
-- 
2.25.1

