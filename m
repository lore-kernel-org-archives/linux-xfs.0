Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51146 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759329AbcIWTBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 15:01:34 -0400
Date: Fri, 23 Sep 2016 20:01:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 01/11] fix memory leaks in tracing_buffers_splice_read()
Message-ID: <20160923190132.GY2356@ZenIV.linux.org.uk>
References: <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160923190032.GA25771@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/trace/trace.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dade4c9..9016f98 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6163,9 +6163,6 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		return -EBUSY;
 #endif
 
-	if (splice_grow_spd(pipe, &spd))
-		return -ENOMEM;
-
 	if (*ppos & (PAGE_SIZE - 1))
 		return -EINVAL;
 
@@ -6175,6 +6172,9 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		len &= PAGE_MASK;
 	}
 
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
  again:
 	trace_access_lock(iter->cpu_file);
 	entries = ring_buffer_entries_cpu(iter->trace_buffer->buffer, iter->cpu_file);
@@ -6232,19 +6232,21 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	/* did we read anything? */
 	if (!spd.nr_pages) {
 		if (ret)
-			return ret;
+			goto out;
 
+		ret = -EAGAIN;
 		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK))
-			return -EAGAIN;
+			goto out;
 
 		ret = wait_on_pipe(iter, true);
 		if (ret)
-			return ret;
+			goto out;
 
 		goto again;
 	}
 
 	ret = splice_to_pipe(pipe, &spd);
+out:
 	splice_shrink_spd(&spd);
 
 	return ret;
-- 
2.9.3

