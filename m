Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0TbXc141341 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:29:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6700D1C5C78C
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Qr1LwdNLGKxuodBl for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11645679-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:00:34 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX1zM-0003Dh-PH
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX1zM-0003WH-4E
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: make compile warn about char sign mismatches again
Date: Tue, 19 Jan 2010 11:30:26 +1100
Message-Id: <1263861026-13448-9-git-send-email-david@fromorbit.com>
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

The -fno-unsigned-char directive has no effect anymore as the
XFs build is clean. However, the kernel build hides pointer sign
differences so turn that back on so that we can clean up all the
mismatches prior to a userspace code resync.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/Makefile       |    2 +-
 fs/xfs/xfs_vnodeops.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 56641fe..1926701 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -16,7 +16,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6 -funsigned-char
+EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6 -Wpointer-sign
 
 XFS_LINUX := linux-2.6
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 6f26875..9f7c001 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2199,7 +2199,8 @@ xfs_symlink(
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-					link_name->name, target_path, 0, 0, 0);
+					link_name->name,
+					(unsigned char *)target_path, 0, 0, 0);
 		if (error)
 			return error;
 	}
@@ -2395,7 +2396,8 @@ std_return:
 					dp, DM_RIGHT_NULL,
 					error ? NULL : ip,
 					DM_RIGHT_NULL, link_name->name,
-					target_path, 0, error, 0);
+					(unsigned char *)target_path,
+					0, error, 0);
 	}
 
 	if (!error)
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
