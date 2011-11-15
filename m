Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAF87IjU037527 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 02:07:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBFF11D0BF5D
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 00:07:15 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	X772knkL73hIFkR1 for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 00:07:15 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RQE31-0007Km-1E
	for xfs@oss.sgi.com; Tue, 15 Nov 2011 08:07:15 +0000
Date: Tue, 15 Nov 2011 03:07:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] repair: validate acl count before reading it
Message-ID: <20111115080714.GA24931@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

This prevents a segfault on a filesystem so badly corrupted by the RAID
controller that it could be considered fuzzed.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/attr_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/attr_repair.c	2011-11-14 20:03:27.000000000 +0000
+++ xfsprogs-dev/repair/attr_repair.c	2011-11-14 20:20:55.000000000 +0000
@@ -931,8 +931,8 @@ process_longform_attr(
 }
 
 
-static xfs_acl_t *
-xfs_acl_from_disk(xfs_acl_disk_t *dacl)
+static int
+xfs_acl_from_disk(struct xfs_acl **aclp, struct xfs_acl_disk *dacl)
 {
 	int			count;
 	xfs_acl_t		*acl;
@@ -940,10 +940,22 @@ xfs_acl_from_disk(xfs_acl_disk_t *dacl)
 	xfs_acl_entry_disk_t	*dace, *end;
 
 	count = be32_to_cpu(dacl->acl_cnt);
+	if (count > XFS_ACL_MAX_ENTRIES) {
+		do_warn(_("to larget ACL, size %d"), count);
+		*aclp = NULL;
+		return EINVAL;
+	}
+
+
 	end = &dacl->acl_entry[0] + count;
 	acl = malloc((int)((char *)end - (char *)dacl));
-	if (!acl)
-		return NULL;
+	if (!acl) {
+		do_warn(_("cannot malloc enough for ACL attribute\n"));
+		do_warn(_("SKIPPING this ACL\n"));
+		*aclp = NULL;
+		return ENOMEM;
+	}
+
 	acl->acl_cnt = count;
 	ace = &acl->acl_entry[0];
 	for (dace = &dacl->acl_entry[0]; dace < end; ace++, dace++) {
@@ -951,7 +963,9 @@ xfs_acl_from_disk(xfs_acl_disk_t *dacl)
 		ace->ae_id = be32_to_cpu(dace->ae_id);
 		ace->ae_perm = be16_to_cpu(dace->ae_perm);
 	}
-	return acl;
+
+	*aclp = acl;
+	return 0;
 }
 
 /*
@@ -1004,15 +1018,14 @@ xfs_acl_valid(xfs_acl_disk_t *daclp)
 	if (daclp == NULL)
 		goto acl_invalid;
 
-	aclp = xfs_acl_from_disk(daclp);
-	if (aclp == NULL) {
-		do_warn(_("cannot malloc enough for ACL attribute\n"));
-		do_warn(_("SKIPPING this ACL\n"));
+	switch (xfs_acl_from_disk(&aclp, daclp)) {
+	case ENOMEM:
 		return 0;
-	}
-
-	if (aclp->acl_cnt > XFS_ACL_MAX_ENTRIES)
+	case EINVAL:
 		goto acl_invalid;
+	default:
+		break;
+	}
 
 	for (i = 0; i < aclp->acl_cnt; i++) {
 		entry = &aclp->acl_entry[i];

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
