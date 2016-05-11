Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 432CF7CA1
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:41:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03FEC304039
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 12:41:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qJo5fcCkcLvBVjmU for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 12:41:29 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 2A06C2B18
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:41:29 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs_db: defang frag command
Message-ID: <2d21b9ba-6db7-e239-3be8-a7bd5e1c39cc@sandeen.net>
Date: Wed, 11 May 2016 14:41:28 -0500
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

Too many people freak out about this fictitious "fragmentation
factor."  As shown in the fact, it is largely meaningless, because
the number approaches 100% extremely quickly for just a few
extents per file.

I thought about removing it altogether, but perhaps a note
about its uselessness, and a more soothing metric (avg extents
per file) might be useful.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/frag.c b/db/frag.c
index 36bb689..e11b140 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -172,6 +172,10 @@ frag_f(
 		answer = 0.0;
 	dbprintf(_("actual %llu, ideal %llu, fragmentation factor %.2f%%\n"),
 		extcount_actual, extcount_ideal, answer);
+	dbprintf(_("Note, this number is largely meaningless.\n"));
+	answer = (double)extcount_actual / (double)extcount_ideal;
+	dbprintf(_("Files on this filesystem average %.2f extents per file\n"),
+		answer);
 	return 0;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
