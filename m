Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37381 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdHCREK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 13:04:10 -0400
Date: Thu, 3 Aug 2017 10:04:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 9/7] xfs_db: btdump should avoid eval for push and pop of
 cursor
Message-ID: <20170803170404.GU4477@magnolia>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150153520589.26081.8786864874176090813.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

We can call the cursor push and pop functions directly from btdump,
so skip all the eval overhead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/btdump.c |   50 +++++++++++++++-----------------------------------
 db/io.c     |   22 ++++++++++++++--------
 db/io.h     |    1 +
 3 files changed, 30 insertions(+), 43 deletions(-)

diff --git a/db/btdump.c b/db/btdump.c
index f525a4a..59c5712 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -82,11 +82,9 @@ dump_btlevel(
 	xfs_daddr_t		orig_daddr = iocur_top->bb;
 	xfs_daddr_t		last_daddr;
 	unsigned int		nr;
-	int			ret;
+	int			ret = 0;
 
-	ret = eval("push");
-	if (ret)
-		return ret;
+	push_cur_and_set_type();
 
 	nr = 1;
 	do {
@@ -111,10 +109,8 @@ dump_btlevel(
 		nr++;
 	} while (iocur_top->bb != orig_daddr && iocur_top->bb != last_daddr);
 
-	ret = eval("pop");
-	return ret;
 err:
-	eval("pop");
+	pop_cur();
 	return ret;
 }
 
@@ -126,11 +122,9 @@ dump_btree(
 	xfs_daddr_t	orig_daddr = iocur_top->bb;
 	xfs_daddr_t	last_daddr;
 	int		level;
-	int		ret;
+	int		ret = 0;
 
-	ret = eval("push");
-	if (ret)
-		return ret;
+	push_cur_and_set_type();
 
 	cur_agno = XFS_FSB_TO_AGNO(mp, XFS_DADDR_TO_FSB(mp, iocur_top->bb));
 	level = xfs_btree_get_level(iocur_top->data);
@@ -153,10 +147,8 @@ dump_btree(
 		 iocur_top->bb != orig_daddr &&
 		 iocur_top->bb != last_daddr);
 
-	ret = eval("pop");
-	return ret;
 err:
-	eval("pop");
+	pop_cur();
 	return ret;
 }
 
@@ -177,7 +169,7 @@ dump_inode(
 {
 	char			*prefix;
 	struct xfs_dinode	*dip;
-	int			ret;
+	int			ret = 0;
 
 	if (attrfork)
 		prefix = "a.bmbt";
@@ -201,9 +193,7 @@ dump_inode(
 		}
 	}
 
-	ret = eval("push");
-	if (ret)
-		return ret;
+	push_cur_and_set_type();
 
 	if (dump_node_blocks) {
 		ret = eval("print %s.keys", prefix);
@@ -222,10 +212,8 @@ dump_inode(
 	if (ret)
 		goto err;
 
-	ret = eval("pop");
-	return ret;
 err:
-	eval("pop");
+	pop_cur();
 	return ret;
 }
 
@@ -397,11 +385,9 @@ dump_dablevel(
 	xfs_daddr_t		orig_daddr = iocur_top->bb;
 	xfs_daddr_t		last_daddr;
 	unsigned int		nr;
-	int			ret;
+	int			ret = 0;
 
-	ret = eval("push");
-	if (ret)
-		return ret;
+	push_cur_and_set_type();
 
 	nr = 1;
 	do {
@@ -421,10 +407,8 @@ dump_dablevel(
 		nr++;
 	} while (iocur_top->bb != orig_daddr && iocur_top->bb != last_daddr);
 
-	ret = eval("pop");
-	return ret;
 err:
-	eval("pop");
+	pop_cur();
 	return ret;
 }
 
@@ -436,11 +420,9 @@ dump_dabtree(
 	xfs_daddr_t			orig_daddr = iocur_top->bb;
 	xfs_daddr_t			last_daddr;
 	int				level;
-	int				ret;
+	int				ret = 0;
 
-	ret = eval("push");
-	if (ret)
-		return ret;
+	push_cur_and_set_type();
 
 	cur_agno = XFS_FSB_TO_AGNO(mp, XFS_DADDR_TO_FSB(mp, iocur_top->bb));
 	level = dbp->level(iocur_top->data);
@@ -468,10 +450,8 @@ dump_dabtree(
 		 iocur_top->bb != orig_daddr &&
 		 iocur_top->bb != last_daddr);
 
-	ret = eval("pop");
-	return ret;
 err:
-	eval("pop");
+	pop_cur();
 	return ret;
 }
 
diff --git a/db/io.c b/db/io.c
index fd9b9f4..0974fee 100644
--- a/db/io.c
+++ b/db/io.c
@@ -220,6 +220,19 @@ push_cur(void)
 	cur_typ = NULL;
 }
 
+void
+push_cur_and_set_type(void)
+{
+	/* save current state */
+	push_cur();
+	if (iocur_top[-1].typ && iocur_top[-1].typ->typnm == TYP_INODE)
+		set_cur_inode(iocur_top[-1].ino);
+	else
+		set_cur(iocur_top[-1].typ, iocur_top[-1].bb,
+			iocur_top[-1].blen, DB_RING_IGN,
+			iocur_top[-1].bbmap);
+}
+
 static int
 push_f(
 	int		argc,
@@ -240,14 +253,7 @@ push_f(
 		}
 	}
 
-	/* save current state */
-	push_cur();
-	if (iocur_top[-1].typ && iocur_top[-1].typ->typnm == TYP_INODE)
-		set_cur_inode(iocur_top[-1].ino);
-	else
-		set_cur(iocur_top[-1].typ, iocur_top[-1].bb,
-			iocur_top[-1].blen, DB_RING_IGN,
-			iocur_top[-1].bbmap);
+	push_cur_and_set_type();
 
 	/* run requested command */
 	if (argc>1)
diff --git a/db/io.h b/db/io.h
index df0fdd7..d238685 100644
--- a/db/io.h
+++ b/db/io.h
@@ -57,6 +57,7 @@ extern void	off_cur(int off, int len);
 extern void	pop_cur(void);
 extern void	print_iocur(char *tag, iocur_t *ioc);
 extern void	push_cur(void);
+extern void	push_cur_and_set_type(void);
 extern int	read_buf(int64_t daddr, int count, void *bufp);
 extern void     write_cur(void);
 extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
