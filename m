Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8188A7F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 13:37:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70A6B304081
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 11:37:55 -0700 (PDT)
Received: from mail-yh0-f49.google.com (mail-yh0-f49.google.com
	[209.85.213.49]) by cuda.sgi.com with ESMTP id 2D0ElMBTnWWeJIUE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Oct 2013 11:37:54 -0700 (PDT)
Received: by mail-yh0-f49.google.com with SMTP id a41so1797118yho.22
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 11:37:53 -0700 (PDT)
From: "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] xfs: fix possible NULL dereference
Date: Mon, 21 Oct 2013 15:32:46 -0300
Message-Id: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
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
To: kernel-br@googlegroups.com
Cc: Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, "Geyslan G. Bem" <geyslan@gmail.com>, open list <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>

This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
dereferencing.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/xfs/xfs_log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a2dea108..8cdeb7e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3703,8 +3703,10 @@ xlog_verify_iclog(
 	spin_lock(&log->l_icloglock);
 	icptr = log->l_iclog;
 	for (i=0; i < log->l_iclog_bufs; i++) {
-		if (icptr == NULL)
+		if (!icptr) {
 			xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
+			break;
+		}
 		icptr = icptr->ic_next;
 	}
 	if (icptr != log->l_iclog)
-- 
1.8.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
