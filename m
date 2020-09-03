Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B4EC433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 03:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D51A20716
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 03:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgICD52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:57:28 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56959 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726528AbgICD52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 23:57:28 -0400
X-IronPort-AV: E=Sophos;i="5.76,384,1592841600"; 
   d="scan'208";a="98860266"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Sep 2020 11:57:24 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id C17EF48990E6;
        Thu,  3 Sep 2020 11:57:22 +0800 (CST)
Received: from G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 3 Sep 2020 11:57:22 +0800
Received: from Fedora-31.g08.fujitsu.local (10.167.220.31) by
 G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Thu, 3 Sep 2020 11:57:20 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <darrick.wong@oracle.com>, <ira.weiny@intel.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH v3] xfs: Add check for unsupported xflags
Date:   Thu, 3 Sep 2020 11:57:13 +0800
Message-ID: <20200903035713.60962-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: C17EF48990E6.AB6BB
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Current ioctl(FSSETXATTR) ignores unsupported xflags silently
so it is not clear for user to know unsupported xflags.
For example, use ioctl(FSSETXATTR) to set dax flag on kernel
v4.4 which doesn't support dax flag:
--------------------------------
# xfs_io -f -c "chattr +x" testfile;echo $?
0
# xfs_io -c "lsattr" testfile
----------------X testfile
--------------------------------

Add check to return -EOPNOTSUPP as ext4/f2fs/btrfs does.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6f22a66777cd..59f9a86f29f7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1425,6 +1425,14 @@ xfs_ioctl_setattr_check_projid(
 	return 0;
 }
 
+#define XFS_SUPPORTED_FS_XFLAGS \
+	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
+	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
+	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
+	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
+	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
+	 FS_XFLAG_HASATTR)
+
 STATIC int
 xfs_ioctl_setattr(
 	xfs_inode_t		*ip,
@@ -1439,6 +1447,10 @@ xfs_ioctl_setattr(
 
 	trace_xfs_ioctl_setattr(ip);
 
+	/* Check if fsx_xflags has unsupported xflags */
+	if (fa->fsx_xflags & ~XFS_SUPPORTED_FS_XFLAGS)
+                return -EOPNOTSUPP;
+
 	code = xfs_ioctl_setattr_check_projid(ip, fa);
 	if (code)
 		return code;
-- 
2.25.1



