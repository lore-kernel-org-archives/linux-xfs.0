Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4D967F4E
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 14:30:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DF0BAC002
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 12:30:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w0ICz8GUvxJj4HsF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 12:30:17 -0700 (PDT)
Message-ID: <53F648CC.9080604@redhat.com>
Date: Thu, 21 Aug 2014 14:30:20 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: lseek: the "whence" argument is called "whence"
References: <53F55765.6030205@redhat.com> <53F64723.4070001@sandeen.net>
In-Reply-To: <53F64723.4070001@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, Jeff Liu <jeff.liu@oracle.com>

For some reason, the older commit:

    965c8e5 lseek: the "whence" argument is called "whence"

    lseek: the "whence" argument is called "whence"
    
    But the kernel decided to call it "origin" instead.
    Fix most of the sites.

left out xfs.  So fix xfs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1da3b7d..0fe36e4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1322,16 +1322,16 @@ STATIC loff_t
 xfs_file_llseek(
 	struct file	*file,
 	loff_t		offset,
-	int		origin)
+	int		whence)
 {
-	switch (origin) {
+	switch (whence) {
 	case SEEK_END:
 	case SEEK_CUR:
 	case SEEK_SET:
-		return generic_file_llseek(file, offset, origin);
+		return generic_file_llseek(file, offset, whence);
 	case SEEK_HOLE:
 	case SEEK_DATA:
-		return xfs_seek_hole_data(file, offset, origin);
+		return xfs_seek_hole_data(file, offset, whence);
 	default:
 		return -EINVAL;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
