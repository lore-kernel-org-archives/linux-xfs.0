Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA1GVvgP037730 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 11:31:58 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id iEAGHMgay8bxTNHW for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 09:33:47 -0700 (PDT)
Message-ID: <5092A46A.8080909@sandeen.net>
Date: Thu, 01 Nov 2012 11:33:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2 V2] xfs_logprint: Handle multiply-logged inode fields
References: <5092A1DE.10609@redhat.com> <5092A2B6.2000907@redhat.com>
In-Reply-To: <5092A2B6.2000907@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

As xlog_print_trans_inode() stands today, it will error
out if more than one flag is set on f->ilf_fields:

	xlog_print_trans_inode: illegal inode type

but this is a perfectly valid case, to have i.e. a data and
an attr flag set.

Following is a pretty big reworking of the function to
handle more than one field type set.

I've tested this by a simple test such as creating one
file on an selinux box, so that data+attr is set, and
logprinting; I've also tested by running logprint after
subsequent xfstest runs (although we hit other bugs that
way).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Fix subject, sigh.

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index e42e108..be2426e 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -657,97 +657,84 @@ xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops)
 
     /* does anything come next */
     op_head = (xlog_op_header_t *)*ptr;
-    switch (f->ilf_fields & XFS_ILOG_NONCORE) {
-	case XFS_ILOG_DEXT: {
-	    ASSERT(f->ilf_size == 3);
-	    (*i)++;
-	    xlog_print_op_header(op_head, *i, ptr);
-	    printf(_("EXTENTS inode data\n"));
-	    *ptr += be32_to_cpu(op_head->oh_len);
-	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))  {
-		return 1;
-	    }
-	    break;
-	}
-	case XFS_ILOG_DBROOT: {
-	    ASSERT(f->ilf_size == 3);
-	    (*i)++;
-	    xlog_print_op_header(op_head, *i, ptr);
-	    printf(_("BTREE inode data\n"));
-	    *ptr += be32_to_cpu(op_head->oh_len);
-	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))  {
-		return 1;
-	    }
+
+    if (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
+	switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
+	case XFS_ILOG_DEV:
+	    printf(_("DEV inode: no extra region\n"));
 	    break;
-	}
-	case XFS_ILOG_DDATA: {
-	    ASSERT(f->ilf_size == 3);
-	    (*i)++;
-	    xlog_print_op_header(op_head, *i, ptr);
-	    printf(_("LOCAL inode data\n"));
-	    if (mode == S_IFDIR) {
-		xlog_print_dir_sf((xfs_dir_shortform_t*)*ptr, size);
-	    }
-	    *ptr += be32_to_cpu(op_head->oh_len);
-	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS)) {
-		return 1;
-	    }
+	case XFS_ILOG_UUID:
+	    printf(_("UUID inode: no extra region\n"));
 	    break;
+	case XFS_ILOG_DEXT:
+	case XFS_ILOG_DBROOT:
+	case XFS_ILOG_DDATA:
+	default:
+	    xlog_panic(_("xlog_print_trans_inode: illegal inode type 0x%x"),
+			f->ilf_fields);
 	}
-	case XFS_ILOG_AEXT: {
-	    ASSERT(f->ilf_size == 3);
+    }
+
+    if (f->ilf_fields & (XFS_ILOG_DFORK | XFS_ILOG_AFORK)) {
+	ASSERT(f->ilf_size <= 4);
+	ASSERT((f->ilf_size == 3) || (f->ilf_fields & XFS_ILOG_AFORK));
+	if (f->ilf_fields & XFS_ILOG_DFORK) {
 	    (*i)++;
 	    xlog_print_op_header(op_head, *i, ptr);
-	    printf(_("EXTENTS inode attr\n"));
-	    *ptr += be32_to_cpu(op_head->oh_len);
-	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))  {
-		return 1;
+
+	    switch (f->ilf_fields & XFS_ILOG_DFORK) {
+	    case XFS_ILOG_DEXT:
+		printf(_("EXTENTS inode data\n"));
+		break;
+	    case XFS_ILOG_DBROOT:
+		printf(_("BTREE inode data\n"));
+		break;
+	    case XFS_ILOG_DDATA:
+		printf(_("LOCAL inode data\n"));
+		if (mode == S_IFDIR)
+		    xlog_print_dir_sf((xfs_dir_shortform_t*)*ptr, size);
+		break;
+	    case XFS_ILOG_DEV:
+	    case XFS_ILOG_UUID:
+	    default:
+		xlog_panic(_("xlog_print_trans_inode: illegal inode type 0x%x"),
+			   f->ilf_fields);
 	    }
-	    break;
-	}
-	case XFS_ILOG_ABROOT: {
-	    ASSERT(f->ilf_size == 3);
-	    (*i)++;
-	    xlog_print_op_header(op_head, *i, ptr);
-	    printf(_("BTREE inode attr\n"));
+
 	    *ptr += be32_to_cpu(op_head->oh_len);
-	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))  {
+	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))
 		return 1;
-	    }
-	    break;
+	    op_head = (xlog_op_header_t *)*ptr;
 	}
-	case XFS_ILOG_ADATA: {
-	    ASSERT(f->ilf_size == 3);
+
+	if (f->ilf_fields & XFS_ILOG_AFORK) {
 	    (*i)++;
 	    xlog_print_op_header(op_head, *i, ptr);
-	    printf(_("LOCAL inode attr\n"));
-	    if (mode == S_IFDIR) {
-		xlog_print_dir_sf((xfs_dir_shortform_t*)*ptr, size);
+
+	    switch (f->ilf_fields & XFS_ILOG_AFORK) {
+	    case XFS_ILOG_AEXT:
+		printf(_("EXTENTS attr data\n"));
+		break;
+	    case XFS_ILOG_ABROOT:
+		printf(_("BTREE attr data\n"));
+		break;
+	    case XFS_ILOG_ADATA:
+		printf(_("LOCAL attr data\n"));
+		if (mode == S_IFDIR)
+		    xlog_print_dir_sf((xfs_dir_shortform_t*)*ptr, size);
+		break;
+	    default:
+		xlog_panic(_("xlog_print_trans_inode: illegal inode type 0x%x"),
+			   f->ilf_fields);
 	    }
 	    *ptr += be32_to_cpu(op_head->oh_len);
-	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS)) {
+	    if (XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS))
 		return 1;
-	    }
-	    break;
-	}
-	case XFS_ILOG_DEV: {
-	    ASSERT(f->ilf_size == 2);
-	    printf(_("DEV inode: no extra region\n"));
-	    break;
-	}
-	case XFS_ILOG_UUID: {
-	    ASSERT(f->ilf_size == 2);
-	    printf(_("UUID inode: no extra region\n"));
-	    break;
-	}
-	case 0: {
-	    ASSERT(f->ilf_size == 2);
-	    break;
+	    op_head = (xlog_op_header_t *)*ptr;
 	}
-	default: {
-	    xlog_panic(_("xlog_print_trans_inode: illegal inode type"));
-	}
-    }
+    } else	/* neither XFS_ILOG_DFORK nor XFS_ILOG_AFORK */
+	ASSERT(f->ilf_size == 2);
+
     return 0;
 }	/* xlog_print_trans_inode */
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
