Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 619E67F6B
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:18:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A26030406B
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:18:58 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 85dp7xVaYuRePR2q (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:18:56 -0800 (PST)
Message-Id: <20131212181845.192929733@bombadil.infradead.org>
Date: Thu, 12 Dec 2013 10:15:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] splice: stop exporting splice_from_pipe implementation
	details
References: <20131212181459.994196463@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0005-splice-stop-exporting-splice_from_pipe-implementatio.patch
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
To: Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

The splice_to_file and __splice_to_file helpers with the various
actors are everyting consumers need to implement splice properly,
so stop exporting the low-level helpers that are used to implement
these functions, or in two cases were they were so trivially remove
the helpers entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/splice.c            |   49 +++++++++---------------------------------------
 include/linux/splice.h |    7 -------
 2 files changed, 9 insertions(+), 47 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 108e527..8627a85 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -812,8 +812,8 @@ static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
  *    locking is required around copying the pipe buffers to the
  *    destination.
  */
-int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_desc *sd,
-			  splice_actor *actor)
+static int splice_from_pipe_feed(struct pipe_inode_info *pipe,
+		struct splice_desc *sd, splice_actor *actor)
 {
 	int ret;
 
@@ -859,7 +859,6 @@ int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_desc *sd,
 
 	return 1;
 }
-EXPORT_SYMBOL(splice_from_pipe_feed);
 
 /**
  * splice_from_pipe_next - wait for some data to splice from
@@ -871,7 +870,8 @@ EXPORT_SYMBOL(splice_from_pipe_feed);
  *    value (one) if pipe buffers are available.  It will return zero
  *    or -errno if no more data needs to be spliced.
  */
-int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_desc *sd)
+static int splice_from_pipe_next(struct pipe_inode_info *pipe,
+		struct splice_desc *sd)
 {
 	while (!pipe->nrbufs) {
 		if (!pipe->writers)
@@ -896,40 +896,6 @@ int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_desc *sd)
 
 	return 1;
 }
-EXPORT_SYMBOL(splice_from_pipe_next);
-
-/**
- * splice_from_pipe_begin - start splicing from pipe
- * @sd:		information about the splice operation
- *
- * Description:
- *    This function should be called before a loop containing
- *    splice_from_pipe_next() and splice_from_pipe_feed() to
- *    initialize the necessary fields of @sd.
- */
-void splice_from_pipe_begin(struct splice_desc *sd)
-{
-	sd->num_spliced = 0;
-	sd->need_wakeup = false;
-}
-EXPORT_SYMBOL(splice_from_pipe_begin);
-
-/**
- * splice_from_pipe_end - finish splicing from pipe
- * @pipe:	pipe to splice from
- * @sd:		information about the splice operation
- *
- * Description:
- *    This function will wake up pipe writers if necessary.  It should
- *    be called after a loop containing splice_from_pipe_next() and
- *    splice_from_pipe_feed().
- */
-void splice_from_pipe_end(struct pipe_inode_info *pipe, struct splice_desc *sd)
-{
-	if (sd->need_wakeup)
-		wakeup_pipe_writers(pipe);
-}
-EXPORT_SYMBOL(splice_from_pipe_end);
 
 /**
  * __splice_from_pipe - splice data from a pipe to given actor
@@ -949,14 +915,17 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
 {
 	int ret;
 
-	splice_from_pipe_begin(sd);
+	sd->num_spliced = 0;
+	sd->need_wakeup = false;
+
 	do {
 		ret = splice_from_pipe_next(pipe, sd);
 		if (ret > 0)
 			ret = splice_from_pipe_feed(pipe, sd, actor);
 	} while (ret > 0);
-	splice_from_pipe_end(pipe, sd);
 
+	if (sd->need_wakeup)
+		wakeup_pipe_writers(pipe);
 	return sd->num_spliced ? sd->num_spliced : ret;
 }
 EXPORT_SYMBOL(__splice_from_pipe);
diff --git a/include/linux/splice.h b/include/linux/splice.h
index c5aca88..0dabcc7 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -69,13 +69,6 @@ extern ssize_t splice_from_pipe(struct pipe_inode_info *, struct file *,
 				splice_actor *);
 extern ssize_t __splice_from_pipe(struct pipe_inode_info *,
 				  struct splice_desc *, splice_actor *);
-extern int splice_from_pipe_feed(struct pipe_inode_info *, struct splice_desc *,
-				 splice_actor *);
-extern int splice_from_pipe_next(struct pipe_inode_info *,
-				 struct splice_desc *);
-extern void splice_from_pipe_begin(struct splice_desc *);
-extern void splice_from_pipe_end(struct pipe_inode_info *,
-				 struct splice_desc *);
 extern int pipe_to_file(struct pipe_inode_info *, struct pipe_buffer *,
 			struct splice_desc *);
 extern int __pipe_to_file(struct pipe_inode_info *, struct pipe_buffer *,
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
