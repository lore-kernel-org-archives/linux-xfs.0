Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C006C7F50
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 02:01:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 547F4AC004
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 00:01:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CVCzGzNjewkOs19W (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 00:01:24 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id AA1C8AB0
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 07:01:23 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] repair: fix wrong logic when validating node magic number
Date: Thu, 13 Aug 2015 15:01:16 +0800
Message-Id: <1439449276-1699-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

Magic number is wrong only when != XFS_DA_NODE_MAGIC and
!= XFS_DA3_NODE_MAGIC.

This is triggered by shared/002 when testing 512 block size XFS.

  Phase 1 - find and verify superblock...
  Phase 2 - using internal log
          - scan filesystem freespace and inode maps...
          - found root inode chunk
  Phase 3 - for each AG...
          - scan (but don't clear) agi unlinked lists...
          - process known inodes and perform inode discovery...
          - agno = 0
  bad magic number febe in block 64 (108) for directory inode 35
  ......

Fix it by changing "||" to "&&".

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 repair/attr_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 62f80e7..83a07a8 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -570,7 +570,7 @@ verify_da_path(xfs_mount_t	*mp,
 		 * entry count, verify level
 		 */
 		bad = 0;
-		if (nodehdr.magic != XFS_DA_NODE_MAGIC ||
+		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
 		    nodehdr.magic != XFS_DA3_NODE_MAGIC)  {
 			do_warn(
 	_("bad magic number %x in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
