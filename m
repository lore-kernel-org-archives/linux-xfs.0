Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC38529DFA
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 14:26:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B19648F8054
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 12:26:17 -0700 (PDT)
Received: from mail-ve0-f169.google.com (mail-ve0-f169.google.com
	[209.85.128.169]) by cuda.sgi.com with ESMTP id
	kN0zvi9fervWZPkI (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 12:26:16 -0700 (PDT)
Received: by mail-ve0-f169.google.com with SMTP id m1so8008789ves.14
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 12:26:16 -0700 (PDT)
Received: from [192.168.0.129] (rrcs-97-78-60-146.se.biz.rr.com.
	[97.78.60.146])
	by mx.google.com with ESMTPSA id tf2sm17278156veb.8.2013.06.13.12.26.15
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Thu, 13 Jun 2013 12:26:15 -0700 (PDT)
Message-ID: <51BA1CD2.5070306@gmail.com>
Date: Thu, 13 Jun 2013 15:26:10 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: Correct spelling error in xfs_db for CRC
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

Hi!  This is a simple spelling fix made for the xfsprogs crc-dev 
branch, in case it hasn't been fixed already.

Thanks!

Michael

>From 68dad8f59987198abe34c9ae5ea48ac6af532819 Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Wed, 12 Jun 2013 17:27:44 -0400
Subject: [PATCH] xfsprogs: Correct spelling error in xfs_db for CRC
 filesystems

Change "thi version" to "this version".

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 db/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/init.c b/db/init.c
index 2932e51..77be286 100644
--- a/db/init.c
+++ b/db/init.c
@@ -141,7 +141,7 @@ init(
 	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5 &&
 	    !(x.isreadonly & LIBXFS_ISREADONLY)) {
 		fprintf(stderr, 
-	_("%s: modifications to %s are not supported in thi version.\n"
+	_("%s: modifications to %s are not supported in this version.\n"
 	"Use \"-r\" to run %s in read-only mode on this filesystem .\n"),
 			progname, fsdevice, progname);
 		if (!force)
-- 
1.8.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
