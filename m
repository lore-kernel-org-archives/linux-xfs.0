Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 567BC7F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:11:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E359DAC003
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:11:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OO5A6hP6JI8s3DUD for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:11:39 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/6] xfstests: fsstress punch should always have
	FALLOC_FL_KEEP_SIZE set
Date: Tue, 25 Feb 2014 20:15:25 +0100
Message-Id: <1393355728-12056-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsstress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 4c3368f..42c8a5a 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2555,8 +2555,8 @@ punch_f(int opno, long r)
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
 	len = (off64_t)(random() % (1024 * 1024));
-	mode |= FALLOC_FL_KEEP_SIZE & random();
 	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
+	mode |= FALLOC_FL_KEEP_SIZE;
 	if (v)
 		printf("%d/%d: punch hole(%d) %s %s %lld %lld %d\n",
 		       procid, opno, mode,
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
