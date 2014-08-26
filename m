Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB4C77F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 20:21:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C98998F8033
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 18:21:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	eMJmQGTW3wUwj2Mc for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 18:21:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XM5SC-0000KB-6J
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XM5SC-0002UI-5b
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
Date: Tue, 26 Aug 2014 11:21:39 +1000
Message-Id: <1409016101-9511-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1409016101-9511-1-git-send-email-david@fromorbit.com>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
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

It aborts recovery without freeing the current trans structure that
we are decoding.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1970732f..460cf98 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3587,8 +3587,9 @@ xlog_recovery_process_ophdr(
 	/* unexpected flag values */
 	case XLOG_UNMOUNT_TRANS:
 		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
-		error = 0;
-		break;
+		xlog_recover_free_trans(trans);
+		return 0;
+
 	case XLOG_START_TRANS:
 		xfs_warn(log->l_mp, "%s: bad transaction 0x%x", __func__, tid);
 		ASSERT(0);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
