Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6TER9HM257845 for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 09:27:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 963D610DAA9F
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 07:36:46 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id BQLOHNJwWgkFPfYl for
	<xfs@oss.sgi.com>; Wed, 29 Jul 2009 07:36:46 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 1A245A9BF27
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 09:27:55 -0500 (CDT)
Message-ID: <4A705C6A.5010603@sandeen.net>
Date: Wed, 29 Jul 2009 09:27:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH (trivial)] xfs_db: remove "-f" option from freesp usage()
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
To: xfs-oss <xfs@oss.sgi.com>

the freesp doesn't support "-f" so take it out of the usage().

The manpage is fine; usage() is the only reference to "-f"

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/db/freesp.c b/db/freesp.c
index 51ce810..e1902c6 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -196,7 +196,7 @@ init(
 static int
 usage(void)
 {
-	dbprintf(_("freesp arguments: [-bcdfs] [-a agno] [-e binsize] [-h h1]... "
+	dbprintf(_("freesp arguments: [-bcds] [-a agno] [-e binsize] [-h h1]... "
 		 "[-m binmult]\n"));
 	return 0;
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
