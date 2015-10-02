Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0404F7F56
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:20:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D74458F8035
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:20:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JCuKdyTGaw5CBPBm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:58 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id D55842FE853
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJvEG023987
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 18/18] xfs_copy: format v5 sb logs correctly
Date: Fri,  2 Oct 2015 14:19:55 -0400
Message-Id: <1443809995-20395-19-git-send-email-bfoster@redhat.com>
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

xfs_copy formats the target filesystem log in non-duplicate copy mode to
stamp the new fs UUID into the log. The current format mechanism resets
the current LSN of the target filesystem to cycle 1, which is invalid
for v5 superblocks. The current LSN of v5 superblocks must always move
forward and remain ahead of metadata LSNs stored in filesystem metadata.

Update the log format helper to detect and use an alternate format
mechanism for v5 superblock logs. Allocate an independent log format
buffer based on the size of the log and format the buffer with an
incremented cycle count using the libxfs log format mechanism.

Note that the new libxfs log format mechanism could be used for both v5
and older superblock formats. The new mechanism requires a new, full log
sized buffer allocation as well as doing I/O to the entire log whereas
the pre-v5 sb mechanism only writes to the log head and tail. This is
due to how xfs_copy uses its own internal buffer data structure rather
than libxfs buftarg structures. As such, keep the original mechanism
around to avoid potential disruption for non-v5 users. The old mechanism
can be removed at some point in the future when the new mechanism is
shaken out and v5 filesystems tend to outnumber v4.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 copy/xfs_copy.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index a5f25ad..1dc7c65 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -64,7 +64,7 @@ pthread_mutex_t	mainwait;
 
 xfs_off_t	write_log_trailer(int fd, wbuf *w, xfs_mount_t *mp);
 xfs_off_t	write_log_header(int fd, wbuf *w, xfs_mount_t *mp);
-static void	format_logs(struct xfs_mount *);
+static int	format_logs(struct xfs_mount *);
 
 /* general purpose message reporting routine */
 
@@ -1293,15 +1293,72 @@ clear_log(
 	}
 }
 
+/*
+ * Format the log to a particular cycle number. This is required for version 5
+ * superblock filesystems to provide metadata LSN validity guarantees.
+ */
 static void
+format_log(
+	struct xfs_mount	*mp,
+	thread_args		*tcarg,
+	wbuf			*buf)
+{
+	int			logstart;
+	int			length;
+	int			cycle = XLOG_INIT_CYCLE;
+
+	buf->owner = tcarg;
+	buf->length = buf->size;
+	buf->position = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart) << BBSHIFT;
+
+	logstart = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logstart);
+	length = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+
+	/*
+	 * Bump the cycle number on v5 superblock filesystems to guarantee that
+	 * all existing metadata LSNs are valid (behind the current LSN) on the
+	 * target fs.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cycle = mp->m_log->l_curr_cycle + 1;
+
+	/*
+	 * Format the entire log into the memory buffer and write it out. If the
+	 * write fails, mark the target inactive so the failure is reported.
+	 */
+	libxfs_log_clear(NULL, buf->data, logstart, length, &buf->owner->uuid,
+			 xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
+			 mp->m_sb.sb_logsunit, XLOG_FMT, cycle);
+	if (do_write(buf->owner, buf))
+		target[tcarg->id].state = INACTIVE;
+}
+
+static int
 format_logs(
 	struct xfs_mount	*mp)
 {
 	thread_args		*tcarg;
 	int			i;
+	wbuf			logbuf;
+	int			logsize;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		logsize = XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks);
+		if (!wbuf_init(&logbuf, logsize, w_buf.data_align,
+			       w_buf.min_io_size, w_buf.id))
+			return -ENOMEM;
+	}
 
 	for (i = 0, tcarg = targ; i < num_targets; i++)  {
-		clear_log(mp, tcarg);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			format_log(mp, tcarg, &logbuf);
+		else
+			clear_log(mp, tcarg);
 		tcarg++;
 	}
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		free(logbuf.data);
+
+	return 0;
 }
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
