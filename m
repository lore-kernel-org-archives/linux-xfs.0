Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B9897F4C
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 11:47:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8FA630406A
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 09:47:33 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id m5aAxdgug5BvoSFe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 09:47:33 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 17 Apr 2013 12:47:32 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 1B63AC9001D
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 12:47:29 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3HGlTGK259104 for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 12:47:29 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r3HGlSOV010025 for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 13:47:28 -0300
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r3HGlSa3009978 for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 13:47:28 -0300
Subject: [PATCH] xfsprogs: Add depraction message for xfs_check
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 17 Apr 2013 11:47:24 -0500
Message-ID: <1366217244.3762.32327.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS mailing list <xfs@oss.sgi.com>

Add deprecation message for xfs_check and suggest to use xfs_repair -n
instead.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
diff --git a/db/xfs_check.sh b/db/xfs_check.sh
index c76b540..553da63 100755
--- a/db/xfs_check.sh
+++ b/db/xfs_check.sh
@@ -7,6 +7,9 @@ OPTS=" "
 DBOPTS=" "
 USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
 
+echo "xfs_check is deprecated and scheduled for removal in June 2014."
+echo "Please use xfs_repair -n <dev> instead."
+
 while getopts "b:fi:l:stvV" c
 do
 	case $c in
diff --git a/man/man8/xfs_check.8 b/man/man8/xfs_check.8
index 620d0fc..1654532 100644
--- a/man/man8/xfs_check.8
+++ b/man/man8/xfs_check.8
@@ -35,11 +35,11 @@ during the execution of
 .BR xfs_check .
 Otherwise, spurious problems are reported.
 .PP
-Note that using
+Note that
 .B xfs_check
-is NOT recommended. Please use 
+is deprecated and scheduled for removal in June 2014. Please use
 .BR xfs_repair " " \-n
-instead, for better scalability and speed.
+instead.
 .SH
 OPTIONS
 .TP


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
