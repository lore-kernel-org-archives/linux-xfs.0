Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38684 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbeCTDIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 23:08:36 -0400
Subject: [PATCH 2/4] libfrog: fs_table_lookup_mount should realpath the
 argument
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Mar 2018 20:08:32 -0700
Message-ID: <152151531216.18312.5625644435478815432.stgit@magnolia>
In-Reply-To: <152151529988.18312.2660325658864402943.stgit@magnolia>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Call realpath on the dir argument so that we're comparing canonical
paths when looking for the mountpoint.  This fixes the problem where
'/home/' doesn't match '/home' even though they refer to the same thing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/paths.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/libfrog/paths.c b/libfrog/paths.c
index 62b4eda..19ee1ea 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -102,16 +102,19 @@ fs_table_lookup_mount(
 	uint		i;
 	dev_t		dev = 0;
 	char		rpath[PATH_MAX];
+	char		dpath[PATH_MAX];
 
 	if (fs_device_number(dir, &dev))
 		return NULL;
+	if (!realpath(dir, dpath))
+		return NULL;
 
 	for (i = 0; i < fs_count; i++) {
 		if (fs_table[i].fs_flags != FS_MOUNT_POINT)
 			continue;
 		if (!realpath(fs_table[i].fs_dir, rpath))
 			continue;
-		if (strcmp(rpath, dir) == 0)
+		if (strcmp(rpath, dpath) == 0)
 			return &fs_table[i];
 	}
 	return NULL;

