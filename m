Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0082C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 16:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB57820717
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 16:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfLRQkR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 11:40:17 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:44199 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfLRQkQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 11:40:16 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MUGqT-1iGuOr0t6J-00RLZB; Wed, 18 Dec 2019 17:40:06 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] xfs: disallow broken ioctls without compat-32-bit-time
Date:   Wed, 18 Dec 2019 17:39:29 +0100
Message-Id: <20191218163954.296726-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191218163954.296726-1-arnd@arndb.de>
References: <20191218163954.296726-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6ujAzFNzbSvWONOGFgSWinycKZWnfNnaCJ6HIW30mi/PzDQi6Wu
 hKOaMDeT4IWEcnmQSowIe92SThixIKCnshY2b1DvLkb9cwh/JBIhP6ELzY+IEBfeaBlBnvG
 HG/9w0pt+nFUcJUliGN/drBqfYUb9AK8V0Z8lDB4YEIiaUW8qvmH2nOUBipIWTIT+YULKl0
 DLu+k/jmWAKQFz3vpL/vw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Phie+ptjyJE=:EGVmmJtbEU0+IRu25Koo9X
 gB6r/Vk3tbNyA1FA2jcJ0DLdt6R2yBk3mg2IZZrji+Z5pUazLPh/KswFMI50Enri0I9nE+ANH
 2j1XO9is3USpw973y3vrxgDHzE6W4afEKpdgeNymEdnk1nAWMs0wGgUV7cMdUPnzq7mHSyMpJ
 +KNVxyeARysnFu5t2x3dzxI8dl/f3SVCUI9lAtLb0O3ZsTzNvlbeT7Kbpuv1HHRhzv4jmosd0
 e9o3ImrhDWiP6UpFkFw4nwvqVFZd3IXs+fhlFENkpnc3qbZWkskLWT72/M+k8KG/rcw42UeMF
 m21DzColmhBoh0Ss6DYmHqPuP2jLEts6isFEdkVTUJzyL8360L9RjsbafGHgVqDc29mSyuarx
 kszzc7VkEvsuP/1SNOSKWb3Wa4aRTjMMocpjrtUdcjA0/uqpYL/A+OJAPwYeqhEEIPKTkkQcM
 /U4/BegYQ7scv2xY/ti20LtHp+ZvOZyJVnhAwmeQfXdsNQJnuJ1PAvQ45C7j5HShFVH4viDHn
 dtzQV9TPOLOzFj8vWBjBgTXWEJyA3z4md+oqaTnVense41w1o+rOyk9tOD57gFqtD3Y4ZQRoT
 T0DwiqDRmBZ2vNKPllydRgAM+ZBgPf2HMUEgeNd5axSPtvpsd3ixSuyVrpjQ6Lbvh/2DYwpSi
 ww5O4fRDWUP4VaQKBmtrqbl2+3f5cgjO1+raAj6AWncDatN3qQjC9DphFdTKCdLvgbOfzm+4Y
 wagisEsGvWUe4B5o3B8BXpDstc3oALZP8wCrFBRzI8y4EePxiQztwSQTHI70nGnuWGBoE9mNs
 M8C07KLky3DBhl31X5ei5Hk9Zm9VB8SHkE6GXpkM+of5Sdc2ZK2rYdMc8XF/+EGyHkwb2h8oF
 EQJjOtppA7S+gjkCJBRg==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When building a kernel that disables support for 32-bit time_t
system calls, it also makes sense to disable the old xfs_bstat
ioctls completely, as they truncate the timestamps to 32-bit
values once the extended times are supported.

Any application using these needs to be updated to use the v5
interfaces.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_ioctl.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7b35d62ede9f..d43582e933a0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -36,6 +36,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
 
+#include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 
@@ -617,6 +618,23 @@ xfs_fsinumbers_fmt(
 	return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
 }
 
+/* disallow y2038-unsafe ioctls with CONFIG_COMPAT_32BIT_TIME=n */
+static bool xfs_have_compat_bstat_time32(unsigned int cmd)
+{
+	if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
+		return true;
+
+	if (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall())
+		return true;
+
+	if (cmd == XFS_IOC_FSBULKSTAT_SINGLE ||
+	    cmd == XFS_IOC_FSBULKSTAT ||
+	    cmd == XFS_IOC_SWAPEXT)
+		return false;
+
+	return true;
+}
+
 STATIC int
 xfs_ioc_fsbulkstat(
 	xfs_mount_t		*mp,
@@ -637,6 +655,9 @@ xfs_ioc_fsbulkstat(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (!xfs_have_compat_bstat_time32(cmd))
+		return -EINVAL;
+
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
@@ -1815,6 +1836,11 @@ xfs_ioc_swapext(
 	struct fd	f, tmp;
 	int		error = 0;
 
+	if (!xfs_have_compat_bstat_time32(XFS_IOC_SWAPEXT)) {
+		error = -EINVAL;
+		goto out;
+	}
+
 	/* Pull information for the target fd */
 	f = fdget((int)sxp->sx_fdtarget);
 	if (!f.file) {
-- 
2.20.0

