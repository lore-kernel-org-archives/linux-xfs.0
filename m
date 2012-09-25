Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8PEVOr1064347 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 09:31:24 -0500
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17CCD304032
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 07:32:39 -0700 (PDT)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	q8PEWZp6004643
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 09:32:35 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5/Submit) id
	q8PEWZZ1004642
	for xfs@oss.sgi.com; Tue, 25 Sep 2012 09:32:35 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120925142421.398175185@sgi.com>
Date: Tue, 25 Sep 2012 09:24:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfsprog: remove duplicate vector memalign from xfs_io
References: <20120925142414.660506845@sgi.com>
Content-Disposition: inline;
	filename=xfsprogs-io_remove_duplicate_vector_memalign.patch
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

The vector feature of xfs_io uses its own memory buffer in the iov structure
and does not use the buffer entry. Remove the duplicate memalign.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 io/pread.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
