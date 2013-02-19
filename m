Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76E5D7F5E
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 05:37:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4B8AAC002
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 03:37:44 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id llrYl3H9uanuh89F (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Feb 2013 03:37:43 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 05/11] xfstets: fsstress add replace file operation
Date: Tue, 19 Feb 2013 15:37:17 +0400
Message-Id: <1361273843-16094-5-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
References: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

The most common usecase for rename(2) syscall is an atomic replacement
of existing file with newer version. But rename_f() rename some existing
filename to newly generated (non existing) filename. As result the most
important usecase is not covered.
Since rename_f() is already exist in fsstress and it has known behavior,
some tests already depends on that behaviour, let's add another operation
(replace_f) which invoke rename(2) for two existing entries.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ltp/fsstress.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b4cfb25..85ff72a 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -80,6 +80,7 @@ typedef enum {
 	OP_READ,
 	OP_READLINK,
 	OP_RENAME,
+	OP_REPLACE,
 	OP_RESVSP,
 	OP_RMDIR,
 	OP_SETATTR,
@@ -165,6 +166,7 @@ void	punch_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	rename_f(int, long);
+void	replace_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setattr_f(int, long);
@@ -202,6 +204,7 @@ opdesc_t	ops[] = {
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
+	{ OP_REPLACE, "replace", replace_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
 	{ OP_SETATTR, "setattr", setattr_f, 0, 1 },
@@ -2680,6 +2683,50 @@ rename_f(int opno, long r)
 }
 
 void
+replace_f(int opno, long r)
+{
+	int		e;
+	pathname_t	src_f, dst_f;
+	fent_t		*src_fep, *dst_fep;
+	flist_t		*src_flp, *dst_flp;
+	int		v;
+	int		v1;
+
+	/* get an existing path for the source of the rename */
+	init_pathname(&src_f);
+	if (!get_fname(FT_ANYm, r, &src_f, &src_flp, &src_fep, &v)) {
+		if (v)
+			printf("%d/%d: replace - no filename\n", procid, opno);
+		free_pathname(&src_f);
+		return;
+	}
+	/* get an existing path for the destination of the rename */
+	init_pathname(&dst_f);
+	if (!get_fname(1 << (src_flp - flist), rand(), &dst_f, &dst_flp, &dst_fep, &v1)) {
+		if (v1)
+			printf("%d/%d: replace - no filename\n", procid, opno);
+		free_pathname(&dst_f);
+		return;
+	}
+	
+	v |= v1;
+	e = rename_path(&src_f, &dst_f) < 0 ? errno : 0;
+	check_cwd();
+	if (e == 0 && src_fep->id != dst_fep->id ) {
+		del_from_flist(src_flp - flist, src_fep - src_flp->fents);
+	}
+	if (v) {
+		printf("%d/%d: replace %s with %s %d\n", procid, opno, dst_f.path,
+			src_f.path, e);
+		if (e == 0 && src_fep->id != dst_fep->id)
+			printf("%d/%d: replace del entry: id=%d,parent=%d\n",
+				procid, opno, src_fep->id, src_fep->parent);
+	}
+	free_pathname(&src_f);
+	free_pathname(&dst_f);
+}
+
+void
 resvsp_f(int opno, long r)
 {
 	int		e;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
