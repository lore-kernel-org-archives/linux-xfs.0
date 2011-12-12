Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCLvvUn124076 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 15:57:58 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1507B16EFFE6
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 13:57:56 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id A8xplRcqwwAncpJY
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 13:57:56 -0800 (PST)
Received: by qadb15 with SMTP id b15so4936787qad.5
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 13:57:55 -0800 (PST)
From: Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] xfs: fix acl count validation in xfs_acl_from_disk()
Date: Mon, 12 Dec 2011 16:55:52 -0500
Message-Id: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>, Ben Myers <bpm@sgi.com>
Cc: linux-kernel@vger.kernel.org, Xi Wang <xi.wang@gmail.com>, xfs@oss.sgi.com

Commit fa8b18ed didn't prevent the integer overflow and possible
memory corruption.  "count" can go negative and bypass the check.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 fs/xfs/xfs_acl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 76e4266..ac702a6 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -39,7 +39,7 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	struct posix_acl_entry *acl_e;
 	struct posix_acl *acl;
 	struct xfs_acl_entry *ace;
-	int count, i;
+	unsigned int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
 	if (count > XFS_ACL_MAX_ENTRIES)
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
