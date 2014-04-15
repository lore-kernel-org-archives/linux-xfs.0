Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7CA987F58
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 11:18:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20188AC004
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:18:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lZY0GQasLxGkvp6E for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:18:29 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3FGISFg005850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:18:28 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3FGISDt028528
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:18:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 2/4] xfs: initialize inode security on tmpfile creation
Date: Tue, 15 Apr 2014 12:18:24 -0400
Message-Id: <1397578706-5385-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Initialize security for inodes allocated via the tmpfile interface. This
ensures security is initialized if the inode is subsequently linked back
into the namespace.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8fdbc38..2b1d1bd 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1063,6 +1063,12 @@ xfs_vn_tmpfile(
 
 	inode = VFS_I(ip);
 
+	error = xfs_init_security(inode, dir, &dentry->d_name);
+	if (unlikely(error)) {
+		iput(inode);
+		return -error;
+	}
+
 	d_tmpfile(dentry, inode);
 
 	return 0;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
