Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C6937CAE
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E5C68F8065
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tupfGYZVTxr10CvW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:12 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id E81093B70D
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:11 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0W007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:11 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 19/19] mkfs: conflicting values with disabled crc should fail
Date: Thu, 21 Apr 2016 11:39:53 +0200
Message-Id: <1461231593-31294-20-git-send-email-jtulak@redhat.com>
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

If crc=0, then finobt=1 and spinodes=1 should both fail, instead of a warning.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c4cd5ba..249e547 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2394,21 +2394,24 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	} else {
 		/*
 		 * The kernel doesn't currently support crc=0,finobt=1
-		 * filesystems. If crcs are not enabled and the user has
-		 * explicitly turned them off then silently turn them off
-		 * to avoid an unnecessary warning. If the user explicitly
-		 * tried to use crc=0,finobt=1, then issue a warning before
-		 * turning them off. The same is also for sparse inodes.
+		 * filesystems. If crcs are not enabled and the user has not
+		 * explicitly turned finobt on, then silently turn it off to
+		 * avoid an unnecessary warning.
+		 * If the user explicitly tried to use crc=0,finobt=1,
+		 * then issue an error.
+		 * The same is also for sparse inodes.
 		 */
 		if (sb_feat.finobt && mopts.subopt_params[M_FINOBT].seen) {
 			fprintf(stderr,
-_("warning: finobt not supported without CRC support, disabled.\n"));
+_("finobt not supported without CRC support\n"));
+			usage();
 		}
 		sb_feat.finobt = 0;
 
 		if (sb_feat.spinodes) {
 			fprintf(stderr,
-	_("warning: sparse inodes not supported without CRC support, disabled.\n"));
+	_("sparse inodes not supported without CRC support\n"));
+			usage();
 		}
 		sb_feat.spinodes = 0;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
