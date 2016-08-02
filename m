Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9944C7D3B
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 01:49:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6AFA18F8033
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 23:49:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xogMWTE9VHPtEBWB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 23:49:05 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 8B6CC834
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 06:49:04 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_quota: fall back silently if XFS_GETNEXTQUOTA fails
Date: Tue,  2 Aug 2016 14:49:00 +0800
Message-Id: <1470120540-15135-1-git-send-email-zlang@redhat.com>
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
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>

After XFS_GETNEXTQUOTA feature has been merged into linux kernel and
xfsprogs, xfs_quota use Q_XGETNEXTQUOTA for report and dump, and
fall back to old XFS_GETQUOTA ioctl if XFS_GETNEXTQUOTA fails.

But when XFS_GETNEXTQUOTA fails, xfs_quota print a warning as
"XFS_GETQUOTA: Invalid argument". That's due to kernel can't
recognize XFS_GETNEXTQUOTA ioctl and return EINVAL. At this time,
the warning is helpless, xfs_quota just need to fall back.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

Both dump_file and report_mount have this problem, so I fix them
together.

xfstests xfs/299 can reproduce this bug in report_mount, the
newest xfs/106 can reproduce both(dump and report, hope I didn't
miss others:).

This patch checks "if cmd == XFS_GETQUOTA", but I'm thinking about
if we should check "if !(cmd == XFS_GETNEXTQUOTA && errno == EINVAL)"?

The first one don't print all errors from XFS_GETNEXTQUOTA, but the
second one only for EINVAL error.

So the question become should we:
1) fall back silently if XFS_GETNEXTQUOTA fails?
2) Or fall back silently if kernel has no XFS_GETNEXTQUOTA feature?

I think both of them make sense. What do you think?

Thanks,
Zorro


 quota/report.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/quota/report.c b/quota/report.c
index 59290e1..70220b4 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -90,8 +90,10 @@ dump_file(
 	else
 		cmd = XFS_GETQUOTA;
 
+	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA */
 	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
-		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
+		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
+		    cmd == XFS_GETQUOTA)
 			perror("XFS_GETQUOTA");
 		return 0;
 	}
@@ -347,8 +349,10 @@ report_mount(
 	else
 		cmd = XFS_GETQUOTA;
 
+	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA*/
 	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
-		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
+		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
+		    cmd == XFS_GETQUOTA)
 			perror("XFS_GETQUOTA");
 		return 0;
 	}
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
