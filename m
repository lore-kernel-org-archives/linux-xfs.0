Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C22767F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 09:01:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 602FAAC050
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 07:01:38 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id VRICbdoY7LiLFed1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 07:01:33 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F0B1EAC18
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 15:01:31 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Correctly lock inode when removing suid and security
	marks
Date: Tue,  2 Dec 2014 16:01:29 +0100
Message-Id: <1417532489-26580-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

Currently XFS calls file_remove_suid() without holding i_mutex. This is
wrong because that function can end up messing with file permissions and
security xattrs for which we need i_mutex held.

Fix the problem by grabbing iolock exclusively when we will need to
change anything in permissions / xattrs.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index eb596b419942..ad6636ac4943 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -521,6 +521,18 @@ restart:
 	if (error)
 		return error;
 
+	/* For changing security info in file_remove_suid() we need i_mutex */
+	if (!IS_NOSEC(inode) && *iolock == XFS_IOLOCK_SHARED) {
+		struct dentry *dentry = file->f_path.dentry;
+
+		if (should_remove_suid(dentry) ||
+		    security_inode_need_killpriv(dentry)) {
+			xfs_rw_iunlock(ip, *iolock);
+			*iolock = XFS_IOLOCK_EXCL;
+			xfs_rw_ilock(ip, *iolock);
+			goto restart;
+		}
+	}
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
