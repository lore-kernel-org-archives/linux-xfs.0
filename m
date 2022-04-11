Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65D3C43219
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiDKAeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiDKAeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F863DF7B
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4BA7253ACEA
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMP-4T
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pil-3V
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/17] xfs: convert buffer flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:31 +1000
Message-Id: <20220411003147.2104423-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=tBb2bbeoAAAA:8 a=20KFwNOVAAAA:8
        a=kPxMgYnPrDWbSKvey_gA:9 a=Oj-tNtZlA1e06AYgeCfH:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned. This manifests as a compiler error such as:

/kisskb/src/fs/xfs/./xfs_trace.h:432:2: note: in expansion of macro 'TP_printk'
  TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
  ^
/kisskb/src/fs/xfs/./xfs_trace.h:440:5: note: in expansion of macro '__print_flags'
     __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
     ^
/kisskb/src/fs/xfs/xfs_buf.h:67:4: note: in expansion of macro 'XBF_UNMAPPED'
  { XBF_UNMAPPED,  "UNMAPPED" }
    ^
/kisskb/src/fs/xfs/./xfs_trace.h:440:40: note: in expansion of macro 'XFS_BUF_FLAGS'
     __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
                                        ^
/kisskb/src/fs/xfs/./xfs_trace.h: In function 'trace_raw_output_xfs_buf_flags_class':
/kisskb/src/fs/xfs/xfs_buf.h:46:23: error: initializer element is not constant
 #define XBF_UNMAPPED  (1 << 31)/* do not map the buffer */

as __print_flags assigns XFS_BUF_FLAGS to a structure that uses an
unsigned long for the flag. Since this results in the value of
XBF_UNMAPPED causing a signed integer overflow, the result is
technically undefined behavior, which gcc-5 does not accept as an
integer constant.

This is based on a patch from Arnd Bergman <arnd@arndb.de>.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |  6 +++---
 fs/xfs/xfs_buf.h | 42 +++++++++++++++++++++---------------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e1afb9e503e1..bf4e60871068 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -406,7 +406,7 @@ xfs_buf_alloc_pages(
 STATIC int
 _xfs_buf_map_pages(
 	struct xfs_buf		*bp,
-	uint			flags)
+	xfs_buf_flags_t		flags)
 {
 	ASSERT(bp->b_flags & _XBF_PAGES);
 	if (bp->b_page_count == 1) {
@@ -868,7 +868,7 @@ xfs_buf_read_uncached(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		daddr,
 	size_t			numblks,
-	int			flags,
+	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
@@ -903,7 +903,7 @@ int
 xfs_buf_get_uncached(
 	struct xfs_buftarg	*target,
 	size_t			numblks,
-	int			flags,
+	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
 	int			error;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index edcb6254fa6a..1ee3056ff9cf 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -22,28 +22,28 @@ struct xfs_buf;
 
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
-#define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
-#define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
-#define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
-#define XBF_NO_IOACCT	 (1 << 3) /* bypass I/O accounting (non-LRU bufs) */
-#define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
-#define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
-#define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
-#define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
+#define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
+#define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
+#define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
+#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
+#define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
+#define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
+#define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
+#define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
 
 /* buffer type flags for write callbacks */
-#define _XBF_INODES	 (1 << 16)/* inode buffer */
-#define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
-#define _XBF_LOGRECOVERY	 (1 << 18)/* log recovery buffer */
+#define _XBF_INODES	 (1u << 16)/* inode buffer */
+#define _XBF_DQUOTS	 (1u << 17)/* dquot buffer */
+#define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
 
 /* flags used only internally */
-#define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
-#define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
-#define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
+#define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
+#define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
+#define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
 /* flags used only as arguments to access routines */
-#define XBF_TRYLOCK	 (1 << 30)/* lock requested, but do not wait */
-#define XBF_UNMAPPED	 (1 << 31)/* do not map the buffer */
+#define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
+#define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -58,7 +58,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ _XBF_INODES,		"INODES" }, \
 	{ _XBF_DQUOTS,		"DQUOTS" }, \
-	{ _XBF_LOGRECOVERY,		"LOG_RECOVERY" }, \
+	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
@@ -247,11 +247,11 @@ xfs_buf_readahead(
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
-int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
-		struct xfs_buf **bpp);
+int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
+		xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
-			  size_t numblks, int flags, struct xfs_buf **bpp,
-			  const struct xfs_buf_ops *ops);
+		size_t numblks, xfs_buf_flags_t flags, struct xfs_buf **bpp,
+		const struct xfs_buf_ops *ops);
 int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
 void xfs_buf_hold(struct xfs_buf *bp);
 
-- 
2.35.1

