Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RD91PS097861 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 08:09:02 -0500
Message-Id: <20120927124742.695778439@sgi.com>
Date: Thu, 27 Sep 2012 07:47:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v2] xfsprog: remove duplicate vector memalign from xfs_io
References: <20120925142414.660506845@sgi.com>
	<20120925142421.398175185@sgi.com> <20120926220434.GG13214@sgi.com>
Content-Disposition: inline;
	filename=v2-xfsprogs-io_remove_duplicate_vector_memalign.patch
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
Cc: Ben Myers <bpm@sgi.com>

The vector feature of xfs_io uses its own memory buffer in the iov structure
and does not use the buffer entry. Remove the duplicate memalign.

v2: removed global buffer in __dump_buffer() and use passed buf pointer per
    Ben's detection.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
---
 io/pread.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/io/pread.c
===================================================================
--- a/io/pread.c
+++ b/io/pread.c
@@ -76,8 +76,7 @@ alloc_iovec(
 	buffersize = 0;
 	for (i = 0; i < vectors; i++) {
 		iov[i].iov_base = memalign(pagesize, bsize);
-		buffer = memalign(pagesize, bsize);
-		if (!buffer) {
+		if (!iov[i].iov_base) {
 			perror("memalign");
 			goto unwind;
 		}
@@ -130,7 +129,7 @@ __dump_buffer(
 	int		i, j;
 	char		*p;
 
-	for (i = 0, p = (char *)buffer; i < len; i += 16) {
+	for (i = 0, p = (char *)buf; i < len; i += 16) {
 		char	*s = p;
 
 		printf("%08llx:  ", (unsigned long long)offset + i);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
