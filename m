Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823B9145A18
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jan 2025 10:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738317790; cv=none; b=l7ZdAn7RhFsQnsPUfZJ7omIvVba47V7iztQBy1JVMuv4Kou355he0jsU7dzq3ey3YFWAd3Le5pQ72mH3L7KdZSWLWYGvj2cGCUjs7cAT1DuMqvYcksi8tufb8r3Xc5eeQBbfv/yYVyn9e3JsGHy1Rbcfm/4Ke2cV48krCTpK5UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738317790; c=relaxed/simple;
	bh=8tIodsSnIYFm2dgdTno8oqll+yBPH6oCuL80TL2Ze5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lWENc6ZoqKuRpoe9R+PPHJwLt0rhx0xU5x2jpIG9mP5wiWCS49hOb/ShCMbIwJmxHJbppaU5gm6tmHCL8uwzvG7IeZzrAOe5Vq0eLtsLFOOZc6MK1449oJUx+iz3Ydd1ZV+Q6gEgEZaEadAmP9GQ8vMZoopym8mxhTKV5oGNlHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSw8w9nG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSw8w9nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB1FC4CED1;
	Fri, 31 Jan 2025 10:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738317790;
	bh=8tIodsSnIYFm2dgdTno8oqll+yBPH6oCuL80TL2Ze5E=;
	h=From:To:Cc:Subject:Date:From;
	b=ZSw8w9nGDc3IoNfih5eweGdON2EjOp9VYqZ6fW9Tx4wei8OTFnqdhIaiacQvKZbEM
	 OiAhTrSKL0WdM0cWUNQceG5UlMFEAGtJ72e/d3VAm8BYweaTJxX35Hui/cxjnExHW2
	 NryXZ/lTsDcKR0HqZkUiGyaLyk45WaLt9mkmI6py5UslQpwXBjpRSECSRaamUfkb4+
	 cIpevJ6mPFGbuhBCmPziPReCLu5eloTyPQBTnbbbYjjs87qokBcQhV82SWtRJv5mDB
	 45oO6mDQgH6VC20myNR3CrsZqcWDoBJHiVollc5ULLphdhasVDNtok+Y4IQKNxX8aL
	 kMRCH+b9HGucw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	david@fromorbit.com,
	dchinner@redhat.com,
	hch@lst.de
Subject: [PATCH V2] xfs: Do not allow norecovery mount with quotacheck
Date: Fri, 31 Jan 2025 11:02:54 +0100
Message-ID: <20250131100302.15430-1-cem@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Mounting a filesystem that requires quota state changing will generate a
transaction.

We already check for a read-only device; we should do that for
norecovery too.

A quotacheck on a norecovery mount, and with the right log size, will cause
the mount process to hang on:

[<0>] xlog_grant_head_wait+0x5d/0x2a0 [xfs]
[<0>] xlog_grant_head_check+0x112/0x180 [xfs]
[<0>] xfs_log_reserve+0xe3/0x260 [xfs]
[<0>] xfs_trans_reserve+0x179/0x250 [xfs]
[<0>] xfs_trans_alloc+0x101/0x260 [xfs]
[<0>] xfs_sync_sb+0x3f/0x80 [xfs]
[<0>] xfs_qm_mount_quotas+0xe3/0x2f0 [xfs]
[<0>] xfs_mountfs+0x7ad/0xc20 [xfs]
[<0>] xfs_fs_fill_super+0x762/0xa50 [xfs]
[<0>] get_tree_bdev_flags+0x131/0x1d0
[<0>] vfs_get_tree+0x26/0xd0
[<0>] vfs_cmd_create+0x59/0xe0
[<0>] __do_sys_fsconfig+0x4e3/0x6b0
[<0>] do_syscall_64+0x82/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

This is caused by a transaction running with bogus initialized head/tail

I initially hit this while running generic/050, with random log
sizes, but I managed to reproduce it reliably here with the steps
below:

mkfs.xfs -f -lsize=1025M -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, -i
sparse=1 /dev/vdb2 > /dev/null
mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
xfs_io -x -c 'shutdown -f' /mnt
umount /mnt
mount -o ro,norecovery,usrquota,grpquota,prjquota  /dev/vdb2 /mnt

Last mount hangs up

As we add yet another validation if quota state is changing, this also
add a new helper named xfs_qm_validate(), factoring the quota state
changes out of xfs_qm_newmount() to reduce cluttering within it.

As per Darrick suggestion, add a new, different  warning message if
metadir is enabled.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---

Changelog V1->V2:
	- Issue a different warn message in case metadir is enabled
	- Factour out quota state validator code to a new helper
	- Change patch subject to reduce length


 fs/xfs/xfs_qm_bhv.c | 55 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 37f1230e7584..a6a7870401c3 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -78,6 +78,28 @@ xfs_qm_statvfs(
 	}
 }
 
+STATIC int
+xfs_qm_validate(
+	xfs_mount_t	*mp,
+	uint		uqd,
+	uint		gqd,
+	uint		pqd)
+{
+	int state;
+
+	/* Is quota state changing? */
+	state = ((uqd && !XFS_IS_UQUOTA_ON(mp)) ||
+		(!uqd &&  XFS_IS_UQUOTA_ON(mp)) ||
+		 (gqd && !XFS_IS_GQUOTA_ON(mp)) ||
+		(!gqd &&  XFS_IS_GQUOTA_ON(mp)) ||
+		 (pqd && !XFS_IS_PQUOTA_ON(mp)) ||
+		(!pqd &&  XFS_IS_PQUOTA_ON(mp)));
+
+	return  state &&
+		(xfs_dev_is_read_only(mp, "changing quota state") ||
+		xfs_has_norecovery(mp));
+}
+
 int
 xfs_qm_newmount(
 	xfs_mount_t	*mp,
@@ -97,24 +119,25 @@ xfs_qm_newmount(
 	}
 
 	/*
-	 * If the device itself is read-only, we can't allow
-	 * the user to change the state of quota on the mount -
-	 * this would generate a transaction on the ro device,
-	 * which would lead to an I/O error and shutdown
+	 * If the device itself is read-only and/or in norecovery
+	 * mode, we can't allow the user to change the state of
+	 * quota on the mount - this would generate a transaction
+	 * on the ro device, which would lead to an I/O error and
+	 * shutdown.
 	 */
 
-	if (((uquotaondisk && !XFS_IS_UQUOTA_ON(mp)) ||
-	    (!uquotaondisk &&  XFS_IS_UQUOTA_ON(mp)) ||
-	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
-	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)) ||
-	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
-	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)))  &&
-	    xfs_dev_is_read_only(mp, "changing quota state")) {
-		xfs_warn(mp, "please mount with%s%s%s%s.",
-			(!quotaondisk ? "out quota" : ""),
-			(uquotaondisk ? " usrquota" : ""),
-			(gquotaondisk ? " grpquota" : ""),
-			(pquotaondisk ? " prjquota" : ""));
+	if (xfs_qm_validate(mp, uquotaondisk,
+			    gquotaondisk, pquotaondisk)) {
+
+		if (xfs_has_metadir(mp))
+			xfs_warn(mp,
+			       "metadir enabled, please mount withouth quotas");
+		else
+			xfs_warn(mp, "please mount with%s%s%s%s.",
+				(!quotaondisk ? "out quota" : ""),
+				(uquotaondisk ? " usrquota" : ""),
+				(gquotaondisk ? " grpquota" : ""),
+				(pquotaondisk ? " prjquota" : ""));
 		return -EPERM;
 	}
 
-- 
2.48.1

