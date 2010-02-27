Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1RMqktv039216 for <xfs@oss.sgi.com>; Sat, 27 Feb 2010 16:52:47 -0600
Received: from elasmtp-banded.atl.sa.earthlink.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE45B1FE78F
	for <xfs@oss.sgi.com>; Sat, 27 Feb 2010 14:54:11 -0800 (PST)
Received: from elasmtp-banded.atl.sa.earthlink.net
	(elasmtp-banded.atl.sa.earthlink.net [209.86.89.70]) by
	cuda.sgi.com with ESMTP id svHawkgBDi67QoxO for
	<xfs@oss.sgi.com>; Sat, 27 Feb 2010 14:54:11 -0800 (PST)
Received: from [98.114.168.230] (helo=[192.168.10.2])
	by elasmtp-banded.atl.sa.earthlink.net with esmtpsa
	(TLSv1:AES256-SHA:256) (Exim 4.67)
	(envelope-from <linush@mindspring.com>) id 1NlVY2-0003nd-Qo
	for xfs@oss.sgi.com; Sat, 27 Feb 2010 17:54:10 -0500
Subject: Proposed patch for xfsprogs
From: "C. Linus Hicks" <linush@mindspring.com>
Date: Sat, 27 Feb 2010 17:54:10 -0500
Message-Id: <1267311250.28691.40.camel@lh10.linush.net>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

During my recent experience with having to reconstruct parts of an XFS
filesystem that got corrupted as a result of several bad blocks, I found
that some of the information displayed using "blockget -v" was pretty
useless, and I am proposing the following code change to introduce a
slight summarization.

Repeating lines of "setting block <foo> to <bar>" and "setting inode to
<foo> for {,rt}block <bar>" will be summarized down to two lines.



--- a/xfsprogs-3.1.1/db/check.c	2010-01-29 14:46:13.000000000 -0500
+++ b/xfsprogs-3.1.1/db/check.c	2010-02-27 17:02:14.111418960 -0500
@@ -1509,6 +1509,7 @@
 {
 	xfs_extlen_t	i;
 	int		mayprint;
+	int		isfirst = 1;
 	char		*p;
 
 	if (!check_range(agno, agbno, len))  {
@@ -1520,10 +1521,15 @@
 	mayprint = verbose | blist_size;
 	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
 		*p = (char)type2;
-		if (mayprint && (verbose || CHECK_BLISTA(agno, agbno + i)))
+		if (isfirst && mayprint && (verbose || CHECK_BLISTA(agno, agbno + i))) {
 			dbprintf(_("setting block %u/%u to %s\n"), agno, agbno + i,
 				typename[type2]);
+			isfirst = 0;
+		}
 	}
+	if ((len > 1) && mayprint && (verbose || CHECK_BLISTA(agno, agbno + i)))
+		dbprintf(_("    ... until %u/%u\n"),
+				agno, agbno + len - 1);
 }
 
 static void
@@ -4544,6 +4550,7 @@
 {
 	xfs_extlen_t	i;
 	inodata_t	**idp;
+	int		isfirst = 1;
 	int		mayprint;
 
 	if (!check_inomap(agno, agbno, len, id->ino))
@@ -4551,11 +4558,16 @@
 	mayprint = verbose | id->ilist | blist_size;
 	for (i = 0, idp = &inomap[agno][agbno]; i < len; i++, idp++) {
 		*idp = id;
-		if (mayprint &&
-		    (verbose || id->ilist || CHECK_BLISTA(agno, agbno + i)))
+		if (isfirst && mayprint &&
+		    (verbose || id->ilist || CHECK_BLISTA(agno, agbno + i))) {
 			dbprintf(_("setting inode to %lld for block %u/%u\n"),
 				id->ino, agno, agbno + i);
+			isfirst = 0;
+		}
 	}
+	if ((len > 1) && mayprint && 
+	    (verbose || id->ilist || CHECK_BLISTA(agno, agbno + i)))
+		dbprintf(_("\t\t      ... until %u/%u\n"), agno, agbno + len - 1);
 }
 
 static void
@@ -4575,6 +4587,7 @@
 {
 	xfs_extlen_t	i;
 	inodata_t	**idp;
+	int		isfirst = 1;
 	int		mayprint;
 
 	if (!check_rinomap(bno, len, id->ino))
@@ -4584,10 +4597,16 @@
 	     i < len;
 	     i++, idp++) {
 		*idp = id;
-		if (mayprint && (verbose || id->ilist || CHECK_BLIST(bno + i)))
+		if (isfirst && mayprint &&
+		    (verbose || id->ilist || CHECK_BLIST(bno + i))) {
 			dbprintf(_("setting inode to %lld for rtblock %llu\n"),
 				id->ino, bno + i);
+			isfirst = 0;
+		}
 	}
+	if ((len > 1) && mayprint &&
+	    (verbose || id->ilist || CHECK_BLIST(bno + i)))
+		dbprintf(_("\t\t      ... until %llu\n"), bno + len - 1);
 }
 
 static void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
