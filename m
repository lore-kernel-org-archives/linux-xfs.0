Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BE357F9C
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 05:59:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B0A5304032
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:59:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xW5N91LfYDRVnDIh for
	<xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:59:45 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1CBxiVR023816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 06:59:44 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs_mkfs: Do not discard if '-N' is provided
Date: Tue, 12 Feb 2013 12:59:41 +0100
Message-Id: <1360670381-19838-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

When '-N' is specified we really should not write anything to the
device, neither we should attempt to discard the device.

This commit fixes xfs_mkfs to not attempt to discard the device in the
case user specified '-N' flag.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a889620..95e27e0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2010,7 +2010,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 			exit(1);
 		}
 
-	if (discard) {
+	if (discard && !Nflag) {
 		discard_blocks(xi.ddev, xi.dsize);
 		if (xi.rtdev)
 			discard_blocks(xi.rtdev, xi.rtsize);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
