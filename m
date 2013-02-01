Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 984E17F78
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 04:44:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7028A8F8039
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 02:44:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LHM7jH2Y7PCZoNK4 for
	<xfs@oss.sgi.com>; Fri, 01 Feb 2013 02:44:08 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 08/18] gfs2: use ->invalidatepage() length argument
Date: Fri,  1 Feb 2013 11:43:34 +0100
Message-Id: <1359715424-32318-9-git-send-email-lczerner@redhat.com>
In-Reply-To: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
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
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in gfs2_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/gfs2/aops.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 5bd558c..3cf3dc8 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -949,24 +949,29 @@ static void gfs2_invalidatepage(struct page *page, unsigned int offset,
 				unsigned int length)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
+	unsigned int stop = offset + length;
+	int partial_page = (offset || length < PAGE_CACHE_SIZE);
 	struct buffer_head *bh, *head;
 	unsigned long pos = 0;
 
 	BUG_ON(!PageLocked(page));
-	if (offset == 0)
+	if (!partial_page)
 		ClearPageChecked(page);
 	if (!page_has_buffers(page))
 		goto out;
 
 	bh = head = page_buffers(page);
 	do {
+		if (pos + bh->b_size > stop)
+			return;
+
 		if (offset <= pos)
 			gfs2_discard(sdp, bh);
 		pos += bh->b_size;
 		bh = bh->b_this_page;
 	} while (bh != head);
 out:
-	if (offset == 0)
+	if (!partial_page)
 		try_to_release_page(page, 0);
 }
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
