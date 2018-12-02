Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbeLBSJI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 13:09:08 -0500
Date: Sun, 2 Dec 2018 10:08:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/2] splice: don't read more than available pipe space
Message-ID: <20181202180832.GR8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
because xfs doesn't allow short directio reads.

The brokenness is compounded by splice_direct_to_actor immediately
bailing on do_splice_to returning <= 0 without ever calling ->actor
(which empties out the pipe), so if userspace calls back we'll EFAULT
again on the full pipe, and nothing ever gets copied.

Therefore, teach splice_direct_to_actor to clamp its requests to the
amount of free space in the pipe and remove the simulated short read
from the iomap directio code.

Fixes: 4721a601099 ("iomap: dio data corruption and spurious errors when pipes fill")
Reported-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: split into two parts per hch request
---
 fs/splice.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
 
