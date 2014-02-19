Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D48CF7FA6
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 15:10:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C48228F807A
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 13:10:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id K9rWGrqiyJ3x61G7 for
	<xfs@oss.sgi.com>; Wed, 19 Feb 2014 13:10:16 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1JLAFwB025224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 16:10:15 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1JLAEOx016232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 16:10:14 -0500
Message-ID: <53051DB5.4080403@redhat.com>
Date: Wed, 19 Feb 2014 15:10:13 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: fix sibling pointer tests in verify_dir2_path()
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

RH QE reported that if we create a 1G filesystem with default
options, mount it, and create inodes until full, then run
repair, repair reports corruption in verify_dir2_path() with:

> bad back pointer in block 8390324 for directory inode 131

The commit 88b32f0 xfs: add CRCs to dir2/da node blocks
had a small error which regressed this; although we switch
to the "newnode," to check sibling pointers, we re-populate
the node hdr with the old "node" data.  This causes the
backpointer test to be testing the wrong node's values.

Fixing this bug fixes the testcase.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dir2.c b/repair/dir2.c
index 3aabcaa..06dc000 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -552,7 +552,7 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 
 		newnode = bp->b_addr;
 		btree = xfs_da3_node_tree_p(newnode);
-		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		xfs_da3_node_hdr_from_disk(&nodehdr, newnode);
 		/*
 		 * verify magic number and back pointer, sanity-check
 		 * entry count, verify level

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
