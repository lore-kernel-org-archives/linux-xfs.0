Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:55831 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932365AbdJZIdc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:32 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003D1-O7
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005Md-Me
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/14] xfs: hide reserved metadata space from users
Date: Thu, 26 Oct 2017 19:33:18 +1100
Message-Id: <20171026083322.20428-11-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

One of the major user-visible issues with the new rmap and reflink
code is that it has to reserve worst case allocation space for it's
per-AG btrees. The reservation isn't small, either - it's ~2% of
total space - and so is very noticable. Indeed, a freshly mkfs'd,
empty 500TB filesystem reports:

$ df -h /mnt/scratch
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdc        500T  9.6T  491T   2% /mnt/scratch

That 10TB of space has already be used, before the user even writes
a byte of data to it. This space can never be used by the user, so
reporting it as free space is sub-optimal. At minimum, it's going to
cause issues with space usage reporting tools that admins use.

However, now that we can track usable space seperately to the block
device size, we can make this space disappear from the filesystem
completely. That is, if the reservation also drops the maximum
usable space available to the filesystem, the above freeshly made
filesystem on the 500TB device now reports as:

$ df -h /mnt/scratch
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdc        491T   62M  491T   1% /mnt/scratch

A 491TB filesystem with just 62MB used in it.

The filesystem no longer reports the reservation as used space and
the filesystem now reports exactly what the users and admins expect:
that it is completely empty.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index df3e600835e8..475512d54a0a 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -143,6 +143,28 @@ xfs_ag_resv_needed(
 	return len;
 }
 
+/*
+ * xfs_ag_resv_update_space() hides the reservations from userspace by modifying
+ * the maximum usable space in the filesystem as well as the free blocks
+ * available.  This means a truly empty filesystem will report that it's truly
+ * empty rather than reporting that it has some significant amount of free space
+ * used that the user cannot free.
+ */
+static int
+xfs_ag_resv_update_space(
+	struct xfs_mount	*mp,
+	int64_t			resv)
+{
+	int			error;
+
+	error = xfs_mod_fdblocks(mp, resv, true);
+	if (error)
+		return error;
+
+	mp->m_usable_blocks += resv;
+	return 0;
+}
+
 /* Clean out a reservation */
 static int
 __xfs_ag_resv_free(
@@ -166,7 +188,8 @@ __xfs_ag_resv_free(
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
-	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
+
+	error = xfs_ag_resv_update_space(pag->pag_mount, (int64_t)oldresv);
 	resv->ar_reserved = 0;
 	resv->ar_asked = 0;
 
@@ -207,7 +230,7 @@ __xfs_ag_resv_init(
 		ask = used;
 	reserved = ask - used;
 
-	error = xfs_mod_fdblocks(mp, -(int64_t)reserved, true);
+	error = xfs_ag_resv_update_space(pag->pag_mount, -(int64_t)reserved);
 	if (error) {
 		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
 				error, _RET_IP_);
-- 
2.15.0.rc0

