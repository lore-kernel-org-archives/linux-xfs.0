Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A18A7F59
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2543D8F8033
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cfLzEqB505ZEDs3f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:57 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 08BA4B8BB1
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJuOr023978
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 04/18] libxfs: pass lsn param to log clear and record
	header logging helpers
Date: Fri,  2 Oct 2015 14:19:41 -0400
Message-Id: <1443809995-20395-5-git-send-email-bfoster@redhat.com>
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

In preparation to support the ability to format the log with an
arbitrary cycle number, the log clear and record logging helpers must be
updated to receive the desired cycle and LSN values as parameters.

Update libxfs_log_clear() to receive the desired cycle number to format
the log with. Define a preprocessor directive to represent the currently
hardcoded case of cycle 1. Update libxfs_log_header() to receive the lsn
and tail_lsn of the record to write. Use a NULL value LSN to represent
the currently hardcoded behavior.

All callers are updated to use the current default values. As such, this
patch does not change behavior in any way.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 copy/xfs_copy.c  |  4 ++--
 db/sb.c          |  2 +-
 include/libxfs.h | 12 ++++++++----
 libxfs/rdwr.c    | 26 ++++++++++++++++++++------
 mkfs/xfs_mkfs.c  |  2 +-
 repair/phase2.c  |  2 +-
 6 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 2f4f5cb..949be5f 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1212,8 +1212,8 @@ write_log_header(int fd, wbuf *buf, xfs_mount_t *mp)
 
 	offset = libxfs_log_header(p, &buf->owner->uuid,
 			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
-			mp->m_sb.sb_logsunit, XLOG_FMT,
-			next_log_chunk, buf);
+			mp->m_sb.sb_logsunit, XLOG_FMT, NULLCOMMITLSN,
+			NULLCOMMITLSN, next_log_chunk, buf);
 	do_write(buf->owner);
 
 	return roundup(logstart + offset, buf->length);
diff --git a/db/sb.c b/db/sb.c
index 598e787..560e653 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -278,7 +278,7 @@ sb_logzero(uuid_t *uuidp)
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			uuidp,
 			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
-			mp->m_sb.sb_logsunit, XLOG_FMT)) {
+			mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE)) {
 		dbprintf(_("ERROR: cannot clear the log\n"));
 		return 0;
 	}
diff --git a/include/libxfs.h b/include/libxfs.h
index cc06fc6..6c87934 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -149,10 +149,14 @@ extern int	platform_nproc(void);
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef char	*(libxfs_get_block_t)(char *, int, void *);
 
-extern int	libxfs_log_clear (struct xfs_buftarg *, xfs_daddr_t, uint,
-				uuid_t *, int, int, int);
-extern int	libxfs_log_header (char *, uuid_t *, int, int, int,
-				libxfs_get_block_t *, void *);
+/*
+ * Helpers to clear the log to a particular log cycle.
+ */
+#define XLOG_INIT_CYCLE	1
+extern int	libxfs_log_clear(struct xfs_buftarg *, xfs_daddr_t, uint,
+				 uuid_t *, int, int, int, int);
+extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
+				  xfs_lsn_t, libxfs_get_block_t *, void *);
 
 
 /* Shared utility routines */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 282f22d..da781da 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -150,14 +150,21 @@ libxfs_log_clear(
 	uuid_t			*fs_uuid,
 	int			version,
 	int			sunit,
-	int			fmt)
+	int			fmt,
+	int			cycle)
 {
 	xfs_buf_t		*bp;
 	int			len;
+	xfs_lsn_t		lsn;
 
 	if (!btp->dev || !fs_uuid)
 		return -EINVAL;
 
+	if (cycle != XLOG_INIT_CYCLE)
+		return -EINVAL;
+
+	lsn = xlog_assign_lsn(cycle, 0);
+
 	/* first zero the log */
 	libxfs_device_zero(btp, start, length);
 
@@ -165,8 +172,8 @@ libxfs_log_clear(
 	len = ((version == 2) && sunit) ? BTOBB(sunit) : 2;
 	len = MAX(len, 2);
 	bp = libxfs_getbufr(btp, start, len);
-	libxfs_log_header(XFS_BUF_PTR(bp),
-			  fs_uuid, version, sunit, fmt, next, bp);
+	libxfs_log_header(XFS_BUF_PTR(bp), fs_uuid, version, sunit, fmt, lsn,
+			  lsn, next, bp);
 	bp->b_flags |= LIBXFS_B_DIRTY;
 	libxfs_putbufr(bp);
 	return 0;
@@ -179,6 +186,8 @@ libxfs_log_header(
 	int			version,
 	int			sunit,
 	int			fmt,
+	xfs_lsn_t		lsn,
+	xfs_lsn_t		tail_lsn,
 	libxfs_get_block_t	*nextfunc,
 	void			*private)
 {
@@ -187,11 +196,16 @@ libxfs_log_header(
 	__be32			cycle_lsn;
 	int			i, len;
 
+	if (lsn == NULLCOMMITLSN)
+		lsn = xlog_assign_lsn(XLOG_INIT_CYCLE, 0);
+	if (tail_lsn == NULLCOMMITLSN)
+		tail_lsn = lsn;
+
 	len = ((version == 2) && sunit) ? BTOBB(sunit) : 1;
 
 	memset(p, 0, BBSIZE);
 	head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
-	head->h_cycle = cpu_to_be32(1);
+	head->h_cycle = cpu_to_be32(CYCLE_LSN(lsn));
 	head->h_version = cpu_to_be32(version);
 	if (len != 1)
 		head->h_len = cpu_to_be32(sunit - BBSIZE);
@@ -203,8 +217,8 @@ libxfs_log_header(
 	head->h_fmt = cpu_to_be32(fmt);
 	head->h_size = cpu_to_be32(XLOG_HEADER_CYCLE_SIZE);
 
-	head->h_lsn = cpu_to_be64(xlog_assign_lsn(1, 0));
-	head->h_tail_lsn = cpu_to_be64(xlog_assign_lsn(1, 0));
+	head->h_lsn = cpu_to_be64(lsn);
+	head->h_tail_lsn = cpu_to_be64(tail_lsn);
 
 	memcpy(&head->h_fs_uuid, fs_uuid, sizeof(uuid_t));
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d993fc0..238d400 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2670,7 +2670,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	libxfs_log_clear(mp->m_logdev_targp,
 		XFS_FSB_TO_DADDR(mp, logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT);
+		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT, XLOG_INIT_CYCLE);
 
 	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
 	if (mp == NULL) {
diff --git a/repair/phase2.c b/repair/phase2.c
index 7e264c4..0673a0c 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -98,7 +98,7 @@ zero_log(xfs_mount_t *mp)
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 		&mp->m_sb.sb_uuid,
 		xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
-		mp->m_sb.sb_logsunit, XLOG_FMT);
+		mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE);
 }
 
 /*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
