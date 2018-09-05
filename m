Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbeIEUzl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Sep 2018 16:55:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9155030DF6FC
        for <linux-xfs@vger.kernel.org>; Wed,  5 Sep 2018 16:24:46 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59C44608EE
        for <linux-xfs@vger.kernel.org>; Wed,  5 Sep 2018 16:24:46 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: don't fail dax mount w/ reflink if dax gets disabled
Message-ID: <d4e84fa3-6cf5-4ea1-d61c-e1c74f2b0d06@redhat.com>
Date: Wed, 5 Sep 2018 11:24:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Today, we can get an interesting result when mounting a reflink filesystem
with -o dax on a device that doesn't support it:

XFS (sda1): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
XFS (sda1): DAX unsupported by block device. Turning off DAX.
XFS (sda1): DAX and reflink cannot be used together!

<fail mount>

If we're willing to silently turn off DAX due to incompatibility with the
block device, it makes no sense to then fail the mount due to
incompatibility with the filesystem format.  So, skip this check if we
already decided to turn off DAX and proceed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 207ee30..c85c432 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1677,8 +1677,7 @@ struct proc_xfs_info {
 			xfs_alert(mp,
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
-		}
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		} else if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 			xfs_alert(mp,
 		"DAX and reflink cannot be used together!");
 			error = -EINVAL;
