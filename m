Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0TklQ141445 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:29:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 525B011F8B49
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:30:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	VOynqEUcAULpAS4m for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:30:45 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11706925-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:00:43 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX1zM-0003DK-BZ
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX1zL-0003Vy-MK
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: directory names are unsigned
Date: Tue, 19 Jan 2010 11:30:19 +1100
Message-Id: <1263861026-13448-2-git-send-email-david@fromorbit.com>
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

Convert the struct xfs_name to use unsigned chars for the name
strings to match both what is stored on disk (__uint8_t) and what
the VFS expects (unsigned char).

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_types.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index d725428..b099045 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -151,8 +151,8 @@ typedef enum {
 } xfs_btnum_t;
 
 struct xfs_name {
-	const char	*name;
-	int		len;
+	const unsigned char	*name;
+	int			len;
 };
 
 #endif	/* __XFS_TYPES_H__ */
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
