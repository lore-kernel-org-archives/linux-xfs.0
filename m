Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q71Eur09036474 for <xfs@oss.sgi.com>; Wed, 1 Aug 2012 09:56:53 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	dBo3SNOPeFdUUEdm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Aug 2012 07:56:52 -0700 (PDT)
Received: by yenl3 with SMTP id l3so9040749yen.26
	for <xfs@oss.sgi.com>; Wed, 01 Aug 2012 07:56:52 -0700 (PDT)
Message-ID: <501943B1.5090300@inktank.com>
Date: Wed, 01 Aug 2012 09:56:49 -0500
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: kill struct declarations in xfs_mount.h
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

I noticed that "struct xfs_mount_args" was still declared in
"fs/xfs/xfs_mount.h".  That struct doesn't even exist any more (and
is obviously not referenced elsewhere in that header file).  While
in there, delete four other unneeded struct declarations in that
file.

Doing so highlights that "fs/xfs/xfs_trace.h" was relying indirectly
on "xfs_mount.h" to be #included in order to declare "struct
xfs_bmbt_irec", so add that declaration to resolve that issue.

Signed-off-by: Alex Elder <elder@inktank.com>
---
 fs/xfs/xfs_mount.h |    5 -----
 fs/xfs/xfs_trace.h |    1 +
 2 files changed, 1 insertion(+), 5 deletions(-)

Index: b/fs/xfs/xfs_mount.h
===================================================================
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -54,12 +54,7 @@ typedef struct xfs_trans_reservations {
 #include "xfs_sync.h"

 struct xlog;
-struct xfs_mount_args;
 struct xfs_inode;
-struct xfs_bmbt_irec;
-struct xfs_bmap_free;
-struct xfs_extdelta;
-struct xfs_swapext;
 struct xfs_mru_cache;
 struct xfs_nameops;
 struct xfs_ail;
Index: b/fs/xfs/xfs_trace.h
===================================================================
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -37,6 +37,7 @@ struct xlog_recover;
 struct xlog_recover_item;
 struct xfs_buf_log_format;
 struct xfs_inode_log_format;
+struct xfs_bmbt_irec;

 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
