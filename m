Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UJg6WZ211571 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 14:42:16 -0500
Received: from snoot.americas.sgi.com (cxfsopus16.americas.sgi.com
	[128.162.240.194])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABB52AC01F;
	Mon, 30 Mar 2009 12:41:42 -0700 (PDT)
From: Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] xfstests: fix async io error handling in fsx
Date: Mon, 30 Mar 2009 14:41:41 -0500
Message-Id: <1238442101-24311-1-git-send-email-felixb@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The result of async io returned in the event.res in addition
to the number of bytes read/written provides negated error
number. The broken libaio defines event.res as unsigned
while the same structure in the kernel defines it as signed.
The kernel indeed treat it as signed, and returns the
negated error number. Till libaio is fixed we provide
the signed long temp var.
Also set errno for each error condition in aio_rw, as the
caller is not aio aware and expects ret(-1)+errno by the
traditional libc convention.

Signed-off-by: Felix Blyakher <felixb@sgi.com>
---
 ltp/fsx.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index ebe5324..739d56c 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -962,6 +962,7 @@ __aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 	static struct timespec ts;
 	struct iocb *iocbs[] = { &iocb };
 	int ret;
+	long res;
 
 	if (rw == READ) {
 		io_prep_pread(&iocb, fd, buf, len, offset);
@@ -976,21 +977,48 @@ __aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 		fprintf(stderr, "errcode=%d\n", ret);
 		fprintf(stderr, "aio_rw: io_submit failed: %s\n",
 				strerror(ret));
-		return(-1);
+		goto out_error;
 	}
 
 	ret = io_getevents(io_ctx, 1, 1, &event, &ts);
 	if (ret != 1) {
-		fprintf(stderr, "errcode=%d\n", ret);
-		fprintf(stderr, "aio_rw: io_getevents failed: %s\n",
-				 strerror(ret));
-		return -1;
+		if (ret == 0)
+			fprintf(stderr, "aio_rw: no events available\n");
+		else {
+			fprintf(stderr, "errcode=%d\n", -ret);
+			fprintf(stderr, "aio_rw: io_getevents failed: %s\n",
+				 	strerror(-ret));
+		}
+		goto out_error;
 	}
 	if (len != event.res) {
-		fprintf(stderr, "bad read length: %lu instead of %u\n",
-				event.res, len);
+		/*
+		 * The b0rked libaio defines event.res as unsigned.
+		 * However the kernel strucuture has it signed,
+		 * and it's used to pass negated error value.
+		 * Till the library is fixed use the temp var.
+		 */
+		res = (long)event.res;
+		if (res >= 0)
+			fprintf(stderr, "bad io length: %lu instead of %u\n",
+					res, len);
+		else {
+			fprintf(stderr, "errcode=%d\n", -res);
+			fprintf(stderr, "aio_rw: async io failed: %s\n",
+					strerror(-res));
+			goto out_error;
+		}
+
 	}
 	return event.res;
+
+out_error:
+	/*
+	 * The caller expects error return in traditional libc
+	 * convention, i.e. -1 and the errno set to error.
+	 */
+	errno = ret <= 0 ? -ret : -res;
+	return -1;
 }
 
 int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
-- 
1.5.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
