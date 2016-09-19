Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F0EC7CA1
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 08:26:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 701CD304039
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 06:26:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8hy2GAcDhWg1S3tR for <xfs@oss.sgi.com>;
	Mon, 19 Sep 2016 06:26:52 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7FE6351C06B
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 08:26:36 -0500 (CDT)
Subject: [PATCH V2] mkfs.xfs: clarify ftype defaults in manpage
References: <1f98ea1d-893c-d1c0-2307-3f5a9b478238@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5a728f87-665a-1b1a-84b5-ab420cfa4250@sandeen.net>
Date: Mon, 19 Sep 2016 08:26:51 -0500
MIME-Version: 1.0
In-Reply-To: <1f98ea1d-893c-d1c0-2307-3f5a9b478238@redhat.com>
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
To: xfs@oss.sgi.com

When CRCs were made default, a few leftovers related to its
prior non-default status remained in the manpage, in the ftype
section.  Clean those up, stating the correct default for this
feature.

Reported-by: Chris Murphy <chris@cmurf.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: reflect reality regarding defaults, sorry about that.

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 9578c4d..c44b3bd 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -636,13 +636,11 @@ do not need to look up the inode to determine the inode type.
 
 The
 .I value
-is either 0 or 1, with 1 signifiying that filetype information
-will be stored in the directory structure. The default value is 0.
+is either 0 or 1, with 1 signifying that filetype information
+will be stored in the directory structure.  The default value is 1.
 
-When CRCs are enabled via
-.B \-m crc=1,
-the ftype functionality is always enabled. This feature can not be turned
-off for such filesystem configurations.
+When CRCs are enabled (the default), the ftype functionality is always
+enabled, and cannot be turned off.
 .IP
 .RE
 .TP


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
