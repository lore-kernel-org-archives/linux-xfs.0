Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3Q6c7qJ026074 for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 01:38:07 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id z9vyDZAvFCRd1lFj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Apr 2012 23:38:06 -0700 (PDT)
Received: by pbbrr4 with SMTP id rr4so1590541pbb.26
	for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 23:38:06 -0700 (PDT)
From: Chen Baozi <baozich@gmail.com>
Subject: [RESEND PATCH] fs/xfs/xfs_dinode.h: fix comments of xfs_dinode_t.
Date: Thu, 26 Apr 2012 06:37:44 +0800
Message-Id: <1335393464-13835-1-git-send-email-baozich@gmail.com>
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
To: xfs@oss.sgi.com
Cc: Chen Baozi <baozich@gmail.com>, linux-kernel@vger.kernel.org

XFS: fix comments

fix:
- comments about xfs_dinode_t.

Signed-off-by: Chen Baozi <baozich@gmail.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_dinode.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index a372163..1d9643b 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -33,7 +33,7 @@ typedef struct xfs_timestamp {
  * variable size the leftover area split into a data and an attribute fork.
  * The format of the data and attribute fork depends on the format of the
  * inode as indicated by di_format and di_aformat.  To access the data and
- * attribute use the XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR macros
+ * attribute use the XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR macros
  * below.
  *
  * There is a very similar struct icdinode in xfs_inode which matches the
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
