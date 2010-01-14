Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EACicM250452 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 04:12:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 385DC165517
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:13:40 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	83lbDx8WtrUSUIOp for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 02:13:40 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11528819-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:43:39 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVMhj-0007ra-UZ
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:13:27 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVMdg-0001LW-Go
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:09:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfsprogs: fix sign warning in mkfs directory code
Date: Thu, 14 Jan 2010 21:09:11 +1100
Message-Id: <1263463752-5052-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1263463752-5052-1-git-send-email-david@fromorbit.com>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 mkfs/proto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 8fc8c4c..3723685 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -432,7 +432,7 @@ parseproto(
 	mode |= val;
 	creds.cr_uid = (int)getnum(pp);
 	creds.cr_gid = (int)getnum(pp);
-	xname.name = name;
+	xname.name = (uchar_t *)name;
 	xname.len = name ? strlen(name) : 0;
 	tp = libxfs_trans_alloc(mp, 0);
 	flags = XFS_ILOG_CORE;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
