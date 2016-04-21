Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 957D47CD6
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B135AC005
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id feCB4ueH8DBAOap2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:09 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 6064F62646
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:09 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0T007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:08 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 16/19] mkfs: move spinodes crc check
Date: Thu, 21 Apr 2016 11:39:50 +0200
Message-Id: <1461231593-31294-17-git-send-email-jtulak@redhat.com>
In-Reply-To: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
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

Spinodes crc check is now moved to be in the same way as finobt.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 mkfs/xfs_mkfs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index be82ec5..a6334bc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2389,19 +2389,20 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		 * explicitly turned them off then silently turn them off
 		 * to avoid an unnecessary warning. If the user explicitly
 		 * tried to use crc=0,finobt=1, then issue a warning before
-		 * turning them off.
+		 * turning them off. The same is also for sparse inodes.
 		 */
 		if (sb_feat.finobt && mopts.subopt_params[M_FINOBT].seen) {
 			fprintf(stderr,
 _("warning: finobt not supported without CRC support, disabled.\n"));
 		}
 		sb_feat.finobt = 0;
-	}
 
-	if (sb_feat.spinodes && !sb_feat.crcs_enabled) {
-		fprintf(stderr,
-_("warning: sparse inodes not supported without CRC support, disabled.\n"));
+		if (sb_feat.spinodes) {
+			fprintf(stderr,
+	_("warning: sparse inodes not supported without CRC support, disabled.\n"));
+		}
 		sb_feat.spinodes = 0;
+
 	}
 
 	if (nsflag || nlflag) {
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
