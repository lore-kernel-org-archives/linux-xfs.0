Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A67D87F56
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 13:09:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8228A304059
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 11:09:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id s1lDxH9OokEtSqWd for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 11:09:21 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 494AD61D1A43
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 13:09:21 -0500 (CDT)
Message-ID: <55D617D1.7070405@sandeen.net>
Date: Thu, 20 Aug 2015 13:09:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/4] xfs_repair: free msgbuf on exit
References: <55D61740.9070507@sandeen.net>
In-Reply-To: <55D61740.9070507@sandeen.net>
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

Just to keep valgrind less noisy, and make it easiser to spot
more things that actually matter ...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/xfs_repair.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index db703d0..85a012b 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -946,5 +946,7 @@ _("Repair of readonly mount complete.  Immediate reboot encouraged.\n"));
 
 	pftrace_done();
 
+	free(msgbuf);
+
 	return (0);
 }
-- 1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
