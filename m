Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA971Cii083090 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 01:01:12 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OE3mJHQtIESmPZCX for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 23:03:10 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TWicG-0006Aq-0x
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 18:03:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TWicF-0003oI-Ts
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 18:02:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs_quota: fix report command parsing
Date: Fri,  9 Nov 2012 18:02:58 +1100
Message-Id: <1352444578-14600-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1352444578-14600-1-git-send-email-david@fromorbit.com>
References: <1352444578-14600-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The report command line needs to be parsed as a whole not as
individual elements - report_f() is set up to do this correctly.
When treated as non-global command line, the report function is
called once for each command line arg, resulting in reports being
issued multiple times.

Set the command to be a global command so that it is only called
once.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 quota/report.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/quota/report.c b/quota/report.c
index a1e165b..70894a2 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -653,6 +653,7 @@ report_init(void)
 	report_cmd.cfunc = report_f;
 	report_cmd.argmin = 0;
 	report_cmd.argmax = -1;
+	report_cmd.flags = CMD_FLAG_GLOBAL;
 	report_cmd.args = _("[-bir] [-gpu] [-ahnt] [-f file]");
 	report_cmd.oneline = _("report filesystem quota information");
 	report_cmd.help = report_help;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
