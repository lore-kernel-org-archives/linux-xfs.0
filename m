Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45564 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbcJGXID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 19:08:03 -0400
Subject: [PATCH 6/7] xfs: fix error initialization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Oct 2016 16:07:56 -0700
Message-ID: <147588167673.12127.8923121358064293920.stgit@birch.djwong.org>
In-Reply-To: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

Eric Sandeen reported a gcc complaint about uninitialized error
variables, so fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_reflink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 220d263..5965e94 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1437,7 +1437,7 @@ xfs_reflink_dirty_extents(
 	xfs_off_t		flen;
 	struct xfs_bmbt_irec	map[2];
 	int			nmaps;
-	int			error;
+	int			error = 0;
 
 	while (end - fbno > 0) {
 		nmaps = 1;

