Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 113527CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 10:51:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D620E304051
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 08:51:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id L2JNGv5kuqgWnkzF for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2016 08:51:13 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D2D1C481A
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 10:51:12 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs_metadump: don't warn about unobfuscated log with -o
Message-ID: <541974d2-5877-a7ef-af3c-7d1a47e227c0@sandeen.net>
Date: Thu, 4 Aug 2016 10:51:12 -0500
MIME-Version: 1.0
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

It makes no sense to warn about un-obfuscated logs
when we asked xfs_metadump to not obfuscate metadata:

# xfs_metadump -o /dev/loop2 bad.metadump
xfs_metadump: Filesystem log is dirty; image will contain unobfuscated metadata in log.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/metadump.c b/db/metadump.c
index d7ff6e5..01a51c4 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2575,12 +2575,14 @@ copy_log(void)
 		break;
 	case 1:
 		/* keep the dirty log */
-		print_warning(
+		if (obfuscate)
+			print_warning(
 _("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
 		break;
 	case -1:
 		/* log detection error */
-		print_warning(
+		if (obfuscate)
+			print_warning(
 _("Could not discern log; image will contain unobfuscated metadata in log."));
 		break;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
