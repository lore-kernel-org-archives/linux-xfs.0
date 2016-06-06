Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D50D7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 02:55:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C21FA8F8037
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 00:55:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LbdGUBGvVpXw4hXU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 00:55:33 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 66D89C05B1DD
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 07:55:33 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] mkfs: fix -l su minval
Date: Mon,  6 Jun 2016 09:55:29 +0200
Message-Id: <1465199729-8622-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

-l su should be in range BBTOB(1) <= L_SU <= XLOG_MAX_RECORD_BSIZE, because the
upper limit is imposed by kernel on iclogbuf: stripe unit can't be bigger than
the log buffer, but the log buffer can span multiple stripe units. L_SUNIT is
changed in the same way.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 955dcfd..ed7800f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -462,7 +462,7 @@ struct opt_params lopts = {
 		{ .index = L_SUNIT,
 		  .conflicts = { L_SU,
 				 LAST_CONFLICT },
-		  .minval = BTOBB(XLOG_MIN_RECORD_BSIZE),
+		  .minval = 1,
 		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
@@ -470,7 +470,7 @@ struct opt_params lopts = {
 		  .conflicts = { L_SUNIT,
 				 LAST_CONFLICT },
 		  .convert = true,
-		  .minval = XLOG_MIN_RECORD_BSIZE,
+		  .minval = BBTOB(1),
 		  .maxval = XLOG_MAX_RECORD_BSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
