Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3581329DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 10:40:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF5B8AC00B
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:40:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ep8GKd409R8hJECo for
	<xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:40:42 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PFef9h001412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:40:41 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r3PFefw9023265
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:40:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: enhance warning on xfs_imap() failure in
	xfs_iunlink_remove()
Date: Thu, 25 Apr 2013 11:41:30 -0400
Message-Id: <1366904490-46821-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1366904490-46821-1-git-send-email-bfoster@redhat.com>
References: <1366904490-46821-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c22f980..a4fe989 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1678,8 +1678,10 @@ xfs_iunlink_remove(
 			error = xfs_imap(mp, tp, next_ino, &imap, 0);
 			if (error) {
 				xfs_warn(mp,
-	"%s: xfs_imap returned error %d.",
-					 __func__, error);
+					"%s: xfs_imap() returned error %d "
+					"for inode 0x%llx ag %d agino 0x%x",
+					__func__, error, ip->i_ino, agno, agino);
+
 				return error;
 			}
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
