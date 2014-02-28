Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 881667F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 10:11:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77D418F8052
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:11:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fjOvrrXQD7Kqahfr for
	<xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:11:19 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 6/8] fsstress: translate flags in fiemap_f
Date: Fri, 28 Feb 2014 17:11:03 +0100
Message-Id: <1393603865-26198-6-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
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

Translate flags in fiemap_f output to human readable strings.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsstress.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 24864db..869a8ac 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2252,6 +2252,18 @@ fdatasync_f(int opno, long r)
 	free_pathname(&f);
 	close(fd);
 }
+
+#ifdef HAVE_LINUX_FIEMAP_H
+struct print_flags fiemap_flags[] = {
+	{ FIEMAP_FLAG_SYNC, "SYNC"},
+	{ FIEMAP_FLAG_XATTR, "XATTR"},
+	{ -1, NULL}
+};
+
+#define translate_fiemap_flags(mode)	\
+	({translate_flags(mode, "|", fiemap_flags);})
+#endif
+
 void
 fiemap_f(int opno, long r)
 {
@@ -2314,9 +2326,10 @@ fiemap_f(int opno, long r)
 
 	e = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
 	if (v)
-		printf("%d/%d: ioctl(FIEMAP) %s%s %lld %lld %x %d\n",
+		printf("%d/%d: ioctl(FIEMAP) %s%s %lld %lld (%s) %d\n",
 		       procid, opno, f.path, st, (long long)fiemap->fm_start,
-		       (long long) fiemap->fm_length, fiemap->fm_flags, e);
+		       (long long) fiemap->fm_length,
+		       translate_fiemap_flags(fiemap->fm_flags), e);
 	free(fiemap);
 	free_pathname(&f);
 	close(fd);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
