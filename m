Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:55847 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726599AbeKIKcX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 05:32:23 -0500
Date: Fri, 9 Nov 2018 11:54:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/2] splice: increase pipe size in splice_direct_to_actor()
Message-ID: <20181109005410.GG19305@dastard>
References: <20181108221909.27602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108221909.27602-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

When copy_file_range() is called on files that have been opened with
O_DIRECT, do_splice_direct() does a manual copy of the range one
pipe buffer at a time. The default is 16 pages, which means on
x86_64 it is limited to 64kB IO. This is extremely slow - 64k
synchrnous read/write will run at maybe 5-10MB/s on a spinning disk
and be seek bound. It will be faster on SSDs, but still very
inefficient.

Increase the pipe size to the maximum allowed user size so that we
can get decent throughput for this highly sub-optimal copy loop. Add
a new function to the pipe code that lets us set the pipe size to
the maximum allowed without root permissions to keep things really
simple. We also don't care if changing the pipe size fails - that
will just result in a slower copy.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/pipe.c                 | 10 ++++++++++
 fs/splice.c               |  7 +++++++
 include/linux/pipe_fs_i.h |  1 +
 3 files changed, 18 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index bdc5d3c0977d..436bc0464569 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1109,6 +1109,16 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 	return ret;
 }
 
+/*
+ * Set the pipe to the maximum allowable user size. Advisory only, will
+ * swallow any errors and return the resultant pipe size.
+ */
+long pipe_set_max_safe_size(struct pipe_inode_info *pipe)
+{
+	pipe_set_size(pipe, pipe_max_size);
+	return pipe->buffers * PAGE_SIZE;
+}
+
 /*
  * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
  * location, so checking ->i_pipe is not enough to verify that this is a
diff --git a/fs/splice.c b/fs/splice.c
index 3553f1956508..9749139da731 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -931,6 +931,13 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		current->splice_pipe = pipe;
 	}
 
+	/*
+	 * Try to increase the data holding capacity of the pipe so we can do
+	 * larger IOs. This may not increase the size at all because maximum
+	 * user pipe size is administrator controlled, but we still should try.
+	 */
+	pipe_set_max_safe_size(pipe);
+
 	/*
 	 * Do the splice.
 	 */
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 5a3bb3b7c9ad..962ba4cfcb74 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -191,5 +191,6 @@ struct pipe_inode_info *get_pipe_info(struct file *file);
 
 int create_pipe_files(struct file **, int);
 unsigned int round_pipe_size(unsigned long size);
+long pipe_set_max_safe_size(struct pipe_inode_info *pipe);
 
 #endif
