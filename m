Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 002017CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 21:47:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77EB1AC001
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 19:47:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vC2ZceQFqxBjLSRR for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 19:47:46 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 318A92B2E
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 21:47:46 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] mkfs.xfs: annotate fallthrough cases in cvtnum
Message-ID: <51117671-6856-0fb7-d86e-0fdf6a29b5e5@sandeen.net>
Date: Wed, 11 May 2016 21:47:45 -0500
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

We should really collapse our 3 cvtnum variants,
but for now at least shut up Coverity about this
intentional case fallthrough.

Addresses-Coverity-ID: 1361553
Addresses-Coverity-ID: 1361554
Addresses-Coverity-ID: 1361555
Addresses-Coverity-ID: 1361556
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 955dcfd..12fe8f3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3623,14 +3623,19 @@ cvtnum(
 	switch (c) {
 	case 'e':
 		i *= 1024LL;
+		/* fall through */
 	case 'p':
 		i *= 1024LL;
+		/* fall through */
 	case 't':
 		i *= 1024LL;
+		/* fall through */
 	case 'g':
 		i *= 1024LL;
+		/* fall through */
 	case 'm':
 		i *= 1024LL;
+		/* fall through */
 	case 'k':
 		return i * 1024LL;
 	default:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
