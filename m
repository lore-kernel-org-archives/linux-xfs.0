Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbeJEHlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:35 -0400
Subject: [PATCH 06/15] vfs: strengthen checking of file range inputs to
 clone/dedupe range
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:45:15 -0700
Message-ID: <153870031519.29072.18289185889660082318.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Clone range is an optimization on a regular file write.  File writes
that extend the file length are subject to various constraints which are
not checked by clonerange.  This is a correctness problem, because we're
never allowed to touch ranges that the page cache can't support
(s_maxbytes); we're not supposed to deal with large offsets
(MAX_NON_LFS) if O_LARGEFILE isn't set; and we must obey resource limits
(RLIMIT_FSIZE).

Therefore, add these checks to the new generic_clone_checks function so
that we curtail unexpected behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mm/filemap.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)


diff --git a/mm/filemap.c b/mm/filemap.c
index 68ec91d05c7b..f74391721234 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3015,6 +3015,37 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
 		return -EINVAL;
 	count = min(count, size_in - (uint64_t)pos_in);
 
+	/* Don't exceed RLMIT_FSIZE in the file we're writing into. */
+	if (limit != RLIM_INFINITY) {
+		if (pos_out >= limit) {
+			send_sig(SIGXFSZ, current, 0);
+			return -EFBIG;
+		}
+		count = min(count, limit - (uint64_t)pos_out);
+	}
+
+	/* Don't exceed the LFS limits. */
+	if (unlikely(pos_out + count > MAX_NON_LFS &&
+				!(file_out->f_flags & O_LARGEFILE))) {
+		if (pos_out >= MAX_NON_LFS)
+			return -EFBIG;
+		count = min(count, MAX_NON_LFS - (uint64_t)pos_out);
+	}
+	if (unlikely(pos_in + count > MAX_NON_LFS &&
+				!(file_in->f_flags & O_LARGEFILE))) {
+		if (pos_in >= MAX_NON_LFS)
+			return -EFBIG;
+		count = min(count, MAX_NON_LFS - (uint64_t)pos_in);
+	}
+
+	/* Don't operate on ranges the page cache doesn't support. */
+	if (unlikely(pos_out >= inode_out->i_sb->s_maxbytes ||
+		     pos_in >= inode_in->i_sb->s_maxbytes))
+		return -EFBIG;
+
+	count = min(count, inode_out->i_sb->s_maxbytes - (uint64_t)pos_out);
+	count = min(count, inode_in->i_sb->s_maxbytes - (uint64_t)pos_in);
+
 	/*
 	 * If the user wanted us to link to the infile's EOF, round up to the
 	 * next block boundary for this check.
