Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8JQWb225223 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:19:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ACF04FADD6
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:19:26 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AZ8xDXEr7RvFFQlF for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:19:26 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwQv-00077c-Ln
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:19:25 +0000
Message-Id: <20111128081925.630748714@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:17:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] xfs: validate acl count
References: <20111128081732.350228200@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-validate-acls
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

This prevents in-memory corruption and possible panics if the on-disk
ACL is badly corrupted.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_acl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_acl.c	2011-11-20 12:49:11.181244706 +0100
+++ xfs/fs/xfs/xfs_acl.c	2011-11-20 12:49:50.637697619 +0100
@@ -42,6 +42,8 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
+	if (count > XFS_ACL_MAX_ENTRIES)
+		return ERR_PTR(-EFSCORRUPTED);
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
