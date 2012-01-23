Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHVxK7122778 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:31:59 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pHpjmEg4r8jDMpo4 for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:31:57 -0800 (PST)
Message-ID: <4F1D9989.8060808@redhat.com>
Date: Mon, 23 Jan 2012 11:31:53 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: check for size parsing errors in xfs_quota
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: James Lawrie <james@jdlawrie.co.uk>

Doing something like 

# xfs_quota -x -c 'limit -u bhard=1.2g ...

will cause cvtnum to fail and return a value of -1LL (because it
cannot parse the decimal), but the quota caller doesn't check
for this error value, casts it to U64, shifts right, and we end
up with an answer of 16 petabytes rather than erroring out.
Fix this.

Reported-by: James Lawrie <james@jdlawrie.co.uk>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/edit.c b/quota/edit.c
index b704e63..067cd63 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -226,13 +226,17 @@ extractb(
 	uint		sectorsize,
 	__uint64_t	*value)
 {
-	__uint64_t	v;
+	long long	v;
 	char		*s = string;
 
 	if (strncmp(string, prefix, length) == 0) {
 		s = string + length + 1;
-		v = (__uint64_t)cvtnum(blocksize, sectorsize, s);
-		*value = v >> 9;	/* syscalls use basic blocks */
+		v = cvtnum(blocksize, sectorsize, s);
+		if (v == -1LL) {
+			fprintf(stderr, _("%s: Error: could not parse size %s.\n"), progname, s);
+			return 0;
+		}
+		*value = (__uint64_t)v >> 8;	/* syscalls use basic blocks */
 		if (v > 0 && *value == 0)
 			fprintf(stderr, _("%s: Warning: `%s' in quota blocks is 0 (unlimited).\n"), progname, s);
 		return 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
