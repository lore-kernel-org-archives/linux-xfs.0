Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSLJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 13:11:09 -0500
Date: Sun, 2 Dec 2018 10:10:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 2/2] iomap: partially revert 4721a601099 (simulated
 directio short read on EFAULT)
Message-ID: <20181202181045.GS8125@magnolia>
References: <20181202180832.GR8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181202180832.GR8125@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: jencce.kernel@gmail.com, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit 4721a601099, we tried to fix a problem wherein directio reads
into a splice pipe will bounce EFAULT/EAGAIN all the way out to
userspace by simulating a zero-byte short read.  This happens because
some directio read implementations (xfs) will call
bio_iov_iter_get_pages to grab pipe buffer pages and issue asynchronous
reads, but as soon as we run out of pipe buffers that _get_pages call
returns EFAULT, which the splice code translates to EAGAIN and bounces
out to userspace.

In that commit, the iomap code catches the EFAULT and simulates a
zero-byte read, but that causes assertion errors on regular splice reads
because xfs doesn't allow short directio reads.  This causes infinite
splice() loops and assertion failures on generic/095 on overlayfs
because xfs only permit total success or total failure of a directio
operation.  The underlying issue in the pipe splice code has now been
fixed by changing the pipe splice loop to avoid avoid reading more data
than there is space in the pipe.

Therefore, it's no longer necessary to simulate the short directio, so
remove the hack from iomap.

Fixes: 4721a601099 ("iomap: dio data corruption and spurious errors when pipes fill")
Reported-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: split into two patches per hch request
---
 fs/iomap.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 3ffb776fbebe..d6bc98ae8d35 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1877,15 +1877,6 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 				dio->wait_for_completion = true;
 				ret = 0;
 			}
-
-			/*
-			 * Splicing to pipes can fail on a full pipe. We have to
-			 * swallow this to make it look like a short IO
-			 * otherwise the higher splice layers will completely
-			 * mishandle the error and stop moving data.
-			 */
-			if (ret == -EFAULT)
-				ret = 0;
 			break;
 		}
 		pos += ret;
