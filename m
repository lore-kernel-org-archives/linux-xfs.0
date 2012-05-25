Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PGmxhN141150 for <xfs@oss.sgi.com>; Fri, 25 May 2012 11:48:59 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id ceQ8qrshXbPJIwtc
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 May 2012 09:48:57 -0700 (PDT)
Received: by dadg9 with SMTP id g9so1792576dad.26
	for <xfs@oss.sgi.com>; Fri, 25 May 2012 09:48:57 -0700 (PDT)
From: Chen Baozi <baozich@gmail.com>
Subject: [RESEND PATCH] xfs: fix typo in comment of xfs_dinode_t.
Date: Sat, 26 May 2012 00:48:47 +0800
Message-Id: <D347A332-0256-43E4-8FCE-BCFC1DD478C8@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bpm@sgi.com, linux-kernel@vger.kernel.org

There should be "XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR" instead
of "XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR".

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
