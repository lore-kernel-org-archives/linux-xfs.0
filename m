Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbcKQXT0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 18:19:26 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6DF224E4CB
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2016 23:19:16 +0000 (UTC)
Received: from Liberator.example.com (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uAHNJF3l023948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2016 18:19:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: add alignment filter to freesp command
Message-ID: <1ed1ffd4-75e0-fa14-f812-b6ac4fd12987@redhat.com>
Date: Thu, 17 Nov 2016 17:19:15 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This adds an alignment filter to the xfs_db freesp command, i.e.

xfs_db> freesp -A 4

will show only 4-block aligned free extents.

This can be useful for finding freespace suitable for allocations
with specific alignment requirements, such as inode allocation.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/freesp.c b/db/freesp.c
index 27e9f5a..c3ca2f3 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -54,6 +54,7 @@ static int	usage(void);
 
 static int		agcount;
 static xfs_agnumber_t	*aglist;
+static int		alignment;
 static int		countflag;
 static int		dumpflag;
 static int		equalsize;
@@ -67,7 +68,7 @@ static long long	totexts;
 
 static const cmdinfo_t	freesp_cmd =
 	{ "freesp", NULL, freesp_f, 0, -1, 0,
-	  "[-bcdfs] [-a agno]... [-e binsize] [-h h1]... [-m binmult]",
+	  "[-bcdfs] [-A alignment] [-a agno]... [-e binsize] [-h h1]... [-m binmult]",
 	  "summarize free space for filesystem", NULL };
 
 static int
@@ -147,8 +148,11 @@ init(
 	totblocks = totexts = 0;
 	aglist = NULL;
 	hist = NULL;
-	while ((c = getopt(argc, argv, "a:bcde:h:m:s")) != EOF) {
+	while ((c = getopt(argc, argv, "A:a:bcde:h:m:s")) != EOF) {
 		switch (c) {
+		case 'A':
+			alignment = atoi(optarg);
+			break;
 		case 'a':
 			aglistadd(optarg);
 			break;
@@ -372,6 +376,9 @@ addtohist(
 {
 	int		i;
 
+	if (alignment && (XFS_AGB_TO_FSB(mp,agno,agbno) % alignment))
+		return;
+
 	if (dumpflag)
 		dbprintf("%8d %8d %8d\n", agno, agbno, len);
 	totexts++;
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 460d89d..2c89769 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -512,12 +512,17 @@ enables processing of realtime control file data.
 enables processing of realtime file data.
 .RE
 .TP
-.BI "freesp [\-bcds] [\-a " ag "] ... [\-e " i "] [\-h " h1 "] ... [\-m " m ]
+.BI "freesp [\-bcds] [\-A " alignment "] [\-a " ag "] ... [\-e " i "] [\-h " h1 "] ... [\-m " m ]
 Summarize free space for the filesystem. The free blocks are examined
 and totalled, and displayed in the form of a histogram, with a count
 of extents in each range of free extent sizes.
 .RS 1.0i
 .TP 0.4i
+.B \-A
+reports only free extents with starting blocks aligned to
+.I alignment
+blocks.
+.TP
 .B \-a
 adds
 .I ag

