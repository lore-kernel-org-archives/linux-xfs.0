Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o53NrYjb186331 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 18:53:35 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9517F384B58
	for <xfs@oss.sgi.com>; Thu,  3 Jun 2010 16:56:02 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	W2gmMYlwieGEXSaO for <xfs@oss.sgi.com>;
	Thu, 03 Jun 2010 16:56:02 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] writeback: Add tracing to write_cache_pages
Date: Fri,  4 Jun 2010 09:55:25 +1000
Message-Id: <1275609328-12514-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1275609328-12514-1-git-send-email-david@fromorbit.com>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Add a trace event to the ->writepage loop in write_cache_pages to give
visibility into how the ->writepage call is changing variables within the
writeback control structure. Of most interest is how wbc->nr_to_write changes
from call to call, especially with filesystems that write multiple pages
in ->writepage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/trace/events/writeback.h |    1 +
 mm/page-writeback.c              |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 72c1a12..5dda40e 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -244,6 +244,7 @@ DEFINE_WBC_EVENT(wbc_writeback_wait);
 DEFINE_WBC_EVENT(wbc_balance_dirty_start);
 DEFINE_WBC_EVENT(wbc_balance_dirty_written);
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
+DEFINE_WBC_EVENT(wbc_writepage);
 
 #endif /* _TRACE_WRITEBACK_H */
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 68eb727..caaf954 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -921,6 +921,7 @@ continue_unlock:
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
+			trace_wbc_writepage(wbc);
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
 				if (ret == AOP_WRITEPAGE_ACTIVATE) {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
