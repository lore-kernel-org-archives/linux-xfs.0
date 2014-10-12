Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 49DB97F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 13:26:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3862E30404E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 11:26:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id agAmG89bvqfz7h3f for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 11:26:18 -0700 (PDT)
Message-ID: <543AC7C9.5040503@sandeen.net>
Date: Sun, 12 Oct 2014 13:26:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix agno increment in xfs_inumbers() loop
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
To: xfs-oss <xfs@oss.sgi.com>, Jie Liu <jeff.liu@oracle.com>

commit c7cb51d xfs: fix error handling at xfs_inumbers
caused a regression in xfs_inumbers, which in turn broke
xfsdump, causing incomplete dumps.

The loop in xfs_inumbers() needs to fill the user-supplied
buffers, and iterates via xfs_btree_increment, reading new
ags as needed.

But the first time through the loop, if xfs_btree_increment()
succeeds, we continue, which triggers the ++agno at the bottom
of the loop, and we skip to soon to the next ag - without
the proper setup under next_ag to read the next ag.

Fix this by removing the agno increment from the loop conditional,
and only increment agno if we have actually hit the code under
the next_ag: target.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. it's alarming that apparently no test in the dump group
detects this problem!  I'll look into it.

So I can say that I've tested this with xfstests, but I guess
that doesn't matter much, yet.

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f71be9c..f1deb96 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -639,7 +639,8 @@ next_ag:
 		xfs_buf_relse(agbp);
 		agbp = NULL;
 		agino = 0;
-	} while (++agno < mp->m_sb.sb_agcount);
+		agno++;
+	} while (agno < mp->m_sb.sb_agcount);
 
 	if (!error) {
 		if (bufidx) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
