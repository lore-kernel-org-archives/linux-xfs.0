Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 098077CBF
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:25:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DDB1E3040A4
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 19:25:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bElCkeeSsQalXBXs for <linux-xfs@oss.sgi.com>;
	Wed, 31 Jul 2013 19:25:20 -0700 (PDT)
Received: from Liberator.local (c-98-240-249-49.hsd1.mn.comcast.net
	[98.240.249.49])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9D649609D8D8
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:25:19 -0500 (CDT)
Message-ID: <51F9C70E.30702@sandeen.net>
Date: Wed, 31 Jul 2013 21:25:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix agcnts leak in xfs_repair's scan_ags
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

agcnts is malloc'd but never freed in this function.

Coverity found this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/scan.c b/repair/scan.c
index 76bb7f1..4040f53 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1367,6 +1367,8 @@ scan_ags(
 		ifreecount += agcnts[i].ifreecount;
 	}
 
+	free(agcnts);
+
 	/*
 	 * Validate that our manual counts match the superblock.
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
