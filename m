Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbcI3Uw7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 16:52:59 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C26A57EA99
        for <linux-xfs@vger.kernel.org>; Fri, 30 Sep 2016 20:52:08 +0000 (UTC)
Subject: [PATCH 1/5] xfs_io: fix inode command help and argsmax
References: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <f485f5cb-084b-40e6-b7de-c469782b71b2@redhat.com>
Date: Fri, 30 Sep 2016 15:52:08 -0500
MIME-Version: 1.0
In-Reply-To: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

The short help implied that -n and -v were exclusive, and the longer
help wasn't particularly clear.

Further, argsmax is wrong; "-n -v num" is 3, not 2.

 # xfs_io -c "inode -n -v 123" /mnt/test2
 bad argument count 3 to inode, expected between 0 and 2 arguments
 # xfs_io -c "inode -vn 123" /mnt/test2
 128:32

Fix up all of those issues.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/open.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/io/open.c b/io/open.c
index 3eaa013..5efa739 100644
--- a/io/open.c
+++ b/io/open.c
@@ -757,16 +757,13 @@ inode_help(void)
 {
 	printf(_(
 "\n"
-"Query physical information about the inode"
+"Query physical information about an inode"
 "\n"
-" Default:	-- Return true(1) or false(0) if any inode greater than\n"
-"		   32bits has been found in the filesystem\n"
-"[num]		-- Return inode number [num] or 0 if the inode [num] is in use\n"
-"		   or not\n"
-" -n [num]	-- Return the next valid inode after [num]\n"
-" -v		-- verbose mode\n"
-"		   Display the inode number and its physical size (in bits)\n"
-"		   according to the argument used\n"
+" Default:	-- Return 1 if any inode number greater than 32 bits exists in\n"
+"		   the filesystem, or 0 if none exist\n"
+" num		-- Return inode number [num] if in use, or 0 if not in use\n"
+" -n num	-- Return the next used inode after [num]\n"
+" -v		-- Verbose mode - display returned inode number's size in bits\n"
 "\n"));
 }
 
@@ -956,9 +953,9 @@ open_init(void)
 
 	inode_cmd.name = "inode";
 	inode_cmd.cfunc = inode_f;
-	inode_cmd.args = _("[-n | -v] [num]");
+	inode_cmd.args = _("[-nv] [num]");
 	inode_cmd.argmin = 0;
-	inode_cmd.argmax = 2;
+	inode_cmd.argmax = 3;
 	inode_cmd.flags = CMD_NOMAP_OK;
 	inode_cmd.oneline =
 		_("Query inode number usage in the filesystem");
-- 
1.7.1

