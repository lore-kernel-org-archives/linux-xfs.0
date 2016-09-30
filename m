Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48035 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbcI3DFt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:05:49 -0400
Subject: [PATCH 01/63] vfs: support FS_XFLAG_COWEXTSIZE and get/set of CoW
 extent size hint
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:05:41 -0700
Message-ID: <147520474174.29434.4219258758809697838.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Introduce XFLAGs for the new XFS CoW extent size hint, and actually
plumb the CoW extent size hint into the fsxattr structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/uapi/linux/fs.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3b00f7c..cf39876 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -157,7 +157,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* CoW extsize field value (get/set)*/
+	unsigned char	fsx_pad[8];
 };
 
 /*
@@ -178,6 +179,7 @@ struct fsxattr {
 #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
+#define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is

