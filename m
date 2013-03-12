Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 036407F63
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 09:50:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C1A008F804C
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:50:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zdveyW0cXkXqIibm for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 07:50:21 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5818163C59BB
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 09:50:21 -0500 (CDT)
Message-ID: <513F40AD.10303@sandeen.net>
Date: Tue, 12 Mar 2013 09:50:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: remove unconditional ASSERT(0)
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
To: xfs-oss <xfs@oss.sgi.com>

I don't know what I was thinking in 7e8e3cc, but I added an
ASSERT(0) in the main path.  Obviously this isn't right.

Just remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Really sorry, no idea what is up w/ my brain lately.
Trying to do too many things at once, too quickly.

diff --git a/repair/scan.c b/repair/scan.c
index 6a62dff..76bb7f1 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1076,8 +1076,7 @@ scan_freelist(
 				  "freelist scan\n"), i);
 			return;
 		}
-	} else /* should have been fixed in verify_set_agf() */
-		ASSERT(0);
+	}
 
 	count = 0;
 	for (;;) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
