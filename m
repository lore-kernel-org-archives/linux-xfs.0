Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5CBC17F77
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 05:10:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B3E48F80BA
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 03:10:51 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id flHcrm7CWbdEWGvk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Aug 2013 03:10:50 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Wed, 7 Aug 2013 04:10:50 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 7983F1FF0046
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 04:05:18 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r77AAfPi169986 for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 04:10:41 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r77AAe5P006560
	for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 04:10:41 -0600
From: zwu.kernel@gmail.com
Subject: [PATCH 10/12] xfs: fix the comment of xlog_recover_buffer_pass2()
Date: Wed,  7 Aug 2013 18:11:07 +0800
Message-Id: <1375870269-13157-11-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
References: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7681b19..5623014 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2425,7 +2425,7 @@ xlog_recover_do_dquot_buffer(
  * over the log during recovery.  During the first we build a table of
  * those buffers which have been cancelled, and during the second we
  * only replay those buffers which do not have corresponding cancel
- * records in the table.  See xlog_recover_do_buffer_pass[1,2] above
+ * records in the table.  See xlog_recover_buffer_pass[1,2] above
  * for more details on the implementation of the table of cancel records.
  */
 STATIC int
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
