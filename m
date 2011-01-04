Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p046Aq8w190589 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 00:10:52 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A5AD161ABA0
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 22:12:58 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	YNGsxSlTdI2mPGA7 for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 22:12:58 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	6472723-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 16:42:57 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Pa08T-0000dT-NF
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 17:12:45 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pa08R-0004T9-Eg
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 17:12:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] repair: warn if running in low memory mode
Date: Tue,  4 Jan 2011 17:12:43 +1100
Message-Id: <1294121563-17150-1-git-send-email-david@fromorbit.com>
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

When checking large filesystems, xfs_repair makes an estimate of how
much RAM it will need to execute effectively. If the amount of RAM
is less than this, it reduces the bhash size and turns of
prefetching, which will substantially slow down the repair process.
Add a warning that indicates this is happening, along with a
recommendation of how much RAM repair calculates it needs to run
with prefetching enabled.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/xfs_repair.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e36eeae..eea1b34 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -650,12 +650,20 @@ main(int argc, char **argv)
 			 * Turn off prefetch and minimise libxfs cache if
 			 * physical memory is deemed insufficient
 			 */
-			if (max_mem_specified)
+			if (max_mem_specified) {
 				do_abort(_("Required memory for repair is "
 					"greater that the maximum specified "
 					"with the -m option. Please increase "
 					"it to at least %lu.\n"),
 					mem_used / 1024);
+			} else {
+				do_warn(_("Not enough RAM available for repair "
+					"to enable prefetching. This will be "
+					"_slow_.\n"
+					"You need at least %luMB RAM to run "
+					"with prefetching enabled."),
+					mem_used * 1280 / (1024 * 1024));
+			}
 			do_prefetch = 0;
 			libxfs_bhash_size = 64;
 		} else {
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
