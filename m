Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67B8B7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 06:29:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05DA8AC004
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 04:29:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pP5thgR2GxNhfMav for
	<xfs@oss.sgi.com>; Fri, 26 Apr 2013 04:29:26 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3QBTPn1015933
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 07:29:25 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r3QBTPsu014578
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 07:29:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/2] xfs: enhance warning on xfs_imap() failure in
	xfs_iunlink_remove()
Date: Fri, 26 Apr 2013 07:30:13 -0400
Message-Id: <1366975813-65025-1-git-send-email-bfoster@redhat.com>
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

From: Eric Sandeen <sandeen@redhat.com>

Include the global ino, ag number and agino in the warning message
emitted should xfs_imap() fail in the xfs_iunlink_remove() code
path.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
v2: Fix up indendation such that the string is on a single line.

 fs/xfs/xfs_inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c22f980..f00c6d1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1678,8 +1678,10 @@ xfs_iunlink_remove(
 			error = xfs_imap(mp, tp, next_ino, &imap, 0);
 			if (error) {
 				xfs_warn(mp,
-	"%s: xfs_imap returned error %d.",
-					 __func__, error);
+	"%s: xfs_imap() returned error %d for inode 0x%llx ag %d agino 0x%x",
+					 __func__, error, ip->i_ino,
+					 agno, agino);
+
 				return error;
 			}
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
