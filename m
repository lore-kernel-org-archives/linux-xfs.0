Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5765A7FCA
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46BFA30408A
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PKLnSwPMbi8eFPgy for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWO-0003wk-H8
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkWO-0001N3-Dz
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 43/48] xfs_repair: drop buffer reference on symlink error
Date: Fri,  7 Jun 2013 10:26:06 +1000
Message-Id: <1370564771-4929-44-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

Failing to drop the buffer when the header is bad results in a
deadlock in a later phase when we try to read the remote symlink
again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dinode.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/repair/dinode.c b/repair/dinode.c
index 2df9a91..31a26d7 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1523,6 +1523,7 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 					do_warn(
 _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 						lino, i, fsbno);
+					libxfs_putbuf(bp);
 					return(1);
 				}
 				buf_data += sizeof(struct xfs_dsymlink_hdr);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
