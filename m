Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66CD97F47
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 17:32:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E72498F8059
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 15:32:34 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	heSV7PBMFEzYHfRF for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 15:32:32 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aGxY9-0000Cj-SI
	for xfs@oss.sgi.com; Thu, 07 Jan 2016 10:31:29 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aGxY9-0003d8-Rb
	for xfs@oss.sgi.com; Thu, 07 Jan 2016 10:31:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: add tracepoints to readpage calls
Date: Thu,  7 Jan 2016 10:31:26 +1100
Message-Id: <1452123087-13892-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1452123087-13892-1-git-send-email-david@fromorbit.com>
References: <1452123087-13892-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

This allows us to see page cache driven readahead in action as it
passes through XFS. This helps to understand buffered read
throughput problems such as readahead IO IO sizes being too small
for the underlying device to reach max throughput.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c  |  2 ++
 fs/xfs/xfs_trace.h | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 29e7e5d..379c089 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1917,6 +1917,7 @@ xfs_vm_readpage(
 	struct file		*unused,
 	struct page		*page)
 {
+	trace_xfs_vm_readpage(page->mapping->host, 1);
 	return mpage_readpage(page, xfs_get_blocks);
 }
 
@@ -1927,6 +1928,7 @@ xfs_vm_readpages(
 	struct list_head	*pages,
 	unsigned		nr_pages)
 {
+	trace_xfs_vm_readpages(mapping->host, nr_pages);
 	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 877079eb..391d797 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1222,6 +1222,32 @@ DEFINE_PAGE_EVENT(xfs_writepage);
 DEFINE_PAGE_EVENT(xfs_releasepage);
 DEFINE_PAGE_EVENT(xfs_invalidatepage);
 
+DECLARE_EVENT_CLASS(xfs_readpage_class,
+	TP_PROTO(struct inode *inode, int nr_pages),
+	TP_ARGS(inode, nr_pages),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, nr_pages)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->nr_pages = nr_pages;
+	),
+	TP_printk("dev %d:%d ino 0x%llx nr_pages %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->nr_pages)
+)
+
+#define DEFINE_READPAGE_EVENT(name)		\
+DEFINE_EVENT(xfs_readpage_class, name,	\
+	TP_PROTO(struct inode *inode, int nr_pages), \
+	TP_ARGS(inode, nr_pages))
+DEFINE_READPAGE_EVENT(xfs_vm_readpage);
+DEFINE_READPAGE_EVENT(xfs_vm_readpages);
+
 DECLARE_EVENT_CLASS(xfs_imap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
 		 int type, struct xfs_bmbt_irec *irec),
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
