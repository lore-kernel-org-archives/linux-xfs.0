Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C345F7F56
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 13:38:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D04EAC005
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 11:38:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id g5zKiTu0lOMXnyPy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Sep 2015 11:38:04 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id AAABCAA8
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 18:38:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8SIc3t4018011
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 14:38:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: add an xfs_zero_eof() tracepoint
Date: Mon, 28 Sep 2015 14:38:01 -0400
Message-Id: <1443465481-63460-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443465481-63460-1-git-send-email-bfoster@redhat.com>
References: <1443465481-63460-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add a tracepoint in xfs_zero_eof() to facilitate tracking and debugging
EOF zeroing events. This has proven useful in the context of other
direct I/O tracepoints to ensure EOF zeroing occurs within appropriate
file ranges.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c  | 2 ++
 fs/xfs/xfs_trace.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 347b3e0..541dcfb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -482,6 +482,8 @@ xfs_zero_eof(
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(offset > isize);
 
+	trace_xfs_zero_eof(ip, isize, offset - isize);
+
 	/*
 	 * First handle zeroing the block on which isize resides.
 	 *
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5ed36b1..957f5cc 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1312,6 +1312,7 @@ DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
 DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
 DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
 DEFINE_SIMPLE_IO_EVENT(xfs_setfilesize);
+DEFINE_SIMPLE_IO_EVENT(xfs_zero_eof);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
