Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9940C4D2C4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0215A2469F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLMU56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 15:57:58 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:56003 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMU55 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 15:57:57 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N9dg5-1hcRf53jM5-015a8l; Fri, 13 Dec 2019 21:57:46 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH v2 20/24] xfs: disallow broken ioctls without compat-32-bit-time
Date:   Fri, 13 Dec 2019 21:53:48 +0100
Message-Id: <20191213205417.3871055-11-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191213204936.3643476-1-arnd@arndb.de>
References: <20191213204936.3643476-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+OC98lqsRIacY7Fo8hffNaEguwEx5BrW1ehoyzc3XQFB5ZHNiyH
 3YX603rEPTrkOQExfMO9QXAGFroF+FD93OMx9FVC6EZty09STF3GnlQELmGO576vt5HzmMn
 X5re2BzBcKgFmWs4Z1qDbbqpMGHnWYZCouGOGdR3XUvGTqVJihZQ7bnJ/2nvsy1qXT1bBNT
 LbByJ8SMK3jY0wg9jfTVA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hyZOFL3Pdhc=:c8WEjei9ibUrYRg7I5nOOT
 uV2U+LutYN//sc6CK3IG/2yqD9u5+kPxqEpfyfGI5AnPSM42vSXYkcWAmuHZNl3qkpHZfBfi5
 jL3Y/aBoYbidXGGJpMF9E4OjvFS+f1i0kfrEk6woVEmJDvyxstAQx0azJUrOpRZ8D5lMEErZY
 zKTSPj3FmzEE7eIytszzFwKN7qLS0lY4X+6j76qz+q46OloyHeJE0EZy9TiVFErDzyzMt7Rrw
 DEDRlCQfw9ic8qFrLRqjgIitBCIhLFktVhXGQVtF8Hw4gXZONvO3lF/Ugtfpscc9K3DuEz7NO
 Tl/TE2WRwqa2ELqxyPYka4nMkdhcQ6XBF1GmkHKtzbStWOLw4Mn6OUpCRasZZ1iArigNbCA39
 xvzP7ILLUKggS0iNdk6flDo16UFbFGuN5Owv0f59Jm6ipUZntiBhIm2GjTE0bTPdFq6vasDAk
 SFTAJT/jZtxnclb1CEN7VFV4ZV81CxAqh/2ISzAhACjF5gE3OTVR0fz5Fil39oMVYA1uEGIT3
 HWoPW/SNtQ363sKS75X6AAyU9us76vzNZbZyPj3Hi7BYvXrSdLoOAajFzm7gEYfPWJlQ3GJS5
 lriS8hPIMhzMFlAEnAw05o0230kTwVbTLNafzi7NjuGr/2YnwzdVoAJRe3Q+6hxYQx5XcJLYU
 gHc2QlrcR8ihFfBqSSxgf/5OA9HkYzWL02Ey9ma6puSYTXvA8kqvcCeCKm+Y07/FKPiQdJ6ut
 ufWZcVA+3+STIzCrybd1pcL1zSIUCpmwFMvwlvCEEKzPw48lb7P48aagOI/F7pG3V2O+b6Z4M
 TJGaa3pPvY/0B4jk3pyexJfYgefRXzzP9aN7oQZ3CjYDbtfQnBUfJiyByUAHvN1GfXJ4E08fU
 3wzrXqTv0isiQ9PrA16w==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When building a kernel that disables support for 32-bit time_t
system calls, it also makes sense to disable the old xfs_bstat
ioctls completely, as they truncate the timestamps to 32-bit
values.

Any application using these needs to be updated to use the v5
interfaces.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_ioctl.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7b35d62ede9f..a4a4eed8879c 100644
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
 
+	if (xfs_have_compat_bstat_time32(XFS_IOC_SWAPEXT)) {
+		error = -EINVAL;
+		goto out;
+	}
+
 	/* Pull information for the target fd */
 	f = fdget((int)sxp->sx_fdtarget);
 	if (!f.file) {
-- 
2.20.0

