Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8L0l6c055729 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 15:00:47 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dP5Fl6UMOfMXeUyZ for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 13:03:07 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 34D5163C3E3F
	for <xfs@oss.sgi.com>; Sat,  8 Dec 2012 15:03:07 -0600 (CST)
Message-ID: <50C3AB0E.3050006@sandeen.net>
Date: Sat, 08 Dec 2012 15:03:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: remove setfl from xfs_io
References: <50C39123.6050303@sandeen.net>
In-Reply-To: <50C39123.6050303@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Doesn't seem to have worked for ages, and is (therefore)
apparently not ever used:

xfs_io> setfl
xfs_io> help setfl
setfl [-adx] -- set/clear append/direct flags on the open file
xfs_io> setfl -a
bad argument count 1 to setfl, expected 0 arguments
xfs_io> setfl -d
bad argument count 1 to setfl, expected 0 arguments
xfs_io> setfl
xfs_io> 

At best, it seems intended to toggle the flag state, but
gives no feedback about current state.  -x is in help but
not implemented, etc.

Just remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/open.c b/io/open.c
index 46538ba..cc677e6 100644
--- a/io/open.c
+++ b/io/open.c
@@ -25,7 +25,6 @@
 static cmdinfo_t open_cmd;
 static cmdinfo_t stat_cmd;
 static cmdinfo_t close_cmd;
-static cmdinfo_t setfl_cmd;
 static cmdinfo_t statfs_cmd;
 static cmdinfo_t chproj_cmd;
 static cmdinfo_t lsproj_cmd;
@@ -668,45 +667,6 @@ extsize_f(
 }
 
 static int
-setfl_f(
-	int			argc,
-	char			**argv)
-{
-	int			c, flags;
-
-	flags = fcntl(file->fd, F_GETFL, 0);
-	if (flags < 0) {
-		perror("fcntl(F_GETFL)");
-		return 0;
-	}
-
-	while ((c = getopt(argc, argv, "ad")) != EOF) {
-		switch (c) {
-		case 'a':
-			if (flags & O_APPEND)
-				flags |= O_APPEND;
-			else
-				flags &= ~O_APPEND;
-			break;
-		case 'd':
-			if (flags & O_DIRECT)
-				flags |= O_DIRECT;
-			else
-				flags &= ~O_DIRECT;
-			break;
-		default:
-			printf(_("invalid setfl argument -- '%c'\n"), c);
-			return 0;
-		}
-	}
-
-	if (fcntl(file->fd, F_SETFL, flags)  < 0)
-		perror("fcntl(F_SETFL)");
-
-	return 0;
-}
-
-static int
 statfs_f(
 	int			argc,
 	char			**argv)
@@ -791,13 +751,6 @@ open_init(void)
 	close_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	close_cmd.oneline = _("close the current open file");
 
-	setfl_cmd.name = "setfl";
-	setfl_cmd.cfunc = setfl_f;
-	setfl_cmd.args = _("[-adx]");
-	setfl_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	setfl_cmd.oneline =
-		_("set/clear append/direct flags on the open file");
-
 	statfs_cmd.name = "statfs";
 	statfs_cmd.cfunc = statfs_f;
 	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
@@ -837,7 +790,6 @@ open_init(void)
 	add_command(&open_cmd);
 	add_command(&stat_cmd);
 	add_command(&close_cmd);
-	add_command(&setfl_cmd);
 	add_command(&statfs_cmd);
 	add_command(&chproj_cmd);
 	add_command(&lsproj_cmd);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
