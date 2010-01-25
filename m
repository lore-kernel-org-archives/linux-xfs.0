Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P5WQHH033169 for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 23:32:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B0E51C6DD3E
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 21:33:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	9EhO4pcODNC7m9Eh for <xfs@oss.sgi.com>;
	Sun, 24 Jan 2010 21:33:28 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11565127-1927428
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 16:03:27 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NZHZj-0002uj-Sb
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 16:33:23 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NZHZi-0004vr-PE
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 16:33:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: turn off sign warnings
Date: Mon, 25 Jan 2010 16:33:22 +1100
Message-Id: <1264397602-18868-1-git-send-email-david@fromorbit.com>
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

Because they cause warnings in static inline functions conditionally
compiled into XFS from the VFS (e.g. fsnotify).

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1926701..5c5a366 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -16,7 +16,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6 -Wpointer-sign
+EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6
 
 XFS_LINUX := linux-2.6
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
