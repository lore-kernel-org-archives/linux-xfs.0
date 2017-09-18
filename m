Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932436AbdIRJQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:16:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 49/78] xfs: dont leak quotacheck dquots when cow recovery
Date: Mon, 18 Sep 2017 11:11:58 +0200
Message-Id: <20170918091133.734186377@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 77aff8c76425c8f49b50d0b9009915066739e7d2 upstream.

If we fail a mount on account of cow recovery errors, it's possible that
a previous quotacheck left some dquots in memory.  The bailout clause of
xfs_mountfs forgets to purge these, and so we leak them.  Fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1004,6 +1004,8 @@ xfs_mountfs(
 	IRELE(rip);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	/* Clean out dquots that might be in memory after quotacheck. */
+	xfs_qm_unmount(mp);
  out_log_dealloc:
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);


