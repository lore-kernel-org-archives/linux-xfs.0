Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 176F67F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 18:17:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05E79304039
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 16:17:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QNrBpjHVuJfZan6C for
	<xfs@oss.sgi.com>; Mon, 15 Apr 2013 16:17:16 -0700 (PDT)
Message-ID: <516C89DF.4070904@redhat.com>
Date: Mon, 15 Apr 2013 19:14:39 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
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
To: yongtaofu@gmail.com
Cc: sandeen@sandeen.net, xfs@oss.sgi.com

Hi,

Thanks for the data in the previous thread:

http://oss.sgi.com/archives/xfs/2013-04/msg00327.html

I'm spinning off a new thread specifically for this because the original
thread is already too large and scattered to track. As Eric stated,
please try to keep data contained in as few messages as possible.

The data confirms Dave's theory where we are going off the end of the
unlinked list when attempting to remove an inode, pass in NULLAGINO to
xfs_inotobp() and the attempted conversion to a global inode number
leads to EINVAL. The next question here is why wasn't the inode listed
in the probe output on the unlinked inode list?

Unfortunately we're probably going to require to start making some
debug-level changes to the kernel to make progress on this issue. If you
are able to recompile a kernel and/or xfs module (which you referred to
doing in the previous thread), could you start with the patch appended
to this message[1] and collect the xfs_iunlink and xfs_iunlink_remove
tracepoint data the next time the problem occurs? E.g.,

	echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable
	echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/enable
	... reproduce ...
	cat /sys/kernel/debug/tracing/trace > trace.output

Please also include all data relevant to the crash (in a single mail):
trace output, stap script output (so we know what inode to search for in
the trace), references to metadump images, etc. Thanks.

Brian

[1] - Note that the code we're sending here is debug-level and lightly
tested.

---
 fs/xfs/linux-2.6/xfs_trace.h |    2 ++
 fs/xfs/xfs_inode.c           |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index e8ce644..227eb33 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -581,6 +581,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
 DEFINE_INODE_EVENT(xfs_destroy_inode);
 DEFINE_INODE_EVENT(xfs_write_inode);
 DEFINE_INODE_EVENT(xfs_clear_inode);
+DEFINE_INODE_EVENT(xfs_iunlink);
+DEFINE_INODE_EVENT(xfs_iunlink_remove);

 DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
 DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 796edce..a43bec5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1670,6 +1670,8 @@ xfs_iunlink(
 		(sizeof(xfs_agino_t) * bucket_index);
 	xfs_trans_log_buf(tp, agibp, offset,
 			  (offset + sizeof(xfs_agino_t) - 1));
+
+	trace_xfs_iunlink(ip);
 	return 0;
 }

@@ -1820,6 +1822,8 @@ xfs_iunlink_remove(
 				  (offset + sizeof(xfs_agino_t) - 1));
 		xfs_inobp_check(mp, last_ibp);
 	}
+
+	trace_xfs_iunlink_remove(ip);
 	return 0;
 }

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
