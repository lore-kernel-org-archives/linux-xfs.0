Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o22K9PVk011132 for <xfs@oss.sgi.com>; Tue, 2 Mar 2010 14:09:25 -0600
Received: from vms173011pub.verizon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36CFA13EACAD
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 12:10:50 -0800 (PST)
Received: from vms173011pub.verizon.net (vms173011pub.verizon.net
	[206.46.173.11]) by cuda.sgi.com with ESMTP id UFroIFiUXRo3DYS0
	for <xfs@oss.sgi.com>; Tue, 02 Mar 2010 12:10:50 -0800 (PST)
Received: from [192.168.10.2] ([unknown] [98.114.168.230])
	by vms173011.mailsrvcs.net
	(Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16
	2009)) with ESMTPA id <0KYO00KGQ81M2SSC@vms173011.mailsrvcs.net> for
	xfs@oss.sgi.com; Tue, 02 Mar 2010 14:10:34 -0600 (CST)
Subject: Re: Proposed patch for xfsprogs
From: C Linus Hicks <linush@verizon.net>
In-reply-to: <1267454279.28691.45.camel@lh10.linush.net>
References: <1267311250.28691.40.camel@lh10.linush.net>
	<20100301031642.GG22370@discord.disaster>
	<1267454279.28691.45.camel@lh10.linush.net>
Date: Tue, 02 Mar 2010 15:10:33 -0500
Message-id: <1267560633.28691.67.camel@lh10.linush.net>
MIME-version: 1.0
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

This patch is for reducing the verbosity of the xfs_db "blockget"
command especially when using "-v" by listing only start and end block
numbers for a range, rather than listing all individual blocks. For a
sample 50gb filesystem with around 50% free space and about 20 corrupted
sectors, the logfile size drops from 900mb to 3mb.

Here's my fixed patch:

--- a/xfsprogs-3.1.1/db/check.c	2010-01-29 14:46:13.000000000 -0500
+++ b/xfsprogs-3.1.1/db/check.c	2010-03-01 17:47:01.000000000 -0500
@@ -1509,6 +1509,8 @@
 {
 	xfs_extlen_t	i;
 	int		mayprint;
+	int		pcnt = 0;
+	int		first_prnt = -1;
 	char		*p;
 
 	if (!check_range(agno, agbno, len))  {
@@ -1520,10 +1522,25 @@
 	mayprint = verbose | blist_size;
 	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
 		*p = (char)type2;
-		if (mayprint && (verbose || CHECK_BLISTA(agno, agbno + i)))
-			dbprintf(_("setting block %u/%u to %s\n"), agno, agbno + i,
-				typename[type2]);
+		if (mayprint && (verbose || CHECK_BLISTA(agno, agbno + i))) {
+			if (first_prnt == -1) {
+				dbprintf(_("setting block %u/%u to %s\n"),
+					 agno, agbno + i, typename[type2]);
+				first_prnt = i;
+			}
+			else if ((first_prnt + pcnt + 1) == i) {
+				pcnt++;
+			}
+			else {
+				dbprintf(_("    ... until %u/%u\n"),
+					agno, agbno + first_prnt + pcnt);
+				first_prnt = -1;
+				pcnt = 0;
+			}
+		}
 	}
+	if (pcnt > 0)
+		dbprintf(_("    ... until %u/%u\n"), agno, agbno + len - 1);
 }
 
 static void
@@ -4544,6 +4561,8 @@
 {
 	xfs_extlen_t	i;
 	inodata_t	**idp;
+	int		pcnt = 0;
+	int		first_prnt = -1;
 	int		mayprint;
 
 	if (!check_inomap(agno, agbno, len, id->ino))
@@ -4552,10 +4571,26 @@
 	for (i = 0, idp = &inomap[agno][agbno]; i < len; i++, idp++) {
 		*idp = id;
 		if (mayprint &&
-		    (verbose || id->ilist || CHECK_BLISTA(agno, agbno + i)))
-			dbprintf(_("setting inode to %lld for block %u/%u\n"),
-				id->ino, agno, agbno + i);
+		    (verbose || id->ilist || CHECK_BLISTA(agno, agbno + i))) {
+			if (first_prnt == -1) {
+				dbprintf(_("setting inode to %#llx for block "
+					   "%u/%u\n"),
+					id->ino, agno, agbno + i);
+				first_prnt = i;
+			}
+			else if ((first_prnt + pcnt + 1) == i) {
+				pcnt++;
+			}
+			else {
+				dbprintf(_("\t\t      ... until %u/%u\n"),
+					agno, agbno + first_prnt + pcnt);
+				first_prnt = -1;
+				pcnt = 0;
+			}
+		}
 	}
+	if (pcnt > 0)
+		dbprintf(_("\t\t      ... until %u/%u\n"), agno, agbno + len - 1);
 }
 
 static void
@@ -4575,6 +4610,8 @@
 {
 	xfs_extlen_t	i;
 	inodata_t	**idp;
+	int		pcnt = 0;
+	int		first_prnt = -1;
 	int		mayprint;
 
 	if (!check_rinomap(bno, len, id->ino))
@@ -4584,10 +4621,26 @@
 	     i < len;
 	     i++, idp++) {
 		*idp = id;
-		if (mayprint && (verbose || id->ilist || CHECK_BLIST(bno + i)))
-			dbprintf(_("setting inode to %lld for rtblock %llu\n"),
+		if (mayprint &&
+		    (verbose || id->ilist || CHECK_BLIST(bno + i))) {
+		    if (first_prnt == -1) {
+			dbprintf(_("setting inode to %#llx for rtblock %llu\n"),
 				id->ino, bno + i);
+			first_prnt = i;
+		    }
+		    else if ((first_prnt + pcnt + 1) == i) {
+			pcnt++;
+		    }
+		    else {
+			dbprintf(_("\t\t      ... until %llu\n"),
+				bno + first_prnt + pcnt);
+			first_prnt = -1;
+			pcnt = 0;
+		    }
+		}
 	}
+	if (pcnt > 0)
+		dbprintf(_("\t\t      ... until %llu\n"), bno + len - 1);
 }
 
 static void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
