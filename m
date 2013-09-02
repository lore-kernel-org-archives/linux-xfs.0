Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A50B29E04
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 22:23:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 070D18F8049
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 20:23:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ukvdTyh6qDXkrzv1 for <xfs@oss.sgi.com>;
	Sun, 01 Sep 2013 20:23:07 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGKjF-0008Ra-Tw
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 13:23:01 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGKjF-0006Vj-TN
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 13:23:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: fix endian warning in xlog_recover_get_buf_lsn()
Date: Mon,  2 Sep 2013 13:22:58 +1000
Message-Id: <1378092179-24973-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1378092179-24973-1-git-send-email-david@fromorbit.com>
References: <1378092179-24973-1-git-send-email-david@fromorbit.com>
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

sparse reports:

fs/xfs/xfs_log_recover.c:2017:24: sparse: cast to restricted __be64

Because I used the wrong structure for the on-disk superblock cast
in 50d5c8d ("xfs: check LSN ordering for v5 superblocks during
recovery"). Fix it.

Reported-by: kbuild test robot
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8984ec4..1c3b0c9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2014,7 +2014,7 @@ xlog_recover_get_buf_lsn(
 	case XFS_ATTR3_RMT_MAGIC:
 		return be64_to_cpu(((struct xfs_attr3_rmt_hdr *)blk)->rm_lsn);
 	case XFS_SB_MAGIC:
-		return be64_to_cpu(((struct xfs_sb *)blk)->sb_lsn);
+		return be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
 	default:
 		break;
 	}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
