Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17443 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751859AbdGaW7h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jul 2017 18:59:37 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] xfs_io: allow lsattr & lsproj on foreign filesystems
Date: Mon, 31 Jul 2017 16:58:33 -0600
Message-Id: <20170731225833.11104-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>

The following commit:

commit 73b54bb6a2fb ("xfs_io: allow chattr & chproj on foreign filesystems")

allowed chattr and chproj to be run on non-xfs filesystems now that
FS_IOC_FSSETXATTR is a generic vfs call.  It failed to enable the
corresponding lsattr and lsproj commands for those filesystems, though.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: 73b54bb6a2fb ("xfs_io: allow chattr & chproj on foreign filesystems")
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
---
 io/attr.c | 2 +-
 io/open.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/attr.c b/io/attr.c
index b8eec1b..728560e 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -353,7 +353,7 @@ attr_init(void)
 	lsattr_cmd.args = _("[-R|-D|-a|-v]");
 	lsattr_cmd.argmin = 0;
 	lsattr_cmd.argmax = 1;
-	lsattr_cmd.flags = CMD_NOMAP_OK;
+	lsattr_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	lsattr_cmd.oneline =
 		_("list extended inode flags set on the currently open file");
 	lsattr_cmd.help = lsattr_help;
diff --git a/io/open.c b/io/open.c
index b50f068..f2ea7c3 100644
--- a/io/open.c
+++ b/io/open.c
@@ -812,7 +812,7 @@ open_init(void)
 	lsproj_cmd.args = _("[-D | -R]");
 	lsproj_cmd.argmin = 0;
 	lsproj_cmd.argmax = -1;
-	lsproj_cmd.flags = CMD_NOMAP_OK;
+	lsproj_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	lsproj_cmd.oneline =
 		_("list project identifier set on the currently open file");
 	lsproj_cmd.help = lsproj_help;
-- 
2.9.4

