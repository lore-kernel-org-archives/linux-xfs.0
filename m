Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA0D629DFB
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 16:00:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5300CAC016
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 14:00:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Jwy8D4MCFBqbdB1o for
	<linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 14:00:25 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8CL0OrI024226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 17:00:24 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8CL0Nda022252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 17:00:24 -0400
Message-ID: <52322B67.80305@redhat.com>
Date: Thu, 12 Sep 2013 16:00:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_check: fix test for too-high level in v2 dir node
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
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

The test as it stands allows level == XFS_DA_NODE_MAXDEPTH (5),
but a max depth of 5 equates to level values of 0 through 4.

Level 5 would be a depth of 6.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/check.c b/db/check.c
index cbe55ba..d9e3e3f 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3138,7 +3138,7 @@ process_leaf_node_dir_v2_int(
 	case XFS_DA_NODE_MAGIC:
 		node = iocur_top->data;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
-		if (nodehdr.level < 1 || nodehdr.level > XFS_DA_NODE_MAXDEPTH) {
+		if (nodehdr.level < 1 || nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
 			if (!sflag || v)
 				dbprintf(_("bad node block level %d for dir ino "
 					 "%lld block %d\n"),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
