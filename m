Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A75897F50
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 14:38:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 817C3304064
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:38:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gtmpyfeJtWiSKu2k for
	<xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:38:10 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAEKcAl7018804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 15:38:10 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id rAEKc8OD006121
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 15:38:10 -0500
Message-ID: <528534B0.8070709@redhat.com>
Date: Thu, 14 Nov 2013 14:38:08 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: correct docs for "-t" units
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
To: xfs-oss <xfs@oss.sgi.com>

usage() says that the xfs_repair -t reporting interval is
in minutes, and the manpage says nothing at all about units.

Actually, it's in seconds.

Clarify in both places that the interval is specified in
seconds.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 47436ec..ed20fb7 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -152,7 +152,7 @@ in no modify mode first.
 .RE
 .TP
 .B \-t " interval"
-Modify reporting interval. During long runs
+Modify reporting interval, specified in seconds. During long runs
 .B xfs_repair
 outputs its progress every 15 minutes. Reporting is only activated when
 ag_stride is enabled.
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index a863337..7beffcb 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -90,7 +90,7 @@ usage(void)
 "  -v           Verbose output.\n"
 "  -c subopts   Change filesystem parameters - use xfs_admin.\n"
 "  -o subopts   Override default behaviour, refer to man page.\n"
-"  -t interval  Reporting interval in minutes.\n"
+"  -t interval  Reporting interval in seconds.\n"
 "  -d           Repair dangerously.\n"
 "  -V           Reports version and exits.\n"), progname);
 	exit(1);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
