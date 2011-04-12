Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3CDUt6x152883 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 08:30:55 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E58291E0575E
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 06:34:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3lU12SpvG9GYDbpq for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2011 06:34:14 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q9djQ-0000Jw-Gq
	for xfs@oss.sgi.com; Tue, 12 Apr 2011 23:34:12 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q9djY-0007fX-Fz
	for xfs@oss.sgi.com; Tue, 12 Apr 2011 23:34:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix duplicate message output
Date: Tue, 12 Apr 2011 23:34:20 +1000
Message-Id: <1302615260-29450-1-git-send-email-david@fromorbit.com>
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

Commit 957935dc ("xfs: fix xfs_debug warnings" broke the logic in
__xfs_printk(). Instead of only printing one of two possible output
strings based on whether the fs has a name or not, it outputs both.
Fix it to only output one message again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_message.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_message.c b/fs/xfs/linux-2.6/xfs_message.c
index 3ca7956..9f76cce 100644
--- a/fs/xfs/linux-2.6/xfs_message.c
+++ b/fs/xfs/linux-2.6/xfs_message.c
@@ -34,8 +34,10 @@ __xfs_printk(
 	const struct xfs_mount	*mp,
 	struct va_format	*vaf)
 {
-	if (mp && mp->m_fsname)
+	if (mp && mp->m_fsname) {
 		printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
+		return;
+	}
 	printk("%sXFS: %pV\n", level, vaf);
 }
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
