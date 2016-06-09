Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A75E27CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 08:41:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A2AE304051
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 06:41:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id djk5dXWvjEXQAZgw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2016 06:41:49 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 97478C003574
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 13:41:48 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] mkfs: test that -l su is a multiple of block size
Date: Thu,  9 Jun 2016 15:41:40 +0200
Message-Id: <1465479700-14111-1-git-send-email-jtulak@redhat.com>
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

lsunit was already tested, but lsu was not. So a thing like -l su=4097 was
possible. This commit adds a check to fix it.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 455bf11..b9b50fe 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2875,6 +2875,15 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		lsunit = dsunit;
 	}
 
+	if (lsu) {
+		if (lsu % blocksize != 0) {
+			fprintf(stderr,
+	_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+			lsu, blocksize);
+			exit(1);
+		}
+	}
+
 	if (sb_feat.log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
 		/* Warn only if specified on commandline */
 		if (lsuflag || lsunitflag) {
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
