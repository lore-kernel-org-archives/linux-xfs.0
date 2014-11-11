Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A7CEB7F6A
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 96E748F8035
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:46 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id eOkHigQZ7pGFMSfQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:44 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 01/11] xfs: Remove useless test
Date: Tue, 11 Nov 2014 22:04:15 +0100
Message-Id: <1415739865-2438-2-git-send-email-jack@suse.cz>
In-Reply-To: <1415739865-2438-1-git-send-email-jack@suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Q_XQUOTARM is never passed to xfs_fs_set_xstate() so remove the test.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_quotaops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index b238027df987..9ad73240ed54 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -77,7 +77,7 @@ xfs_fs_set_xstate(
 
 	if (sb->s_flags & MS_RDONLY)
 		return -EROFS;
-	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
+	if (!XFS_IS_QUOTA_RUNNING(mp))
 		return -ENOSYS;
 
 	if (uflags & FS_QUOTA_UDQ_ACCT)
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
