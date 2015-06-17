Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F6AB7FA1
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:57:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0419AC002
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:57:30 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id xV54B3BOChDTdDuw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:57:29 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5B28-0003YL-Cl
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:57:28 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] xfs: remove inst_t
Date: Wed, 17 Jun 2015 12:55:29 +0200
Message-Id: <1434538532-6566-3-git-send-email-hch@lst.de>
In-Reply-To: <1434538532-6566-1-git-send-email-hch@lst.de>
References: <1434538532-6566-1-git-send-email-hch@lst.de>
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

We can simply use a void pointer to pass a long return addresses in the
debugging helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_error.c | 4 ++--
 fs/xfs/xfs_error.h | 4 ++--
 fs/xfs/xfs_linux.h | 2 --
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 338e50b..74d0e59 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -127,7 +127,7 @@ xfs_error_report(
 	struct xfs_mount	*mp,
 	const char		*filename,
 	int			linenum,
-	inst_t			*ra)
+	void			*ra)
 {
 	if (level <= xfs_error_level) {
 		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
@@ -146,7 +146,7 @@ xfs_corruption_error(
 	void			*p,
 	const char		*filename,
 	int			linenum,
-	inst_t			*ra)
+	void			*ra)
 {
 	if (level <= xfs_error_level)
 		xfs_hex_dump(p, 64);
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index c0394ed..4ed3042 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -21,10 +21,10 @@
 struct xfs_mount;
 
 extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
-			const char *filename, int linenum, inst_t *ra);
+			const char *filename, int linenum, void *ra);
 extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, void *p, const char *filename,
-			int linenum, inst_t *ra);
+			int linenum, void *ra);
 extern void xfs_verifier_error(struct xfs_buf *bp);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 1637a95..3f48263 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -32,8 +32,6 @@ typedef unsigned int		__uint32_t;
 typedef signed long long int	__int64_t;
 typedef unsigned long long int	__uint64_t;
 
-typedef __uint32_t		inst_t;		/* an instruction */
-
 typedef __s64			xfs_off_t;	/* <file offset> type */
 typedef unsigned long long	xfs_ino_t;	/* <inode> type */
 typedef __s64			xfs_daddr_t;	/* <disk address> type */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
