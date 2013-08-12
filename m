Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C6587F81
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 22:17:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6BB9B8F8049
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 20:17:57 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id GWxh4M6rUBZnoSxV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 20:17:56 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Sun, 11 Aug 2013 21:17:56 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id A4B213E4003E
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 21:17:30 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7C3HsQB167570 for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 21:17:54 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r7C3HnoT004821
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 21:17:54 -0600
From: zwu.kernel@gmail.com
Subject: [PATCH 09/12] xfs: fix the comment of xfs_log_unmount_write()
Date: Mon, 12 Aug 2013 11:15:00 +0800
Message-Id: <1376277303-29455-10-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
References: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
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
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0fd27dc..6fd274c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -720,7 +720,7 @@ xfs_log_mount_finish(xfs_mount_t *mp)
  * Unmount record used to have a string "Unmount filesystem--" in the
  * data section where the "Un" was really a magic number (XLOG_UNMOUNT_TYPE).
  * We just write the magic number now since that particular field isn't
- * currently architecture converted and "nUmount" is a bit foo.
+ * currently architecture converted and "Unmount" is a bit foo.
  * As far as I know, there weren't any dependencies on the old behaviour.
  */
 
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
