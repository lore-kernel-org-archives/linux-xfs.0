Return-Path: <SRS0=FSF3=YN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0642ACA9EB1
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 16:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D115D222C2
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 16:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJTQAC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Oct 2019 12:00:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:32418 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbfJTQAB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 Oct 2019 12:00:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Oct 2019 09:00:00 -0700
X-IronPort-AV: E=Sophos;i="5.67,320,1566889200"; 
   d="scan'208";a="209275529"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.157])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Oct 2019 09:00:00 -0700
From:   ira.weiny@intel.com
To:     linux-kernel@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/5] fs/xfs: Allow toggle of physical DAX flag
Date:   Sun, 20 Oct 2019 08:59:35 -0700
Message-Id: <20191020155935.12297-6-ira.weiny@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191020155935.12297-1-ira.weiny@intel.com>
References: <20191020155935.12297-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Switching between DAX and non-DAX on a file is racy with respect to data
operations.  However, if no data is involved the flag is safe to switch.

Allow toggling the physical flag if a file is empty.  The file length
check is not racy with respect to other operations as it is performed
under XFS_MMAPLOCK_EXCL and XFS_IOLOCK_EXCL locks.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/xfs/xfs_ioctl.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d3a7340d3209..3839684c249b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -33,6 +33,7 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "libxfs/xfs_dir2.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -1232,12 +1233,10 @@ xfs_diflags_to_linux(
 		inode->i_flags |= S_NOATIME;
 	else
 		inode->i_flags &= ~S_NOATIME;
-#if 0	/* disabled until the flag switching races are sorted out */
 	if (xflags & FS_XFLAG_DAX)
 		inode->i_flags |= S_DAX;
 	else
 		inode->i_flags &= ~S_DAX;
-#endif
 }
 
 static int
@@ -1320,6 +1319,12 @@ xfs_ioctl_setattr_dax_invalidate(
 
 	/* lock, flush and invalidate mapping in preparation for flag change */
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+
+	if (i_size_read(inode) != 0) {
+		error = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)
 		goto out_unlock;
-- 
2.20.1

