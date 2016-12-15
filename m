Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23654 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753971AbcLOSMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 13:12:03 -0500
Subject: [PATCH 3/3] xfs_io: fix the minimum arguments to the reflink command
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Dec 2016 10:11:58 -0800
Message-ID: <148182551808.24784.14290922921211733530.stgit@birch.djwong.org>
In-Reply-To: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

The reflink command can reflink the entirety of two files if the
offsets and lengths are not specified... but we forgot to permit
that case.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/reflink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/io/reflink.c b/io/reflink.c
index a09e82d..d26cbdd 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -302,7 +302,7 @@ reflink_init(void)
 	reflink_cmd.name = "reflink";
 	reflink_cmd.altname = "rl";
 	reflink_cmd.cfunc = reflink_f;
-	reflink_cmd.argmin = 4;
+	reflink_cmd.argmin = 1;
 	reflink_cmd.argmax = -1;
 	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	reflink_cmd.args =

