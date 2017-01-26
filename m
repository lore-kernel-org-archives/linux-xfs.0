Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753060AbdAZUoe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jan 2017 15:44:34 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DE9C81229
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2017 20:44:03 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0QKi2vr002777
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2017 15:44:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH (trivial)] xfs: remove unused full argument from bmap
 formatter
Message-ID: <cdb58427-dace-29e8-f7c3-ed0d40acebf5@redhat.com>
Date: Thu, 26 Jan 2017 14:44:01 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The "full" argument was used only by the fiemap formatter,
which is now gone with the iomap updates.

Remove the unused arg.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b9abce5..e0a1a1a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -779,11 +779,9 @@
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	for (i = 0; i < cur_ext; i++) {
-		int full = 0;	/* user array is full */
-
 		/* format results & advance arg */
-		error = formatter(&arg, &out[i], &full);
-		if (error || full)
+		error = formatter(&arg, &out[i]);
+		if (error)
 			break;
 	}
 
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 68a621a..2aabc76 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -35,7 +35,7 @@ int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
 
 /* bmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
+typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *);
 int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
 		xfs_bmap_format_t formatter, void *arg);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c67cfb4..cf1363db 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1524,7 +1524,7 @@ struct dentry *
 }
 
 STATIC int
-xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
+xfs_getbmap_format(void **ap, struct getbmapx *bmv)
 {
 	struct getbmap __user	*base = (struct getbmap __user *)*ap;
 
@@ -1567,7 +1567,7 @@ struct dentry *
 }
 
 STATIC int
-xfs_getbmapx_format(void **ap, struct getbmapx *bmv, int *full)
+xfs_getbmapx_format(void **ap, struct getbmapx *bmv)
 {
 	struct getbmapx __user	*base = (struct getbmapx __user *)*ap;
 

