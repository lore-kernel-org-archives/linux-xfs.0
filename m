Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3bKID235622 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:37:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAD5817746C
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:38:19 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	RgUiHSjLT7n0ymec for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 19:38:19 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11651452-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:08:17 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXROY-00053E-6K
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXROX-00008L-3b
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfstests: Don't use tempnam in growfiles.c
Date: Wed, 20 Jan 2010 14:38:03 +1100
Message-Id: <1263958688-435-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263958688-435-1-git-send-email-david@fromorbit.com>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
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

tempnam() generates a compiler warning as a dangerous function.
This code doesn't care about security issues with tempnam, so
remove it and just manually build the filenames without the
randomness of tempnam.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 ltp/growfiles.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/ltp/growfiles.c b/ltp/growfiles.c
index a987b5a..52c9079 100644
--- a/ltp/growfiles.c
+++ b/ltp/growfiles.c
@@ -1162,10 +1162,9 @@ no whole file checking will be performed!\n", Progname, TagName, (int)getpid());
 	/*
 	 * construct auto filename and insert them into filenames space
 	 */
-		
 	for(ind=0;ind<num_auto_files; ind++, num++) {
-		sprintf((char *)filenames+(num*PATH_MAX), "%s.%d",
-			tempnam(auto_dir, auto_file), ind );
+		sprintf((char *)filenames+(num*PATH_MAX), "%s/%s.%d",
+			auto_dir, auto_file, ind);
 	}
 
 	/*
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
