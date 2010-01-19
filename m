Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0TaN3141339 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:29:38 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7486811F8B3E
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	g2UcVZeNrDfly1W8 for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11404481-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:00:33 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX1zM-0003DL-D4
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX1zL-0003W0-PI
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: convert DM ops to use unsigned char names
Date: Tue, 19 Jan 2010 11:30:20 +1100
Message-Id: <1263861026-13448-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861026-13448-1-git-send-email-david@fromorbit.com>
References: <1263861026-13448-1-git-send-email-david@fromorbit.com>
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

dmops uses a signed char for it's namespace event. To be consistent
with the rest of the code, convert them to unsigned char for the
namespace string.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_mount.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e62fd1c..f4d1441 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -78,7 +78,8 @@ typedef int	(*xfs_send_destroy_t)(struct xfs_inode *, dm_right_t);
 typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
 			struct xfs_inode *, dm_right_t,
 			struct xfs_inode *, dm_right_t,
-			const char *, const char *, mode_t, int, int);
+			const unsigned char *, const unsigned char *,
+			mode_t, int, int);
 typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
 			char *, char *);
 typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, struct xfs_inode *,
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
