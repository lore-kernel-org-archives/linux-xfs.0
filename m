Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0a6Pn142252 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:36:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8D821C5C7D1
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:37:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	oijt6dqeIrj9Vx8e for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:37:04 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11645729-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:07:03 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX25e-0003Eh-5C
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:02 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX25d-0003aY-HH
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] xfsprogs: fix print format warnings in xfs_io
Date: Tue, 19 Jan 2010 11:36:51 +1100
Message-Id: <1263861413-13729-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861413-13729-1-git-send-email-david@fromorbit.com>
References: <1263861413-13729-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/madvise.c |    2 +-
 io/mincore.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/madvise.c b/io/madvise.c
index cd16a4c..3235402 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -96,7 +96,7 @@ madvise_f(
 			return 0;
 		} else if (llength > (size_t)llength) {
 			printf(_("length argument too large -- %lld\n"),
-				llength);
+				(long long)llength);
 			return 0;
 		} else
 			length = (size_t)llength;
diff --git a/io/mincore.c b/io/mincore.c
index d534540..60625ef 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -56,7 +56,7 @@ mincore_f(
 			return 0;
 		} else if (llength > (size_t)llength) {
 			printf(_("length argument too large -- %lld\n"),
-				llength);
+				(long long)llength);
 			return 0;
 		} else
 			length = (size_t)llength;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
