Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A4757F56
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:20:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 976FA8F8035
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sPzdA325VK9X3hKC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:58 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id E17EAB8BA9
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJvnZ031593
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 15/18] xfs_copy: genericize write helper to facilitate
	separate log buf
Date: Fri,  2 Oct 2015 14:19:52 -0400
Message-Id: <1443809995-20395-16-git-send-email-bfoster@redhat.com>
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

xfs_copy uses a fixed write buffer throughout the code for the various
targets. This is a global buffer and is assumed to be the write source
in the do_write() helper used by the log clearing code.

v5 superblock log formatting will require a larger, independent buffer
to format the log. Therefore, update do_write() to accept a write buffer
parameter to optionally override the global write buffer. This patch
does not change current behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 copy/xfs_copy.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index f3e5288..0481ece 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -170,20 +170,26 @@ check_errors(void)
  * are taken care of when the buffer's read in
  */
 int
-do_write(thread_args *args)
+do_write(
+	thread_args	*args,
+	wbuf		*buf)
 {
-	int	res, error = 0;
+	int		res;
+	int		error = 0;
 
-	if (target[args->id].position != w_buf.position)  {
-		if (lseek64(args->fd, w_buf.position, SEEK_SET) < 0)  {
+	if (!buf)
+		buf = &w_buf;
+
+	if (target[args->id].position != buf->position)  {
+		if (lseek64(args->fd, buf->position, SEEK_SET) < 0)  {
 			error = target[args->id].err_type = 1;
 		} else  {
-			target[args->id].position = w_buf.position;
+			target[args->id].position = buf->position;
 		}
 	}
 
-	if ((res = write(target[args->id].fd, w_buf.data,
-				w_buf.length)) == w_buf.length)  {
+	if ((res = write(target[args->id].fd, buf->data,
+				buf->length)) == buf->length)  {
 		target[args->id].position += res;
 	} else  {
 		error = 2;
@@ -191,7 +197,7 @@ do_write(thread_args *args)
 
 	if (error) {
 		target[args->id].error = errno;
-		target[args->id].position = w_buf.position;
+		target[args->id].position = buf->position;
 	}
 	return error;
 }
@@ -203,7 +209,7 @@ begin_reader(void *arg)
 
 	for (;;) {
 		pthread_mutex_lock(&args->wait);
-		if (do_write(args))
+		if (do_write(args, NULL))
 			goto handle_error;
 	        pthread_mutex_lock(&glob_masks.mutex);
 		if (--glob_masks.num_working == 0)
@@ -1168,7 +1174,7 @@ main(int argc, char **argv)
 				memset(w_buf.data, 0, w_buf.length);
 
 				while (w_buf.position < end_pos)  {
-					do_write(tcarg);
+					do_write(tcarg, NULL);
 					w_buf.position += w_buf.length;
 				}
 				tcarg++;
@@ -1190,7 +1196,7 @@ main(int argc, char **argv)
 
 			for (j = 0, tcarg = targ; j < num_targets; j++)  {
 				sb_update_uuid(sb, &ag_hdr, tcarg);
-				do_write(tcarg);
+				do_write(tcarg, NULL);
 				tcarg++;
 			}
 		}
@@ -1212,7 +1218,7 @@ next_log_chunk(char *p, int offset, void *private)
 	if (buf->length < (int)(p - buf->data) + offset) {
 		/* need to flush this one, then start afresh */
 
-		do_write(buf->owner);
+		do_write(buf->owner, NULL);
 		memset(buf->data, 0, buf->length);
 		return buf->data;
 	}
@@ -1247,7 +1253,7 @@ write_log_header(int fd, wbuf *buf, xfs_mount_t *mp)
 			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
 			mp->m_sb.sb_logsunit, XLOG_FMT, NULLCOMMITLSN,
 			NULLCOMMITLSN, next_log_chunk, buf);
-	do_write(buf->owner);
+	do_write(buf->owner, NULL);
 
 	return roundup(logstart + offset, buf->length);
 }
@@ -1272,7 +1278,7 @@ write_log_trailer(int fd, wbuf *buf, xfs_mount_t *mp)
 		read_wbuf(fd, buf, mp);
 		offset = (int)(logend - buf->position);
 		memset(buf->data, 0, offset);
-		do_write(buf->owner);
+		do_write(buf->owner, NULL);
 	}
 
 	return buf->position;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
