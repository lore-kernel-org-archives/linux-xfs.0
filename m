Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 057177F67
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 04:38:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E807D304048
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 02:38:52 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3XuG1M7c6mMKu2iv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 02:38:47 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/5] fs: Fix S_NOSEC handling
Date: Tue,  3 Mar 2015 11:38:35 +0100
Message-Id: <1425379119-3773-2-git-send-email-jack@suse.cz>
In-Reply-To: <1425379119-3773-1-git-send-email-jack@suse.cz>
References: <1425379119-3773-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, xfs@oss.sgi.com

file_remove_suid() could mistakenly set S_NOSEC inode bit when root was
modifying the file. As a result following writes to the file by ordinary
user would avoid clearing suid or sgid bits.

Fix the bug by checking actual mode bits before setting S_NOSEC.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index f00b16f45507..be326ae7f880 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1693,7 +1693,8 @@ int file_remove_suid(struct file *file)
 		error = security_inode_killpriv(dentry);
 	if (!error && killsuid)
 		error = __remove_suid(dentry, killsuid);
-	if (!error && (inode->i_sb->s_flags & MS_NOSEC))
+	if (!error && (inode->i_sb->s_flags & MS_NOSEC) &&
+	    !is_sxid(inode->i_mode))
 		inode->i_flags |= S_NOSEC;
 
 	return error;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
