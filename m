Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953D8C35242
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 19:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DDF721741
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 19:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgBHTfP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Feb 2020 14:35:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:1353 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbgBHTev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Feb 2020 14:34:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2020 11:34:50 -0800
X-IronPort-AV: E=Sophos;i="5.70,418,1574150400"; 
   d="scan'208";a="431203209"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.157])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2020 11:34:50 -0800
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
Subject: [PATCH v3 06/12] fs/xfs: Check if the inode supports DAX under lock
Date:   Sat,  8 Feb 2020 11:34:39 -0800
Message-Id: <20200208193445.27421-7-ira.weiny@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200208193445.27421-1-ira.weiny@intel.com>
References: <20200208193445.27421-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

One of the checks for an inode supporting DAX is if the inode is
reflinked.  During a non-DAX to DAX state change we could race with
the file being reflinked and end up with a reflinked file being in DAX
state.

Prevent this race by checking for DAX support under the MMAP_LOCK.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/xfs/xfs_ioctl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index da1eb2bdb386..4ff402fd6636 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1194,10 +1194,6 @@ xfs_ioctl_setattr_dax_invalidate(
 
 	*join_flags = 0;
 
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) == FS_XFLAG_DAX &&
-	    !xfs_inode_supports_dax(ip))
-		return -EINVAL;
-
 	/* If the DAX state is not changing, we have nothing to do here. */
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
 	    (ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
@@ -1211,6 +1207,13 @@ xfs_ioctl_setattr_dax_invalidate(
 
 	/* lock, flush and invalidate mapping in preparation for flag change */
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+
+	if ((fa->fsx_xflags & FS_XFLAG_DAX) == FS_XFLAG_DAX &&
+	    !xfs_inode_supports_dax(ip)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)
 		goto out_unlock;
-- 
2.21.0

