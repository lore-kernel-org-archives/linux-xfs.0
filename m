Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B761A7F47
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 14:03:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42740AC002
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 12:03:34 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0236.hostedemail.com
	[216.40.44.236]) by cuda.sgi.com with ESMTP id Ctw2p1Krru3eQCZN
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 12:03:30 -0700 (PDT)
Message-ID: <1427051007.27543.21.camel@perches.com>
Subject: [PATCH] xfs: Fix incorrect positive ENOMEM return
From: Joe Perches <joe@perches.com>
Date: Sun, 22 Mar 2015 12:03:27 -0700
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

commit 5681ca40064f ("xfs: Remove icsb infrastructure")
incorrectly added a positive error return value.

This value filters up through the return layers
and should be negative as the other return values
are in the same function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3ad0b17..8782b36 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1380,7 +1380,7 @@ xfs_init_percpu_counters(
 
 	error = percpu_counter_init(&mp->m_icount, 0, GFP_KERNEL);
 	if (error)
-		return ENOMEM;
+		return -ENOMEM;
 
 	error = percpu_counter_init(&mp->m_ifree, 0, GFP_KERNEL);
 	if (error)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
