Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C5B057CB6
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:41:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BB11E8F8050
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 09:41:59 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dbUCCBNfp8uRFSFF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 09:41:58 -0800 (PST)
Date: Fri, 12 Feb 2016 09:41:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 33/32] aiocp: fix the gcc warnings
Message-ID: <20160212174154.GF6346@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Eliminate a debug printf that was causing warnings and fix the other two
debug printfs to avoid tripping on return value warnings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/aio-dio-regress/aiocp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/aio-dio-regress/aiocp.c b/src/aio-dio-regress/aiocp.c
index 1abff9c..ccab2ac 100644
--- a/src/aio-dio-regress/aiocp.c
+++ b/src/aio-dio-regress/aiocp.c
@@ -190,7 +190,7 @@ static void wr_done(io_context_t ctx, struct iocb *iocb, long res, long res2)
 	--busy;
 	free_iocb(iocb);
 	if (debug)
-		write(2, "w", 1);
+		fprintf(stderr, "w");
 }
 
 /*
@@ -225,7 +225,7 @@ static void rd_done(io_context_t ctx, struct iocb *iocb, long res, long res2)
 			io_error("io_submit write", res);
 	}
 	if (debug)
-		write(2, "r", 1);
+		fprintf(stderr, "r");
 	if (debug > 1)
 		printf("%d", iosize);
 }
@@ -404,7 +404,6 @@ int main(int argc, char *const *argv)
 	memset(&myctx, 0, sizeof(myctx));
 	io_queue_init(aio_maxio, &myctx);
 	tocopy = howmany(length, aio_blksize);
-printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
 	if (init_iocb(aio_maxio, aio_blksize) < 0) {
 		fprintf(stderr, "Error allocating the i/o buffers\n");
 		exit(1);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
