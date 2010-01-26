Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0Q3OM8K096432 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 21:24:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16A571C62635
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 19:25:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	FhNwglht76BgAxw5 for <xfs@oss.sgi.com>;
	Mon, 25 Jan 2010 19:25:24 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11731313-1927428
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2010 13:55:23 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NZc3O-00047w-9F
	for xfs@oss.sgi.com; Tue, 26 Jan 2010 14:25:22 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NZc3C-0004zK-Qb
	for xfs@oss.sgi.com; Tue, 26 Jan 2010 14:25:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsprogs: clean up .dep files on make clean
Date: Tue, 26 Jan 2010 14:25:10 +1100
Message-Id: <1264476310-19127-1-git-send-email-david@fromorbit.com>
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

And make git ignore them, too.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 .gitignore         |    1 +
 include/buildrules |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/.gitignore b/.gitignore
index b06e074..aa6cd35 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,5 +1,6 @@
 # object files
 *.o
+.dep
 
 # build system
 .census
diff --git a/include/buildrules b/include/buildrules
index d1a3a6f..1695e23 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -7,7 +7,7 @@ _BUILDRULES_INCLUDED_ = 1
 include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
-	@rm -f $(DIRT)
+	@rm -f $(DIRT) .dep
 	@rm -fr $(DIRDIRT)
 %-clean:
 	@echo "Cleaning $*"
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
