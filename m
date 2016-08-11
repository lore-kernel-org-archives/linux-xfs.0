Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 022A17CA1
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:11:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB09C304043
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DA5ikwVOXHHNM5EY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:11 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C447D3DEF0
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 17:11:10 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-69.bos.redhat.com [10.18.41.69])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7BHB99a003834
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 13:11:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/5] xfs: update metadata LSN in buffers during log recovery
Date: Thu, 11 Aug 2016 13:11:06 -0400
Message-Id: <1470935467-52772-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
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

Log recovery is currently broken for v5 superblocks in that it never
updates the metadata LSN of buffers written out during recovery. The
metadata LSN is recorded in various bits of metadata to provide recovery
ordering criteria that prevents transient corruption states reported by
buffer write verifiers. Without such ordering logic, buffer updates can
be replayed out of order and lead to false positive transient corruption
states. This is generally not a corruption vector on its own, but
corruption detection shuts down the filesystem and ultimately prevents a
mount if it occurs during log recovery. This requires an xfs_repair run
that clears the log and potentially loses filesystem updates.

This problem is avoided in most cases as metadata writes during normal
filesystem operation update the metadata LSN appropriately. The problem
with log recovery not updating metadata LSNs manifests if the system
happens to crash shortly after log recovery itself. In this scenario, it
is possible for log recovery to complete all metadata I/O such that the
filesystem is consistent. If a crash occurs after that point but before
the log tail is pushed forward by subsequent operations, however, the
next mount performs the same log recovery over again. If a buffer is
updated multiple times in the dirty range of the log, an earlier update
in the log might not be valid based on the current state of the
associated buffer after all of the updates in the log had been replayed
(before the previous crash). If a verifier happens to detect such a
problem, the filesystem claims corruption and immediately shuts down.

This commonly manifests in practice as directory block verifier failures
such as the following, likely due to directory verifiers being
particularly detailed in their checks as compared to most others:

  ...
  Mounting V5 Filesystem
  XFS (dm-0): Starting recovery (logdev: internal)
  XFS (dm-0): Internal error XFS_WANT_CORRUPTED_RETURN at line ... of \
    file fs/xfs/libxfs/xfs_dir2_data.c.  Caller xfs_dir3_data_verify ...
  ...

Update log recovery to update the metadata LSN of recovered buffers.
Since metadata LSNs are already updated by write verifer functions via
attached log items, attach a dummy log item to the buffer during
validation and explicitly set the LSN of the current transaction. This
ensures that the metadata LSN of a buffer is updated based on whether
the recovery I/O actually completes, and if so, that subsequent recovery
attempts identify that the buffer is already up to date with respect to
the current transaction.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cc46db7..0c0b743 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -44,6 +44,7 @@
 #include "xfs_error.h"
 #include "xfs_dir2.h"
 #include "xfs_rmap_item.h"
+#include "xfs_buf_item.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -381,6 +382,15 @@ xlog_recover_iodone(
 						SHUTDOWN_META_IO_ERROR);
 		}
 	}
+
+	/*
+	 * On v5 supers, a bli could be attached to update the metadata LSN.
+	 * Clean it up.
+	 */
+	if (bp->b_fspriv)
+		xfs_buf_item_relse(bp);
+	ASSERT(bp->b_fspriv == NULL);
+
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp);
 }
@@ -2552,6 +2562,27 @@ xlog_recover_validate_buf_type(
 		xfs_warn(mp, warnmsg);
 		ASSERT(0);
 	}
+
+	/*
+	 * We must update the metadata LSN of the buffer as it is written out to
+	 * ensure that older transactions never replay over this one and corrupt
+	 * the buffer. This can occur if log recovery is interrupted at some
+	 * point after the current transaction completes, at which point a
+	 * subsequent mount starts recovery from the beginning.
+	 *
+	 * Write verifiers update the metadata LSN from log items attached to
+	 * the buffer. Therefore, initialize a bli purely to carry the LSN to
+	 * the verifier. We'll clean it up in our ->iodone() callback.
+	 */
+	if (bp->b_ops && current_lsn != NULLCOMMITLSN) {
+		struct xfs_buf_log_item	*bip;
+
+		ASSERT(!bp->b_iodone || bp->b_iodone == xlog_recover_iodone);
+		bp->b_iodone = xlog_recover_iodone;
+		xfs_buf_item_init(bp, mp);
+		bip = bp->b_fspriv;
+		bip->bli_item.li_lsn = current_lsn;
+	}
 }
 
 /*
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
