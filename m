Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 96F097F37
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 18:07:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2510EAC002
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 16:07:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PGQPsOAedXh6YdCr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2016 16:07:35 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 61A316E772
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 00:07:34 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs.xfs.8: Clarify mkfs vs. mount block size limits.
Message-ID: <56A02144.9030206@redhat.com>
Date: Wed, 20 Jan 2016 18:07:32 -0600
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
To: xfs@oss.sgi.com, dwysocha@redhat.com

The current explanation is a bit vague to the uninitiated;
clarify the text to make it obvious that while the mkfs.xfs
utility is able to create valid filesystems with block sizes
up to 65536, the Linux kernel can only mount filesystems with
page sized or smaller blocks.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 1fe510b..980c7bc 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -126,7 +126,10 @@ or in bytes with
 .BR size= .
 The default value is 4096 bytes (4 KiB), the minimum is 512, and the
 maximum is 65536 (64 KiB).
-XFS on Linux currently only supports pagesize or smaller blocks.
+Although
+.B mkfs.xfs
+will accept any of these values and create a valid filesystem,
+XFS on Linux can only mount filesystems with pagesize or smaller blocks.
 .TP
 .BI \-m " global_metadata_options"
 These options specify metadata format options that either apply to the entire

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
