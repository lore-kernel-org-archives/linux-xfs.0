Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECE427F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 12:30:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C92F88F8068
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 10:30:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xG8jicOtRypQX7VK for
	<xfs@oss.sgi.com>; Fri, 22 Feb 2013 10:30:38 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1MIUYUq025294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 13:30:35 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r1MIUP4Y008377
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 13:30:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix potential infinite loop in xfs_iomap_prealloc_size()
Date: Fri, 22 Feb 2013 13:32:56 -0500
Message-Id: <1361557976-54981-1-git-send-email-bfoster@redhat.com>
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

If freesp == 0, we could end up in an infinite loop while squashing
the preallocation. Break the loop when we've killed the prealloc
entirely.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
Hi all,

Mark caught this while reviewing the quota throttling patchset. I figured
it better that my set depend on this rather than vice versa, so I'll plan on a
v5 for at least a rebase, but I'll wait a bit for further comments on v4.

Brian

 fs/xfs/xfs_iomap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 912d83d..b0b0f44 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -413,7 +413,7 @@ xfs_iomap_prealloc_size(
 		 * have a large file on a small filesystem and the above
 		 * lowspace thresholds are smaller than MAXEXTLEN.
 		 */
-		while (alloc_blocks >= freesp)
+		while (alloc_blocks && alloc_blocks >= freesp)
 			alloc_blocks >>= 4;
 	}
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
