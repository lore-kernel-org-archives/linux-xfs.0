Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58502 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbeLAGbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 01:31:12 -0500
Date: Fri, 30 Nov 2018 11:20:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] splice: don't read more than available pipe space
Message-ID: <20181130192047.GO8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: jencce.kernel@gmail.com, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

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
because xfs doesn't allow short directio reads.

The brokenness is compounded by splice_direct_to_actor immediately
bailing on do_splice_to returning <= 0 without ever calling ->actor
(which empties out the pipe), so if userspace calls back we'll EFAULT
again on the full pipe, and nothing ever gets copied.

Therefore, teach splice_direct_to_actor to clamp its requests to the
amount of free space in the pipe and remove the simulated short read
from the iomap directio code.

Fixes: 4721a601099 ("iomap: dio data corruption and spurious errors when pipes fill")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c  |    9 ---------
 fs/splice.c |    5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

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
diff --git a/fs/splice.c b/fs/splice.c
index 3553f1956508..4bd9d9590199 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -949,7 +949,10 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		size_t read_len;
 		loff_t pos = sd->pos, prev_pos = pos;
 
-		ret = do_splice_to(in, &pos, pipe, len, flags);
+		/* Don't try to read more the pipe has space for. */
+		read_len = min_t(size_t, len,
+				 (pipe->buffers - pipe->nrbufs) << PAGE_SHIFT);
+		ret = do_splice_to(in, &pos, pipe, read_len, flags);
 		if (unlikely(ret <= 0))
 			goto out_release;
 
