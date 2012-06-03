Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q53BDFKh098405 for <xfs@oss.sgi.com>; Sun, 3 Jun 2012 06:13:15 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id BwsmFWK1Bnr9B1Gq
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jun 2012 04:13:14 -0700 (PDT)
Received: by dadg9 with SMTP id g9so5887495dad.26
	for <xfs@oss.sgi.com>; Sun, 03 Jun 2012 04:13:14 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH 3/3] XFS: Print error when there are no free AGs.
Date: Sun,  3 Jun 2012 16:42:49 +0530
Message-Id: <5038397a733a1759bf37699e7fca71ee53a47ca7.1338721614.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1338721614.git.rprabhu@wnohang.net>
References: <cover.1338721614.git.rprabhu@wnohang.net>
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
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, raghu.prabhu13@gmail.com

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

After looping through all the AGs and failing to find any with free inodes,
printk once about lack of AGs with free inodes.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_ialloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 343d7a8..b24ffa3 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -776,7 +776,11 @@ nextag:
 			tagno = 0;
 		if (tagno == agno) {
 			*inop = NULLFSINO;
-			return noroom ? ENOSPC : 0;
+			if (noroom) {
+				pr_err_once("XFS (%s): Out of AGs with free inodes: Required %d, Current %llu, Maximum %llu",
+						mp->m_fsname, XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
+				return 0;
+			}
 		}
 		pag = xfs_perag_get(mp, tagno);
 		if (pag->pagi_inodeok == 0) {
-- 
1.7.10.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
