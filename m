Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A10A37F58
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 07:27:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A0258F8037
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 05:27:56 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id T5TZQybRpIMkHAcC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 05:27:55 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/5] xfs: Correctly lock inode when removing suid and security
	marks
Date: Thu,  4 Dec 2014 14:27:39 +0100
Message-Id: <1417699659-14284-6-git-send-email-jack@suse.cz>
In-Reply-To: <1417699659-14284-1-git-send-email-jack@suse.cz>
References: <1417699659-14284-1-git-send-email-jack@suse.cz>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Currently XFS calls file_remove_privs() without holding i_mutex. This is
wrong because that function can end up messing with file permissions and
security xattrs for which we need i_mutex held.

Fix the problem by grabbing iolock exclusively when we will need to
change anything in permissions / xattrs.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5c9e8296ebb3..c6622aa1f8af 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -521,6 +521,13 @@ restart:
 	if (error)
 		return error;
 
+	/* For changing security info in file_remove_privs() we need i_mutex */
+	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
+		xfs_rw_iunlock(ip, *iolock);
+		*iolock = XFS_IOLOCK_EXCL;
+		xfs_rw_ilock(ip, *iolock);
+		goto restart;
+	}
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
@@ -557,7 +564,9 @@ restart:
 	 * setgid bits if the process is not being run by root.  This keeps
 	 * people from modifying setuid and setgid binaries.
 	 */
-	return file_remove_privs(file);
+	if (!IS_NOSEC(inode))
+		return file_remove_privs(file);
+	return 0;
 }
 
 /*
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
