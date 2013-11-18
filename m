Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8150029E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 10:02:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F10B8F8052
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 08:02:08 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 62Fsxkrf0XzptIey for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 08:02:07 -0800 (PST)
Message-ID: <528A39FD.5090109@sandeen.net>
Date: Mon, 18 Nov 2013 10:02:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfsprogs: suggest "-d" option for repair of RO mount
References: <528261AD.50501@redhat.com>
In-Reply-To: <528261AD.50501@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

We can offer the suggestion of a "-d" repair, if we're
in single-user mode with i.e. the root fs mounted readonly.

This change suggests -d to repair any RO mounted fs.

e2fsck allows this, and users are used to being able to
do it in single-user mode.  A separate patch will recommend
a reboot after repair completes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Now with more danger!

diff --git a/repair/init.c b/repair/init.c
index c3f380b..a7a7613 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -97,8 +97,17 @@ xfs_init(libxfs_init_t *args)
 	else
 		args->isreadonly = LIBXFS_EXCLUSIVELY;
 
-	if (!libxfs_init(args))
+	if (!libxfs_init(args)) {
+		/* would -d be an option? */
+		if (!no_modify && !dangerously) {
+			args->isreadonly = (LIBXFS_ISINACTIVE |
+					    LIBXFS_DANGEROUSLY);
+			if (libxfs_init(args))
+				fprintf(stderr,
+_("Unmount or use the dangerous (-d) option to repair a read-only mounted filesystem\n"));
+		}
 		do_error(_("couldn't initialize XFS library\n"));
+	}
 
 	ts_create();
 	increase_rlimit();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
