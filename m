Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9BDE87F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 20:03:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 761EF8F806F
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:03:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NEQSqZhYX74AaYPF for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:03:22 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1Q23Mdx022748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 21:03:22 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1Q23LIF008762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 21:03:21 -0500
Message-ID: <530D4B68.9090905@redhat.com>
Date: Tue, 25 Feb 2014 20:03:20 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_copy: accept XFS_ABTB_CRC_MAGIC
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

xfs_copy needs a fair bit of work for CRCs because it rewrites
UUIDs by default, but this change will get it working properly
with the "-d" (duplicate) option which keeps the same UUID.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

However, I wonder if we should fail CRC filesystems outright
for now if -d isn't specified, because it will invalidate every
CRC and generally make a mess of things...

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 9986fbf..7c807a4 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -957,7 +957,9 @@ main(int argc, char **argv)
 				 ((char *)btree_buf.data +
 				  pos - btree_buf.position);
 
-			ASSERT(be32_to_cpu(block->bb_magic) == XFS_ABTB_MAGIC);
+			ASSERT(be32_to_cpu(block->bb_magic) == 
+				(xfs_sb_version_hascrc(&mp->m_sb) ?
+				 XFS_ABTB_CRC_MAGIC : XFS_ABTB_MAGIC));
 
 			if (be16_to_cpu(block->bb_level) == 0)
 				break;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
