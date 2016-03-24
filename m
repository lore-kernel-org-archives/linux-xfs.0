Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C722D7CDC
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:15:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4DBDDAC00A
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CgGwmqwaB8vXwFnG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:54 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 99909804F3
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:53 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbLM009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:53 -0400
From: jtulak@redhat.com
Subject: [PATCH 16/19] mkfs: move spinodes crc check
Date: Thu, 24 Mar 2016 12:15:33 +0100
Message-Id: <1458818136-56043-17-git-send-email-jtulak@redhat.com>
In-Reply-To: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
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

From: Jan Tulak <jtulak@redhat.com>

Spinodes crc check is now moved to be in the same way as finobt.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 mkfs/xfs_mkfs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7bd9fd5..9a6ae2c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2411,12 +2411,13 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 			}
 			sb_feat.finobt = 0;
 		}
-	}

-	if (sb_feat.spinodes && !sb_feat.crcs_enabled) {
-		fprintf(stderr,
-_("warning: sparse inodes not supported without CRC support, disabled.\n"));
-		sb_feat.spinodes = 0;
+		if (sb_feat.spinodes) {
+			fprintf(stderr,
+	_("warning: sparse inodes not supported without CRC support, disabled.\n"));
+			sb_feat.spinodes = 0;
+		}
+
 	}

 	if (nsflag || nlflag) {
--
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
