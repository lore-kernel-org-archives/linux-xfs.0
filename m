Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8FC237F4E
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 12:21:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 63EEC8F8035
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 10:21:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CfpM2E90YbOJMSFT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 10:21:12 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 085D41361
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 18:21:12 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: fix cut & paste error in xfs_fsr.c
Message-ID: <56423596.3030300@redhat.com>
Date: Tue, 10 Nov 2015 12:21:10 -0600
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jtulak@redhat.com

Commit:

7141fc xfsprogs: make fsr use mntinfo when there is no mntent

added an inadvertent "break;" to initallfs() after the call
to find_mountpoint_check(); this is likely a cut & paste error
from the call in find_mountpoint(), where we really *do* want to
stop after the first one we find.

Fix that by removing the break, and fix the declaration-after-code.

Addresses-Coverity-Id: 1338431
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I'll probably follow this with some other cleanups, but this is
the functional fix AFAICT.

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index b902acc..9332c57 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -433,12 +433,11 @@ initallfs(char *mtab)
 	}
 
 	while ( (mp = platform_mntent_next(&cursor)) != NULL) {
+		int rw = 0;
+
 		mntp = find_mountpoint_check(&sb, mp, &ms);
 		if (mntp == NULL)
 			continue;
-		break;
-
-		int rw = 0;
 
 		if (strcmp(mp->mnt_type, MNTTYPE_XFS ) != 0 ||
 		    stat64(mp->mnt_fsname, &sb) == -1 ||


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
