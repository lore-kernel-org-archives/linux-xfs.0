Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A17B729DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 11:41:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FC068F8052
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 09:41:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xX8qTjOzmxqxAZss (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 09:40:59 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id EB5F580504
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 17:40:58 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u19HewqI016686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 9 Feb 2016 12:40:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: guard fsxattr definition for newer kernels
Message-ID: <56BA24A9.4090403@redhat.com>
Date: Tue, 9 Feb 2016 11:40:57 -0600
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

After 334e580,
fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion

the file include/linux/fs.h now defines struct fsxattr.

It defines FS_IOC_FSGETXATTR as well, so use that to wrap
our local definition, and skip it if the kernel is providing
it so that we don't get multiple definitions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Should the kernel also #define HAVE_FSXATTR to help existing
xfsprogs-devel installations?

(And what if headers are included in the other order?  Should
we try to guard on the kernel side or no?)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d8b733a..f4858df 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -37,8 +37,10 @@ struct dioattr {
 
 /*
  * Structure for XFS_IOC_FSGETXATTR[A] and XFS_IOC_FSSETXATTR.
+ * If FS_IOC_FSGETXATTR is defined, the kernel is now providing
+ * this structure definition.
  */
-#ifndef HAVE_FSXATTR
+#if (!defined(HAVE_FSXATTR) && !defined(FS_IOC_FSGETXATTR))
 struct fsxattr {
 	__u32		fsx_xflags;	/* xflags field value (get/set) */
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
