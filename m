Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1745C7FA0
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 15:57:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E505630407B
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 13:57:00 -0700 (PDT)
Received: from mail.sigma-star.at (mail.sigma-star.at [95.130.255.111]) by
	cuda.sgi.com with ESMTP id MSOBf0t5RyYqYyCa for
	<xfs@oss.sgi.com>; Mon, 19 Aug 2013 13:56:59 -0700 (PDT)
From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] xfs: Register hotcpu notifier after initialization
Date: Mon, 19 Aug 2013 22:56:44 +0200
Message-Id: <1376945804-29508-1-git-send-email-richard@nod.at>
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
Cc: Richard Weinberger <richard@nod.at>, bpm@sgi.com, elder@kernel.org, linux-kernel@vger.kernel.org

Currently the code initializizes mp->m_icsb_mutex and other things
_after_ register_hotcpu_notifier().
As the notifier takes mp->m_icsb_mutex it can happen
that it takes the lock before it's initialization.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/xfs/xfs_mount.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..986f9cf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -2260,12 +2260,6 @@ xfs_icsb_init_counters(
 	if (mp->m_sb_cnts == NULL)
 		return -ENOMEM;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	mp->m_icsb_notifier.notifier_call = xfs_icsb_cpu_notify;
-	mp->m_icsb_notifier.priority = 0;
-	register_hotcpu_notifier(&mp->m_icsb_notifier);
-#endif /* CONFIG_HOTPLUG_CPU */
-
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
@@ -2278,6 +2272,13 @@ xfs_icsb_init_counters(
 	 * initial balance kicks us off correctly
 	 */
 	mp->m_icsb_counters = -1;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	mp->m_icsb_notifier.notifier_call = xfs_icsb_cpu_notify;
+	mp->m_icsb_notifier.priority = 0;
+	register_hotcpu_notifier(&mp->m_icsb_notifier);
+#endif /* CONFIG_HOTPLUG_CPU */
+
 	return 0;
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
