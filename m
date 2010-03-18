Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2IMqBWh198023 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:52:11 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0781D8F808E
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 15:53:46 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o2IMrkUZ001845
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:53:46 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o2IMrkx6001843
	for xfs@oss.sgi.com; Thu, 18 Mar 2010 17:53:46 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003182253.o2IMrkx6001843@stout.americas.sgi.com>
Date: Thu, 18 Mar 2010 17:53:46 -0500
Subject: [PATCH 1/7] xfs: add const qualifiers to xfs error function args
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Change the tag and file name arguments to xfs_error_report() and
xfs_corruption_error() to use a const qualifier.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_error.c |   30 +++++++++++++++---------------
 fs/xfs/xfs_error.h |    9 +++++----
 2 files changed, 20 insertions(+), 19 deletions(-)

Index: b/fs/xfs/xfs_error.c
===================================================================
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -186,18 +186,18 @@ xfs_cmn_err(int panic_tag, int level, xf
 
 void
 xfs_error_report(
-	char		*tag,
-	int		level,
-	xfs_mount_t	*mp,
-	char		*fname,
-	int		linenum,
-	inst_t		*ra)
+	const char		*tag,
+	int			level,
+	struct xfs_mount	*mp,
+	const char		*filename,
+	int			linenum,
+	inst_t			*ra)
 {
 	if (level <= xfs_error_level) {
 		xfs_cmn_err(XFS_PTAG_ERROR_REPORT,
 			    CE_ALERT, mp,
 		"XFS internal error %s at line %d of file %s.  Caller 0x%p\n",
-			    tag, linenum, fname, ra);
+			    tag, linenum, filename, ra);
 
 		xfs_stack_trace();
 	}
@@ -205,15 +205,15 @@ xfs_error_report(
 
 void
 xfs_corruption_error(
-	char		*tag,
-	int		level,
-	xfs_mount_t	*mp,
-	void		*p,
-	char		*fname,
-	int		linenum,
-	inst_t		*ra)
+	const char		*tag,
+	int			level,
+	struct xfs_mount	*mp,
+	void			*p,
+	const char		*filename,
+	int			linenum,
+	inst_t			*ra)
 {
 	if (level <= xfs_error_level)
 		xfs_hex_dump(p, 16);
-	xfs_error_report(tag, level, mp, fname, linenum, ra);
+	xfs_error_report(tag, level, mp, filename, linenum, ra);
 }
Index: b/fs/xfs/xfs_error.h
===================================================================
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -29,10 +29,11 @@ extern int	xfs_error_trap(int);
 
 struct xfs_mount;
 
-extern void xfs_error_report(char *tag, int level, struct xfs_mount *mp,
-				char *fname, int linenum, inst_t *ra);
-extern void xfs_corruption_error(char *tag, int level, struct xfs_mount *mp,
-				void *p, char *fname, int linenum, inst_t *ra);
+extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
+			const char *filename, int linenum, inst_t *ra);
+extern void xfs_corruption_error(const char *tag, int level,
+			struct xfs_mount *mp, void *p, const char *filename,
+			int linenum, inst_t *ra);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
 	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
