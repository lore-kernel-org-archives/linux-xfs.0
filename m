Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4NKZZSk022428 for <xfs@oss.sgi.com>; Mon, 23 May 2011 15:35:36 -0500
Received: from e38.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 790FA1656007
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 13:35:17 -0700 (PDT)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id qFTDLzQXt2gzmv9a for
	<xfs@oss.sgi.com>; Mon, 23 May 2011 13:35:17 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4NKR6sD006497
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:27:06 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4NKaVZq095158 for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:36:32 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p4NKZ9SQ001988
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:35:09 -0600
Message-ID: <4DDAC4F2.9090909@linux.vnet.ibm.com>
Date: Mon, 23 May 2011 13:34:58 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: Fix for xfstest 252 hang on ext4
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
To: xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>

Xfstests 252 hangs on ext4 due to a loop in xfsprogs that does not exit.  

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 fa990cc... 81fc92c... M	io/fiemap.c
 io/fiemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index fa990cc..81fc92c 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -246,7 +246,7 @@ fiemap_f(
 		       flg_w, _("FLAGS"));
 	}
 
-	while (!last && ((cur_extent + 1) != max_extents)) {
+	while (!last && (cur_extent <= max_extents)) {
 		if (max_extents)
 			num_extents = min(num_extents,
 					  max_extents - (cur_extent + 1));
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
