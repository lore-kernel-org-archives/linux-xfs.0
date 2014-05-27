Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0DBB7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 05:31:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA9678F8037
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 03:31:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id X0DiQ6WssMonxmag (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 03:31:19 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WpEf9-00072N-2a
	for xfs@oss.sgi.com; Tue, 27 May 2014 10:31:19 +0000
Date: Tue, 27 May 2014 03:31:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH xfs: tone down writepage/releasepage WARN_ONs
Message-ID: <20140527103119.GA26420@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I recently ran into the issue fixed by

  "xfs: kill buffers over failed write ranges properly"

which spams the log with lots of backtraces.  Make debugging any issues
like that easier by using WARN_ON_ONCE in the writeback code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d1b99b6..e32640e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -975,7 +975,7 @@ xfs_vm_writepage(
 	 * Given that we do not allow direct reclaim to call us, we should
 	 * never be called while in a filesystem transaction.
 	 */
-	if (WARN_ON(current->flags & PF_FSTRANS))
+	if (WARN_ON_ONCE(current->flags & PF_FSTRANS))
 		goto redirty;
 
 	/* Is this page beyond the end of the file? */
@@ -1225,9 +1225,9 @@ xfs_vm_releasepage(
 
 	xfs_count_page_state(page, &delalloc, &unwritten);
 
-	if (WARN_ON(delalloc))
+	if (WARN_ON_ONCE(delalloc))
 		return 0;
-	if (WARN_ON(unwritten))
+	if (WARN_ON_ONCE(unwritten))
 		return 0;
 
 	return try_to_free_buffers(page);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
