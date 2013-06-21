Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F4177F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 08:28:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11928AC005
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 06:27:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9FYADozjzAUQFgTi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Jun 2013 06:27:57 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r5LDLcuq025031
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 13:21:39 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5LDRtLv001114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 13:27:55 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5LDRtoZ024156 for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 13:27:55 GMT
Message-ID: <51C454DE.2010008@oracle.com>
Date: Fri, 21 Jun 2013 21:27:58 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: lseek SEEK_DATA/SEEK_HOLE consolidation
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Consolidate lseek(2) SEEK_DATA/SEEK_HOLE according to the
implementation of VFS lseek_execute():
- if end up with a negative offset, return EINVAL if file
  is not huge.
- if end up with an offset larger than s_maxbytes, return
  EINVAL as well.
- reset file version to 0 if end up with an offset that is
  not equal to the current file offset.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a5f2042..dc42751 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1270,8 +1270,19 @@ xfs_seek_data(
 	}
 
 out:
-	if (offset != file->f_pos)
+	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
+		error = EINVAL;
+		goto out_unlock;
+	}
+	if (offset > inode->i_sb->s_maxbytes) {
+		error = EINVAL;
+		goto out_unlock;
+	}
+
+	if (offset != file->f_pos) {
 		file->f_pos = offset;
+		file->f_version = 0;
+	}
 
 out_unlock:
 	xfs_iunlock_map_shared(ip, lock);
@@ -1372,6 +1383,15 @@ xfs_seek_hole(
 	}
 
 out:
+	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
+		error = EINVAL;
+		goto out_unlock;
+	}
+	if (offset > inode->i_sb->s_maxbytes) {
+		error = EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * At this point, we must have found a hole.  However, the returned
 	 * offset may be bigger than the file size as it may be aligned to
@@ -1379,8 +1399,10 @@ out:
 	 * situation in particular.
 	 */
 	offset = min_t(loff_t, offset, isize);
-	if (offset != file->f_pos)
+	if (offset != file->f_pos) {
 		file->f_pos = offset;
+		file->f_version = 0;
+	}
 
 out_unlock:
 	xfs_iunlock_map_shared(ip, lock);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
