Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4AISnR8046149 for <xfs@oss.sgi.com>; Thu, 10 May 2012 13:28:49 -0500
Date: Thu, 10 May 2012 13:32:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20120510183245.GL3963@sgi.com>
References: <20120510130134.0efffc5ba1f3a80c614e8f29@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120510130134.0efffc5ba1f3a80c614e8f29@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 10, 2012 at 01:01:34PM +1000, Stephen Rothwell wrote:
> After merging the xfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: ".xfs_extent_busy_trim" [fs/xfs/xfs.ko] undefined!
> 
> Caused by commit e459df5b5b93 ("xfs: move busy extent handling to it's
> own file") (and aided by 425dcd6c2289 "xfs: clean up busy extent naming").
> 
> I have used the xfs tree from next-20120508 for today.

Thanks Stephen.  The following should resolve the issue.

Regards,
	Ben



xfs: make xfs_extent_busy_trim not static

Commit e459df5, 'xfs: move busy extent handling to it's own file'
moved some code from xfs_alloc.c into xfs_extent_busy.c for
convenience in userspace code merges.  One of the functions moved is
xfs_extent_busy_trim (formerly xfs_alloc_busy_trim) which is defined
STATIC.  Unfortunately this function is still used in xfs_alloc.c, and
this results in an undefined symbol in xfs.ko.

Make xfs_extent_busy_trim not static and add its prototype to
xfs_extent_busy.h.

Signed-off-by: Ben Myers <bpm@sgi.com>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c
+++ xfs/fs/xfs/xfs_alloc.c
@@ -47,8 +47,6 @@ STATIC int xfs_alloc_ag_vextent_near(xfs
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
-STATIC void xfs_extent_busy_trim(struct xfs_alloc_arg *,
-		xfs_agblock_t, xfs_extlen_t, xfs_agblock_t *, xfs_extlen_t *);
 
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
Index: xfs/fs/xfs/xfs_extent_busy.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extent_busy.c
+++ xfs/fs/xfs/xfs_extent_busy.c
@@ -345,7 +345,7 @@ restart:
  * args->minlen no suitable extent could be found, and the higher level
  * code needs to force out the log and retry the allocation.
  */
-STATIC void
+void
 xfs_extent_busy_trim(
 	struct xfs_alloc_arg	*args,
 	xfs_agblock_t		bno,
Index: xfs/fs/xfs/xfs_extent_busy.h
===================================================================
--- xfs.orig/fs/xfs/xfs_extent_busy.h
+++ xfs/fs/xfs/xfs_extent_busy.h
@@ -54,6 +54,10 @@ void
 xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
 
+void
+xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t bno,
+	xfs_extlen_t len, xfs_agblock_t *rbno, xfs_extlen_t *rlen);
+
 int
 xfs_extent_busy_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
