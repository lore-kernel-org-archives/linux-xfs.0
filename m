Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 565807F37
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1DB83304039
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:01 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	05HEJkjDnKM9l8J2 for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:43:58 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Ia-MI
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002e5-LR
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/15] mkfs: sanitise ftype parameter values.
Date: Fri, 29 Nov 2013 12:43:37 +1100
Message-Id: <1385689430-10103-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1385689430-10103-1-git-send-email-david@fromorbit.com>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Because passing "-n ftype=2" should fail.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cc74535..3145205 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1550,12 +1550,15 @@ _("cannot specify both crc and ftype\n"));
 						reqval('n', nopts, N_FTYPE);
 					if (nftype)
 						respec('n', nopts, N_FTYPE);
-					dirftype = atoi(value);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "n ftype");
 					if (crcs_enabled) {
 						fprintf(stderr,
 _("cannot specify both crc and ftype\n"));
 						usage();
 					}
+					dirftype = c;
 					nftype = 1;
 					break;
 				default:
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
