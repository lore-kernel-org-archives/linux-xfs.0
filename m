Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9J1LwwB225544 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 20:21:59 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id 5lXDBxVAKy8rCydz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Oct 2012 18:23:37 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id DD34233D891
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 01:23:36 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] xfs_fsr: fix space/tab mixing in help string
Date: Thu, 18 Oct 2012 21:23:39 -0400
Message-Id: <1350609819-14770-1-git-send-email-vapier@gentoo.org>
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

Minor issue -- some tabs slipped into the help string throwing the
output off slightly.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 fsr/xfs_fsr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 2db2224..b1e279e 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -391,14 +391,14 @@ usage(int ret)
 "Options:\n"
 "       -n              Do nothing, only interesting with -v. Not\n"
 "                       effective with in mtab mode.\n"
-"       -s		Print statistics only.\n"
+"       -s              Print statistics only.\n"
 "       -g              Print to syslog (default if stdout not a tty).\n"
 "       -t time         How long to run in seconds.\n"
-"       -p passes	Number of passes before terminating global re-org.\n"
+"       -p passes       Number of passes before terminating global re-org.\n"
 "       -f leftoff      Use this instead of %s.\n"
 "       -m mtab         Use something other than /etc/mtab.\n"
 "       -d              Debug, print even more.\n"
-"       -v		Verbose, more -v's more verbose.\n"
+"       -v              Verbose, more -v's more verbose.\n"
 		), progname, progname, _PATH_FSRLAST);
 	exit(ret);
 }
-- 
1.7.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
