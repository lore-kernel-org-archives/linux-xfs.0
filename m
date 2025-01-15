Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161E51E260C
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 06:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736921940; cv=none; b=qID1s9DbYBGY1udFYU12fq680+TjpDSavqJiYAlXtW0RThcYdPSb/KVlKANmyPmulThJCcShfOwYUMh93KvW9QERHuL3Nf3LdnV6mZCIAC4fijNoaM0ME5XR2ZcGh4HZTaK3o76aqL6wUfZez4hjBld4tA3Ha3Rt5FZpAf/bcCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736921940; c=relaxed/simple;
	bh=2O2rFQmWMhLX7agb67hBZ9HWed9AKd0JwJLm9CYi/aE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jVzAQW6q9Ww34AIen3cO/6gaCqROw/8+kR4AH440ycyhRx6b/tmPQEd6q87yh0HE4fBvmNkt+HamkuIJEU7zRBnPp7pYPT6d3lskwt452phe/7viyo6+csADjGjCrQHm/BZtportPAGv4ukO1cuKWelY9damFw8fwW/FqafbUMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efe9X34A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efe9X34A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8E9C4CEDF;
	Wed, 15 Jan 2025 06:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736921938;
	bh=2O2rFQmWMhLX7agb67hBZ9HWed9AKd0JwJLm9CYi/aE=;
	h=From:To:Cc:Subject:Date:From;
	b=efe9X34A8cYOkTPn++ZDZgcf5yfpCFnRfwjDQ9m965XTEd8oeVrKBKmed7YndoGdL
	 KD8gOMixfdVya9Y/hYO0hke2uWNuC9MCec/X180yVhnVAb/4TVXnW/SUQ3rGJaxNlm
	 AIUPaftAKmhcjzSqsTdu1c4pqRJLmjB+b2vJNI+Ob+rD/aBNGaicGLjwYA2zTex5ko
	 VHx7mwLiB/hayYfICsDjQ84H3P0aHqO6rG1UgGsFtgzVKhkWgB9iQ1iVwjwm5YQQf9
	 +9ujJguFVL03isSWTbTIc/yYYLy+JiuzMOh0RK0yA+ACYfjfD9jN/urrBhSjCdBaQB
	 iZRsjBH+G3bBQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com,
	djwong@kernel.org,
	hch@lst.de
Subject: [PATCH] xfs: Prevent mounting with quotas in norecovery if quotacheck is needed
Date: Wed, 15 Jan 2025 07:18:32 +0100
Message-ID: <20250115061840.269757-1-cem@kernel.org>
X-Mailer: git-send-email 2.47.1
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

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_qm_bhv.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 37f1230e7584..eae106ca7e1b 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -97,10 +97,11 @@ xfs_qm_newmount(
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
 
 	if (((uquotaondisk && !XFS_IS_UQUOTA_ON(mp)) ||
@@ -109,7 +110,8 @@ xfs_qm_newmount(
 	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)) ||
 	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
 	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)))  &&
-	    xfs_dev_is_read_only(mp, "changing quota state")) {
+	    (xfs_dev_is_read_only(mp, "changing quota state") ||
+	     xfs_has_norecovery(mp))) {
 		xfs_warn(mp, "please mount with%s%s%s%s.",
 			(!quotaondisk ? "out quota" : ""),
 			(uquotaondisk ? " usrquota" : ""),
-- 
2.47.1

