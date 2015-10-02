Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3832E7F5D
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:20:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08EFF304048
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:20:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BnwJPQMHXBbpgzZ1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:58 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id D51BFA3810
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJveE023986
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 17/18] xfs_copy: refactor log format code into new helper
Date: Fri,  2 Oct 2015 14:19:54 -0400
Message-Id: <1443809995-20395-18-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
References: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
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

The xfs_copy log format code is mostly open-coded into the main()
function of the application. Support for v5 superblock log formatting
will require an alternate mechanism than that utilized for v4
superblocks and older.

As such, refactor the log formatting code into new helper functions. The
top-level helper iterates the copy target devices and another helper
implements the log format magic. This patch does not change existing
behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 copy/xfs_copy.c | 69 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 24 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index e03796a..a5f25ad 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -62,8 +62,9 @@ pthread_mutex_t	mainwait;
 #define ACTIVE		1
 #define INACTIVE	2
 
-xfs_off_t write_log_trailer(int fd, wbuf *w, xfs_mount_t *mp);
-xfs_off_t write_log_header(int fd, wbuf *w, xfs_mount_t *mp);
+xfs_off_t	write_log_trailer(int fd, wbuf *w, xfs_mount_t *mp);
+xfs_off_t	write_log_header(int fd, wbuf *w, xfs_mount_t *mp);
+static void	format_logs(struct xfs_mount *);
 
 /* general purpose message reporting routine */
 
@@ -518,7 +519,7 @@ main(int argc, char **argv)
 	int		i, j;
 	int		howfar = 0;
 	int		open_flags;
-	xfs_off_t	pos, end_pos;
+	xfs_off_t	pos;
 	size_t		length;
 	int		c;
 	__uint64_t	size, sizeb;
@@ -1160,29 +1161,11 @@ main(int argc, char **argv)
 	}
 
 	if (kids > 0)  {
-		if (!duplicate)  {
-
+		if (!duplicate)
 			/* write a clean log using the specified UUID */
-			for (j = 0, tcarg = targ; j < num_targets; j++)  {
-				w_buf.owner = tcarg;
-				w_buf.length = rounddown(w_buf.size,
-							 w_buf.min_io_size);
-				pos = write_log_header(
-							source_fd, &w_buf, mp);
-				end_pos = write_log_trailer(
-							source_fd, &w_buf, mp);
-				w_buf.position = pos;
-				memset(w_buf.data, 0, w_buf.length);
-
-				while (w_buf.position < end_pos)  {
-					do_write(tcarg, NULL);
-					w_buf.position += w_buf.length;
-				}
-				tcarg++;
-			}
-		} else {
+			format_logs(mp);
+		else
 			num_ags = 1;
-		}
 
 		/* reread and rewrite superblocks (UUID and in-progress) */
 		/* [backwards, so inprogress bit only updated when done] */
@@ -1284,3 +1267,41 @@ write_log_trailer(int fd, wbuf *buf, xfs_mount_t *mp)
 
 	return buf->position;
 }
+
+/*
+ * Clear a log by writing a record at the head, the tail and zeroing everything
+ * in between.
+ */
+static void
+clear_log(
+	struct xfs_mount	*mp,
+	thread_args		*tcarg)
+{
+	xfs_off_t		pos;
+	xfs_off_t		end_pos;
+
+	w_buf.owner = tcarg;
+	w_buf.length = rounddown(w_buf.size, w_buf.min_io_size);
+	pos = write_log_header(source_fd, &w_buf, mp);
+	end_pos = write_log_trailer(source_fd, &w_buf, mp);
+	w_buf.position = pos;
+	memset(w_buf.data, 0, w_buf.length);
+
+	while (w_buf.position < end_pos)  {
+		do_write(tcarg, NULL);
+		w_buf.position += w_buf.length;
+	}
+}
+
+static void
+format_logs(
+	struct xfs_mount	*mp)
+{
+	thread_args		*tcarg;
+	int			i;
+
+	for (i = 0, tcarg = targ; i < num_targets; i++)  {
+		clear_log(mp, tcarg);
+		tcarg++;
+	}
+}
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
