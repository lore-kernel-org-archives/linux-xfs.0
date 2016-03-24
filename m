Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F32E17CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:15:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE2BE30405F
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cDuOXpJbAsrF4JBa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:41 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 59364C04FF86
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:40 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbL8009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:39 -0400
From: jtulak@redhat.com
Subject: [PATCH 02/19] mkfs: sanitise ftype parameter values.
Date: Thu, 24 Mar 2016 12:15:19 +0100
Message-Id: <1458818136-56043-3-git-send-email-jtulak@redhat.com>
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

From: Dave Chinner <dchinner@redhat.com>

Because passing "-n ftype=2" should fail.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 mkfs/xfs_mkfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 36e5b4f..979a860 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1596,7 +1596,15 @@ main(
 						reqval('n', nopts, N_FTYPE);
 					if (nftype)
 						respec('n', nopts, N_FTYPE);
-					dirftype = atoi(value);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "n ftype");
+					if (crcs_enabled) {
+						fprintf(stderr,
+_("cannot specify both crc and ftype\n"));
+						usage();
+					}
+					dirftype = c;
 					nftype = 1;
 					break;
 				default:
-- 
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
